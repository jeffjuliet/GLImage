//
//  GLFramebuffer.m
//  GLImage
//
//  Created by 方阳 on 16/11/30.
//  Copyright © 2016年 jefffyang. All rights reserved.
//

#import "GLFramebuffer.h"
#import "GLContext.h"

@interface GLFramebuffer()
{
    CGSize                  bufferSize;
    CVOpenGLESTextureRef    cvTextureRef;
    CVPixelBufferRef        imgBuffer;
    GLuint                  uFramebuffer;
}

@end

@implementation GLFramebuffer

#pragma mark api
- (instancetype)initWithSize:(CGSize)size
{
    return [self initWithSize:size forRender:NO];
}

- (instancetype)initWithSize:(CGSize)size forRender:(BOOL)isForRender
{
    self = [super init];
    if( self )
    {
        bufferSize = size;
        if( isForRender )
        {
            glGenFramebuffers(1, &uFramebuffer);
            glBindFramebuffer(GL_FRAMEBUFFER, uFramebuffer);
        }
        else
        {
            [self generateFramebuffer];
        }
    }
    return self;
}

- (CGSize)size
{
    return bufferSize;
}

- (GLuint)texture
{
    return CVOpenGLESTextureGetName(cvTextureRef);
}

- (void)useFramebuffer
{
    glBindFramebuffer(GL_FRAMEBUFFER, uFramebuffer);
    glViewport(0, 0, bufferSize.width, bufferSize.height);
}

- (CVPixelBufferRef)pixelBuffer
{
    return imgBuffer;
}

#pragma mark utilities

- (void)generateFramebuffer;
{
    glGenFramebuffers(1, &uFramebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, uFramebuffer);
    
    CFDictionaryRef empty; // empty value for attr value.
    CFMutableDictionaryRef attrs;
    empty = CFDictionaryCreate(kCFAllocatorDefault, NULL, NULL, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks); // our empty IOSurface properties dictionary
    attrs = CFDictionaryCreateMutable(kCFAllocatorDefault, 1, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    CFDictionarySetValue(attrs, kCVPixelBufferIOSurfacePropertiesKey, empty);
    
    CVReturn pixelBufCreaRet = CVPixelBufferCreate(kCFAllocatorDefault, bufferSize.width, bufferSize.height, kCVPixelFormatType_32BGRA, attrs, &imgBuffer);
    if( pixelBufCreaRet != kCVReturnSuccess )
    {
        NSAssert(NO, @"pixelbuffer for framebuffer create fail");
    }
    CVReturn textureCreatRet = CVOpenGLESTextureCacheCreateTextureFromImage(kCFAllocatorDefault,
                                                                            [[GLContext sharedGLContext] coreVideoTextureCache],
                                                                            imgBuffer,
                                                                            NULL,
                                                                            GL_TEXTURE_2D,
                                                                            GL_RGBA,
                                                                            bufferSize.width,
                                                                            bufferSize.height,
                                                                            GL_BGRA,
                                                                            GL_UNSIGNED_BYTE,
                                                                            0,
                                                                            &cvTextureRef);
    if( textureCreatRet )
    {
        NSAssert(NO, @"openglestexture create fail for framebuffer");
    }
    
    glBindTexture(CVOpenGLESTextureGetTarget(cvTextureRef), CVOpenGLESTextureGetName(cvTextureRef));
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glFramebufferTexture2D(GL_FRAMEBUFFER,GL_COLOR_ATTACHMENT0,GL_TEXTURE_2D,CVOpenGLESTextureGetName(cvTextureRef),0);
    
    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    NSAssert(status == GL_FRAMEBUFFER_COMPLETE, @"Incomplete filter FBO: %d", status);
    glBindTexture(GL_TEXTURE_2D, 0);
}
@end

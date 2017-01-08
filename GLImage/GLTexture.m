//
//  GLTexture.m
//  GLImage
//
//  Created by 方阳 on 16/12/12.
//  Copyright © 2016年 jefffyang. All rights reserved.
//

#import "GLTexture.h"
#import "GLContext.h"
#import "GLProgram.h"
#import "GLPainter.h"
#import <CoreVideo/CoreVideo.h>

@interface GLTexture()
{
    CVOpenGLESTextureRef textureRef;
    CVOpenGLESTextureRef luminanceTextureRef;
    CVOpenGLESTextureRef chrominanceTextureRef;
}

@end

@implementation GLTexture

+(instancetype)glTextureWithPixelBuffer:(CVPixelBufferRef)pixelBuffer
{
    GLTexture* texture = [[GLTexture alloc] initWithPixelBuffer:pixelBuffer];
    return texture;
}

+(instancetype)glTextureWithPixelBuffer:(CVPixelBufferRef)pixelBuffer isYUV:(BOOL)isYUV;
{
    if( isYUV )
    {
        return [[GLTexture alloc] initWithYUVPixelBuffer:pixelBuffer];
    }
    else{
        return [[GLTexture alloc] initWithPixelBuffer:pixelBuffer];
    }
    
}

- (instancetype)init
{
    self = [super init];
    if( self )
    {
    }
    return self;
}

- (instancetype)initWithYUVPixelBuffer:(CVPixelBufferRef)pixelBuffer;
{
    self = [super init];
    if( self )
    {
        /*
         Mapping the luma plane of a 420v buffer as a source texture:
         CVOpenGLESTextureCacheCreateTextureFromImage(kCFAllocatorDefault, textureCache, pixelBuffer, NULL, GL_TEXTURE_2D, GL_LUMINANCE, width, height, GL_LUMINANCE, GL_UNSIGNED_BYTE, 0, &outTexture);
         
         Mapping the chroma plane of a 420v buffer as a source texture:
         CVOpenGLESTextureCacheCreateTextureFromImage(kCFAllocatorDefault, textureCache, pixelBuffer, NULL, GL_TEXTURE_2D, GL_LUMINANCE_ALPHA, width/2, height/2, GL_LUMINANCE_ALPHA, GL_UNSIGNED_BYTE, 1, &outTexture);
         */
        [[GLContext sharedGLContext] useGLContext];
        CVReturn ret = CVOpenGLESTextureCacheCreateTextureFromImage(kCFAllocatorDefault, [[GLContext sharedGLContext] coreVideoTextureCache], pixelBuffer, NULL, GL_TEXTURE_2D, GL_LUMINANCE, CVPixelBufferGetWidth(pixelBuffer), CVPixelBufferGetHeight(pixelBuffer), GL_LUMINANCE, GL_UNSIGNED_BYTE, 0, &luminanceTextureRef);
        ret = CVOpenGLESTextureCacheCreateTextureFromImage(kCFAllocatorDefault, [[GLContext sharedGLContext] coreVideoTextureCache], pixelBuffer, NULL, GL_TEXTURE_2D, GL_LUMINANCE_ALPHA, CVPixelBufferGetWidth(pixelBuffer)/2, CVPixelBufferGetHeight(pixelBuffer)/2, GL_LUMINANCE_ALPHA, GL_UNSIGNED_BYTE, 1, &chrominanceTextureRef);
    }
    return self;
}

- (instancetype)initWithPixelBuffer:(CVPixelBufferRef)pixelBuffer;
{
    self = [super init];
    if( self )
    {
        [[GLContext sharedGLContext] useGLContext];
        CVReturn ret = CVOpenGLESTextureCacheCreateTextureFromImage(kCFAllocatorDefault, [GLContext sharedGLContext].coreVideoTextureCache, pixelBuffer, NULL, GL_TEXTURE_2D, GL_RGBA, CVPixelBufferGetWidth(pixelBuffer), CVPixelBufferGetHeight(pixelBuffer), GL_BGRA, GL_UNSIGNED_BYTE, 0, &textureRef);
        glBindTexture(CVOpenGLESTextureGetTarget(textureRef), CVOpenGLESTextureGetName(textureRef));
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
        glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
        glBindTexture(GL_TEXTURE_2D, 0);
    }
    return  self;
}

- (GLuint)texture
{
    return CVOpenGLESTextureGetName(textureRef);
}

- (void)dealloc
{
//    [[GLContext sharedGLContext] useGLContext];
    GLuint texturebuffer = CVOpenGLESTextureGetName(textureRef);
//    glDeleteTextures(1, &texturebuffer);
    GLuint u = glGetError();
    if( textureRef )
    {
        CFRelease(textureRef);
    }
    if( chrominanceTextureRef )
    {
        CFRelease(chrominanceTextureRef);
    }
    if( luminanceTextureRef )
    {
        CFRelease(luminanceTextureRef);
    }
}
@end

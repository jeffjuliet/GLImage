//
//  GLImageView.m
//  GLImage
//
//  Created by 方阳 on 16/11/30.
//  Copyright © 2016年 jefffyang. All rights reserved.
//

#import "GLImageView.h"

#import "GLImageView.h"
#import "GLImage.h"
#import "GLFramebuffer.h"
#import "GLPainter.h"
#import "GLStillImage.h"
#import "GLContext.h"

@interface GLImageView()
{
    CAEAGLLayer* _eaglLayer;
    GLuint _colorRenderBuffer;
    GLuint _positionSlot;
    GLuint _colorSlot;
    GLuint _textureSampleUniform;
    GLuint _textureCoordIn;
    GLuint _texture;
    GLuint _params;
    GLuint _offset;
    GLFramebuffer* framebuffer;
    GLStillImage* glImage;
    GLPainter* painter;
    GLPainter* painter2;
    GLFramebuffer* framebuffer1;
    GLFramebuffer* framebuffer2;
}

@end

typedef struct {
    float Position[3];
    float Color[4];
    float texCoordinate[2];
} Vertex;

@implementation GLImageView

const Vertex vers[] = {
    {{1, -1, 0}, {1, 0, 0, 1},{1,1}},
    {{1, 1, 0}, {0, 1, 0, 1},{1,0}},
    {{-1, 1, 0}, {0, 0, 1, 1},{0,0}},
    {{-1, -1, 0}, {0, 0, 0, 1},{0,1}}
};

const GLubyte indis[] = {
    0, 1, 2,
    0, 2, 3
};
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
- (instancetype)initWithImg:(UIImage *)img
{
    CGSize size = img.size;
    
    //    NSUInteger maxSize = MAX(CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds))*[UIScreen mainScreen].scale;
    //    CGFloat maxwh = MAX(size.width, size.height);
    //    CGFloat ratio = 1;
    //    if( maxwh > maxSize )
    //    {
    //        ratio = maxSize/maxwh;
    //    }
    //    size = CGSizeMake(size.width*ratio*4, size.height*ratio*4);
    
    self = [super initWithFrame:CGRectMake(0, 100, size.width/10, size.height/10)];
    self.image = img;
    if ( self ) {
        [self setupLayer];
        dispatch_sync([[GLContext sharedGLContext] getGLContextQueue], ^{
            [[GLContext sharedGLContext] useGLContext];
            [self setupRenderBuffer];
            [self setupFrameBuffer];
            //        [self setupVBOs];
            [self compileShaders];
            [self render];
        });
    }
    return self;
}

+ (Class)layerClass
{
    return [CAEAGLLayer class];
}

- (void)setupLayer
{
    _eaglLayer = (CAEAGLLayer*)self.layer;
    _eaglLayer.opaque = YES;
}

- (void)setupRenderBuffer {
    glGenRenderbuffers(1, &_colorRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
    [[GLContext sharedGLContext].context renderbufferStorage:GL_RENDERBUFFER fromDrawable:_eaglLayer];
}

- (void)setupFrameBuffer {
    glImage = [[GLStillImage alloc] initWithImage:self.image];
    framebuffer1 = [[GLFramebuffer alloc] initWithSize:glImage.size];
    [framebuffer1 useFramebuffer];
    //    framebuffer2 = [[GLFramebuffer alloc] initWithSize:glImage.size];
    //    [framebuffer2 useFramebuffer];
    //    [glImage.framebuffer useFrameBuffer];
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0,GL_RENDERBUFFER, _colorRenderBuffer);
}

- (void)compileShaders {
    painter = [[GLPainter alloc] initWithVertexShader:[NSString stringWithUTF8String:vertexStr] fragmentShader:[NSString stringWithUTF8String:fragmentStr]];
    
    //    painter.inputFramebuffer = glImage.framebuffer;
}

- (void)render {
    painter.inputTexture = glImage.texture;
    [framebuffer1 useFramebuffer];
    painter.bIsForPresent = YES;
    [painter paint];
    //    painter2 = [[openGLPainter alloc] initWithVertexShaderString:[NSString stringWithUTF8String:vertexStr] fragmentShaderString:[NSString stringWithUTF8String:fragmentStr2]];
    //    painter2.inputTexture = [framebuffer1 getFramebufferTexture];
    //    [framebuffer2 useFrameBuffer];
    //    [painter2 paint];
    //    [[GLContext sharedOpenGLContext] presentRenderBufferForDisplay];
    [[GLContext sharedGLContext].context presentRenderbuffer:GL_RENDERBUFFER];
}

@end

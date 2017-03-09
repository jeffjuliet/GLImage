//
//  GLSimplestImageView.m
//  GLImage
//
//  Created by 方阳 on 16/12/16.
//  Copyright © 2016年 jefffyang. All rights reserved.
//

#import "GLSimplestImageView.h"
#import "GLContext.h"
#import "GLFramebuffer.h"
#import "GLPainter.h"
#import "shaderString.h"

@interface GLSimplestImageView()
{
    GLuint _colorRenderBuffer;
    CAEAGLLayer* _eaglLayer;
    GLPainter* painter;
    GLFramebuffer* fbuf;
}

@end

@implementation GLSimplestImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if( self ){
        [self setupLayer];
        dispatch_async([[GLContext sharedGLContext] getGLContextQueue], ^{
            [[GLContext sharedGLContext] useGLContext];
            glGenRenderbuffers(1, &_colorRenderBuffer);
            glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
            [[GLContext sharedGLContext].context renderbufferStorage:GL_RENDERBUFFER fromDrawable:_eaglLayer];
        });
    }
    return self;
}

+ (Class)layerClass
{
    return [CAEAGLLayer class];
}

- (void)layoutSubviews
{
    CGRect frame = self.frame;
    if( CGSizeEqualToSize(self.frame.size, fbuf.size) )
    {
        dispatch_async([[GLContext sharedGLContext] getGLContextQueue], ^{
            [[GLContext sharedGLContext] useGLContext];
            fbuf = [[GLFramebuffer alloc] initWithSize:frame.size];
        });
    }
}

- (void)setupLayer
{
    _eaglLayer = (CAEAGLLayer*)self.layer;
    _eaglLayer.opaque = YES;
}

- (void)setFrameBuffer:(GLFramebuffer*)fb
{
    dispatch_async_on_glcontextqueue(^{
        if( !painter )
        {
            painter = [[GLPainter alloc] initWithVertexShader:defVertexShader fragmentShader:defFragmentShader];
            painter.bIsForPresent = YES;
        }
        if( !fbuf )
        {
            fbuf = [[GLFramebuffer alloc] initWithSize:self.frame.size];
        }
        painter.inputTexture = fb.texture;
        [fbuf useFramebuffer];
        glViewport(0, 0, self.frame.size.width, self.frame.size.height);
        [painter paint];
        
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0,GL_RENDERBUFFER, _colorRenderBuffer);
    });
}

- (void)display
{
    [[GLContext sharedGLContext].context presentRenderbuffer:GL_RENDERBUFFER];
}
@end

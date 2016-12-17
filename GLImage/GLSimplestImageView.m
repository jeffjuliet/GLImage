//
//  GLSimplestImageView.m
//  GLImage
//
//  Created by 方阳 on 16/12/16.
//  Copyright © 2016年 jefffyang. All rights reserved.
//

#import "GLSimplestImageView.h"
#import "GLContext.h"

@interface GLSimplestImageView()
{
    GLuint _colorRenderBuffer;
    CAEAGLLayer* _eaglLayer;
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
        [[GLContext sharedGLContext] useGLContext];
        [self setupLayer];
        glGenRenderbuffers(1, &_colorRenderBuffer);
        glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
        [[GLContext sharedGLContext].context renderbufferStorage:GL_RENDERBUFFER fromDrawable:_eaglLayer];
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

- (void)setFrameBuffer;
{
//    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
//    glViewport(0, 0, bufferSize.width/10, bufferSize.height/10);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0,GL_RENDERBUFFER, _colorRenderBuffer);
}

- (void)display
{
    [[GLContext sharedGLContext].context presentRenderbuffer:GL_RENDERBUFFER];
}
@end

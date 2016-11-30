//
//  GLFirmwareData.m
//  GLImage
//
//  Created by 方阳 on 16/11/30.
//  Copyright © 2016年 jefffyang. All rights reserved.
//

#import "GLFirmwareData.h"
#import "GLContext.h"

@implementation GLFirmwareData

+ (instancetype)sharedInstance
{
    static GLFirmwareData* data = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        data = [[[self class] alloc] init];
    });
    return data;
}

- (GLint)maxTextureSize;
{
    static GLint textureSize;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[GLContext sharedGLContext] useGLContext];
        glGetIntegerv(GL_MAX_TEXTURE_SIZE, &textureSize);
    });
    return textureSize;
}

@end

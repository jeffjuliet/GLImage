//
//  GLContext.m
//  GLImage
//
//  Created by 方阳 on 16/11/30.
//  Copyright © 2016年 jefffyang. All rights reserved.
//

#import "GLContext.h"

@implementation GLContext

+ (instancetype)sharedOpenGLContext;
{
    static GLContext* sharedContext = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedContext = [[GLContext alloc] init];
    });
    return sharedContext;
}

@end

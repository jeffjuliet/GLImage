//
//  GLContext.m
//  GLImage
//
//  Created by 方阳 on 16/11/30.
//  Copyright © 2016年 jefffyang. All rights reserved.
//

#import "GLContext.h"

static void* GLImageContextKey = &GLImageContextKey;

@interface GLContext()
{
    dispatch_queue_t glQueue;
    EAGLContext* glContext;
    CVOpenGLESTextureCacheRef coreVideoTextureCache;
}

@end

@implementation GLContext

+ (instancetype)sharedGLContext;
{
    static GLContext* sharedContext = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedContext = [[GLContext alloc] init];
    });
    return sharedContext;
}

- (instancetype)init;
{
    self = [super init];
    if( self )
    {
        glQueue = dispatch_queue_create("com.jefffyang.GLImage", DISPATCH_QUEUE_SERIAL);
        //为dispatch_queue添加上下文key,方便识别执行的上下文
        dispatch_queue_set_specific(glQueue,GLImageContextKey,(__bridge void*)self,NULL);
    }
    return self;
}

- (void)useGLContext;
{
    if( !glContext )
    {
        [self createContext];
    }
    if( [EAGLContext currentContext] != glContext )
    {
        [EAGLContext setCurrentContext:glContext];
    }
}

- (EAGLContext*)context;
{
    if( !glContext )
    {
        [self createContext];
    }
    return glContext;
}

- (void)createContext;
{
    if( !glContext )
    {
        glContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2 sharegroup:nil];
    }
}

- (dispatch_queue_t)getGLContextQueue;
{
    return glQueue;
}

- (CVOpenGLESTextureCacheRef)coreVideoTextureCache;
{
    if( !coreVideoTextureCache )
    {
        CVReturn ret = CVOpenGLESTextureCacheCreate(kCFAllocatorDefault, NULL, [self context], NULL, &coreVideoTextureCache);
        NSAssert(ret == kCVReturnSuccess, @"core video texture cache create fail");
    }
    return coreVideoTextureCache;
}
@end

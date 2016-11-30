//
//  GLContext.h
//  GLImage
//
//  Created by 方阳 on 16/11/30.
//  Copyright © 2016年 jefffyang. All rights reserved.
//

#import "GLImage.h"

@interface GLContext : NSObject

+ (instancetype)sharedGLContext;
- (void)useGLContext;
- (EAGLContext*)context;
- (CVOpenGLESTextureCacheRef)coreVideoTextureCache;
- (dispatch_queue_t)getGLContextQueue;

@end

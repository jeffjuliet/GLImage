//
//  GLFramebuffer.h
//  GLImage
//
//  Created by 方阳 on 16/11/30.
//  Copyright © 2016年 jefffyang. All rights reserved.
//

#import "GLImage.h"

@interface GLFramebuffer : NSObject

@property (nonatomic,readonly) GLuint texture;
@property (nonatomic,readonly) CVPixelBufferRef pixelBuffer;
@property (nonatomic,assign) CGSize size;

- (instancetype)initWithSize:(CGSize)size;
- (instancetype)initWithSize:(CGSize)size forRender:(BOOL)isForRender;
- (void)useFramebuffer;

@end

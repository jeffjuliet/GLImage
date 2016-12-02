//
//  GLStillImage.h
//  GLImage
//
//  Created by 方阳 on 16/11/30.
//  Copyright © 2016年 jefffyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLImage.h"

@class UIImage;
@interface  GLStillImage: NSObject

@property (nonatomic,readonly) GLuint texture;
@property (nonatomic,readonly) CGSize size;

- (instancetype)initWithCGImage:(CGImageRef)imgRef;
- (instancetype)initWithImage:(UIImage*)img;

@end

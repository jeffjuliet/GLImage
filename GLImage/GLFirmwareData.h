//
//  GLFirmwareData.h
//  GLImage
//
//  Created by 方阳 on 16/11/30.
//  Copyright © 2016年 jefffyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLImage.h"

@interface GLFirmwareData : NSObject

+ (instancetype)sharedInstance;
- (GLint)maxTextureSize;

@end

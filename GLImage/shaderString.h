//
//  shaderString.h
//  GLImage
//
//  Created by 方阳 on 17/1/8.
//  Copyright © 2017年 jefffyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLImage.h"

#define SHADER(a) @""#a

extern const NSString* defVertexShader;
extern const NSString* glYUVVideoRangeToRGBFragmentShaderString;
extern const NSString* glYUVFullRangeToRGBFragmentShaderString;

extern const GLfloat* yuvToRGBBT601videoRangeConversionMatrix;
extern const GLfloat* yuvToRGBBT601fullRangeConversionMatrix;
extern const GLfloat* yuvToRGBBT709videoRangeConversionMatrix;

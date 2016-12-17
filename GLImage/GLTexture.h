//
//  GLTexture.h
//  GLImage
//
//  Created by 方阳 on 16/12/12.
//  Copyright © 2016年 jefffyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface GLTexture : NSObject

@property (nonatomic,readonly) GLuint texture;

+ (instancetype)glTextureWithPixelBuffer:(CVPixelBufferRef)pixelBuffer;

@end

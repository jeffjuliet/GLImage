//
//  GLVideoAssetWriter.h
//  GLImage
//
//  Created by 方阳 on 17/3/15.
//  Copyright © 2017年 jefffyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface GLVideoAssetWriter : NSObject

@property (nonatomic,strong,readonly) NSURL* urlAsset;

- (instancetype)initWithURL:(NSURL*)url withAudio:(BOOL)audio videoSize:(CGSize)size;

- (void)enqueueSampleBuffer:(CMSampleBufferRef)sampleBuffer;

- (void)stopRecording:(void(^)())completion;

@end

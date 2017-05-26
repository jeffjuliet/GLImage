//
//  GLVideoReader.h
//  GLImage
//
//  Created by 方阳 on 17/4/23.
//  Copyright © 2017年 jefffyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>

@interface GLVideoReader : NSObject

//返回的值在当前视频为基于帧的视频的时候才为帧率，如果当前视频为field-based或者interleaved视频时，并不代表实际帧率，而现实中绝大部分视频都是基于帧的
@property (nonatomic,readonly) float curFps;

- (instancetype)initWithAsset:(NSURL*)url;

- (void)startReading:(dispatch_block_t)completion;

- (void)stopReading;

- (CMSampleBufferRef)getNextVideoSampleBuffer;

- (CMSampleBufferRef)getNextAudioSampleBuffer;

@end

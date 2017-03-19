//
//  GLVideoAssetWriter.h
//  GLImage
//
//  Created by 方阳 on 17/3/15.
//  Copyright © 2017年 jefffyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(NSUInteger,sampleType)
{
    sampleTypeVideo,
    sampleTypeAudio
};

@interface GLVideoAssetWriter : NSObject

- (instancetype)initWithURL:(NSURL*)url withAudio:(BOOL)audio;

- (void)enqueueSampleBuffer:(CMSampleBufferRef)sampleBuffer type:(sampleType)type;

- (void)stopRecording;

@end

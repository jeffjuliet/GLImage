//
//  GLVideoReader.m
//  GLImage
//
//  Created by 方阳 on 17/4/23.
//  Copyright © 2017年 jefffyang. All rights reserved.
//

#import "GLVideoReader.h"
#import <AVFoundation/AVFoundation.h>

@interface GLVideoReader()

@property (nonatomic,strong) NSURL* url;
@property (nonatomic,strong) AVURLAsset* asset;
@property (nonatomic,strong) AVAssetReader* assetReader;
@property (nonatomic,strong) AVAssetReaderTrackOutput* videoTrackOutput;
@property (nonatomic,strong) AVAssetReaderTrackOutput* audioTrackOutput;

@end

@implementation GLVideoReader

- (instancetype)initWithAsset:(NSURL *)url
{
    self = [super init];
    if( self )
    {
        _url = url;
    }
    return self;
}

- (void)startReading:(dispatch_block_t)completion
{
    NSDictionary* inputDic = @{AVURLAssetPreferPreciseDurationAndTimingKey:@(YES)};
    if( !_url )
    {
        NSLog(@"startreading asset at null url");
        return;
    }
    _asset = [[AVURLAsset alloc] initWithURL:_url options:inputDic];
    if( _asset )
    {
        [_asset loadValuesAsynchronouslyForKeys:@[@"tracks"] completionHandler:^{
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                NSError* err = nil;
                AVKeyValueStatus stat = [_asset statusOfValueForKey:@"tracks" error:&err];
                if( stat == !AVKeyValueStatusLoaded )
                {
                    return;
                }
                self.assetReader = [AVAssetReader assetReaderWithAsset:self.asset error:&err];
                self.videoTrackOutput = [AVAssetReaderTrackOutput assetReaderTrackOutputWithTrack:[[self.asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] outputSettings:@{(id)kCVPixelBufferPixelFormatTypeKey:@(kCVPixelFormatType_32BGRA)} ];
                self.videoTrackOutput.alwaysCopiesSampleData = NO;
                [self.assetReader addOutput:self.videoTrackOutput];
                self.audioTrackOutput = [AVAssetReaderTrackOutput assetReaderTrackOutputWithTrack:[[self.asset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] outputSettings:@{AVFormatIDKey:@(kAudioFormatLinearPCM),AVLinearPCMIsBigEndianKey:@NO,AVLinearPCMIsFloatKey    :@NO,AVLinearPCMBitDepthKey:@(16)}];
                
                [self.assetReader addOutput:self.audioTrackOutput];
                self.audioTrackOutput.alwaysCopiesSampleData = NO;
                AVAssetTrack* track = self.audioTrackOutput.track;
                [self.assetReader startReading];
                if(completion)
                {
                    completion();
                }
            });
        }];
    }
}

- (void)stopReading
{
    [self.assetReader cancelReading];
    self.assetReader = nil;
}

- (CMSampleBufferRef)getNextVideoSampleBuffer
{
    if( self.assetReader.status == AVAssetReaderStatusReading )
    {
        CMSampleBufferRef buffer = [self.videoTrackOutput copyNextSampleBuffer];
        if( buffer )
        {
            //NSLog(@"ts:%@",@([[NSDate date] timeIntervalSince1970]));
            //CVPixelBufferRef ref = CMSampleBufferGetImageBuffer(buffer);
            return buffer;
        }
    }
    return nil;
}

- (CMSampleBufferRef)getNextAudioSampleBuffer
{
    if( self.assetReader.status == AVAssetReaderStatusReading )
    {
        CMSampleBufferRef buffer = [self.audioTrackOutput copyNextSampleBuffer];
        return buffer;
    }
    return nil;
}

- (float)curFps
{
    return _videoTrackOutput.track.nominalFrameRate;
}
@end

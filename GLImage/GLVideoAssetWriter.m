//
//  GLAssetWriter.m
//  GLImage
//
//  Created by 方阳 on 17/3/15.
//  Copyright © 2017年 jefffyang. All rights reserved.
//

#import "GLVideoAssetWriter.h"

@interface GLVideoAssetWriter()

@property (nonatomic,strong) AVAssetWriter* assetWriter;
@property (nonatomic,strong) AVAssetWriterInput* videoInput;
@property (nonatomic,strong) AVAssetWriterInput* audioInput;
@property (nonatomic,assign) BOOL writing;
@property (nonatomic,strong) NSURL* urlAsset;

@end

@implementation GLVideoAssetWriter


#pragma mark api
- (instancetype)initWithURL:(NSURL *)url withAudio:(BOOL)audio videoSize:(CGSize)size
{
    self = [super init];
    if( self )
    {
        _urlAsset = url;
        if( !url )
        {
            return self;
        }
        _assetWriter = [[AVAssetWriter alloc] initWithURL:url fileType:AVFileTypeQuickTimeMovie error:NULL];
        _videoInput = [[AVAssetWriterInput alloc] initWithMediaType:AVMediaTypeVideo outputSettings:@{AVVideoCodecKey:AVVideoCodecH264,AVVideoWidthKey:@(size.width),AVVideoHeightKey:@(size.height)}];// AVVideoCodecKey, AVVideoWidthKey, and AVVideoHeightKey
        if( audio )
        {
            AudioChannelLayout acl;
            bzero(&acl, sizeof(acl));
            acl.mChannelLayoutTag = kAudioChannelLayoutTag_Stereo;
            _audioInput = [[AVAssetWriterInput alloc] initWithMediaType:AVMediaTypeAudio
                                                         outputSettings:@{AVFormatIDKey:@(kAudioFormatMPEG4AAC),
                                                                        AVSampleRateKey:@(44100),
                                                                          AVNumberOfChannelsKey:@(2),
                                                                          AVChannelLayoutKey:[NSData dataWithBytes:&acl length:sizeof(acl)]
                                                                          }];
        }
        
        if( [_assetWriter canAddInput:_videoInput] )
        {
            _videoInput.expectsMediaDataInRealTime = YES;
            [_assetWriter addInput:_videoInput];
        }
        if( [_assetWriter canAddInput:_audioInput] )
        {
            _audioInput.expectsMediaDataInRealTime = YES;
            [_assetWriter addInput:_audioInput];
        }
        self.writing = YES;
    }
    return self;
}

- (void)enqueueSampleBuffer:(CMSampleBufferRef)sampleBuffer
{
    if( !self.writing )
    {
        return;
    }
    
    CMFormatDescriptionRef format = CMSampleBufferGetFormatDescription(sampleBuffer);
    CMMediaType type = CMFormatDescriptionGetMediaType(format);
    if( self.writing && type == kCMMediaType_Video) //音频采样频率高于视频，确保画面开头不会有黑的情况，starttime设置为第一帧视频时间
    {
        if( self.assetWriter.status == AVAssetWriterStatusUnknown )
        {
            [_assetWriter startWriting];
            [_assetWriter startSessionAtSourceTime:CMSampleBufferGetPresentationTimeStamp(sampleBuffer)];
        }
    }
    switch ( type ) {
        case kCMMediaType_Audio:
        {
            [self enqueueAudioSampleBuffer:sampleBuffer];
        }
            break;
        case kCMMediaType_Video:
        {
            [self enqueueVideoSampleBuffer:sampleBuffer];
        }
            break;
            
        default:
            break;
    }
}

- (void)stopRecording:(void (^)())completion
{
    if( _assetWriter.status == AVAssetWriterStatusWriting )
    {
        self.writing = NO;
        [_assetWriter finishWritingWithCompletionHandler:^{
            if( completion )
            {
                completion();
            }
        }];
    }
}

#pragma mark utility methods
- (void)enqueueVideoSampleBuffer:(CMSampleBufferRef)buf
{
    if( [_videoInput isReadyForMoreMediaData] )
    {
        [_videoInput appendSampleBuffer:buf];
    }
}

- (void)enqueueAudioSampleBuffer:(CMSampleBufferRef)buf
{
    if( [_audioInput isReadyForMoreMediaData] )
    {
        [_audioInput appendSampleBuffer:buf];
    }
}
@end

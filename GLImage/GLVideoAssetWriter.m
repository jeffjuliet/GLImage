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

@end

@implementation GLVideoAssetWriter


#pragma mark api
- (instancetype)initWithURL:(NSURL *)url withAudio:(BOOL)audio
{
    self = [super init];
    if( self )
    {
        _assetWriter = [[AVAssetWriter alloc] initWithURL:url fileType:AVFileTypeQuickTimeMovie error:NULL];
        _videoInput = [[AVAssetWriterInput alloc] initWithMediaType:AVMediaTypeVideo outputSettings:nil];
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
    }
    return self;
}

- (void)enqueueSampleBuffer:(CMSampleBufferRef)sampleBuffer
{
    CMFormatDescriptionRef format = CMSampleBufferGetFormatDescription(sampleBuffer);
    if( !_writing )
    {
        _writing = YES;
        [_assetWriter startWriting];
        [_assetWriter startSessionAtSourceTime:CMSampleBufferGetPresentationTimeStamp(sampleBuffer)];
    }
    switch ( CMFormatDescriptionGetMediaType(format) ) {
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

- (void)stopRecording
{
    if( _assetWriter.status == AVAssetWriterStatusWriting )
    {
        [_assetWriter finishWritingWithCompletionHandler:^{}];
    }
}
@end

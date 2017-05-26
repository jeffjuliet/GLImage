//
//  CtFrameParser.m
//  GLImage
//
//  Created by 方阳 on 17/3/6.
//  Copyright © 2017年 jefffyang. All rights reserved.
//

#import "CtFrameParser.h"

@implementation CtFrameParser
+ (instancetype)sharedParser
{
    static CtFrameParser* parser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        parser = [CtFrameParser new];
    });
    return parser;
}

- (CTFrameRef)getCTFrameOfString:(NSAttributedString *)str inRect:(CGRect)rect;
{
    if( !str )
    {
        return nil;
    }
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)str);
    CGSize size = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), nil, rect.size, nil);
    CGPathRef path = CGPathCreateWithRect(CGRectMake(0, 0, size.width, size.height), &CGAffineTransformIdentity);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, str.length), path, NULL);
    CFRelease(path);
    CFRelease(framesetter);
    return frame;
}
@end

//
//  CtFrameParser.h
//  GLImage
//
//  Created by 方阳 on 17/3/6.
//  Copyright © 2017年 jefffyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

@interface CtFrameParser : NSObject

+ (instancetype)sharedParser;

- (CTFrameRef)getCTFrameOfString:(NSAttributedString*)str inRect:(CGRect)rect;

@end

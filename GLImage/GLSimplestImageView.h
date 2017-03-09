//
//  GLSimplestImageView.h
//  GLImage
//
//  Created by 方阳 on 16/12/16.
//  Copyright © 2016年 jefffyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  GLFramebuffer;
@interface GLSimplestImageView : UIView

- (void)setFrameBuffer:(GLFramebuffer*)fb;
- (void)display;

@end

//
//  GLImageView.h
//  GLImage
//
//  Created by 方阳 on 16/11/30.
//  Copyright © 2016年 jefffyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLImageView : UIView

@property (nonatomic,strong) UIImage* image;
- (instancetype)initWithImg:(UIImage *)img;

@end
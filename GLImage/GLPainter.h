//
//  GLPainter.h
//  GLImage
//
//  Created by 方阳 on 16/11/30.
//  Copyright © 2016年 jefffyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLImage.h"
#import "GLProgram.h"

@interface GLPainter : NSObject
{
    GLProgram* _program;
}

@property (nonatomic,assign) GLuint inputTexture;
@property (nonatomic,assign) BOOL bIsForPresent;

- (instancetype)initWithVertexShader:(const NSString*)vShader fragmentShader:(const NSString*)fShader;
- (void)paint;

@end

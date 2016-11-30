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

extern const GLchar* vertexStr;
extern const GLchar* fragmentStr;

extern const GLchar* fragmentStr2;

@interface GLPainter : NSObject

@property (nonatomic,readonly) GLProgram* program;
@property (nonatomic,assign) GLuint inputTexture;

- (instancetype)initWithVertexShader:(NSString*)vShader fragmentShader:(NSString*)fShader;
- (void)paint;

@end

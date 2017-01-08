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

extern const NSString* defvertex;

@interface GLPainter : NSObject
{
    GLProgram* _program;
}

@property (nonatomic,assign) GLuint inputTexture;
@property (nonatomic,assign) BOOL bIsForPresent;

- (instancetype)initWithVertexShader:(NSString*)vShader fragmentShader:(NSString*)fShader;
- (void)paint;

@end

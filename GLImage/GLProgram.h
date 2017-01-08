//
//  GLProgram.h
//  GLImage
//
//  Created by 方阳 on 16/11/30.
//  Copyright © 2016年 jefffyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLImage.h"

@interface GLProgram : NSObject

- (instancetype)initWithVertexString:(const NSString*)verglsl fragmentString:(const NSString*)fraglsl;

//- (instancetype)initWithVertexChar:(const GLchar*)verglsl fragmentChar:(const GLchar*)fraglsl;

- (BOOL)link;

- (void)use;

- (GLuint)getAttributeLocation:(NSString*)attributeName;

- (GLuint)getUniformLocation:(NSString*)uniformName;

@end

//
//  GLProgram.m
//  GLImage
//
//  Created by 方阳 on 16/11/30.
//  Copyright © 2016年 jefffyang. All rights reserved.
//

#import "GLProgram.h"

@interface GLProgram()
{
    GLuint program;
    GLuint vshader;
    GLuint fshader;
}
@end

@implementation GLProgram

- (instancetype)initWithVertexString:(const NSString *)verglsl fragmentString:(const NSString *)fraglsl;
{
    return [self initWithVertexChar:[verglsl UTF8String] fragmentChar:[fraglsl UTF8String]];
}

- (instancetype)initWithVertexChar:(const GLchar *)verglsl fragmentChar:(const GLchar *)fraglsl
{
    vshader = [self compileShader:GL_VERTEX_SHADER shaderstr:verglsl];
    if ( !vshader ) {
        NSLog(@"compile vshader error");
    }
    fshader = [self compileShader:GL_FRAGMENT_SHADER shaderstr:fraglsl];
    if ( !fshader ) {
        NSLog(@"compile fshader error");
    }
    program = glCreateProgram();
    if ( !program ) {
        NSLog(@"create program error");
    }
    glAttachShader(program, vshader);
    glAttachShader(program, fshader);
    return self;
}

- (GLuint)compileShader:(GLuint)shadertype shaderstr:(const GLchar*)shaderstr
{
    GLuint shader = glCreateShader(shadertype);
    glShaderSource(shader, 1, &shaderstr, NULL);
    glCompileShader(shader);
    
    GLint compileResult;
    glGetShaderiv(shader, GL_COMPILE_STATUS, &compileResult);
    if ( compileResult == GL_FALSE ) {
        GLchar messages[256];
        glGetShaderInfoLog(shader, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        NSLog(@"%@", messageString);
        return 0;
    }
    return shader;
}

- (BOOL)link;
{
    glLinkProgram(program);
    GLint status;
    glGetProgramiv(program, GL_LINK_STATUS, &status);
    if ( status == GL_FALSE ) {
        GLchar messages[256];
        glGetProgramInfoLog(program, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        NSLog(@"%@", messageString);
        return NO;
    }
    if ( vshader ) {
        glDeleteShader(vshader);
        vshader = 0;
    }
    if ( fshader ) {
        glDeleteShader(fshader);
        fshader = 0;
    }
    return YES;
}

- (void)use;
{
    glUseProgram(program);
}

- (GLuint)getAttributeLocation:(NSString *)attributeName
{
    return  glGetAttribLocation(program, [attributeName UTF8String]);
}

- (GLuint)getUniformLocation:(NSString *)uniformName
{
    return glGetUniformLocation(program, [uniformName UTF8String]);
}

- (void)dealloc
{
    if ( vshader ) {
        glDeleteShader(vshader);
    }
    if ( fshader) {
        glDeleteShader(fshader);
    }
    if ( program ) {
        glDeleteProgram(program);
    }
}
@end

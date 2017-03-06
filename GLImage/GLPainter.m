//
//  GLPainter.m
//  GLImage
//
//  Created by 方阳 on 16/11/30.
//  Copyright © 2016年 jefffyang. All rights reserved.
//

#import "GLPainter.h"
#import "shaderString.h"

@interface GLPainter()
{
    GLuint positionSlot;
    GLuint colorSlot;
    GLuint textureCoordIn;
    GLuint textureSampleUniform;
    GLuint params;
    GLuint offset;
}

@end

@implementation GLPainter

- (instancetype)initWithVertexShader:(const NSString *)vShader fragmentShader:(const NSString *)fShader
{
    self = [super init];
    if( self )
    {
        _program = [[GLProgram alloc] initWithVertexString:vShader fragmentString:fShader];
        BOOL linkret = [_program link];
        
        NSAssert(linkret, @"glprogram link fail");
        positionSlot = [_program getAttributeLocation:@"position"];
        colorSlot = [_program getAttributeLocation:@"SourceColor"];
        textureCoordIn = [_program getAttributeLocation:@"textureCoordinate"];
        glEnableVertexAttribArray(positionSlot);
        glEnableVertexAttribArray(colorSlot);
        glEnableVertexAttribArray(textureCoordIn);
        
        textureSampleUniform = [_program getUniformLocation:@"inputImageTexture"];
        params = [_program getUniformLocation:@"params"];
        if( params != 0xffffffff )
        {
            glUniform4f(params, 0.33, 0.63, 0.4, 0.35);
        }
        offset = [_program getUniformLocation:@"singleStepOffset"];
        if( offset != 0xffffffff )
        {
            GLfloat w = 0.01,h = 0.01;
            glUniform2f(offset, w, h);
        }
    }
    return self;
}

- (void)paint
{
    [_program use];
    
    glClearColor(0, 104.0/255.0, 55.0/255.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, _inputTexture);
    glUniform1i(textureSampleUniform, 0);
    
    GLfloat position[] = {-1.0,-1.0,0,1.0,-1.0,0,-1.0,1.0,0,1.0,1.0,0};
    glVertexAttribPointer(positionSlot, 3, GL_FLOAT, GL_FALSE,0, position);
//    GLfloat color[] = {1,1,0,1,0,1,0,1,0,0,1,1,0,0,0,1};
//    glVertexAttribPointer(colorSlot, 4, GL_FLOAT, GL_FALSE,0,color);
    GLfloat coord1[] = {0,0,1,0,0,1,1,1};
    GLfloat coord2[] = {0,1,1,1,0,0,1,0};
    glVertexAttribPointer(textureCoordIn, 2, GL_FLOAT, GL_FALSE, 0, _bIsForPresent? coord2: coord1);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}
@end

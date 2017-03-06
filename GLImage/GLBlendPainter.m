//
//  GLBlendPainter.m
//  GLImage
//
//  Created by 方阳 on 17/1/14.
//  Copyright © 2017年 jefffyang. All rights reserved.
//

#import "GLBlendPainter.h"
#import "GLContext.h"

@implementation GLBlendPainter

- (instancetype)initWithVertexShader:(NSString *)vShader fragmentShader:(NSString *)fShader
{
    self = [super initWithVertexShader:vShader fragmentShader:fShader];
    if( self )
    {
        [[GLContext sharedGLContext] useGLContext];
        [_program use];
        
        glEnableVertexAttribArray([_program getAttributeLocation:@"position"]);
        glEnableVertexAttribArray([_program getAttributeLocation:@"textureCoordinate"]);
    }
    return self;
}

- (void)paint
{
    [_program use];
    
//    glClearColor(0, 104.0/255.0, 55.0/255.0, 1.0);
//    glClear(GL_COLOR_BUFFER_BIT);
    
    GLuint uInputImageTexture = [_program getUniformLocation:@"inputTexture1"];
    glActiveTexture(GL_TEXTURE1);
    glBindTexture(GL_TEXTURE_2D, self.inputTexture);
    glUniform1i(uInputImageTexture, 1);
    
    GLuint texture2 = [_program getUniformLocation:@"inputTexture2"];
    glActiveTexture(GL_TEXTURE2);
    glBindTexture(GL_TEXTURE_2D, self.inputTexture2);
    glUniform1i(texture2, 2);
    
    GLfloat position[] = {0,0,0,1,0,0,0,1,0,1,1,0};
    glVertexAttribPointer([_program getAttributeLocation:@"position"], 3, GL_FLOAT, GL_FALSE,0, position);
    GLfloat coord1[] = {0,0,1,0,0,1,1,1};
    glVertexAttribPointer([_program getAttributeLocation:@"textureCoordinate"], 2, GL_FLOAT, GL_FALSE, 0, coord1);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}
@end

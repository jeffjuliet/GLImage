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
    
    GLuint uInputImageTexture = [_program getUniformLocation:@"inputTexture"];
    glActiveTexture(GL_TEXTURE1);
    glBindTexture(GL_TEXTURE_2D, self.inputTexture);
    glUniform1i(uInputImageTexture, 1);
    
    GLfloat position[] = {0,0.5,1,0.5,0,1,1,1};
    CGPoint x1 = CGPointMake(_blendArea.origin.x, _blendArea.origin.y-_blendArea.size.height);
    CGPoint x2 = CGPointMake(_blendArea.origin.x+_blendArea.size.width, _blendArea.origin.y-_blendArea.size.height);
    CGPoint x3 = CGPointMake(_blendArea.origin.x, _blendArea.origin.y);
    CGPoint x4 = CGPointMake(_blendArea.origin.x+_blendArea.size.width, _blendArea.origin.y);
    if( _blendArea.size.width )
    {
        position[0] = x1.x*2 -1;
        position[1] = x1.y*2 -1;
        position[2] = x2.x*2 -1;
        position[3] = x2.y*2 -1;
        position[4] = x3.x*2 -1;
        position[5] = x3.y*2 -1;
        position[6] = x4.x*2 -1;
        position[7] = x4.y*2 -1;
    }
    glVertexAttribPointer([_program getAttributeLocation:@"position"], 2, GL_FLOAT, GL_FALSE,0, position);
    GLfloat coord1[] = {0,0,1,0,0,1,1,1};
    glVertexAttribPointer([_program getAttributeLocation:@"textureCoordinate"], 2, GL_FLOAT, GL_FALSE, 0, coord1);
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}
@end

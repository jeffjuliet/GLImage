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
    GLuint textureCoordIn;
    GLuint textureSampleUniform;
}

@end

@implementation GLPainter

#pragma mark api
- (instancetype)initWithVertexShader:(const NSString *)vShader fragmentShader:(const NSString *)fShader
{
    self = [super init];
    if( self )
    {
        _program = [[GLProgram alloc] initWithVertexString:vShader fragmentString:fShader];
        BOOL linkret = [_program link];
        
        NSAssert(linkret, @"glprogram link fail");
        positionSlot = [_program getAttributeLocation:@"position"];
//        colorSlot = [_program getAttributeLocation:@"SourceColor"];
        textureCoordIn = [_program getAttributeLocation:@"textureCoordinate"];
        glEnableVertexAttribArray(positionSlot);
//        glEnableVertexAttribArray(colorSlot);
        glEnableVertexAttribArray(textureCoordIn);
        
        textureSampleUniform = [_program getUniformLocation:@"inputImageTexture"];
    }
    return self;
}

//GLfloat co[] = {0,0,0,1,1,0,1,1};
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
//    GLfloat coord1[] = {0,0,1,0,0,1,1,1};
//    GLfloat coord2[] = {0,1,1,1,0,0,1,0};
//    GLfloat* coo = coord2;
    
    glVertexAttribPointer(textureCoordIn, 2, GL_FLOAT, GL_FALSE, 0, [self inputTextureCoordinatesForInputRotation:self.inputRotation]);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}

- (GLfloat*)inputTextureCoordinatesForInputRotation:(GLPainterInputRotation)rotation
{
    static const GLfloat lbx = 0,lby = 0,rbx = 1,rby = 0,ltx = 0,lty = 1,rtx = 1,rty = 1;
    static GLfloat rotationNone[] = {lbx,lby,rbx,rby,ltx,lty,rtx,rty};
    static GLfloat rotation90[] = {rbx,rby,rtx,rty,lbx,lby,ltx,lty};
    static GLfloat rotation180[] = {rtx,rty,ltx,lty,rbx,rby,lbx,lby};
    static GLfloat rotationCounter90[] = {ltx,lty,lbx,lby,rtx,rty,rbx,rby};
    static GLfloat rotationFlipHoriz[] = {rbx,rby,lbx,lby,rtx,rty,ltx,lty};
    static GLfloat rotationCounter90AndFlipHoriz[] = {rtx,rty,rbx,rby,ltx,lty,lbx,lby};
    static GLfloat rotationFlipVert[] = {ltx,lty,rtx,rty,lbx,lby,rbx,rby};
    static GLfloat rotation90AndFLipHoriz[] = {lbx,lby,ltx,lty,rbx,rby,rtx,rty};
    
    static GLfloat* rotationNonePresent = rotationFlipVert;
    static GLfloat* rotation90Present = rotationCounter90AndFlipHoriz;
    static GLfloat* rotation180Present = rotationFlipHoriz;
    static GLfloat* rotationCounter90Present = rotation90AndFLipHoriz;
    static GLfloat* rotationFlipHorizPresent = rotation180;
    static GLfloat* rotationCounter90AndFlipHorizPresent = rotation90;
    static GLfloat* rotationFlipVertPresent = rotationNone;
    static GLfloat* rotation90AndFLipHorizPresent = rotationCounter90;
    switch( rotation )
    {
        case GLInputRotationNone:
            return _bIsForPresent? rotationNonePresent:rotationNone;
        case GLInputRotationClockWise90:
            return _bIsForPresent? rotation90Present:rotation90;
        case GLInputRotation180:
            return _bIsForPresent?rotation180Present:rotation180;
        case GLInputRotationCounterClockWise90:
            return _bIsForPresent?rotationCounter90Present:rotationCounter90;
        case GLInputRotationFlipHorizontal:
            return _bIsForPresent?rotationFlipHorizPresent:rotationFlipHoriz;
        case GLInputRotationCounterClockWise90AndFlipHorizontal:
            return _bIsForPresent?rotationCounter90AndFlipHorizPresent:rotationCounter90AndFlipHoriz;
        case GLInputRotationFlipVertical:
            return _bIsForPresent?rotationFlipVertPresent:rotationFlipVert;
        case GLInputRotationClockWise90AndFlipHorizontal:
            return _bIsForPresent?rotation90AndFLipHorizPresent:rotation90AndFLipHoriz;
        default:
            return rotationNone;
    }
}
@end

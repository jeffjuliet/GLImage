//
//  GLPainter.h
//  GLImage
//
//  Created by 方阳 on 16/11/30.
//  Copyright © 2016年 jefffyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLImage.h"

@class GLProgram;

//在x,y正向及负向4个方位上一共8种相位
/*
 *  比如初始相位 为 ⇋ 中上半个箭头
 *               ⇋         则上半个箭头为 GLInputRotationNone，下半个为GLInputRotation180
 *               ⇌          上半个箭头为 GLInputRotationFlipHorizontal， 下半个为GLInputRotationFlipVertical
 *               ⥮          左半个箭头为 GLInputRotationClockWise90AndFlipHorizontal， 右半个为GLInputRotationCounterClockWise90AndFlipHorizontal
 *               ⥯           左半个箭头为GLInputRotationCounterClockWise90，右半个为 GLInputRotationClockWise90
 *
 */

typedef NS_ENUM(NSUInteger,GLPainterInputRotation)
{
    GLInputRotationNone,
    GLInputRotationClockWise90,
    GLInputRotationClockWise90AndFlipHorizontal,
    GLInputRotationCounterClockWise90,
    GLInputRotationCounterClockWise90AndFlipHorizontal,
    GLInputRotation180,
    GLInputRotationFlipHorizontal,
    GLInputRotationFlipVertical,
};

@interface GLPainter : NSObject
{
    GLProgram* _program;
    GLuint positionSlot;
    GLuint textureCoordIn;
    GLuint textureSampleUniform;
}

@property (nonatomic,assign) GLuint inputTexture;
@property (nonatomic,assign) BOOL bIsForPresent;
@property (nonatomic,assign) GLPainterInputRotation inputRotation;
@property (nonatomic,assign) CGSize scaleSize;

- (instancetype)initWithVertexShader:(const NSString*)vShader fragmentShader:(const NSString*)fShader;
- (GLfloat*)inputTextureCoordinatesForInputRotation:(GLPainterInputRotation)rotation;
- (void)paint;

@end

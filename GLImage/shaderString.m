//
//  shaderString.m
//  GLImage
//
//  Created by 方阳 on 17/1/8.
//  Copyright © 2017年 jefffyang. All rights reserved.
//

#import "shaderString.h"

const NSString* defVertexShader = SHADER
(
 precision highp float;
 attribute vec4 position;
 attribute vec2 textureCoordinate;
 varying vec2 inputTextureCoordinate;
 void main()
 {
     gl_Position = position;
     inputTextureCoordinate = textureCoordinate;
 }
);

const NSString* glYUVVideoRangeToRGBFragmentShaderString = SHADER
(
 precision mediump float;
 varying vec2 inputTextureCoordinate;
 uniform sampler2D chrominanceTexture;
 uniform sampler2D luminanceTexture;
 uniform mat3 yuvToRGBConversion;
 void main()
 {
     vec3 = yuv;
     yuv.y = texture2D(luminanceTexture,inputTextureCoordinate).r - (16.0/255.0);
     yuv.uv = texture2D(chrominanceTexture,inputTextureCoordinate).ra - vec2(0.5,0.5);
     gl_FragColor = vec4(yuvToRGBConversion * yuv,1);
 }
);

const NSString* glYUVFullRangeToRGBFragmentShaderString = SHADER
(
 precision mediump float;
 varying vec2 inputTextureCoordinate;
 uniform sampler2D chrominanceTexture;
 uniform sampler2D luminanceTexture;
 uniform mat3 yuvToRGBConversion;
 void main()
 {
     vec3 yuv;
     yuv.y = texture2D(luminanceTexture,inputTextureCoordinate).r;
     yuv.uv = texture2D(chrominance,inputTextureCoordinate).ra - vec2(0.5,0.5);
     gl_FragColor = vec4(yuvToRGBConversion * yuv,1);
 }
);
/*
 NSString *const kGPUImageYUVFullRangeConversionForLAFragmentShaderString = SHADER_STRING
 (
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D luminanceTexture;
 uniform sampler2D chrominanceTexture;
 uniform mediump mat3 colorConversionMatrix;
 
 void main()
 {
 mediump vec3 yuv;
 lowp vec3 rgb;
 
 yuv.x = texture2D(luminanceTexture, textureCoordinate).r;
 yuv.yz = texture2D(chrominanceTexture, textureCoordinate).ra - vec2(0.5, 0.5);
 rgb = colorConversionMatrix * yuv;
 
 gl_FragColor = vec4(rgb, 1);
 }
 );
 
 NSString *const kGPUImageYUVVideoRangeConversionForLAFragmentShaderString = SHADER_STRING
 (
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D luminanceTexture;
 uniform sampler2D chrominanceTexture;
 uniform mediump mat3 colorConversionMatrix;
 
 void main()
 {
 mediump vec3 yuv;
 lowp vec3 rgb;
 
 yuv.x = texture2D(luminanceTexture, textureCoordinate).r - (16.0/255.0);
 yuv.yz = texture2D(chrominanceTexture, textureCoordinate).ra - vec2(0.5, 0.5);
 rgb = colorConversionMatrix * yuv;
 
 gl_FragColor = vec4(rgb, 1);
 }
 );
 */

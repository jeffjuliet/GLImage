//
//  shaderString.m
//  GLImage
//
//  Created by 方阳 on 17/1/8.
//  Copyright © 2017年 jefffyang. All rights reserved.
//

#import "shaderString.h"

GLfloat BT601videoRangeConversionMatrix[] ={
    1.164, 1.164, 1.164, 0.0, -0.392, 2.017, 1.596, -0.813, 0.0
};

GLfloat BT601fullRangeConversionMatrix[] ={
    1.0, 1.0, 1.0, 0.0, -0.343, 1.765, 1.4, -0.711, 0.0
};

GLfloat BT709videoRangeConversionMatrix[] ={
    1.164, 1.164, 1.164, 0.0, -0.213, 2.112, 1.793, -0.533, 0.0
};

const GLfloat* yuvToRGBBT601videoRangeConversionMatrix = BT601videoRangeConversionMatrix;
const GLfloat* yuvToRGBBT601fullRangeConversionMatrix = BT601fullRangeConversionMatrix;
const GLfloat* yuvToRGBBT709videoRangeConversionMatrix = BT709videoRangeConversionMatrix;

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

const NSString* defFragmentShader = SHADER(
    precision mediump float;
    varying vec2 inputTextureCoordinate;
    uniform sampler2D inputImageTexture;
    void main()
    {
       gl_FragColor = texture2D(inputImageTexture,inputTextureCoordinate);
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
     vec3 yuv;
     yuv.x = texture2D(luminanceTexture,inputTextureCoordinate).r - (16.0/255.0);
     yuv.yz = texture2D(chrominanceTexture,inputTextureCoordinate).ra - vec2(0.5,0.5);
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
     yuv.x = texture2D(luminanceTexture,inputTextureCoordinate).r;
     yuv.yz = texture2D(chrominanceTexture,inputTextureCoordinate).ra - vec2(0.5,0.5);
     gl_FragColor = vec4(yuvToRGBConversion * yuv,1);
 }
);

const NSString* glBlendShaderFragmentString = SHADER
(
 precision mediump float;
 varying vec2 inputTextureCoordinate;
 uniform sampler2D inputTexture1;
 uniform sampler2D inputTexture2;
 void main()
 {
     vec4 color = texture2D(inputTexture2,inputTextureCoordinate);
     if( color.a > 0.0 )
     {
         gl_FragColor.rgba = vec4(clamp(color.r/color.a,0.0,1.0),clamp(color.g/color.a,0.0,1.0),clamp(color.b/color.a,0.0,1.0),color.a);
     }
     else
     {
         gl_FragColor.rgba = color;
     }
 }
);

const NSString* glCustomBeautyShaderFragmentString = SHADER
(
 precision mediump float;
 varying vec2 inputTextureCoordinate;
 uniform sampler2D inputTexture1;
 uniform sampler2D inputTexture2;
 void main()
 {
     gl_FragColor = texture2D(inputTexture2,inputTextureCoordinate);
 }
 );

const NSString* glDefbea = SHADER(
  precision highp float;
  varying lowp vec4 DestinationColor;
  uniform sampler2D inputImageTexture;
  
  uniform vec2 singleStepOffset;
  uniform highp vec4 params;
  
  varying highp vec2 textureCoordinate;
  
  const highp vec3 W = vec3(0.299,0.587,0.114);
  const mat3 saturateMatrix = mat3(1.1102,-0.0598,-0.061,-0.0774,1.0826,-0.1186,-0.0228,-0.0228,1.1772);
  
  float hardlight(float color)
    {
        if(color <= 0.5)
        {
            color = color * color * 2.0;
        }
        else
        {
            color = 1.0 - ((1.0 - color)*(1.0 - color) * 2.0);
        }
        return color;
    }
                                  
void main(){
  vec2 blurCoordinates[24];
  
  blurCoordinates[0] = textureCoordinate.xy + singleStepOffset * vec2(0.0, -10.0);
  blurCoordinates[1] = textureCoordinate.xy + singleStepOffset * vec2(0.0, 10.0);
  blurCoordinates[2] = textureCoordinate.xy + singleStepOffset * vec2(-10.0, 0.0);
  blurCoordinates[3] = textureCoordinate.xy + singleStepOffset * vec2(10.0, 0.0);
  
  blurCoordinates[4] = textureCoordinate.xy + singleStepOffset * vec2(5.0, -8.0);
  blurCoordinates[5] = textureCoordinate.xy + singleStepOffset * vec2(5.0, 8.0);
  blurCoordinates[6] = textureCoordinate.xy + singleStepOffset * vec2(-5.0, 8.0);
  blurCoordinates[7] = textureCoordinate.xy + singleStepOffset * vec2(-5.0, -8.0);
  
  blurCoordinates[8] = textureCoordinate.xy + singleStepOffset * vec2(8.0, -5.0);
  blurCoordinates[9] = textureCoordinate.xy + singleStepOffset * vec2(8.0, 5.0);
  blurCoordinates[10] = textureCoordinate.xy + singleStepOffset * vec2(-8.0, 5.0);
  blurCoordinates[11] = textureCoordinate.xy + singleStepOffset * vec2(-8.0, -5.0);
  
  blurCoordinates[12] = textureCoordinate.xy + singleStepOffset * vec2(0.0, -6.0);
  blurCoordinates[13] = textureCoordinate.xy + singleStepOffset * vec2(0.0, 6.0);
  blurCoordinates[14] = textureCoordinate.xy + singleStepOffset * vec2(6.0, 0.0);
  blurCoordinates[15] = textureCoordinate.xy + singleStepOffset * vec2(-6.0, 0.0);
  
  blurCoordinates[16] = textureCoordinate.xy + singleStepOffset * vec2(-4.0, -4.0);
  blurCoordinates[17] = textureCoordinate.xy + singleStepOffset * vec2(-4.0, 4.0);
  blurCoordinates[18] = textureCoordinate.xy + singleStepOffset * vec2(4.0, -4.0);
  blurCoordinates[19] = textureCoordinate.xy + singleStepOffset * vec2(4.0, 4.0);
  
  blurCoordinates[20] = textureCoordinate.xy + singleStepOffset * vec2(-2.0, -2.0);
  blurCoordinates[21] = textureCoordinate.xy + singleStepOffset * vec2(-2.0, 2.0);
  blurCoordinates[22] = textureCoordinate.xy + singleStepOffset * vec2(2.0, -2.0);
  blurCoordinates[23] = textureCoordinate.xy + singleStepOffset * vec2(2.0, 2.0);
  
  
  float sampleColor = texture2D(inputImageTexture, textureCoordinate).g * 22.0;
  sampleColor += texture2D(inputImageTexture, blurCoordinates[0]).g;
  sampleColor += texture2D(inputImageTexture, blurCoordinates[1]).g;
  sampleColor += texture2D(inputImageTexture, blurCoordinates[2]).g;
  sampleColor += texture2D(inputImageTexture, blurCoordinates[3]).g;
  sampleColor += texture2D(inputImageTexture, blurCoordinates[4]).g;
  sampleColor += texture2D(inputImageTexture, blurCoordinates[5]).g;
  sampleColor += texture2D(inputImageTexture, blurCoordinates[6]).g;
  sampleColor += texture2D(inputImageTexture, blurCoordinates[7]).g;
  sampleColor += texture2D(inputImageTexture, blurCoordinates[8]).g;
  sampleColor += texture2D(inputImageTexture, blurCoordinates[9]).g;
  sampleColor += texture2D(inputImageTexture, blurCoordinates[10]).g;
  sampleColor += texture2D(inputImageTexture, blurCoordinates[11]).g;
  
  sampleColor += texture2D(inputImageTexture, blurCoordinates[12]).g * 2.0;
  sampleColor += texture2D(inputImageTexture, blurCoordinates[13]).g * 2.0;
  sampleColor += texture2D(inputImageTexture, blurCoordinates[14]).g * 2.0;
  sampleColor += texture2D(inputImageTexture, blurCoordinates[15]).g * 2.0;
  sampleColor += texture2D(inputImageTexture, blurCoordinates[16]).g * 2.0;
  sampleColor += texture2D(inputImageTexture, blurCoordinates[17]).g * 2.0;
  sampleColor += texture2D(inputImageTexture, blurCoordinates[18]).g * 2.0;
  sampleColor += texture2D(inputImageTexture, blurCoordinates[19]).g * 2.0;
  
  sampleColor += texture2D(inputImageTexture, blurCoordinates[20]).g * 3.0;
  sampleColor += texture2D(inputImageTexture, blurCoordinates[21]).g * 3.0;
  sampleColor += texture2D(inputImageTexture, blurCoordinates[22]).g * 3.0;
  sampleColor += texture2D(inputImageTexture, blurCoordinates[23]).g * 3.0;
  
  sampleColor = sampleColor / 62.0;
  
  vec3 centralColor = texture2D(inputImageTexture, textureCoordinate).rgb;
  
  float highpass = centralColor.g - sampleColor + 0.5;
  
  for(int i = 0; i < 5;i++)
  {
      highpass = hardlight(highpass);
  }
  float lumance = dot(centralColor, W);
  
  float alpha = pow(lumance, params.r);
  
  vec3 smoothColor = centralColor + (centralColor-vec3(highpass))*alpha*0.1;
  
  smoothColor.r = clamp(pow(smoothColor.r, params.g),0.0,1.0);
  smoothColor.g = clamp(pow(smoothColor.g, params.g),0.0,1.0);
  smoothColor.b = clamp(pow(smoothColor.b, params.g),0.0,1.0);
  
  vec3 lvse = vec3(1.0)-(vec3(1.0)-smoothColor)*(vec3(1.0)-centralColor);
  vec3 bianliang = max(smoothColor, centralColor);
  vec3 rouguang = 2.0*centralColor*smoothColor + centralColor*centralColor - 2.0*centralColor*centralColor*smoothColor;
  
  gl_FragColor = vec4(mix(centralColor, lvse, alpha), 1.0);
  gl_FragColor.rgb = mix(gl_FragColor.rgb, bianliang, alpha);
  gl_FragColor.rgb = mix(gl_FragColor.rgb, rouguang, params.b);
  vec3 satcolor = gl_FragColor.rgb * saturateMatrix;
  gl_FragColor.rgb = mix(gl_FragColor.rgb, satcolor, params.a);
  gl_FragColor.rgb = texture2D(inputImageTexture, textureCoordinate).rgb;
  gl_FragColor.rgb = texture2D(inputImageTexture, textureCoordinate).rrr;
}
);

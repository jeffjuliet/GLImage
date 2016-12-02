//
//  GLPainter.m
//  GLImage
//
//  Created by 方阳 on 16/11/30.
//  Copyright © 2016年 jefffyang. All rights reserved.
//

#import "GLPainter.h"

const GLchar* fragmentStr2 = "precision highp float;\
varying lowp vec4 DestinationColor;\
uniform sampler2D inputImageTexture;\
varying highp vec2 textureCoordinate;\
void main(){\
gl_FragColor.rgb = texture2D(inputImageTexture, textureCoordinate).rgb;\
}";

const GLchar* vertexStr = "attribute vec4 Position;\
attribute vec4 SourceColor; \
varying vec4 DestinationColor;\
attribute vec2 textureCoordIn;\
varying vec2 textureCoordinate;\
void main(void) { \
DestinationColor = SourceColor; \
gl_Position = Position; \
textureCoordinate = textureCoordIn;\
}";
const GLchar* fragmentStr = "precision highp float;\
varying lowp vec4 DestinationColor;\
uniform sampler2D inputImageTexture;\
\
uniform vec2 singleStepOffset;\
uniform highp vec4 params;\
\
varying highp vec2 textureCoordinate;\
\
const highp vec3 W = vec3(0.299,0.587,0.114);\
const mat3 saturateMatrix = mat3(\
1.1102,-0.0598,-0.061,\
-0.0774,1.0826,-0.1186,\
-0.0228,-0.0228,1.1772);\
\
float hardlight(float color)\
{\
if(color <= 0.5)\
{\
color = color * color * 2.0;\
}\
else\
{\
color = 1.0 - ((1.0 - color)*(1.0 - color) * 2.0);\
}\
return color;\
}\
\
void main(){\
vec2 blurCoordinates[24];\
\
blurCoordinates[0] = textureCoordinate.xy + singleStepOffset * vec2(0.0, -10.0);\
blurCoordinates[1] = textureCoordinate.xy + singleStepOffset * vec2(0.0, 10.0);\
blurCoordinates[2] = textureCoordinate.xy + singleStepOffset * vec2(-10.0, 0.0);\
blurCoordinates[3] = textureCoordinate.xy + singleStepOffset * vec2(10.0, 0.0);\
\
blurCoordinates[4] = textureCoordinate.xy + singleStepOffset * vec2(5.0, -8.0);\
blurCoordinates[5] = textureCoordinate.xy + singleStepOffset * vec2(5.0, 8.0);\
blurCoordinates[6] = textureCoordinate.xy + singleStepOffset * vec2(-5.0, 8.0);\
blurCoordinates[7] = textureCoordinate.xy + singleStepOffset * vec2(-5.0, -8.0);\
\
blurCoordinates[8] = textureCoordinate.xy + singleStepOffset * vec2(8.0, -5.0);\
blurCoordinates[9] = textureCoordinate.xy + singleStepOffset * vec2(8.0, 5.0);\
blurCoordinates[10] = textureCoordinate.xy + singleStepOffset * vec2(-8.0, 5.0);\
blurCoordinates[11] = textureCoordinate.xy + singleStepOffset * vec2(-8.0, -5.0);\
\
blurCoordinates[12] = textureCoordinate.xy + singleStepOffset * vec2(0.0, -6.0);\
blurCoordinates[13] = textureCoordinate.xy + singleStepOffset * vec2(0.0, 6.0);\
blurCoordinates[14] = textureCoordinate.xy + singleStepOffset * vec2(6.0, 0.0);\
blurCoordinates[15] = textureCoordinate.xy + singleStepOffset * vec2(-6.0, 0.0);\
\
blurCoordinates[16] = textureCoordinate.xy + singleStepOffset * vec2(-4.0, -4.0);\
blurCoordinates[17] = textureCoordinate.xy + singleStepOffset * vec2(-4.0, 4.0);\
blurCoordinates[18] = textureCoordinate.xy + singleStepOffset * vec2(4.0, -4.0);\
blurCoordinates[19] = textureCoordinate.xy + singleStepOffset * vec2(4.0, 4.0);\
\
blurCoordinates[20] = textureCoordinate.xy + singleStepOffset * vec2(-2.0, -2.0);\
blurCoordinates[21] = textureCoordinate.xy + singleStepOffset * vec2(-2.0, 2.0);\
blurCoordinates[22] = textureCoordinate.xy + singleStepOffset * vec2(2.0, -2.0);\
blurCoordinates[23] = textureCoordinate.xy + singleStepOffset * vec2(2.0, 2.0);\
\
\
float sampleColor = texture2D(inputImageTexture, textureCoordinate).g * 22.0;\
sampleColor += texture2D(inputImageTexture, blurCoordinates[0]).g;\
sampleColor += texture2D(inputImageTexture, blurCoordinates[1]).g;\
sampleColor += texture2D(inputImageTexture, blurCoordinates[2]).g;\
sampleColor += texture2D(inputImageTexture, blurCoordinates[3]).g;\
sampleColor += texture2D(inputImageTexture, blurCoordinates[4]).g;\
sampleColor += texture2D(inputImageTexture, blurCoordinates[5]).g;\
sampleColor += texture2D(inputImageTexture, blurCoordinates[6]).g;\
sampleColor += texture2D(inputImageTexture, blurCoordinates[7]).g;\
sampleColor += texture2D(inputImageTexture, blurCoordinates[8]).g;\
sampleColor += texture2D(inputImageTexture, blurCoordinates[9]).g;\
sampleColor += texture2D(inputImageTexture, blurCoordinates[10]).g;\
sampleColor += texture2D(inputImageTexture, blurCoordinates[11]).g;\
\
sampleColor += texture2D(inputImageTexture, blurCoordinates[12]).g * 2.0;\
sampleColor += texture2D(inputImageTexture, blurCoordinates[13]).g * 2.0;\
sampleColor += texture2D(inputImageTexture, blurCoordinates[14]).g * 2.0;\
sampleColor += texture2D(inputImageTexture, blurCoordinates[15]).g * 2.0;\
sampleColor += texture2D(inputImageTexture, blurCoordinates[16]).g * 2.0;\
sampleColor += texture2D(inputImageTexture, blurCoordinates[17]).g * 2.0;\
sampleColor += texture2D(inputImageTexture, blurCoordinates[18]).g * 2.0;\
sampleColor += texture2D(inputImageTexture, blurCoordinates[19]).g * 2.0;\
\
sampleColor += texture2D(inputImageTexture, blurCoordinates[20]).g * 3.0;\
sampleColor += texture2D(inputImageTexture, blurCoordinates[21]).g * 3.0;\
sampleColor += texture2D(inputImageTexture, blurCoordinates[22]).g * 3.0;\
sampleColor += texture2D(inputImageTexture, blurCoordinates[23]).g * 3.0;\
\
sampleColor = sampleColor / 62.0;\
\
vec3 centralColor = texture2D(inputImageTexture, textureCoordinate).rgb;\
\
float highpass = centralColor.g - sampleColor + 0.5;\
\
for(int i = 0; i < 5;i++)\
{\
highpass = hardlight(highpass);\
}\
float lumance = dot(centralColor, W);\
\
float alpha = pow(lumance, params.r);\
\
vec3 smoothColor = centralColor + (centralColor-vec3(highpass))*alpha*0.1;\
\
smoothColor.r = clamp(pow(smoothColor.r, params.g),0.0,1.0);\
smoothColor.g = clamp(pow(smoothColor.g, params.g),0.0,1.0);\
smoothColor.b = clamp(pow(smoothColor.b, params.g),0.0,1.0);\
\
vec3 lvse = vec3(1.0)-(vec3(1.0)-smoothColor)*(vec3(1.0)-centralColor);\
vec3 bianliang = max(smoothColor, centralColor);\
vec3 rouguang = 2.0*centralColor*smoothColor + centralColor*centralColor - 2.0*centralColor*centralColor*smoothColor;\
\
gl_FragColor = vec4(mix(centralColor, lvse, alpha), 1.0);\
gl_FragColor.rgb = mix(gl_FragColor.rgb, bianliang, alpha);\
gl_FragColor.rgb = mix(gl_FragColor.rgb, rouguang, params.b);\
vec3 satcolor = gl_FragColor.rgb * saturateMatrix;\
gl_FragColor.rgb = mix(gl_FragColor.rgb, satcolor, params.a);\
gl_FragColor.rgb = texture2D(inputImageTexture, textureCoordinate).rgb;\
gl_FragColor.rgb = texture2D(inputImageTexture, textureCoordinate).rrr;\
}";

@interface GLPainter()
{
    GLuint positionSlot;
    GLuint colorSlot;
    GLuint textureCoordIn;
    GLuint textureSampleUniform;
    GLuint params;
    GLuint offset;
}
@property (nonatomic,strong) GLProgram* program;

@end

@implementation GLPainter

- (instancetype)initWithVertexShader:(NSString *)vShader fragmentShader:(NSString *)fShader
{
    self = [super init];
    if( self )
    {
        _program = [[GLProgram alloc] initWithVertexString:vShader fragmentString:fShader];
        BOOL linkret = [_program link];
        
        NSAssert(linkret, @"glprogram link fail");
        positionSlot = [_program getAttributeLocation:@"Position"];
        colorSlot = [_program getAttributeLocation:@"SourceColor"];
        textureCoordIn = [_program getAttributeLocation:@"textureCoordIn"];
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
    GLfloat color[] = {1,1,0,1,0,1,0,1,0,0,1,1,0,0,0,1};
    glVertexAttribPointer(colorSlot, 4, GL_FLOAT, GL_FALSE,0,color);
    GLfloat coord1[] = {0,0,1,0,0,1,1,1};
    GLfloat coord2[] = {0,1,1,1,0,0,1,0};
    glVertexAttribPointer(textureCoordIn, 2, GL_FLOAT, GL_FALSE, 0, _bIsForPresent? coord2: coord1);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}
@end

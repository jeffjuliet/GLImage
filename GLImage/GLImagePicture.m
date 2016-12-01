//
//  GLImagePicture.m
//  GLImage
//
//  Created by 方阳 on 16/11/30.
//  Copyright © 2016年 jefffyang. All rights reserved.
//

#import "GLImagePicture.h"
#import "GLFirmwareData.h"
#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

@interface GLImagePicture()

@property (nonatomic,assign) CGSize size;

@end

@implementation GLImagePicture

- (instancetype)initWithImage:(UIImage*)img
{
    if( img.imageOrientation != UIImageOrientationUp )
    {
        //drawInRect方法比cggraphicsbegincontext并通过cgcontexttranslatectm及cgcontextdrawimage的方式耗时稍低些，且代码更简洁
        NSLog(@"img orientation change:%@",@([[NSDate date] timeIntervalSince1970]*1000));
        UIGraphicsBeginImageContextWithOptions(img.size, NO, img.scale);
        [img drawInRect:CGRectMake(0, 0, img.size.width, img.size.height)];
        img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        NSLog(@"img orientation change:%@",@([[NSDate date] timeIntervalSince1970]*1000));
    }
    return [self initWithCGImage:img.CGImage];
}

- (instancetype)initWithCGImage:(CGImageRef)imgRef
{
    self = [super init];
    if ( self ) {
        size_t width = CGImageGetWidth(imgRef);
        size_t height = CGImageGetHeight(imgRef);
        size_t bytesperrow = CGImageGetBytesPerRow(imgRef);
        size_t bytesperpixel = CGImageGetBitsPerPixel(imgRef);
        size_t bitspercomponent = CGImageGetBitsPerComponent(imgRef);
        CGBitmapInfo info = CGImageGetBitmapInfo(imgRef);
        CGImageAlphaInfo ainfo = CGImageGetAlphaInfo(imgRef);
        NSLog(@"width:%@,height:%@,bytesperrow:%@,bytesperpixel:%@,bitspercomponent:%@,bitmapinfo:%@,ainfo:%@",@(width),@(height),@(bytesperrow),@(bytesperpixel),@(bitspercomponent),@(info),@(ainfo));
        
        NSAssert(width&&height, @"image should has valid w&h");
        GLint maxTextureSize = [[GLFirmwareData sharedInstance] maxTextureSize];
        if ( width > maxTextureSize || height > maxTextureSize ) {
            if ( width > height ) {
                width = maxTextureSize;
                height = height*maxTextureSize*1.0/width;
            }
            else
            {
                height = maxTextureSize;
                width = width*maxTextureSize*1.0/height;
            }
        }
        
        _size = CGSizeMake(width, height);
//        GLuint texture;
//        glGenTextures(1, &texture);
//        glBindTexture(GL_TEXTURE_2D, texture);
//        _texture = texture;
//        
//        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
//        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
//        // This is necessary for non-power-of-two textures
//        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
//        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
//        
//        GLubyte* textureData = (GLubyte*)malloc(width*height*4*sizeof(GLubyte));
//        
//        CGColorSpaceRef colorref = CGColorSpaceCreateDeviceRGB();
//        CGContextRef context = CGBitmapContextCreate(textureData, width, height, 8, width*4, colorref, kCGImageAlphaPremultipliedLast);
//        CGContextDrawImage(context, CGRectMake(0, 0, width, height), imgRef);
//        CGContextRelease(context);
//        
//        CFRelease(colorref);
//        
//        NSLog(@"textureupload begin:%@",@([[NSDate date] timeIntervalSince1970]*1000));
//        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (int)width, (int)height, 0, GL_RGBA, GL_UNSIGNED_BYTE, textureData);
//        NSLog(@"textureupload after:%@",@([[NSDate date] timeIntervalSince1970]*1000));
//        free(textureData);
//        glBindTexture(GL_TEXTURE_2D, 0);
//        
//        NSLog(@"textureupload glk begin:%@",@([[NSDate date] timeIntervalSince1970]*1000));
        
        /*下面glkit方式比上述coregraphics方法耗时一般最少减半*/
        NSError* err = nil;
        GLKTextureInfo* textureinfo = [GLKTextureLoader textureWithCGImage:imgRef options:nil error:&err];
        if( err )
        {
            NSLog(@"%@", err.description);
        }
        GLuint name = textureinfo.name;
        NSLog(@"textureupload glk begin:%@,name:%@",@([[NSDate date] timeIntervalSince1970]*1000),@(name));
        glBindTexture(GL_TEXTURE_2D, name);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        // This is necessary for non-power-of-two textures
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
        _texture = name;
        glBindTexture(GL_TEXTURE_2D, 0);
    }
    return self;
}

@end

//
//  UIImage+ImageRotate.m
//  ToolDemo
//
//  Created by liuqingyuan on 2020/4/6.
//  Copyright © 2020 liuqingyuan. All rights reserved.
//

#import "UIImage+ImageRotate.h"
#import <QuartzCore/QuartzCore.h>
#import <Accelerate/Accelerate.h>

@implementation view

-(void)drawRect:(CGRect)rect{
    CGContextRef contentRef = UIGraphicsGetCurrentContext();
    CGContextSaveGState(contentRef);
    CGContextAddEllipseInRect(contentRef, CGRectMake(0, 0, rect.size.width/2, rect.size.height/2));
    CGContextClip(contentRef);
    CGContextFillPath(contentRef);
    [_image drawAtPoint:CGPointMake(0, 0)];
    
    CGContextRestoreGState(contentRef);
}

@end

@implementation UIImage (ImageRotate)

-(UIImage *)imageRotateIndegree:(float)degree{
    // 将image保存在context中
    size_t width = (size_t)(self.size.width*self.scale);
    size_t height = (size_t)(self.size.height*self.scale);
    // 每行图片数据字节
    size_t bytesRow = width*4;
    // 设置alpha通道
    CGImageAlphaInfo alphainfo = kCGImageAlphaPremultipliedFirst;
    // 配置上下文参数
    CGContextRef bmContext = CGBitmapContextCreate(nil, width, height, 8, bytesRow, CGColorSpaceCreateDeviceRGB(), kCGBitmapByteOrderDefault | alphainfo);
    if (!bmContext) {
        return nil;
    }
    CGContextDrawImage(bmContext, CGRectMake(0, 0, width, height), self.CGImage);
    // 对context进行旋转操作
    UInt8 *data = (UInt8*)CGBitmapContextGetData(bmContext);
    vImage_Buffer src = {data,height,width,bytesRow};
    vImage_Buffer dest = {data,height,width,bytesRow};
    Pixel_8888 bgColor = {0,0,0,0};
    vImageRotate_ARGB8888(&src, &dest, nil, degree, bgColor, kvImageBackgroundColorFill);
    // context转化为image
    CGImageRef imageRef = CGBitmapContextCreateImage(bmContext);
    UIImage *rotateImg = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    return rotateImg;
}

-(UIImage *)cropImageSize:(CGRect)rect{
    CGImageRef subImgRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    CGRect smallRect = CGRectMake(0, 0, CGImageGetWidth(subImgRef), CGImageGetHeight(subImgRef));
    UIGraphicsBeginImageContext(smallRect.size);
    CGContextRef contentRef = UIGraphicsGetCurrentContext();
    CGContextDrawImage(contentRef, smallRect, subImgRef);
    UIImage *image = [UIImage imageWithCGImage:subImgRef];
    UIGraphicsEndImageContext();
    return image;
}

-(UIImage *)cropRoundImage{
    CGFloat imageSizeMin = MIN(self.size.width, self.size.height);
    CGSize imgSize = CGSizeMake(imageSizeMin, imageSizeMin);
    view *mview = [[view alloc]init];
    mview.image = self;
    UIGraphicsBeginImageContext(imgSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    mview.frame = CGRectMake(0, 0, imageSizeMin, imageSizeMin);
    mview.backgroundColor = [UIColor whiteColor];
    [mview.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

-(UIImage *)imageScaleSize:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(UIImage *)imageWater:(UIImage *)waterImage waterString:(nonnull NSString *)waterString{
    UIGraphicsBeginImageContext(self.size);
    // 原始图片渲染
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    CGFloat waterX = 50;
    CGFloat waterY = 80;
    CGFloat width = 80;
    CGFloat height = 80;
    [waterImage drawInRect:CGRectMake(waterX, waterY, width, height)];
    [waterString drawInRect:CGRectMake(0, 0, 100, 15) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor redColor]}];
    UIImage *newImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImg;
}

+ (UIImage *)imageWithBorder:(CGFloat)borderW color:(UIColor *)borderColor image:(UIImage *)image{
 
  //1.开启一个上下文
  CGSize size = CGSizeMake(image.size.width + 2 * borderW, image.size.height + 2 * borderW);
  UIGraphicsBeginImageContextWithOptions(size, NO, 0);
  //2.绘制大圆,显示出来
  UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, size.width, size.height)];
  [borderColor set];
  [path fill];
  //3.绘制一个小圆,把小圆设置成裁剪区域
  UIBezierPath *clipPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(borderW, borderW, image.size.width, image.size.height)];
  [clipPath addClip];
  //4.把图片绘制到上下文当中
  [image drawAtPoint:CGPointMake(borderW, borderW)];
  //5.从上下文当中取出图片
  UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
  //6.关闭上下文
  UIGraphicsEndImageContext();
 
  return newImage;
}

@end

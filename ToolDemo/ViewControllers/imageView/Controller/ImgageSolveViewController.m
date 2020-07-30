//
//  ImgageSolveViewController.m
//  ToolDemo
//
//  Created by liuqingyuan on 2020/4/11.
//  Copyright © 2020 liuqingyuan. All rights reserved.
//

#import "ImgageSolveViewController.h"

@interface ImgageSolveViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UIImageView *image3;
@property (weak, nonatomic) IBOutlet UIImageView *image4;
@property (weak, nonatomic) IBOutlet UIImageView *image5;


@end

@implementation ImgageSolveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //    [self convertFormatTest];
    self.image4.image = [UIImage imageNamed:@"nsfw.jpg"];
    [self grayImage];
    [self imageReColor];
    [self hightLight];
}

-(void)hightLight{
    UIImage *image = [UIImage imageNamed:@"nsfw.jpg"];
    unsigned char* imageData = [self hightLightWithData:[self convertUIImagetoData:image] width:image.size.width height:image.size.height];
    self.image3.image = [self convertDataToUIImage:imageData image:image];
}

//美白算法
-(unsigned char*)hightLightWithData:(unsigned char*)imageData width:(CGFloat)width height:(CGFloat)height{
    // 分配内存空间
    unsigned char* resultData = malloc(width*height*sizeof(unsigned char*)*4);
    // 把内存空间填充为0。因为之前内存空间未初始化，所以需要清0
    memset(resultData, 0, width*height*sizeof(unsigned char*)*4);
    NSArray *colorArrBase = @[@"55",@"110",@"155",@"185",@"220",@"240",@"250",@"255"];
    NSMutableArray *colorArr = [[NSMutableArray alloc]init];
    int beforNum = 0;
    for (int i=0; i<8; i++) {
        NSString *numStr = colorArrBase[i];
        int num = [numStr intValue];
        float step = 0;
        if (i==0) {
            step = num/32;
            beforNum = num;
        }else{
            step = (num - beforNum)/32;
        }
        for (int j = 0; j<32; j++) {
            int newNum = 0;
            if (i==0) {
                newNum = (int)(j*step);
            }else{
                newNum = (int)(beforNum+j*step);
            }
            NSString *newNumStr = [NSString stringWithFormat:@"%d",newNum];
            [colorArr addObject:newNumStr];
        }
        beforNum = num;
    }
    // 提取每个像素，并对颜色进行修改
    // 行
    for (int i=0; i<height; i++) {
        // 列
        for (int j=0; j<width; j++) {
            // 获取像素点
            unsigned int imageIndex = i*width+j;
            unsigned char bitMapRed = *(imageData+imageIndex*4);
            unsigned char bitMapGreen = *(imageData+imageIndex*4+1);
            unsigned char bitMapBlue = *(imageData+imageIndex*4+2);
            NSString *redStr = [colorArr objectAtIndex:bitMapRed];
            NSString *greenStr = [colorArr objectAtIndex:bitMapGreen];
            NSString *blueStr = colorArr[bitMapBlue];
            unsigned char bitMapRedNew = [redStr intValue];
            unsigned char bitMapGreenNew = [greenStr intValue];
            unsigned char bitMapBlueNew = [blueStr intValue];
            memset(resultData+imageIndex*4, bitMapRedNew, 1);
            memset(resultData+imageIndex*4+1, bitMapGreenNew, 1);
            memset(resultData+imageIndex*4+2, bitMapBlueNew, 1);
        }
    }
    return resultData;
}

-(void)imageReColor{
    UIImage *image = [UIImage imageNamed:@"nsfw.jpg"];
    //    unsigned char* imageData = [self imageReColorWithData:[self convertUIImagetoData:image] Width:image.size.width height:image.size.height];
    unsigned char* imageData = [self imageReColorWithData:[self convertUIImagetoData:image] width:image.size.width height:image.size.height];
    self.image2.image = [self convertDataToUIImage:imageData image:image];
}

// 彩色地板图像算法
-(unsigned char*)imageReColorWithData:(unsigned char*)imageData width:(CGFloat)width height:(CGFloat)height{
    // 分配内存空间
    unsigned char* resultData = malloc(width*height*sizeof(unsigned char*)*4);
    // 把内存空间填充为0。因为之前内存空间未初始化，所以需要清0
    memset(resultData, 0, width*height*sizeof(unsigned char*)*4);
    // 提取每个像素，并对颜色进行修改
    // 行
    for (int i=0; i<height; i++) {
        // 列
        for (int j=0; j<width; j++) {
            // 获取像素点
            unsigned int imageIndex = i*width+j;
            unsigned char bitMapRed = *(imageData+imageIndex*4);
            unsigned char bitMapGreen = *(imageData+imageIndex*4+1);
            unsigned char bitMapBlue = *(imageData+imageIndex*4+2);
            memset(resultData+imageIndex*4, 255-bitMapRed, 1);
            memset(resultData+imageIndex*4+1, 255-bitMapGreen, 1);
            memset(resultData+imageIndex*4+2, 255-bitMapBlue, 1);
        }
    }
    return resultData;
}


// 灰度图像算法
// 彩色rgb值不相等。  灰度图像rgb值相等
// gray = 0.299*red + 0.587*green + 0.114*bue
-(unsigned char*)imageGrayWithData:(unsigned char*)imageData Width:(CGFloat)width height:(CGFloat)height{
    // 分配内存空间
    unsigned char* resultData = malloc(width*height*sizeof(unsigned char*)*4);
    // 把内存空间填充为0。因为之前内存空间未初始化，所以需要清0
    memset(resultData, 0, width*height*sizeof(unsigned char*)*4);
    // 提取每个像素，并对颜色进行修改
    // 行
    for (int i=0; i<height; i++) {
        // 列
        for (int j=0; j<width; j++) {
            // 获取像素点
            unsigned int imageIndex = i*width+j;
            unsigned char bitMapRed = *(imageData+imageIndex*4);
            unsigned char bitMapGreen = *(imageData+imageIndex*4+1);
            unsigned char bitMapBlue = *(imageData+imageIndex*4+2);
            int bitMap = bitMapRed*77/255+bitMapGreen*151/255+bitMapBlue*88/255;
            unsigned char newBitMap = bitMap>255?255:bitMap;
            memset(resultData+imageIndex*4, newBitMap, 1);
            memset(resultData+imageIndex*4+1, newBitMap, 1);
            memset(resultData+imageIndex*4+2, newBitMap, 1);
        }
    }
    return resultData;
}

-(void)grayImage{
    UIImage *image = [UIImage imageNamed:@"nsfw.jpg"];
    unsigned char* imageData = [self imageGrayWithData:[self convertUIImagetoData:image] Width:image.size.width height:image.size.height];
    self.image1.image = [self convertDataToUIImage:imageData image:image];
}

-(void)convertFormatTest{
    // 图片转换为数据
    UIImage *image = [UIImage imageNamed:@"nsfw.jpg"];
    unsigned char* imageData = [self convertUIImagetoData:image];
    self.image1.image = [self convertDataToUIImage:imageData image:image];
}

// unsigned char 指针
// 1.uiimage-》CGImage 2.cgcolorspace  3.分配bit级空间 4.cgbitmap  5.渲染
// 使用CoreGraphsic
-(unsigned char *)convertUIImagetoData:(UIImage *)image{
    CGImageRef imgRef = [image CGImage];
    CGSize imageSize = image.size;
    // 创建cgcolor，使用rgb彩色
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    // 每个像素点 对应 4个byte  r g b a 像素点个数等于当前width*height
    // malloc 内存分配
    void *data = malloc(imageSize.width*imageSize.height*4);
    // 创建bitmap
    CGContextRef contentRef = CGBitmapContextCreate(data, imageSize.width, imageSize.height, 8, 4*imageSize.width, colorSpaceRef, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    // 图片渲染
    CGContextDrawImage(contentRef, CGRectMake(0, 0, imageSize.width, imageSize.height), imgRef);
    // UIImage数据以rgba的形式存在data中
    CGColorSpaceRelease(colorSpaceRef);
    CGContextRelease(contentRef);
    return (unsigned char*)data;
}

// data转化为image
-(UIImage *)convertDataToUIImage:(unsigned char*)imageData image:(UIImage *)imageSource{
    CGFloat width = imageSource.size.width;
    CGFloat height = imageSource.size.height;
    NSInteger dataLenght = width*height*4;
    //
    CGDataProviderRef provide = CGDataProviderCreateWithData(nil, imageData, dataLenght, NULL);
    // 每个元素占用的字节数
    int bitsPerComponent = 8;
    // 每点4个元素，每个元素四个字节
    int bitsPerPixel = 32;
    int bytesPerRow = 4*width;
    
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    // 渲染方式
    CGColorRenderingIntent renderIntent = kCGRenderingIntentDefault;
    // 3.每个元素占用的字节数 4. 每个像素点占用位数 5.每行多少字节 6.rgb 7.bitinfo 8.原始数据
    CGImageRef imageRef = CGImageCreate(width, height, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpaceRef, bitmapInfo, provide, nil, NO, renderIntent);
    
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    CFRelease(imageRef);
    CGColorSpaceRelease(colorSpaceRef);
    CGDataProviderRelease(provide);
    return image;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

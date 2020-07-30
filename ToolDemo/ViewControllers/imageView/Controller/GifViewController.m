//
//  GifViewController.m
//  ToolDemo
//
//  Created by liuqingyuan on 2020/4/9.
//  Copyright © 2020 liuqingyuan. All rights reserved.
//

#import "GifViewController.h"
//#import <ImageIO/ImageIO.h>
//#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/MobileCoreServices.h>
@interface GifViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *gifPlayImgView;

@end

@implementation GifViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}

// gif图片显示
-(void)deCompositionGif{
    NSData *gifData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"gifdemo" ofType:@"gif"]];
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)gifData, nil);
    // 将gif分解
    // 获取gif帧数
    size_t count= CGImageSourceGetCount(source);
    // 创建图片你数组
    NSMutableArray *imgArr = [[NSMutableArray alloc]init];
    for (int i=0; i<count; i++) {
        // 安帧数提取图片
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(source, i, nil);
        // 转化为UIImage对象
        UIImage *image = [UIImage imageWithCGImage:imageRef scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
        [imgArr addObject:image];
        // 释放imageRef
        CGImageRelease(imageRef);
    }
    CFRelease(source);
    //分解后的图片保存到document中
//    int i=0;
//    for (UIImage *image in imgArr) {
//        NSData *data = UIImagePNGRepresentation(image);
//        NSString *path = [Tool getDocumentPath];
//        NSString *imagePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.jpg",i]];
//        i++;
//        [data writeToFile:imagePath atomically:YES];
//    }
    self.gifPlayImgView.animationImages = imgArr;
    self.gifPlayImgView.animationDuration = imgArr.count*0.1;
    [self.gifPlayImgView startAnimating];
}

// 图片合并成gif
-(void)createGif{
    // 创建gif文件
    NSString *docPath = [Tool getDocumentPath];
    NSString *gifPath = [docPath stringByAppendingPathComponent:@"gifdemo.gif"];
    // 配置文件属性
    CGImageDestinationRef destion;
    CFURLRef url = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, (CFStringRef) gifPath, kCFURLPOSIXPathStyle, false);
    
    destion = CGImageDestinationCreateWithURL(url, kUTTypeGIF, 30, nil);
    NSDictionary *frameDic = [NSDictionary dictionaryWithObject:@{(NSString *)kCGImagePropertyGIFDelayTime:[NSNumber numberWithFloat:3]} forKey:(NSString *)kCGImagePropertyGIFDelayTime];
    NSMutableDictionary *gifDic = [[NSMutableDictionary alloc]init];
    gifDic[(NSString *)kCGImagePropertyGIFHasGlobalColorMap] = [NSNumber numberWithBool:YES];
    gifDic[(NSString *)kCGImagePropertyColorModel] = (NSString *)kCGImagePropertyColorModelRGB;
    gifDic[(NSString *)kCGImagePropertyDepth] = [NSNumber numberWithInt:8];
    // 是否循环
    gifDic[(NSString *)kCGImagePropertyGIFLoopCount] = [NSNumber numberWithInt:0];
    NSDictionary *gifProperty = @{(NSString *)kCGImagePropertyGIFDictionary:gifDic};
    for (int i=0; i<30; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",i]];
        CGImageDestinationAddImage(destion, image.CGImage, (__bridge CFDictionaryRef)frameDic);
    }
    CGImageDestinationSetProperties(destion, (__bridge CFDictionaryRef)gifProperty);
    CGImageDestinationFinalize(destion);
    CFRelease(destion);
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

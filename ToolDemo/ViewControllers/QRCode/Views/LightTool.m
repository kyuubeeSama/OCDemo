//
//  LightTool.m
//  ErWeiMa
//
//  Created by liuqingyuan on 2018/1/7.
//  Copyright © 2018年 liuqingyuan. All rights reserved.
//

#import "LightTool.h"

@implementation LightTool

-(id)init
{
    self=[super init];
    if (self) {
        // 1.获取硬件设备
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        // 2.创建输入流
        AVCaptureDeviceInput *input = [[AVCaptureDeviceInput alloc]initWithDevice:device error:nil];
        // 3.创建设备输出流
        AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
        [output setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
        // AVCaptureSession属性
        self.session = [[AVCaptureSession alloc]init];
        // 设置为高质量采集率
        [self.session setSessionPreset:AVCaptureSessionPresetHigh];
        // 添加会话输入和输出
        if ([self.session canAddInput:input]) {
            [self.session addInput:input];
        }
        if ([self.session canAddOutput:output]) {
            [self.session addOutput:output];
        }
        // 9.启动会话
        [self.session startRunning];
    }
    return self;
}

#pragma mark- AVCaptureVideoDataOutputSampleBufferDelegate的方法
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    CFDictionaryRef metadataDict = CMCopyDictionaryOfAttachments(NULL,sampleBuffer, kCMAttachmentMode_ShouldPropagate);
    NSDictionary *metadata = [[NSMutableDictionary alloc] initWithDictionary:(__bridge NSDictionary*)metadataDict];
    CFRelease(metadataDict);
    NSDictionary *exifMetadata = [[metadata objectForKey:(NSString *)kCGImagePropertyExifDictionary] mutableCopy];
    float brightnessValue = [[exifMetadata objectForKey:(NSString *)kCGImagePropertyExifBrightnessValue] floatValue];
    NSLog(@"%f",brightnessValue);
    [[NSNotificationCenter defaultCenter]postNotificationName:@"lightValue" object:[NSString stringWithFormat:@"%f",brightnessValue]];
}

@end

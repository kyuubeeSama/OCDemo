//
//  ScanQRCodeViewController.m
//  ErWeiMa
//
//  Created by liuqingyuan on 2018/1/2.
//  Copyright © 2018年 liuqingyuan. All rights reserved.
//

#import "ScanQRCodeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <ImageIO/ImageIO.h>
#import "QRCodeBackgroundView.h"
#import "QRCodeAreaView.h"
#import "Tool.h"
#import "LightTool.h"

@interface ScanQRCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate,AVCaptureVideoDataOutputSampleBufferDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    AVCaptureSession * session;//输入输出的中间桥梁
    QRCodeAreaView *_areaView;//扫描区域视图
}
@property(nonatomic,assign)int isLight;
@end

@implementation ScanQRCodeViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isLight = 1;
    [self createBodyView];
}

-(void)printValue:(NSNotification *)notifaction{
    NSString *lightValue = notifaction.object;
    NSLog(@"%@",lightValue);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)createBodyView
{
    //扫描区域
    CGRect areaRect = CGRectMake((SCREEN_WIDTH - 250)/2, 150, 250, 250);
    
    //半透明背景
    QRCodeBackgroundView *bacgrouView = [[QRCodeBackgroundView alloc]initWithFrame:self.view.bounds];
    bacgrouView.scanFrame = areaRect;
    [self.view addSubview:bacgrouView];
    
    //设置扫描区域
    _areaView = [[QRCodeAreaView alloc]initWithFrame:areaRect];
    [self.view addSubview:_areaView];
    [_areaView.lightBtn addTarget:self action:@selector(lightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //提示文字
    UILabel *label = [UILabel new];
    label.text = @"将二维码放入框内，即开始扫描";
    label.textColor = [UIColor whiteColor];
    label.frame=CGRectMake(0, CGRectGetMaxY(_areaView.frame) + 20, SCREEN_WIDTH, 15);
//    label.y = CGRectGetMaxY(_areaView.frame) + 20;
    [label sizeToFit];
    label.center = CGPointMake(_areaView.center.x, label.center.y);
    [self.view addSubview:label];
    
    //返回键
    UIButton *backbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    backbutton.frame = CGRectMake(12, 26, 42, 42);
    [backbutton setBackgroundImage:[UIImage imageNamed:@"prev"] forState:UIControlStateNormal];
    [backbutton addTarget:self action:@selector(clickBackButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backbutton];
    
    UIButton *imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    imageBtn.frame=CGRectMake(SCREEN_WIDTH-44, 20, 44, 44);
    [self.view addSubview:imageBtn];
    [imageBtn setTitle:@"相册" forState:UIControlStateNormal];
    [imageBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [imageBtn addTarget:self action:@selector(openImage:) forControlEvents:UIControlEventTouchUpInside];
    
    /**
     *  初始化二维码扫描
     */
    
    //获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];

    //创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    //创建输出流
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    // 感光
    AVCaptureVideoDataOutput *newOutput = [[AVCaptureVideoDataOutput alloc] init];
    [newOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    //设置识别区域
    //深坑，这个值是按比例0~1设置，而且X、Y要调换位置，width、height调换位置
    output.rectOfInterest = CGRectMake(_areaView.frame.origin.y/SCREEN_HEIGHT, _areaView.frame.origin.x/SCREEN_WIDTH, _areaView.frame.size.height/SCREEN_HEIGHT, _areaView.frame.size.width/SCREEN_WIDTH);
    
    //初始化链接对象
    session = [[AVCaptureSession alloc]init];
    //高质量采集率
    [session setSessionPreset:AVCaptureSessionPresetHigh];
    
    [session addInput:input];
    [session addOutput:output];
    [session addOutput:newOutput];
    
    //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    layer.frame=self.view.layer.bounds;
    
    [self.view.layer insertSublayer:layer atIndex:0];
    
    //开始捕获
    [session startRunning];
}

-(void)openImage:(UIButton *)button
{
    // 打开相册
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    imagePickerController.allowsEditing = NO;
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

//点击返回按钮回调
-(void)clickBackButton{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)lightBtnClick:(UIButton *)button
{
    // 闪光灯开启关闭按钮
    if (self.isLight == 1) {
        // 打开闪光灯
        [Tool openLight];
        [_areaView.lightBtn setImage:[UIImage imageNamed:@"flashlight_click_ico"] forState:UIControlStateNormal];
        self.isLight = 2;
    }
    else
    {
        // 关闭闪光灯
        [Tool closeLight];
        [_areaView.lightBtn setImage:[UIImage imageNamed:@"flashlight_ico"] forState:UIControlStateNormal];
        self.isLight = 1;
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];        //返回的UIImage
    CIImage *ciImage = [CIImage imageWithCGImage:[image CGImage]];
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:nil];
    NSArray *arr = [detector featuresInImage:ciImage];
    [self dismissViewControllerAnimated:YES completion:nil];
    if (arr.count>0) {
        CIQRCodeFeature *feature = arr[0];
        NSString *QRCodeUrl = feature.messageString;
        NSLog(@"二维码地址是%@",QRCodeUrl);
        // 1. 将二维码地址存到剪贴板
        // 2.使用alertviewcontroller将二维码弹出
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = QRCodeUrl;
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告" message:[NSString stringWithFormat:@"二维码地址是：%@。已复制到剪贴板",QRCodeUrl] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        NSLog(@"图片错误");
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"错误二维码" message:@"该图片不包含二维码" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:cancelAction];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma 二维码扫描的回调
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count>0) {
        [session stopRunning];//停止扫描
        [_areaView stopAnimaion];//暂停动画
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex :0];
        //输出扫描字符串
        NSLog(@"%@",metadataObject.stringValue);
        // 1. 将二维码地址存到剪贴板
        // 2.使用alertviewcontroller将二维码弹出
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = metadataObject.stringValue;
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告" message:[NSString stringWithFormat:@"二维码地址是：%@。已复制到剪贴板",metadataObject.stringValue] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];

    }
}

#pragma mark- AVCaptureVideoDataOutputSampleBufferDelegate的方法
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    CFDictionaryRef metadataDict = CMCopyDictionaryOfAttachments(NULL,sampleBuffer, kCMAttachmentMode_ShouldPropagate);
    NSDictionary *metadata = [[NSMutableDictionary alloc] initWithDictionary:(__bridge NSDictionary*)metadataDict];
    CFRelease(metadataDict);
    NSDictionary *exifMetadata = [[metadata objectForKey:(NSString *)kCGImagePropertyExifDictionary] mutableCopy];
    float brightnessValue = [[exifMetadata objectForKey:(NSString *)kCGImagePropertyExifBrightnessValue] floatValue];

    NSLog(@"%f",brightnessValue);
    if ([Tool isLightExist] && self.isLight == 1) {
        if (brightnessValue > 2) {
            _areaView.lightBtn.alpha=0;
        }
        else
        {
            _areaView.lightBtn.alpha = 1;
            [_areaView.lightBtn setImage:[UIImage imageNamed:@"flashlight_ico"] forState:UIControlStateNormal];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

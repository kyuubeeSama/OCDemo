//
//  RecordVideoViewController.m
//  ToolDemo
//
//  Created by liuqingyuan on 2020/4/14.
//  Copyright © 2020 liuqingyuan. All rights reserved.
//

#import "RecordVideoViewController.h"
#import "View+MASAdditions.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
@interface RecordVideoViewController ()<AVCaptureFileOutputRecordingDelegate>
{
    BOOL isRecordering;
}

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *recordBtn;

@property(nonatomic,strong) AVCaptureSession *session;
@property(nonatomic,strong) AVCaptureMovieFileOutput *output;

@end

@implementation RecordVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 30));
        make.centerX.equalTo(self.view.mas_centerX);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-20);
        } else {
            // Fallback on earlier versions
            make.bottom.equalTo(self.view.mas_bottom).offset(-20);
        }
    }];
    isRecordering = NO;
    self.session = [[AVCaptureSession alloc]init];
    self.session.sessionPreset = AVCaptureSessionPresetMedium;
    NSError *error = nil;
    // 设置媒体类型
    // 设置视频设备
    AVCaptureDevice *cameraDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *camera = [AVCaptureDeviceInput deviceInputWithDevice:cameraDevice error:&error];
    // 设置音频设备
    AVCaptureDevice *micDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    AVCaptureDeviceInput *mic = [AVCaptureDeviceInput deviceInputWithDevice:micDevice error:&error];
    [self.session addInput:camera];
    [self.session addInput:mic];
    
    self.output = [[AVCaptureMovieFileOutput alloc]init];
    if ([self.session canAddOutput:self.output]) {
        [self.session addOutput:self.output];
    }
    
    AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    previewLayer.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-300);
    //TODO:学习insertsublayer
    [self.view.layer insertSublayer:previewLayer atIndex:0];
    [self.session startRunning];
    isRecordering = NO;
}
- (IBAction)recordBtnClick:(UIButton *)sender {
    if (!isRecordering) {
        [self.recordBtn setTitle:@"停止" forState:UIControlStateNormal];
        self.titleLab.text = @"录制中";
        isRecordering = YES;
        NSURL *fileUrl = [self fileUrl];
        [self.output startRecordingToOutputFileURL:fileUrl recordingDelegate:self];
    }else{
        [self.recordBtn setTitle:@"开始录制" forState:UIControlStateNormal];
        self.titleLab.text = @"停止";
        [self.output stopRecording];
        isRecordering = NO;
    }
}

-(NSURL *)fileUrl{
    NSString *outputPath = [[NSString alloc]initWithFormat:@"%@movie.mov",NSTemporaryDirectory()];
    NSURL *outputUrl = [[NSURL alloc]initFileURLWithPath:outputPath];
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:outputPath]) {
        [manager removeItemAtPath:outputPath error:nil];
    }
    return outputUrl;
}

-(void)captureOutput:(AVCaptureFileOutput *)output didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray<AVCaptureConnection *> *)connections error:(NSError *)error{
    // 录制结束
    if (error == nil) {
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc]init];
        [library writeVideoAtPathToSavedPhotosAlbum:outputFileURL completionBlock:^(NSURL *assetURL, NSError *error) {
            if (error) {
                NSLog(@"写入错误");
            }
        }];
    }
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

//
//  GetFaceViewController.m
//  ToolDemo
//
//  Created by liuqingyuan on 2020/4/12.
//  Copyright © 2020 liuqingyuan. All rights reserved.
//

#import "GetFaceViewController.h"

@interface GetFaceViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIImageView *faceImg;


@end

@implementation GetFaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)getFace:(id)sender {
    CIContext *context = [CIContext contextWithOptions:nil];
    UIImage *imageInput = [UIImage imageNamed:@"nsfw.jpg"];
    CIImage *image = [CIImage imageWithCGImage:imageInput.CGImage];
    NSDictionary *param = @{CIDetectorAccuracy:CIDetectorAccuracyHigh};
    // 设置类型为识别面部。其他类型可以参考
    CIDetector *faceDetector = [CIDetector detectorOfType:CIDetectorTypeFace context:context options:param];
    NSArray *detectResult = [faceDetector featuresInImage:image];

    UIView *resultView = [[UIView alloc] initWithFrame:self.imageView.frame];
    [self.view addSubview:resultView];
    for(CIFaceFeature *faceFeature  in detectResult){
        // 面部
        UIView *faceView = [[UIView alloc] initWithFrame:faceFeature.bounds];
        faceView.layer.borderWidth = 1;
        faceView.layer.borderColor = [UIColor orangeColor].CGColor;
        [resultView addSubview:faceView];

        // 左眼
        if (faceFeature.hasLeftEyePosition){
            UIView *leftEyeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
            leftEyeView.center = faceFeature.leftEyePosition;
            leftEyeView.layer.borderWidth = 1;
            leftEyeView.layer.borderColor = [[UIColor redColor] CGColor];
            [resultView addSubview:leftEyeView];
        }
        if (faceFeature.hasRightEyePosition){
            UIView *rightEyeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
            rightEyeView.center = faceFeature.rightEyePosition;
            rightEyeView.layer.borderWidth = 1;
            rightEyeView.layer.borderColor = [[UIColor redColor] CGColor];
            [resultView addSubview:rightEyeView];
        }
        if (faceFeature.hasMouthPosition){
            UIView *mouthView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 5)];
            mouthView.center = faceFeature.rightEyePosition;
            mouthView.layer.borderWidth = 1;
            mouthView.layer.borderColor = [[UIColor redColor] CGColor];
            [resultView addSubview:mouthView];
        }
        resultView.transform = CGAffineTransformMakeScale(1, -1);
        if (detectResult.count>0){
            CIImage *faceImage = [image imageByCroppingToRect:[detectResult[0] bounds]];
            UIImage *face = [UIImage imageWithCGImage:[context createCGImage:faceImage fromRect:faceImage.extent]];
            self.faceImg.image = face;
        }
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

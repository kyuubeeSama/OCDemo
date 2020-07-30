//
//  CoreImageViewController.m
//  ToolDemo
//
//  Created by liuqingyuan on 2020/4/12.
//  Copyright © 2020 liuqingyuan. All rights reserved.
//

#import "CoreImageViewController.h"

@interface CoreImageViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
// 1.旧色调 2.高斯模糊
@property (nonatomic,assign)int type;
@property (weak, nonatomic) IBOutlet UISlider *slider;

@end

@implementation CoreImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.type = 0;
    [self sliderValueChange:self.slider];
}

- (IBAction)sliderValueChange:(UISlider *)sender {
    UIImage *image = [UIImage imageNamed:@"nsfw.jpg"];
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *ciImage = [CIImage imageWithCGImage:[image CGImage]];
    CIImage *result;
    if (self.type == 0) {
        // 创建效果
        CIFilter *sepiaTone = [CIFilter filterWithName:@"CISepiaTone"];
        // 输入图像
        [sepiaTone setValue:ciImage forKey:@"inputImage"];
        self.titleLab.text = [NSString stringWithFormat:@"旧色调%.2f",sender.value];
        // 设置参数
        [sepiaTone setValue:@(sender.value) forKey:@"inputIntensity"];
        // 输出图片
        result = [sepiaTone valueForKey:@"outputImage"];
    }else{
        CIFilter *gaussianBlur = [CIFilter filterWithName:@"CIGaussianBlur"];
        [gaussianBlur setValue:ciImage forKey:@"inputImage"];
        self.titleLab.text = [NSString stringWithFormat:@"高斯%.2f",sender.value*10];
        [gaussianBlur setValue:@(sender.value*10) forKey:@"inputRadius"];
        result = [gaussianBlur valueForKey:@"outputImage"];
    }
    CGImageRef imageRef = [context createCGImage:result fromRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    self.imageView.image = newImage;
    CFRelease(imageRef);
}


- (IBAction)segmentValueChange:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        self.type = 0;
    }else{
        self.type = 1;
    }
    self.imageView.image = [UIImage imageNamed:@"nsfw.jpg"];
    [self sliderValueChange:self.slider];
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

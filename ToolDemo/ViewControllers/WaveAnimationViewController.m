//
//  WaveAnimationViewController.m
//  ToolDemo
//
//  Created by liuqingyuan on 2018/11/8.
//  Copyright © 2018 liuqingyuan. All rights reserved.
//

#import "WaveAnimationViewController.h"
#import "FirstWaves.h"
#import "SecondWaves.h"

@interface WaveAnimationViewController ()

@property (nonatomic,strong)FirstWaves *firstWare;
@property (nonatomic,strong)SecondWaves *secondWare;

@end

@implementation WaveAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //第一个波浪
    self.firstWare = [[FirstWaves alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-220, SCREEN_WIDTH, 220)];
    self.firstWare.alpha=0.6;

    //第二个波浪
    self.secondWare = [[SecondWaves alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-220, SCREEN_WIDTH, 220)];
    self.secondWare.alpha=0.6;
    
    [self.view addSubview:self.firstWare];
    [self.view addSubview:self.secondWare];
    
    //是否有震荡效果
    //[NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(animateWave) userInfo:nil repeats:YES];
}

- (void)animateWave{
    [UIView animateWithDuration:1 animations:^{
        self.firstWare.transform = CGAffineTransformMakeTranslation(0, 20);
        self.secondWare.transform = CGAffineTransformMakeTranslation(0, 20);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1 animations:^{
            self.firstWare.transform = CGAffineTransformMakeTranslation(0, 0);
            self.secondWare.transform = CGAffineTransformMakeTranslation(0, 0);
        } completion:nil];
    }];
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

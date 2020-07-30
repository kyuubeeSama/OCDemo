//
//  PathAnimationViewController.m
//  ToolDemo
//
//  Created by liuqingyuan on 2020/4/13.
//  Copyright © 2020 liuqingyuan. All rights reserved.
//

#import "PathAnimationViewController.h"

@interface PathAnimationViewController ()<CAAnimationDelegate>
{
    int flag;
}

@property (weak, nonatomic) IBOutlet UIView *animationView;

@end

@implementation PathAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    flag = 1;
}
- (IBAction)beginAnimation:(UIButton *)sender {
    // 设置路径
    CGMutablePathRef starPath = CGPathCreateMutable();
    CGPathMoveToPoint(starPath, nil, 160, 100);
    CGPathAddLineToPoint(starPath, nil, 100, 280);
    CGPathAddLineToPoint(starPath, nil, 260, 170);
    CGPathAddLineToPoint(starPath, nil, 60, 170);
    CGPathAddLineToPoint(starPath, nil, 220, 280);
    CGPathCloseSubpath(starPath);

    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    [animation setDuration:10];
    [animation setDelegate:self];
    [animation setPath:starPath];
    CFRelease(starPath);
    [self.animationView.layer addAnimation:animation forKey:@"position"];
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
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

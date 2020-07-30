//
//  YaoViewController.m
//  ToolDemo
//
//  Created by liuqingyuan on 2019/5/20.
//  Copyright © 2019 liuqingyuan. All rights reserved.
//

#import "YaoViewController.h"

@interface YaoViewController ()


@end

@implementation YaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // ios 摇动判断
    [UIApplication sharedApplication].applicationSupportsShakeToEdit = YES;
    [self becomeFirstResponder];
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    [super motionBegan:motion withEvent:event];
    NSLog(@"开始摇动");
}

-(void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    [super motionCancelled:motion withEvent:event];
    NSLog(@"摇动取消");
}

-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    [super motionEnded:motion withEvent:event];
    if (event.subtype == UIEventSubtypeMotionShake) {
        NSLog(@"摇动结束");
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"提示内容" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *oneAction = [UIAlertAction actionWithTitle:@"警示" style:UIAlertActionStyleDestructive handler:nil];
        UIAlertAction *twoAction = [UIAlertAction actionWithTitle:@"提示" style:UIAlertActionStyleDefault handler:nil];
        UIAlertAction *threeAction = [UIAlertAction actionWithTitle:@"提示" style:UIAlertActionStyleDefault handler:nil];
        UIAlertAction *fourAction = [UIAlertAction actionWithTitle:@"提示" style:UIAlertActionStyleDefault handler:nil];
        UIAlertAction *fiveAction = [UIAlertAction actionWithTitle:@"提示" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:oneAction];
        [alert addAction:twoAction];
        [alert addAction:threeAction];
        [alert addAction:fourAction];
        [alert addAction:fiveAction];
        [self presentViewController:alert animated:YES completion:nil];
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

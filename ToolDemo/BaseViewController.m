//
//  BaseViewController.m
//  ToolDemo
//
//  Created by liuqingyuan on 2018/4/12.
//  Copyright © 2018年 liuqingyuan. All rights reserved.
//

#import "BaseViewController.h"
#import "ShareView.h"
#import "MBProgressHUD.h"
#import "Masonry.h"
@interface BaseViewController ()

@property(nonatomic,strong)MBProgressHUD *progress;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
}

-(void)beginProgressWithTitle:(nullable NSString *)title
{
    if (self.progress==nil) {
        self.progress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.progress.label.text = title;
    }
}

-(void)endProgress
{
    [self.progress hideAnimated:YES];
    self.progress = nil;
}
//显示提示
-(void)showAlertWithTitle:(NSString *)string
{
    MBProgressHUD *progress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progress.label.text = string;
    progress.mode = MBProgressHUDModeText;
    [progress hideAnimated:YES afterDelay:2];
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

//
//  CreateGestureViewController.m
//  ToolDemo
//
//  Created by liuqingyuan on 2018/12/27.
//  Copyright © 2018 liuqingyuan. All rights reserved.
//

#import "CreateGestureViewController.h"
#import "YWUnlockPreviewView.h"
#import "YWGesturesUnlockView.h"
@interface CreateGestureViewController ()

@end

@implementation CreateGestureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createHeadView];
}

-(void)createHeadView{
    // 创建头view
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:cancelBtn];
    [cancelBtn setImage:[UIImage imageNamed:@"prev"] forState:UIControlStateNormal];
    cancelBtn.frame = CGRectMake(10, SCREEN_TOP, 44, 44);
    [cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *titleLab = [[UILabel alloc]init];
    [self.view addSubview:titleLab];
    titleLab.frame = CGRectMake(100, SCREEN_TOP, SCREEN_WIDTH-200, 44);
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont systemFontOfSize:15];
    titleLab.text = @"创建密码";
}

-(void)createBodyView{
    // 创建手势九宫格
    
}

-(void)cancelBtnClick:(UIButton *)button{
    [self dismissViewControllerAnimated:YES completion:nil];
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

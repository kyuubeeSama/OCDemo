//
//  GestureViewController.m
//  ToolDemo
//
//  Created by liuqingyuan on 2018/12/27.
//  Copyright © 2018 liuqingyuan. All rights reserved.
//

#import "GestureViewController.h"
#import "CreateGestureViewController.h"
#import "ValidateViewController.h"
@interface GestureViewController ()

@end

@implementation GestureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"密码验证";
    [self createBodyView];
}

-(void)createBodyView{
    // 创建两个按钮
    NSArray *titleArr = @[@"创建",@"验证"];
    for (int i=0; i<2; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:titleArr[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.frame=CGRectMake((SCREEN_WIDTH-100)/2, 150+60*i, 100, 40);
        button.tag = 100+i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
}

-(void)buttonClick:(UIButton *)button
{
    if (button.tag == 100) {
        // 创建
        CreateGestureViewController *VC = [[CreateGestureViewController alloc]init];
        [self presentViewController:VC animated:YES completion:nil];
    }else{
        // 验证
        // 先判断当前用户是否有设置手势密码
        ValidateViewController *VC = [[ValidateViewController alloc]init];
        [self presentViewController:VC animated:YES completion:nil];
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

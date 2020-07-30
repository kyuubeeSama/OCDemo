//
//  ShareViewController.m
//  ToolDemo
//
//  Created by liuqingyuan on 2018/4/12.
//  Copyright © 2018年 liuqingyuan. All rights reserved.
//

#import "ShareViewController.h"

@interface ShareViewController ()

@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title=@"友盟分享";
    [self createBtn];
}

-(void)createBtn
{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:button];
    [button setTitle:@"分享" forState:UIControlStateNormal];
    button.bounds=CGRectMake(0, 0, 100, 50);
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.center=self.view.center;
    [button addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)shareBtnClick:(UIButton *)button
{
    // 弹出分享界面
    [self shareWithDic:nil];
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

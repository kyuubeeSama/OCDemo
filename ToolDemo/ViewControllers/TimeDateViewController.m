//
//  TimeDateViewController.m
//  ToolDemo
//
//  Created by liuqingyuan on 2018/5/18.
//  Copyright © 2018年 liuqingyuan. All rights reserved.
//

#import "TimeDateViewController.h"
#import "DateTimeView.h"
#import "Tool.h"
@interface TimeDateViewController ()<DateTimeViewDelegate>

@end

@implementation TimeDateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    [self createBtn];
}

-(void)createBtn
{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:button];
    button.center=self.view.center;
    button.bounds=CGRectMake(0, 0, 100, 100);
    [button setTitle:@"时间选择器" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(dateTimeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)dateTimeBtnClick:(UIButton *)button
{
    DateTimeView *view=[[DateTimeView alloc]init];
    [self.view addSubview:view];
    view.delegate=self;
    view.frame=CGRectMake(0, SCREEN_HEIGHT-200, SCREEN_WIDTH, 200);
    
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

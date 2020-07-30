//
//  PersonDemoViewController.m
//  ToolDemo
//
//  Created by liuqingyuan on 2019/3/12.
//  Copyright © 2019 liuqingyuan. All rights reserved.
//

#import "PersonDemoViewController.h"

@interface PersonDemoViewController ()

@end

@implementation PersonDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, SCREEN_HEIGHT)];
    [self.view addSubview:leftView];
    leftView.backgroundColor = [UIColor whiteColor];
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

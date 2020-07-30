//
//  SliderViewController.m
//  ToolDemo
//
//  Created by liuqingyuan on 2019/3/12.
//  Copyright © 2019 liuqingyuan. All rights reserved.
//

#import "SliderViewController.h"
#import "JYJSliderMenuTool.h"
#import "PersonDemoViewController.h"
@interface SliderViewController ()

@end

@implementation SliderViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [JYJSliderMenuTool wwww];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"屏幕滑动测试";
    [self addGuestureRecgnizer];
}

-(void)addGuestureRecgnizer
{
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"菜单" style:UIBarButtonItemStyleDone target:self action:@selector(my)];
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizer];
}

- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    if(recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        [self my];
    }
}

- (void)my {
    [JYJSliderMenuTool showWithRootViewController:self];
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

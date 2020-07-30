//
//  ViewController.m
//  ToolDemo
//
//  Created by liuqingyuan on 2018/4/8.
//  Copyright © 2018年 liuqingyuan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    UIColor *randomColor = [UIColor colorWithRed:(arc4random()%255)*1.0f/255.0
                                           green:(arc4random()%255)*1.0f/255.0
                                            blue:(arc4random()%255)*1.0f/255.0 alpha:1];
    self.view.backgroundColor = randomColor;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

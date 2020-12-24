//
//  BaseViewController.h
//  ToolDemo
//
//  Created by liuqingyuan on 2018/4/12.
//  Copyright © 2018年 liuqingyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tool.h"
@interface BaseViewController : UIViewController

-(void)beginProgressWithTitle:(nullable NSString *)title;
-(void)endProgress;
-(void)showAlertWithTitle:(nullable NSString *)string;

@end

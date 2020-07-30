
//
//  TouchidViewController.m
//  ToolDemo
//
//  Created by liuqingyuan on 2018/11/27.
//  Copyright © 2018 liuqingyuan. All rights reserved.
//

#import "TouchidViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
@interface TouchidViewController ()

@end

@implementation TouchidViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"指纹解锁";
    [self createView];
    [self checkDevice];
    
}

-(void)createView
{
    UILabel *titleLab = [[UILabel alloc]init];
    [self.view addSubview:titleLab];
    titleLab.center = self.view.center;
    titleLab.bounds = CGRectMake(0, 0, 300, 40);
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.textColor = [UIColor redColor];
    titleLab.tag = 100;
    titleLab.font = [UIFont systemFontOfSize:15];
    titleLab.text = @"请使用touchid解锁";
}

-(void)checkDevice
{
    UILabel *label = [self.view viewWithTag:100];
    //首先判断版本
    if (NSFoundationVersionNumber < NSFoundationVersionNumber_iOS_8_0) {
        //        NSLog(@"系统版本不支持TouchID");
        label.text = @"系统版本不支持TouchID";
        return;
    }
    
    LAContext *context = [[LAContext alloc] init];
    context.localizedFallbackTitle = @"输入密码";
    if (@available(iOS 10.0, *)) {
        //        context.localizedCancelTitle = @"22222";
    } else {
        // Fallback on earlier versions
    }
    NSError *error = nil;
    
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"请使用指纹解锁" reply:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    label.text = @"TouchID 验证成功";
                });
            }else if(error){
                
                switch (error.code) {
                    case LAErrorAuthenticationFailed:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            label.text = @"TouchID 验证失败";
                        });
                        break;
                    }
                    case LAErrorUserCancel:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            label.text = @"TouchID 被用户手动取消";
                        });
                    }
                        break;
                    case LAErrorUserFallback:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            label.text = @"用户不使用TouchID,选择手动输入密码";
                        });
                    }
                        break;
                    case LAErrorSystemCancel:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            label.text = @"TouchID 被系统取消 (如遇到来电,锁屏,按了Home键等)";
                        });
                    }
                        break;
                    case LAErrorPasscodeNotSet:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            label.text = @"TouchID 无法启动,因为用户没有设置密码";
                        });
                    }
                        break;
                    case LAErrorTouchIDNotEnrolled:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            label.text = @"TouchID 无法启动,因为用户没有设置TouchID";
                        });
                    }
                        break;
                    case LAErrorTouchIDNotAvailable:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            label.text = @"TouchID 无效";
                        });
                    }
                        break;
                    case LAErrorTouchIDLockout:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            label.text = @"TouchID 被锁定(连续多次验证TouchID失败,系统需要用户手动输入密码)";
                        });
                    }
                        break;
                    case LAErrorAppCancel:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            label.text = @"当前软件被挂起并取消了授权 (如App进入了后台等)";
                        });
                    }
                        break;
                    case LAErrorInvalidContext:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            label.text = @"当前软件被挂起并取消了授权 (LAContext对象无效)";
                        });
                    }
                        break;
                    default:
                        break;
                }
            }
        }];
    }else{
        label.text = @"当前设备不支持TouchID";
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

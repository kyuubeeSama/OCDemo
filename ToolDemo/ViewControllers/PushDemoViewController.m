//
//  PushDemoViewController.m
//  ToolDemo
//
//  Created by liuqingyuan on 2019/5/22.
//  Copyright © 2019 liuqingyuan. All rights reserved.
//

#import "PushDemoViewController.h"
#import <UserNotifications/UserNotifications.h>
@interface PushDemoViewController ()<UNUserNotificationCenterDelegate>

@end

@implementation PushDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //TODO:添加按钮，点击按钮发送推送
    if ([[UIApplication sharedApplication] currentUserNotificationSettings].types != UIUserNotificationTypeNone) {
        // 进入后台后发送通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendLocalNotification) name:UIApplicationDidEnterBackgroundNotification object:nil];
    } else{
        //用户注册通知，注册后才能收到通知，这会给用户一个弹框，提示用户选择是否允许发送通知
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound   categories:nil]];
    }
}

- (void)sendLocalNotification {
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        content.title = @"iOS10通知";
        content.subtitle = @"新通知学习笔记";
        content.body = @"新通知变化很大，之前本地通知和远程推送是两个类，现在合成一个了。这是一条测试通知，";
        content.badge = @1;
//        UNNotificationSound *sound = [UNNotificationSound soundNamed:@""];
//        content.sound = sound;
        content.userInfo = @{@"value":@"notification"};
        content.sound = [UNNotificationSound defaultSound];
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"OXNotification" content:content trigger:nil];
        [center addNotificationRequest:request withCompletionHandler:^(NSError *_Nullable error) {
            NSLog(@"成功添加推送");
        }];
    } else {
        // Fallback on earlier versions
        UILocalNotification *notification=[[UILocalNotification alloc] init];
        notification.fireDate=[NSDate dateWithTimeIntervalSinceNow:5];
        notification.alertBody=@"闹钟响了。";
        notification.alertTitle=@"请打开闹钟";
        notification.repeatInterval=NSCalendarUnitSecond;
        //设置本地通知的时区
        notification.timeZone = [NSTimeZone defaultTimeZone];
        notification.applicationIconBadgeNumber=1;
        
        notification.userInfo=@{@"name":@"zhangsanfeng"};
        notification.soundName=UILocalNotificationDefaultSoundName;
        //调用通知
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
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

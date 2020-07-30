//
//  ProximityViewController.m
//  chuanganqi
//
//  Created by liuqingyuan on 2018/2/24.
//  Copyright © 2018年 liuqingyuan. All rights reserved.
//

#import "ProximityViewController.h"

@interface ProximityViewController ()

@end

@implementation ProximityViewController

// FIXME:完善传感器：计步器传感器，加速度，陀螺仪
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title=@"距离传感器";
    // 打开距离传感器
    [UIDevice currentDevice].proximityMonitoringEnabled = YES;
    // 通过通知监听有物品靠近还是离开
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(proximityStateDidChange:) name:UIDeviceProximityStateDidChangeNotification object:nil];
}

- (void)proximityStateDidChange:(NSNotification *)note
{
    if ([UIDevice currentDevice].proximityState) {
        NSLog(@"有物品靠近");
    } else {
        NSLog(@"有物品离开");
    }
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

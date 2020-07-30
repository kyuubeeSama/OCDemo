//
//  DanMuViewController.m
//  ToolDemo
//
//  Created by liuqingyuan on 2020/4/8.
//  Copyright © 2020 liuqingyuan. All rights reserved.
// FIXME:详细理解，并添加详细注释

#import "DanMuViewController.h"
#import "BulletManager.h"
@interface DanMuViewController ()

@property(nonatomic,strong)BulletManager *manager;

@end

@implementation DanMuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    __weak typeof(self) weakSelf = self;
    self.manager.generateViewBlock = ^(BulletView * _Nonnull view) {
        view.frame = CGRectMake(SCREEN_WIDTH, 300+view.trajectory*40, CGRectGetWidth(view.bounds), CGRectGetHeight(view.bounds));
        [weakSelf.view addSubview:view];
        [view startAnimation];
    };
}

- (IBAction)stopBiets:(id)sender {
    [self.manager stop];
}


- (IBAction)beginBullets:(id)sender {
    [self.manager start];
}

-(BulletManager *)manager{
    if (!_manager) {
        _manager = [[BulletManager alloc]init];
    }
    return _manager;
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

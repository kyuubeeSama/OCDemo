//
//  PointNineViewController.m
//  ToolDemo
//
//  Created by liuqingyuan on 2019/3/14.
//  Copyright © 2019 liuqingyuan. All rights reserved.
//

#import "PointNineViewController.h"

@interface PointNineViewController ()

@end

@implementation PointNineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.center = self.view.center;
    imageView.bounds = CGRectMake(0, 0, 80, 600);
    [self.view addSubview:imageView];
    
    UIImage *image = [UIImage imageNamed:@"lt_zqp"];
    CGFloat top = 30;       // 顶端盖高度
    CGFloat bottom = 30;    // 底端盖高度
    CGFloat left = 30;     // 左端盖宽度
    CGFloat right = 30;    // 右端盖宽度
    
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    /*
     * Stretch  拉伸
     * Tile     平铺
     */
    image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    imageView.image = image;
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

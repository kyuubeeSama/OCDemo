//
//  ViewAnimationViewController.m
//  ToolDemo
//
//  Created by liuqingyuan on 2020/4/13.
//  Copyright © 2020 liuqingyuan. All rights reserved.
//

#import "ViewAnimationViewController.h"

@interface ViewAnimationViewController ()

@property (weak, nonatomic) IBOutlet UIButton *beginBtn;
@property (weak, nonatomic) IBOutlet UIView *animationView;


@end

@implementation ViewAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)buttonClick:(UIButton *)sender {
    self.beginBtn.hidden = YES;
    [UIView animateWithDuration:2 animations:^{
        CGRect rect = self.animationView.frame;
//        rect.origin.y = 176+100;
        self.animationView.frame = rect;
    } completion:^(BOOL finished) {
        self.beginBtn.hidden = NO;
    }];
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

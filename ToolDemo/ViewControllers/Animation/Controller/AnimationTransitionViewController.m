//
//  AnimationTransitionViewController.m
//  ToolDemo
//
//  Created by liuqingyuan on 2020/4/13.
//  Copyright © 2020 liuqingyuan. All rights reserved.
//

#import "AnimationTransitionViewController.h"

@interface AnimationTransitionViewController ()

@property (weak, nonatomic) IBOutlet UIView *animationView;


@end

@implementation AnimationTransitionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
}

- (IBAction)buttonClick:(UIButton *)sender {
    switch (sender.tag){
        case 1:
        {
            [UIView transitionWithView:self.animationView duration:3.0f options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionTransitionFlipFromLeft animations:nil completion:nil];
        }
            break;
        case 2:{
            [UIView transitionWithView:self.animationView duration:3.0f options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionTransitionFlipFromRight animations:nil completion:nil];
        }
            break;
        case 3:{
            [UIView transitionWithView:self.animationView duration:3.0f options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionTransitionCurlUp animations:nil completion:nil];
        }
            break;
        default:{
            [UIView transitionWithView:self.animationView duration:3.0f options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionTransitionCurlDown animations:nil completion:nil];
        }
            break;
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

//
//  AnimationViewController.m
//  ToolDemo
//
//  Created by liuqingyuan on 2020/4/13.
//  Copyright © 2020 liuqingyuan. All rights reserved.
//

#import "AnimationViewController.h"
#import "ViewAnimationViewController.h"
#import "AnimationTransitionViewController.h"
#import "SliderTransitionAnimator.h"
#import "BehaviorViewController.h"
#import "PathAnimationViewController.h"
@interface AnimationViewController ()<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,UIViewControllerTransitioningDelegate>

@property(nonatomic,strong)UITableView *mainTable;
@property(nonatomic,copy)NSArray *listArr;

@end

@implementation AnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.listArr = @[@"动画块",@"过渡动画",@"重力行为",@"碰撞行为",@"吸附行为",@"推行为",@"甩行为",@"路径动画"];
    [self makeUI];
}

-(void)makeUI{
    self.navigationController.delegate = self;
    self.transitioningDelegate = self;
    self.mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    [self.view addSubview:self.mainTable];
    self.mainTable.delegate = self;
    self.mainTable.dataSource = self;
    self.mainTable.estimatedRowHeight = 0;
    self.mainTable.estimatedSectionFooterHeight = 0;
    self.mainTable.estimatedSectionHeaderHeight = 0;
    self.mainTable.rowHeight = 60;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.textLabel.text = self.listArr[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0){
        ViewAnimationViewController *VC = [[ViewAnimationViewController alloc] init];
//        [self.navigationController pushViewController:VC animated:YES];
        [self presentViewController:VC animated:YES completion:nil];
    }else if(indexPath.row == 1){
        AnimationTransitionViewController *VC = [[AnimationTransitionViewController alloc]init];
        [self.navigationController pushViewController:VC animated:YES];
//        [self navigationController:self.navigationController animationControllerForOperation:UINavigationControllerOperationPush fromViewController:self toViewController:VC];
    }else if(indexPath.row == 7){
        PathAnimationViewController *VC = [[PathAnimationViewController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    }
    else{
        BehaviorViewController *VC = [[BehaviorViewController alloc] init];
        if (indexPath.row == 2){
            VC.behavior = Grayvity;
        }else if(indexPath.row == 3){
            VC.behavior = Collision;
        }else if(indexPath.row == 4){
            VC.behavior = Attachment;
        }else if(indexPath.row == 5){
            VC.behavior = Push;
        }else if(indexPath.row == 6){
            VC.behavior = Snap;
        }
        [self.navigationController pushViewController:VC animated:YES];
    }
}

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC {
    SliderTransitionAnimator *animator = [SliderTransitionAnimator new];
    animator.ispresenting = (operation == UINavigationControllerOperationPush)?YES:NO;
    return animator;
}
// TODO:模态自定义动画待实现
-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    SliderTransitionAnimator *animator = [SliderTransitionAnimator new];
    animator.ispresenting = YES;
    return animator;
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    SliderTransitionAnimator *animator = [SliderTransitionAnimator new];
    animator.ispresenting = NO;
    return animator;
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

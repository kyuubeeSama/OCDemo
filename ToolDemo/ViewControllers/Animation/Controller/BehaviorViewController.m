//
//  BehaviorViewController.m
//  ToolDemo
//
//  Created by liuqingyuan on 2020/4/13.
//  Copyright © 2020 liuqingyuan. All rights reserved.
//

#import "BehaviorViewController.h"

@interface BehaviorViewController ()<UICollisionBehaviorDelegate>

@property (weak, nonatomic) IBOutlet UIView *animationView;
@property(nonatomic,strong)UIDynamicAnimator *animator;
@property(nonatomic,strong)UIGravityBehavior *gravity;

@property (nonatomic, strong)UICollisionBehavior *collision;

@property (nonatomic, strong)UIAttachmentBehavior *attach;

@property  (nonatomic, assign)BOOL firstContact;

@property (weak, nonatomic) IBOutlet UIView *pointView;
@property (weak, nonatomic) IBOutlet UIView *lineView;


@end

@implementation BehaviorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.lineView.hidden = YES;
    self.pointView.hidden = YES;
    if (self.behavior == Grayvity) {
        [self addGravity];
    }else if(self.behavior == Collision){
        [self addCollision];
    }else if(self.behavior == Attachment){
        self.lineView.hidden = NO;
        self.pointView.hidden = NO;
        [self addAttach];
        self.collision.collisionDelegate = self;
    }else if(self.behavior == Push){
        self.lineView.hidden = NO;
        self.pointView.hidden = NO;
        [self addAttach];
        self.collision.collisionDelegate = self;
    }else if(self.behavior == Snap){
        //TODO:了解该方法
    }
}

-(void)addGravity{
    // 滑出屏幕
    self.animator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
    self.gravity = [[UIGravityBehavior alloc]initWithItems:@[self.animationView]];
    CGVector gravityDirection = {0,0.1};
    [self.gravity setGravityDirection:gravityDirection];
    [self.animator addBehavior:self.gravity];
}

-(void)addCollision{
    // 向下落，到底碰撞
    self.animator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
    self.gravity = [[UIGravityBehavior alloc]initWithItems:@[self.animationView]];
    CGVector gravityDirection = {0,0.1};
    [self.gravity setGravityDirection:gravityDirection];
    [self.animator addBehavior:self.gravity];

    self.collision = [[UICollisionBehavior alloc] initWithItems:@[self.animationView]];
    self.collision.translatesReferenceBoundsIntoBoundary = YES;
    [self.animator addBehavior:self.collision];

}

-(void)addAttach{
    self.animator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
    self.gravity = [[UIGravityBehavior alloc]initWithItems:@[self.animationView]];
    CGVector gravityDirection = {0,0.1};
    [self.gravity setGravityDirection:gravityDirection];
    [self.animator addBehavior:self.gravity];

    self.collision = [[UICollisionBehavior alloc] initWithItems:@[self.animationView]];
    [self.collision addBoundaryWithIdentifier:@"lineView" fromPoint:self.lineView.frame.origin toPoint:CGPointMake(self.lineView.frame.origin.x+self.lineView.frame.size.width, self.lineView.frame.origin.y)];
    self.collision.translatesReferenceBoundsIntoBoundary = YES;
    [self.animator addBehavior:self.collision];

    UIDynamicItemBehavior *itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.animationView]];
    itemBehavior.elasticity = 0.5;
    [self.animator addBehavior:itemBehavior];
}

-(void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id <UIDynamicItem>)item withBoundaryIdentifier:(nullable id <NSCopying>)identifier atPoint:(CGPoint)p {
    if (self.behavior == Attachment){
        // 吸附行为。 把pointview 添加到animationview上
        self.attach = [[UIAttachmentBehavior alloc] initWithItem:self.pointView attachedToItem:self.animationView];
        [self.animator addBehavior:self.attach];
    }else if(self.behavior == Push){
        if (!_firstContact){
            self.firstContact = YES;
            self.attach = [[UIAttachmentBehavior alloc] initWithItem:self.pointView attachedToItem:self.animationView];
            [self.animator addBehavior:self.attach];

            // 设置推行为
            UIPushBehavior *push = [[UIPushBehavior alloc] initWithItems:@[self.animationView] mode:UIPushBehaviorModeInstantaneous];
            CGVector pushDirection = {0.5,-0.5};
            [push setPushDirection:pushDirection];
            [push setMagnitude:5.0f];
            [self.animator addBehavior:push];
        }
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

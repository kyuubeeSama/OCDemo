//
//  BulletManager.m
//  ToolDemo
//
//  Created by liuqingyuan on 2020/4/8.
//  Copyright © 2020 liuqingyuan. All rights reserved.
//

#import "BulletManager.h"

@implementation BulletManager

-(id)init{
    self = [super init];
    if (self) {
        self.bStopAnimation = YES;
    }
    return self;
}

-(void)start{
    if (!self.bStopAnimation) {
        return;
    }
    self.bStopAnimation = NO;
    [self.bulletComments removeAllObjects];
    [self.bulletComments addObjectsFromArray:self.listArr];
    [self initBulletComments];
}

-(void)initBulletComments{
    NSMutableArray *tarjectorys = [[NSMutableArray alloc]initWithArray:@[@(0),@(1),@(2)]];
    for (int i= 0; i<3; i++) {
        if (self.bulletComments.count>0) {
            // 获取随机弹道
            NSInteger index = arc4random()%tarjectorys.count;
            int trajectory = [[tarjectorys objectAtIndex:index] intValue];
            [tarjectorys removeObjectAtIndex:index];
            // 读取第一条弹幕
            NSString *comment = [self.bulletComments firstObject];
            [self.bulletComments removeObjectAtIndex:0];
            // 创建弹幕
            [self createBulletView:comment trajectory:trajectory];
        }
    }
}

-(void)createBulletView:(NSString *)comment trajectory:(int)trajectory{
    if (self.bStopAnimation) {
        return;
    }
    BulletView *view = [[BulletView alloc]initWithComment:comment];
    view.trajectory = trajectory;
    [view startAnimation];
    __weak typeof(view) weakView = view;
    view.moveStatusBlock = ^(MoveStatus status) {
        if (self.bStopAnimation) {
            return;
        }
        switch (status) {
            case start:
            {
                // 开始执行动画
                [self.bulletViews addObject:weakView];
            }
                break;
            case end:
            {
                if ([self.bulletViews containsObject:weakView]) {
                    [weakView endAnimation];
                    [self.bulletViews removeObject:weakView];
//                    if (self.generateViewBlock) {
//                        self.generateViewBlock(weakView);
//                    }
                }
                if (self.bulletViews.count == 0) {
                    // 屏幕已经没有弹幕
                    self.bStopAnimation = YES;
                    [self start];
                }
            }
                break;
            default:{
                NSString *comment = [self nextComment];
                if (comment) {
                    [self createBulletView:comment trajectory:trajectory];
                }
            }
                break;
        }
        
    };
                        if (self.generateViewBlock) {
                            self.generateViewBlock(weakView);
                        }
}

-(NSString *)nextComment{
    if (self.bulletComments.count == 0) {
        return nil;
    }
    NSString *comment = [self.bulletComments firstObject];
    if (comment) {
        [self.bulletComments removeObjectAtIndex:0];
    }
    return comment;
}

-(void)stop{
    if (self.bStopAnimation) {
        return;;
    }
    self.bStopAnimation = YES;
    //数组遍历用
    [self.bulletViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BulletView *view = obj;
        [view endAnimation];
        view = nil;
    }];
    [self.bulletViews removeAllObjects];
}

-(NSMutableArray *)listArr{
    if (!_listArr) {
        _listArr = [[NSMutableArray alloc]initWithArray:@[
                                                          @"非常长的弹幕测试_________0",
                                                          @"非常长的弹幕测试_________1",
                                                          @"非常长的弹幕测试_________3",
                                                          @"非常长的弹幕测试_________4",
                                                          @"非常长的弹幕测试_________5",
                                                          @"非常长的弹幕测试_________6",
                                                          @"非常长的弹幕测试_________7",
                                                          @"非常长的弹幕测试_________8"]];
    }
    return _listArr;;
}

-(NSMutableArray *)bulletComments{
    if (!_bulletComments) {
        _bulletComments = [[NSMutableArray alloc]init];
    }
    return _bulletComments;;
}

-(NSMutableArray *)bulletViews{
    if (!_bulletViews) {
        _bulletViews = [[NSMutableArray alloc]init];
    }
    return _bulletViews;;
}


@end

//
//  BulletManager.h
//  ToolDemo
//
//  Created by liuqingyuan on 2020/4/8.
//  Copyright © 2020 liuqingyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BulletView.h"
NS_ASSUME_NONNULL_BEGIN

@interface BulletManager : NSObject

@property(nonatomic,copy)void(^generateViewBlock)(BulletView *view);

@property(nonatomic,strong)NSMutableArray *listArr;
// 使用的数组变量
@property(nonatomic,strong)NSMutableArray *bulletComments;
// 存储弹幕view
@property(nonatomic,strong)NSMutableArray *bulletViews;

@property(nonatomic,assign)BOOL bStopAnimation;

-(void)start;
-(void)stop;

@end

NS_ASSUME_NONNULL_END

//
//  BulletView.h
//  ToolDemo
//
//  Created by liuqingyuan on 2020/4/8.
//  Copyright © 2020 liuqingyuan. All rights reserved.
//  弹幕
 
#import <UIKit/UIKit.h>
#import "Tool.h"
NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    start,
    enter,
    end
} MoveStatus;

@interface BulletView : UIView

@property(nonatomic,strong)UILabel *commentLab;

@property(nonatomic,assign)int trajectory;// 弹道
@property(nonatomic,copy) void (^moveStatusBlock)(MoveStatus status); //弹幕状态回调

-(instancetype)initWithComment:(NSString *)comment;
-(void)startAnimation;
-(void)endAnimation;

@end

NS_ASSUME_NONNULL_END

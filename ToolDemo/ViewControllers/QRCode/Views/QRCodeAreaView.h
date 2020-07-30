//
//  QRCodeAreaView.h
//  ErWeiMa
//
//  Created by liuqingyuan on 2018/1/2.
//  Copyright © 2018年 liuqingyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QRCodeAreaView : UIView

/**
 *  开始动画
 */
-(void)startAnimaion;

/**
 *  暂停动画
 */
-(void)stopAnimaion;

/**
 *  记录当前线条绘制的位置
 */
@property (nonatomic,assign) CGPoint position;

/**
 *  定时器
 */
@property (nonatomic,strong)NSTimer  *timer;

// 手电筒按钮
@property(nonatomic,retain)UIButton *lightBtn;

@end

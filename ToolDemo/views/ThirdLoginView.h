//
//  ThirdLoginView.h
//  ToolDemo
//
//  Created by liuqingyuan on 2018/4/27.
//  Copyright © 2018年 liuqingyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ThirdLoginViewDelegate <NSObject>

-(void)ThirdLoginViewDelegateThirdLoginBtnClick:(int)type;

@end

@interface ThirdLoginView : UIView

@property(nonatomic,assign)id<ThirdLoginViewDelegate> delegate;

@end

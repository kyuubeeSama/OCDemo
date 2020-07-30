//
//  DateTimeView.h
//  ToolDemo
//
//  Created by liuqingyuan on 2018/5/18.
//  Copyright © 2018年 liuqingyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DateTimeViewDelegate <NSObject>

-(void)DateTimeViewDelegateSureBtnClickWithTime:(NSString *)time;

@end

@interface DateTimeView : UIView

@property(nonatomic,assign)id<DateTimeViewDelegate> delegate;
@property(nonatomic,copy)NSString *time;
@end

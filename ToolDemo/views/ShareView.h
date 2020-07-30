//
//  ShareView.h
//  ToolDemo
//
//  Created by liuqingyuan on 2018/4/12.
//  Copyright © 2018年 liuqingyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ShareViewDelegate <NSObject>

-(void)shareBtnClickWithType:(int)type;

@end

@interface ShareView : UIView

@property(nonatomic,assign)id<ShareViewDelegate> delegate;

@end

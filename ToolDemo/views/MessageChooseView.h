//
//  MessageChooseView.h
//  quanyihui
//
//  Created by liuqingyuan on 2019/3/11.
//  Copyright © 2019 qyhl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tool.h"
#import "UIColor+Category.h"
NS_ASSUME_NONNULL_BEGIN

@interface MessageChooseView : UIView

@property(nonatomic,copy)void(^chooseBlock)(int index);

-(id)initWithFrame:(CGRect)frame WithArr:(NSArray *)array;

-(void)reloadnum;

@end

NS_ASSUME_NONNULL_END

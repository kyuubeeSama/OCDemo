//
//  UIView+Category.h
//  ToolDemo
//
//  Created by liuqingyuan on 2020/3/7.
//  Copyright © 2020 liuqingyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Category)

-(void)addRoundWithRadio:(CGFloat)radio byRoundingCorners:(UIRectCorner)corners Rect:(CGRect)rect borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

@end

NS_ASSUME_NONNULL_END

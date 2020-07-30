//
//  UIView+Category.m
//  ToolDemo
//
//  Created by liuqingyuan on 2020/3/7.
//  Copyright © 2020 liuqingyuan. All rights reserved.
//

#import "UIView+Category.h"

@implementation UIView (Category)

-(void)addRoundWithRadio:(CGFloat)radio byRoundingCorners:(UIRectCorner)corners Rect:(CGRect)rect borderWidth:(CGFloat)borderWidth borderColor:(nonnull UIColor *)borderColor{
    //绘制圆角 要设置的圆角 使用“|”来组合
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(radio, radio)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    //设置大小
    maskLayer.frame = self.bounds;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    
    if (borderWidth > 0){
        CAShapeLayer *maskBorderLayer = [[CAShapeLayer alloc] init];
        //设置大小
        maskBorderLayer.frame = self.bounds;
        //设置图形样子
        maskBorderLayer.path = maskPath.CGPath;
        //边框的宽度
        maskBorderLayer.lineWidth = 2;
        maskBorderLayer.fillColor = [UIColor clearColor].CGColor;
        //边框的颜色
        maskBorderLayer.strokeColor= [UIColor blackColor].CGColor;
        [self.layer addSublayer:maskBorderLayer];
    }
}

@end

//
//  FillingView.m
//  ToolDemo
//
//  Created by liuqingyuan on 2020/4/12.
//  Copyright © 2020 liuqingyuan. All rights reserved.
//  使用drawrect进行颜色填充

#import "FillingView.h"

@implementation FillingView

-(instancetype)init {
    self = [super init];
    if (self){
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(remove)];
        [self addGestureRecognizer:tapGestureRecognizer];
    }
    return self;
}

-(void)remove{
    [self removeFromSuperview];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    // Drawing code
//    // 颜色填充
//    [[UIColor greenColor] setFill];
//    UIRectFill(rect);
//
//    // 描边
//    [[UIColor redColor] setStroke];
//    CGRect frame = CGRectMake(30, 30, 50, 50);
//    UIRectFrame(frame);
//}

// 图像与文字
//-(void)drawRect:(CGRect)rect {
//    [[UIColor grayColor] setFill];
//    UIRectFill(rect);
//
//    UIImage *image = [UIImage imageNamed:@"nsfw.jpg"];
//    [image drawInRect:CGRectMake(10, 10, 72, 108)];
//
//    NSString *string = @"一条文字";
//    UIFont *font = [UIFont systemFontOfSize:15];
//    NSDictionary *attrDic = @{NSFontAttributeName:font};
//    [string drawAtPoint:CGPointMake(100, 200) withAttributes:attrDic];
//}

// 图形上下文
// TODO:补充学习贝塞斯曲线
//-(void)drawRect:(CGRect)rect {
//    [[UIColor greenColor] setFill];
//    UIRectFill(rect);
//    CGContextRef context = UIGraphicsGetCurrentContext();
////    设置起始点
//    CGContextMoveToPoint(context, 75, 10);
//    // 添加线
//    CGContextAddLineToPoint(context, 10, 150);
//    CGContextAddLineToPoint(context, 160, 150);
//    // 闭合各点
//    CGContextClosePath(context);
//// stroke 描边 fill填充
//    [[UIColor blackColor] setStroke];
//    [[UIColor redColor] setFill];
//    CGContextDrawPath(context, kCGPathFillStroke);
//}

// 坐标变换
-(void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIImage *image = [UIImage imageNamed:@"nsfw.jpg"];
    CGImageRef imgRef = image.CGImage;

    CGContextSaveGState(context);
    // 平移变换
//    CGContextTranslateCTM(context, 70, 50);
// 缩放变换
//    CGContextScaleCTM(context, 0.5, 0.75);
// 旋转操作
    CGContextRotateCTM(context, -45*M_PI/180);
    CGRect touchRect = CGRectMake(0, 0, 144, 216);
    CGContextDrawImage(context, touchRect, imgRef);

    CGContextRestoreGState(context);
}

@end

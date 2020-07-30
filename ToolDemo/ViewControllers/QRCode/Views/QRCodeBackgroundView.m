//
//  QRCodeBackgroundView.m
//  ErWeiMa
//
//  Created by liuqingyuan on 2018/1/2.
//  Copyright © 2018年 liuqingyuan. All rights reserved.
//

#import "QRCodeBackgroundView.h"

@implementation QRCodeBackgroundView

- (void)drawRect:(CGRect)rect {
//    self.scanFrame = CGRectMake((SCREEN_WIDTH - 218)/2, (SCREEN_HEIGHT - 218)/2, 218, 218);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //填充区域颜色
    [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.65] set];
    
    //扫码区域上面填充
    CGRect notScanRect = CGRectMake(0, 0, self.frame.size.width, self.scanFrame.origin.y);
    CGContextFillRect(context, notScanRect);
    
    //扫码区域左边填充
    rect = CGRectMake(0, self.scanFrame.origin.y, self.scanFrame.origin.x,self.scanFrame.size.height);
    CGContextFillRect(context, rect);
    
    //扫码区域右边填充
    rect = CGRectMake(CGRectGetMaxX(self.scanFrame), self.scanFrame.origin.y, self.scanFrame.origin.x,self.scanFrame.size.height);
    CGContextFillRect(context, rect);
    
    //扫码区域下面填充
    rect = CGRectMake(0, CGRectGetMaxY(self.scanFrame), self.frame.size.width,self.frame.size.height - CGRectGetMaxY(self.scanFrame));
    CGContextFillRect(context, rect);
    
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

//
//  QRCodeAreaView.m
//  ErWeiMa
//
//  Created by liuqingyuan on 2018/1/2.
//  Copyright © 2018年 liuqingyuan. All rights reserved.
//

#import "QRCodeAreaView.h"

@implementation QRCodeAreaView

- (void)drawRect:(CGRect)rect {
    CGPoint newPosition = self.position;
    newPosition.y += 1;
    
    //判断y到达底部，从新开始下降
    if (newPosition.y > rect.size.height) {
        newPosition.y = 0;
    }
    
    //重新赋值position
    self.position = newPosition;
    
    // 绘制图片
    UIImage *image = [UIImage imageNamed:@"line"];
    
    [image drawAtPoint:self.position];
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        UIImageView *areaView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"frame_icon"]];
        // 1. 用一个临时变量保存返回值。
        CGRect temp = areaView.frame;
        // 3. 修改frame的值
        temp.size.width=self.frame.size.width;
        temp.size.height=self.frame.size.height;
        areaView.frame = temp;
        [self addSubview:areaView];
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(setNeedsDisplay) userInfo:nil repeats:YES];
        self.lightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:self.lightBtn];
        
        self.lightBtn=[[UIButton alloc]init];
        [self addSubview:self.lightBtn];
        self.lightBtn.frame=CGRectMake(frame.size.width/2-27.5, frame.size.height-65, 55, 55);
    }
    
    return self;
}

-(void)startAnimaion{
    [self.timer setFireDate:[NSDate date]];
}

-(void)stopAnimaion{
    [self.timer setFireDate:[NSDate distantFuture]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

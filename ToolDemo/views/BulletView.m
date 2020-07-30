//
//  BulletView.m
//  ToolDemo
//
//  Created by liuqingyuan on 2020/4/8.
//  Copyright © 2020 liuqingyuan. All rights reserved.
//

#import "BulletView.h"

@implementation BulletView



-(instancetype)initWithComment:(NSString *)comment{
    self = [super init];
    if (self) {
        self.commentLab.backgroundColor = [UIColor redColor];
        CGFloat width = [comment sizeWithAttributes:@{NSForegroundColorAttributeName:[UIFont systemFontOfSize:15]}].width;
        self.commentLab.text = comment;
        self.bounds = CGRectMake(0, 0, width+30, 30);
        self.commentLab.frame = CGRectMake(10, 0, width, 30);
    }
    return self;
}

-(void)enterScreen{
    if (self.moveStatusBlock) {
        self.moveStatusBlock(enter);
    }
    
}

-(void)startAnimation{
    //FIXME:滚动速度优化
    CGFloat duration = 4.0f;
    CGFloat wholeWidth = SCREEN_WIDTH+CGRectGetWidth(self.bounds);
    __block CGRect frame = self.frame;
    if (self.moveStatusBlock) {
        self.moveStatusBlock(start);
    }
    CGFloat speed = wholeWidth/duration;
    CGFloat enterDuration = CGRectGetWidth(self.bounds)/speed;
    // 监控时间
    [self performSelector:@selector(enterScreen) withObject:nil afterDelay:enterDuration];
    // TODO:学习该方法
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(enterDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//    });
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        frame.origin.x -= wholeWidth;
        self.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (self.moveStatusBlock) {
            self.moveStatusBlock(end);
        }
    }];
}

-(void)endAnimation{
    // 停止时间监控
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self.layer removeAllAnimations];
}

-(UILabel *)commentLab{
    if (!_commentLab) {
        _commentLab = [[UILabel alloc]init];
        _commentLab.font = [UIFont systemFontOfSize:15];
        _commentLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_commentLab];
    }
    return _commentLab;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

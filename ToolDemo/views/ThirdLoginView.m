//
//  ThirdLoginView.m
//  ToolDemo
//
//  Created by liuqingyuan on 2018/4/27.
//  Copyright © 2018年 liuqingyuan. All rights reserved.
//

#import "ThirdLoginView.h"
#import "ThirdHeader.h"
#import "Tool.h"
@implementation ThirdLoginView

-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        NSArray *array=@[@"qq",@"w"];
        for (int i=0; i<2; i++) {
            UIView *view=[[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2*i, 0, SCREEN_WIDTH/2, 100)];
            [self addSubview:view];
            
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            [view addSubview:button];
            [button setImage:[UIImage imageNamed:array[i]] forState:UIControlStateNormal];
            button.tag=100+i;
            [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            button.frame=CGRectMake(SCREEN_WIDTH/4-30, 20, 60, 60);
        }
    }
    return self;
}

-(void)btnClick:(UIButton *)button
{
    [self.delegate ThirdLoginViewDelegateThirdLoginBtnClick:(int)button.tag-100];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

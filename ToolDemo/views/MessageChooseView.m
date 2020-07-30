//
//  MessageChooseView.m
//  quanyihui
//
//  Created by liuqingyuan on 2019/3/11.
//  Copyright © 2019 qyhl. All rights reserved.
//

#import "MessageChooseView.h"
#import "Masonry.h"
@interface MessageChooseView ()

@property(nonatomic,strong)UIView *redView;
@property(nonatomic,copy)NSArray *titleArr;

@end

@implementation MessageChooseView

-(id)initWithFrame:(CGRect)frame WithArr:(nonnull NSArray *)array
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleArr = array;
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
        [self addSubview:backView];
        for (int i=0; i<array.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [backView addSubview:button];
            [button setTitle:array[i] forState:UIControlStateNormal];
            if (i == 0) {
                [button setTitleColor:[UIColor colorWithHexString:@"BC271E"] forState:UIControlStateNormal];
            }else{
                [button setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
            }
            UILabel *numLab = [[UILabel alloc]init];
            [button addSubview:numLab];
            [numLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(button.mas_right);
                make.top.equalTo(button.mas_top).offset(3);
                make.size.mas_equalTo(CGSizeMake(15, 15));
            }];
            numLab.backgroundColor = [UIColor redColor];
            numLab.font = [UIFont systemFontOfSize:11];
            numLab.textAlignment = NSTextAlignmentCenter;
            numLab.textColor = [UIColor whiteColor];
            numLab.layer.masksToBounds = YES;
            numLab.layer.cornerRadius = 7.5;
            numLab.hidden = YES;
            button.frame = CGRectMake(SCREEN_WIDTH/array.count*i, 0, SCREEN_WIDTH/array.count, 45);
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = 20+i;
        }
        self.redView = [[UIView alloc]init];
        self.redView.backgroundColor = [UIColor colorWithHexString:@"BC271E"];
        self.redView.layer.masksToBounds = YES;
        self.redView.layer.cornerRadius = 1.5;
        self.redView.frame = CGRectMake(20, 42, SCREEN_WIDTH/array.count-40, 3);
        [backView addSubview:self.redView];
        
    }
    return self;
}

-(void)reloadnum
{
    for (UIView *view in [self subviews]) {
        [view removeFromSuperview];
    }
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
    [self addSubview:backView];
    for (int i=0; i<self.titleArr.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [backView addSubview:button];
        [button setTitle:self.titleArr[i] forState:UIControlStateNormal];
        if (i == 0) {
            [button setTitleColor:[UIColor colorWithHexString:@"BC271E"] forState:UIControlStateNormal];
        }else{
            [button setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        }
        UILabel *numLab = [[UILabel alloc]init];
        [button addSubview:numLab];
        [numLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(button.mas_right);
            make.top.equalTo(button.mas_top).offset(3);
            make.size.mas_equalTo(CGSizeMake(15, 15));
        }];
        numLab.backgroundColor = [UIColor redColor];
        
        numLab.font = [UIFont systemFontOfSize:11];
        numLab.textAlignment = NSTextAlignmentCenter;
        numLab.textColor = [UIColor whiteColor];
        numLab.layer.masksToBounds = YES;
        numLab.layer.cornerRadius = 7.5;
        numLab.hidden = YES;
        button.frame = CGRectMake(SCREEN_WIDTH/self.titleArr.count*i, 0, SCREEN_WIDTH/self.titleArr.count, 45);
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 20+i;
    }
    self.redView = [[UIView alloc]init];
    self.redView.backgroundColor = [UIColor colorWithHexString:@"BC271E"];
    self.redView.layer.masksToBounds = YES;
    self.redView.layer.cornerRadius = 1.5;
    self.redView.frame = CGRectMake(20, 42, SCREEN_WIDTH/self.titleArr.count-40, 3);
    [backView addSubview:self.redView];
}

-(void)buttonClick:(UIButton *)button
{
    // 移动red条位置
    self.redView.frame = CGRectMake(SCREEN_WIDTH/self.titleArr.count*(button.tag-20)+20, 42, SCREEN_WIDTH/self.titleArr.count-40, 3);
    // 修改被点击按钮的颜色
    for (int i=20; i<self.titleArr.count+20; i++) {
        UIButton *chooseBtn = [self viewWithTag:i];
        [chooseBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    }
    [button setTitleColor:[UIColor colorWithHexString:@"BC271E"] forState:UIControlStateNormal];
    if (self.chooseBlock) {
        self.chooseBlock((int)button.tag-20);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

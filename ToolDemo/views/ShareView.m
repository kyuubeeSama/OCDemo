//
//  ShareView.m
//  ToolDemo
//
//  Created by liuqingyuan on 2018/4/12.
//  Copyright © 2018年 liuqingyuan. All rights reserved.
//

#import "ShareView.h"
#import "ThirdHeader.h"
#import "Tool.h"
@implementation ShareView

-(id)init
{
    self=[super init];
    if (self) {
        UIView *backView=[[UIView alloc]init];
        [self addSubview:backView];
        backView.backgroundColor=[Tool setViewColorWithred:1 green:1 blue:1 alpha:0.8];
        backView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        
        UIView *bottomView=[[UIView alloc]init];
        [backView addSubview:bottomView];
        bottomView.backgroundColor=[UIColor whiteColor];
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backView.mas_left);
            make.right.equalTo(backView.mas_right);
            make.bottom.equalTo(backView.mas_bottom).offset(SCREEN_BOTTOM);
            make.height.mas_equalTo(280);
        }];
        
        NSArray *imgArr=@[@"share_qq_ico",@"share_qzone_ico",@"share_wechat_ico",@"share_friend_ico",@"share_url_ico"];
        NSArray *titleArr=@[@"QQ好友",@"QQ空间",@"微信好友",@"朋友圈",@"复制链接"];
        
        UILabel *titleLab=[[UILabel alloc]init];
        [bottomView addSubview:titleLab];
        titleLab.text=@"分享到";
        titleLab.textAlignment=NSTextAlignmentCenter;
        titleLab.textColor=[Tool getColorWithValue:0x999999];
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bottomView.mas_left);
            make.right.equalTo(bottomView.mas_right);
            make.top.equalTo(bottomView.mas_top).offset(15);
            make.height.mas_equalTo(12);
        }];
        titleLab.font=[UIFont systemFontOfSize:12];
        
        for (int i=0; i<5; i++) {
            int hang = i/4;
            int lie = i%4;
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            [bottomView addSubview:button];
            [button addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            button.tag=100+i;
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(bottomView.mas_left).offset(SCREEN_WIDTH/4*lie);
                make.top.equalTo(bottomView.mas_top).offset(44+86*hang);
                make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/4, 86));
            }];
            UIImageView *btnImg=[[UIImageView alloc]init];
            [button addSubview:btnImg];
            [btnImg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(button.mas_centerX);
                make.size.mas_equalTo(CGSizeMake(44, 44));
                make.top.equalTo(button.mas_top).offset(17);
            }];
            btnImg.image=[UIImage imageNamed:imgArr[(NSUInteger)i]];
            
            UILabel *titleLab=[[UILabel alloc]init];
            [button addSubview:titleLab];
            titleLab.text=titleArr[(NSUInteger)i];
            [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(button.mas_left);
                make.right.equalTo(button.mas_right);
                make.top.equalTo(btnImg.mas_bottom).offset(11);
                make.height.mas_equalTo(14);
            }];
            titleLab.font=[UIFont systemFontOfSize:14];
            titleLab.textAlignment=NSTextAlignmentCenter;
            titleLab.textColor=[Tool getColorWithValue:0x333333];
        }
        
        UIButton *cancelBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [bottomView addSubview:cancelBtn];
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bottomView.mas_left);
            make.right.equalTo(bottomView.mas_right);
            make.bottom.equalTo(bottomView.mas_bottom);
            make.height.mas_equalTo(44);
        }];
        [cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[Tool getColorWithValue:0xff6444] forState:UIControlStateNormal];
        cancelBtn.backgroundColor=[UIColor whiteColor];
    }
    return self;
}

-(void)shareBtnClick:(UIButton *)button
{
    [self.delegate shareBtnClickWithType:(int)button.tag-100];
    [self removeFromSuperview];
}

-(void)cancelBtnClick:(UIButton *)button
{
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"shareway"];
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

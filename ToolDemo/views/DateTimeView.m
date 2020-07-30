//
//  DateTimeView.m
//  ToolDemo
//
//  Created by liuqingyuan on 2018/5/18.
//  Copyright © 2018年 liuqingyuan. All rights reserved.
//

#import "DateTimeView.h"
#import "Tool.h"
@implementation DateTimeView

-(id)init
{
    self=[super init];
    if (self) {
        UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        [self addSubview:headView];
        headView.backgroundColor=[UIColor whiteColor];
        
        UIButton *cancelBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [headView addSubview:cancelBtn];
        cancelBtn.frame=CGRectMake(0, 0, 44, 44);
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *sureBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [headView addSubview:sureBtn];
        sureBtn.frame=CGRectMake(SCREEN_WIDTH-44, 0, 44, 44);
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [sureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIDatePicker *datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 200-44)];
        [self addSubview:datePicker];
        datePicker.datePickerMode=UIDatePickerModeDate;
        datePicker.locale=[NSLocale localeWithLocaleIdentifier:@"zh_CN"];
        [datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"YYYY-MM-dd";
        datePicker.date=[dateFormatter dateFromString:@"1993-4-5"];
    }
    return self;
}

- (void)dateChange:(UIDatePicker *)datePicker
{
    NSDate *theDate = datePicker.date;
    NSLog(@"%@",[theDate descriptionWithLocale:[NSLocale currentLocale]]);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"YYYY-MM-dd";
    NSLog(@"%@",[dateFormatter stringFromDate:theDate]);
    self.time=[dateFormatter stringFromDate:theDate];
}

-(void)cancelBtnClick:(UIButton *)button
{
    [self removeFromSuperview];
}

-(void)sureBtnClick:(UIButton *)button
{
    [self.delegate DateTimeViewDelegateSureBtnClickWithTime:self.time];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

//
//  BaseViewController.m
//  ToolDemo
//
//  Created by liuqingyuan on 2018/4/12.
//  Copyright © 2018年 liuqingyuan. All rights reserved.
//

#import "BaseViewController.h"
#import "ShareView.h"
#import "MBProgressHUD.h"
#import "Masonry.h"
#import <UMShare/UMShare.h>
@interface BaseViewController ()<ShareViewDelegate>

@property(nonatomic,strong)MBProgressHUD *progress;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
//        self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
}

-(void)shareWithDic:(NSDictionary *)share
{
    ShareView *view=[[ShareView alloc]init];
    view.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    view.delegate=self;
    [self.view addSubview:view];
}

-(void)shareBtnClickWithType:(int)type
{
    switch (type) {
        case 0:
            [self shareWebPageToPlatformType:UMSocialPlatformType_QQ];
            break;
        case 1:
            [self shareWebPageToPlatformType:UMSocialPlatformType_Qzone];
            break;
        default:
            break;
    }
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"分享标题" descr:@"分享内容描述" thumImage:[UIImage imageNamed:@"icon"]];
    //设置网页地址
    shareObject.webpageUrl =@"http://mobile.umeng.com/social";
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",data);
        }
    }];
}

-(void)beginProgressWithTitle:(nullable NSString *)title
{
    if (self.progress==nil) {
        self.progress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.progress.label.text = title;
    }
}

-(void)endProgress
{
    [self.progress hideAnimated:YES];
    self.progress = nil;
}
//显示提示
-(void)showAlertWithTitle:(NSString *)string
{
    MBProgressHUD *progress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progress.label.text = string;
    progress.mode = MBProgressHUDModeText;
    [progress hideAnimated:YES afterDelay:2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

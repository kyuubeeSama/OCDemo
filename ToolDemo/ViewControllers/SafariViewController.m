//
//  SafariViewController.m
//  ToolDemo
//
//  Created by liuqingyuan on 2019/6/11.
//  Copyright © 2019 liuqingyuan. All rights reserved.
//

#import "SafariViewController.h"
#import <SafariServices/SafariServices.h>
API_AVAILABLE(ios(11.0))
@interface SafariViewController ()<SFSafariViewControllerDelegate>
@property (strong,nonatomic) UIWebView *myweb;
@property (strong,nonatomic) UIView *myview;
@property (strong,nonatomic) SFSafariViewController *safariView;
@property (strong,nonatomic) SFAuthenticationSession *auth;
@end

@implementation SafariViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //两秒之后在加载该view更加直观
    [self performSelector:@selector(gotodiddd) withObject:nil afterDelay:2.0f];
}

-(void)gotodiddd
{
    if(@available(iOS 11.0, *)) {
        SFAuthenticationSession *auth = [[SFAuthenticationSession alloc] initWithURL:[NSURL URLWithString:@"http://dai.qingyuannet.com/index/company/index?from=app"] callbackURLScheme:@"xtshow" completionHandler:^(NSURL * _Nullable callbackURL, NSError * _Nullable error) {
            //用户点击取消时，会出现error：SFAuthenticationErrorCanceledLogin
            NSLog(@"%@---%@",callbackURL,error);
        }];
        self.auth = auth;
        [self.auth start];
    }else{
        self.safariView = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:@"http://dai.qingyuannet.com/index/company/index?from=app"]];
        self.safariView.delegate=self;
        [self presentViewController:self.safariView animated:false completion:nil];
    }
}

- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller
{
    NSLog(@"%s",__func__);
}
- (void)safariViewController:(SFSafariViewController *)controller didCompleteInitialLoad:(BOOL)didLoadSuccessfully
{
    NSLog(@"didLoadSuccessfully:%d",didLoadSuccessfully);
    if (didLoadSuccessfully) {
//        [controller dismissViewControllerAnimated:true completion:nil];
    }
}

//- (void)webViewDidFinishLoad:(UIWebView *)webView
//{
//
//    NSHTTPCookieStorage *sharedHTTPCookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//    NSArray *cookies = [sharedHTTPCookieStorage cookiesForURL:[NSURL URLWithString:@"http://adapp.jidonggame.com/"]];
//    NSEnumerator *enumerator = [cookies objectEnumerator];
//    NSHTTPCookie *cookie;
//    while (cookie = [enumerator nextObject]) {
//        NSLog(@"COOKIE{name: %@, value: %@}", [cookie name], [cookie value]);
//        [sharedHTTPCookieStorage deleteCookie:cookie];
//    }
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

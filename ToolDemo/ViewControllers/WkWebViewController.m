//
//  WkWebViewController.m
//  ToolDemo
//
//  Created by liuqingyuan on 2019/4/28.
//  Copyright © 2019 liuqingyuan. All rights reserved.
//

#import "WkWebViewController.h"
#import <WebKit/WebKit.h>

@interface WkWebViewController ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>
    
    @property(nonatomic,retain)WKWebView *webView;
    
    @end

@implementation WkWebViewController

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // 不再使用时，需要销毁。否则会造成内存泄露。具体再哪里销毁根据具体需要判断，此处只是示例
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"sendmessage"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"WKWebView";
    [self setNav];
    [self makeUI];
}
    
-(void)setNav{
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClick:)];
    self.navigationItem.leftBarButtonItem = leftBtn;
}
    
-(void)makeUI{
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    if (@available(iOS 10.0, *)) {
        config.mediaTypesRequiringUserActionForPlayback = NO;
        config.allowsAirPlayForMediaPlayback = YES;
    }else{
        config.mediaPlaybackRequiresUserAction = NO;//把手动播放设置NO ios(8.0, 9.0)
        config.mediaPlaybackAllowsAirPlay = YES;//允许播放，ios(8.0, 9.0)
    }
    config.allowsInlineMediaPlayback = YES;//是否允许内联(YES)或使用本机全屏控制器(NO)，默认是NO。
    config.preferences = [[WKPreferences alloc] init];
    config.preferences.minimumFontSize = 10;
    config.preferences.javaScriptEnabled = YES;
    config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    config.userContentController = [[WKUserContentController alloc] init];
    config.processPool = [[WKProcessPool alloc] init];
    [config.userContentController addScriptMessageHandler:self name:@"sendmessage"];
    
    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, TOP_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-(TOP_HEIGHT)) configuration:config];
    [self.view addSubview:self.webView];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    //    NSURL *url = [NSURL URLWithString:@"http://app.369qyh.com"];
    //    NSURL *url = [NSURL URLWithString:@"https://www.baidu.com"];
    NSURL *url = [NSURL URLWithString:@"http://369qyh.com/files/dianzishu/index.html"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
//    NSString *filepath = [[NSBundle mainBundle]pathForResource:@"swiftindex" ofType:@"html"];
//    NSURL *url = [NSURL fileURLWithPath:filepath];
//    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}
    
-(void)backBtnClick:(UIButton *)button {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
    
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    [self beginProgressWithTitle:nil];
}
    
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [self endProgress];
    NSString *doc = @"document.body.outerHTML";
    [webView evaluateJavaScript:doc
                     completionHandler:^(id _Nullable htmlStr, NSError * _Nullable error) {
        if (error) {
           NSLog(@"JSError:%@",error);
        }
        NSLog(@"html:%@",htmlStr);
    }] ;
}
    
-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSLog(@"当前网页是%@",navigationAction.request.URL.absoluteString);
    //允许跳转
    NSString *urlStr = navigationAction.request.URL.absoluteString;
    if ([urlStr rangeOfString:@"/files/mp4/"].location != NSNotFound) {
        [self endProgress];
    }
    if (navigationAction.navigationType == WKNavigationTypeLinkActivated) {
        decisionHandler(WKNavigationActionPolicyAllow);
    }else{
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}
    
//    警告框
-(void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    NSLog(@"%@",message);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }];
    [alert addAction:sureAction];
    [self presentViewController:alert animated:YES completion:nil];
}
//    确认框
-(void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    NSLog(@"确认框");
    // confirm
    completionHandler(YES);
}
//    输入框
-(void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    NSLog(@"输入框");
    completionHandler(@"http");
}

//实现js注入方法的协议方法

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
//    根据name判断js是否一致
       if ([message.name isEqualToString:@"sendmessage"]) {
          NSLog(@"%@", message.body);
           }
    
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

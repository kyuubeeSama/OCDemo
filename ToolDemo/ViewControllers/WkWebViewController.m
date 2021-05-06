//
//  WkWebViewController.m
//  ToolDemo
//
//  Created by liuqingyuan on 2019/4/28.
//  Copyright © 2019 liuqingyuan. All rights reserved.
//

#import "WkWebViewController.h"
#import <WebKit/WebKit.h>
#import "Masonry.h"

@interface WkWebViewController ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler,UISearchBarDelegate>

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
    // TODO:头部添加搜索框
    UISearchBar *search = [[UISearchBar alloc]init];
    [self.view addSubview:search];
    [search mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        } else {
            // Fallback on earlier versions
            make.top.equalTo(self.view);
        }
        make.height.mas_equalTo(50);
    }];
    search.delegate = self;
    search.showsSearchResultsButton = YES;
    search.searchBarStyle = UISearchBarStyleDefault;
    
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.mediaTypesRequiringUserActionForPlayback = NO;
    config.allowsAirPlayForMediaPlayback = YES;
    config.allowsInlineMediaPlayback = YES;//是否允许内联(YES)或使用本机全屏控制器(NO)，默认是NO。
    config.preferences = [[WKPreferences alloc] init];
    config.preferences.minimumFontSize = 10;
    config.preferences.javaScriptEnabled = YES;
    config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    config.userContentController = [[WKUserContentController alloc] init];
    config.processPool = [[WKProcessPool alloc] init];
    [config.userContentController addScriptMessageHandler:self name:@"sendmessage"];
    
    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) configuration:config];
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(search.mas_bottom).offset(10);
    }];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    //    NSString *filepath = [[NSBundle mainBundle]pathForResource:@"swiftindex" ofType:@"html"];
    //    NSURL *url = [NSURL fileURLWithPath:filepath];
    //    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    // 载入网页
    if ([self urlValidation:searchBar.text]) {
        NSURL *url = [NSURL URLWithString:searchBar.text];
        [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    }else{
        [self showAlertWithTitle:@"网址错误"];
    }
}

//MARK:判断地址是否有效
- (BOOL)urlValidation:(NSString *)string {
    NSError *error;
    // 正则1
    NSString *regulaStr =@"\\bhttps?://[a-zA-Z0-9\\-.]+(?::(\\d+))?(?:(?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?";
    
    // 正则2
    //    regulaStr =@"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *arrayOfAllMatches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    for (NSTextCheckingResult *match in arrayOfAllMatches){
        //        NSString* substringForMatch = [string substringWithRange:match.range];
        return YES;
    }
    return NO;
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
//    修改部分css的样式
    NSString *jsStr1 = @"var header = document.getElementsByClassName(\"header\")[0];"
    "header.style.display = \"none\";"
    "var search = document.getElementsByClassName(\"newiphone_searchtop\")[0];"
    "search.style.display = \"none\";"
    "var footer = document.getElementsByClassName(\"none_foot_img\")[0];"
    "footer.style.display = \"none\";"
    "var ad = document.getElementsByClassName(\"app_box_none\")[0];"
    "ad.style.display = \"none\"";
    [webView evaluateJavaScript:jsStr1 completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        if (error) {
            NSLog(@"JSError:%@",error);
        }else{
            NSLog(@"success");
        }
    }];
    
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
    // TODO:点击禁止跳转
    
    if ([urlStr rangeOfString:@"/files/mp4/"].location != NSNotFound) {
        [self endProgress];
    }
    if (navigationAction.navigationType == WKNavigationTypeLinkActivated) {
        // 禁止跳转
        decisionHandler(WKNavigationActionPolicyCancel);
//        decisionHandler(WKNavigationActionPolicyAllow);
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

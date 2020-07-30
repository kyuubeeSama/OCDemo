//
//  WebViewController.m
//  ToolDemo
//
//  Created by liuqingyuan on 2019/6/26.
//  Copyright © 2019 liuqingyuan. All rights reserved.
//

#import "WebViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>



@protocol JSClickDelegate <JSExport>

-(void)sendmessage;

@end

@interface WebViewController ()<UIWebViewDelegate,JSClickDelegate>

@property(nonatomic,strong)UIWebView *webView;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self makeUI];
}

-(void)makeUI{
    self.webView = [[UIWebView alloc]init];
    self.webView.frame = CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT);
    [self.view addSubview:self.webView];
    self.webView.delegate = self;
    /*
    NSString *oldAgent = [self.webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSLog(@"old agent :%@", oldAgent);
    NSString *path = [[NSBundle mainBundle] pathForResource:@"swiftindex" ofType:@"html"];
    NSURL* url = [NSURL  fileURLWithPath:path];//创建URL
    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
    [self.webView loadRequest:request];//加载
     */
//    NSString *url = @"http://192.168.1.221:8080/ets/home/requestTransponder/news.htm?id=12&flowSource=";
//    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.1.53:8081/app/bidding/biddingCondition.htm"]]];
//    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *imgSrc = [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('qrcode').src"];
    NSLog(@"图片的值是%@",imgSrc);
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgSrc]]];
    CIImage *ciImage = [CIImage imageWithCGImage:[image CGImage]];
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:nil];
    NSArray *arr = [detector featuresInImage:ciImage];
    [self dismissViewControllerAnimated:YES completion:nil];
    if (arr.count>0) {
        CIQRCodeFeature *feature = arr[0];
        NSString *QRCodeUrl = feature.messageString;
        NSLog(@"图片地址是%@",QRCodeUrl);
    }else{
        NSLog(@"图片错误");
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"错误二维码" message:@"该图片不包含二维码" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:cancelAction];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    /*
    [webView stringByEvaluatingJavaScriptFromString:@"function getdata(){\
     var complete = document.getElementById(\"complete\");\
     complete.onclick=function(){\
     alert(\"hello\");\
     jointParameters();\
     window.location.href=\"https://www.sure.com\";\
     }\
     }"];
    [webView stringByEvaluatingJavaScriptFromString:@"function getdata2(){\
     var cancel = document.getElementById(\"cancel\");\
     cancel.onclick=function(){\
     alert(\"NO\");\
     window.location.href=\"https://www.cancel.com\";\
     }\
     }"];
    [webView stringByEvaluatingJavaScriptFromString:@"getdata2()"];
    [webView stringByEvaluatingJavaScriptFromString:@"getdata();"];
    */
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *url = request.URL.absoluteString;
    NSLog(@"%@",url);
    if ([url rangeOfString:@"sure"].location != NSNotFound) {
        NSString *value = [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('jointParameter').value"];
        NSLog(@"value = %@",value);
        return NO;
    }else if ([url rangeOfString:@"cancel"].location != NSNotFound){
        NSLog(@"取消");
        return NO;
    }
    else{
return YES;
    }
}
/*
-(NSString *)getImgSrcById:(NSString *)string
{
    NSString *imageValue =
    return @"";
}
 */
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  DemoViewController.m
//  ToolDemo
//
//  Created by liuqingyuan on 2018/12/10.
//  Copyright © 2018 liuqingyuan. All rights reserved.
//

#import "DemoViewController.h"
#import "Singleton.h"
//#import "NSFWDetector-Swift.h"
//#import "ToolDemo-Swift.h"
#import "UIColor+Category.h"
#import "UIView+Category.h"
#import "RequestData.h"
#import "UIImage+ImageRotate.h"
#import "UIView+LXShadowPath.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "TTRangeSlider.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "HZPhotoBrowser.h"
#import <MRDLNA/MRDLNA.h>

@interface DemoViewController () <DLNADelegate>

@property(nonatomic, strong) MRDLNA *dlnaManager;

@end

@implementation DemoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"demo";
    // swift 混编
//    if (@available(iOS 12.0, *)) {
//        SwiftDemo *swift = [[SwiftDemo alloc]init];
//        NSString *result = [swift checkImageWithImage:[UIImage imageNamed:@"nsfw.jpg"]];
//        NSLog(@"%@",result);
//    } else {
//        // Fallback on earlier versions
//    }

//    [self createView];
//    [self requestTest];
//    self.view.backgroundColor = [UIColor blackColor];
//    UIImageView *imageView = [[UIImageView alloc]init];
//    [self.view addSubview:imageView];
//    imageView.center = self.view.center;
//    imageView.bounds = CGRectMake(0, 0, 50, 50);
//    imageView.image = [UIImage imageNamed:@"tab_index"];
//    imageView.image = [self makeRoundImage:[UIImage imageNamed:@"tab_index"]];
//    imageView.image = [UIImage imageWithBorder:5 color:[UIColor whiteColor] image:[UIImage imageNamed:@"tab_index"]];
//    [self shadow];
//    [self newShadow];
//    [self createBtn];
//    [self makeSlider];
//    [self makeImage];
    [self makeDlna];
}
//TODO:文字长度截取
//-(void)makeLabel{
//
//}

//TODO:图片查看设置
- (void)makeImage {
    UIImageView *image = [[UIImageView alloc] init];
    [self.view addSubview:image];
    image.center = self.view.center;
    image.bounds = CGRectMake(0, 0, 200, 200);
    image.userInteractionEnabled = YES;
    image.contentMode = UIViewContentModeScaleAspectFit;
    [image sd_setImageWithURL:[NSURL URLWithString:@"https://tse4-mm.cn.bing.net/th/id/OIP.YHIHn0znRU-OfddNxIpYogHaHa?w=181&h=182&c=7&o=5&pid=1.7"]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer *_Nullable x) {
        HZPhotoBrowser *browser = [[HZPhotoBrowser alloc] init];
        browser.isFullWidthForLandScape = NO;
        browser.currentImageIndex = 0;
        browser.imageArray = @[@"https://tse4-mm.cn.bing.net/th/id/OIP.YHIHn0znRU-OfddNxIpYogHaHa?w=181&h=182&c=7&o=5&pid=1.7"];
        [browser show];
    }];
    [image addGestureRecognizer:tap];
}

// TODO:投屏测试
- (void)makeDlna {
    // 创建按钮，查找设备
    // 将获取的设备弹出，以供选择
    // 将一个视频地址投送出去
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:button];
    button.center = self.view.center;
    button.bounds = CGRectMake(0, 0, 80, 80);
    button.backgroundColor = [UIColor yellowColor];
    self.dlnaManager = [MRDLNA sharedMRDLNAManager];
    self.dlnaManager.delegate = self;
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl *x) {
        [self.dlnaManager startSearch];
    }];
}

- (void)searchDLNAResult:(NSArray *)devicesArray {
    NSLog(@"搜索");
    for (CLUPnPDevice *device in devicesArray) {
        NSLog(@"设备名是%@", device.friendlyName);
    }
    if ([devicesArray count]) {
        NSString *urlStr = @"http://223.110.239.40:6060/cntvmobile/vod/p_cntvmobile00000000000020150518/m_cntvmobile00000000000659727681";
        // 获取到设备
        // 弹出界面，让用选择投屏设备
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择投屏设备" preferredStyle:UIAlertControllerStyleActionSheet];
        for (CLUPnPDevice *device in devicesArray) {
                UIAlertAction *action = [UIAlertAction actionWithTitle:device.friendlyName style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    // 选中设备，并发送视频地址给设备
                    self.dlnaManager.device = device;
                    self.dlnaManager.playUrl = urlStr;
                    // 播放
                    [self.dlnaManager dlnaPlay];
                }];
            [alertController addAction:action];
        }
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

// 滑动进度条
- (void)makeSlider {
    TTRangeSlider *slider = [[TTRangeSlider alloc] init];
    [self.view addSubview:slider];
    slider.frame = CGRectMake(30, 150, 200, 30);
    slider.handleImage = [UIImage imageNamed:@"slider"];
    slider.tintColorBetweenHandles = [UIColor redColor];
    slider.tintColor = [UIColor grayColor];
    slider.labelPosition = LabelPositionNone;
    slider.handleColor = [UIColor clearColor];
}


- (void)newShadow {
    UIView *shadowView = [[UIView alloc] init];
    [self.view addSubview:shadowView];
    shadowView.frame = CGRectMake(50, 300, 200, 200);
    shadowView.backgroundColor = [UIColor redColor];
    [shadowView LX_SetShadowPathWith:[UIColor yellowColor] shadowOpacity:0.3 shadowRadius:2 shadowSide:LXShadowPathLeftRight shadowPathWidth:10];
}

- (void)requestTest {
    [RequestData requestDataWithMethod:AFNetworkMethodGet WithUrl:@"/app/goHomePageNew.htm" withData:nil success:^(NSDictionary *dic) {
        NSLog(@"%@", dic);
    }                          failure:^(NSError *error) {
    }];
}

- (void)shadow {
    UIView *view = [[UIView alloc] init];
    [self.view addSubview:view];
    view.frame = CGRectMake(50, 300, 100, 100);
    view.backgroundColor = [UIColor redColor];
    //    [Tool setPartRoundWithView:view corners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadius:5];
    view.layer.masksToBounds = YES;
    view.layer.shadowColor = [[UIColor blackColor] CGColor];
    view.layer.shadowOffset = CGSizeMake(0, 0);
    view.layer.shadowOpacity = 1;
    //设置阴影半径
    view.layer.shadowRadius = 5.0f;
    //设置渲染内容被缓存
    view.layer.shouldRasterize = YES;
    //超出父视图部分是否显示
    view.layer.masksToBounds = NO;
    view.layer.borderWidth = 0.0;
    view.layer.opaque = 0.10;
    view.layer.cornerRadius = 3.0;
    //栅格化处理
    view.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    //正常矩形
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:view.bounds];
    view.layer.shadowPath = path.CGPath;
    //    [self createBtn];
    Singleton *single = [Singleton sharedInstance];
    single.num = 5;
}

- (void)createBtn {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:button];
    button.frame = CGRectMake(100, 150, 60, 60);
    button.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [button setImage:[UIImage imageNamed:@"demo.jpg"] forState:UIControlStateNormal];
    [button setClipsToBounds:YES];
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl *_Nullable x) {
        NSLog(@"点击按钮");
    }];
}

- (void)createView {
    // 渐变色测试
//    UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
//    [view setTitle:@"进入政策法规" forState:UIControlStateNormal];
//    [view setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.view addSubview:view];
//    view.frame = CGRectMake(100, 300, 160, 30);
//    view.backgroundColor = [UIColor gradientFromeColor:[UIColor colorWithHexString:@"2782C7"]  toColor:[UIColor colorWithHexString:@"191970"] withDirection:leftToRight withValue:160];
//    view.layer.masksToBounds = YES;
//    view.layer.cornerRadius = 15;

    UIView *view = [[UIView alloc] init];
    [self.view addSubview:view];
    view.frame = CGRectMake(100, 300, 100, 40);
    view.backgroundColor = [UIColor redColor];
    // FIXME:圆角测试
//    [view addRoundWithRadio:20 byRoundingCorners:UIRectCornerAllCorners Rect:view.bounds];
//    view.layer.borderColor = [[UIColor blackColor] CGColor];
//    view.layer.borderWidth = 1;
}

- (UIImage *)makeRoundImage:(UIImage *)image {
//    CGFloat imageSizeMin = MIN(image.size.width, image.size.height);
    CGSize imgSize = image.size;
    view *mview = [[view alloc] init];
    mview.image = image;
    UIGraphicsBeginImageContext(imgSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    mview.frame = CGRectMake(-10, -10, imgSize.width + 20, imgSize.height + 20);
    mview.backgroundColor = [UIColor whiteColor];
    [mview.layer renderInContext:context];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
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

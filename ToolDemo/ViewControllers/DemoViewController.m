//
//  DemoViewController.m
//  ToolDemo
//
//  Created by liuqingyuan on 2018/12/10.
//  Copyright © 2018 liuqingyuan. All rights reserved.
//

#import "DemoViewController.h"
#import "Singleton.h"
#import "NSFWDetector-Swift.h"
//#import "ToolDemo-Swift.h"
#import "UIColor+Category.h"
#import "UIView+Category.h"
#import "RequestData.h"
#import "UIImage+ImageRotate.h"
#import "UIView+LXShadowPath.h"
#import <ReactiveObjC/ReactiveObjC.h>
@interface DemoViewController ()

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
    [self createBtn];
}

-(void)newShadow{
    UIView *shadowView = [[UIView alloc]init];
    [self.view addSubview:shadowView];
    shadowView.frame = CGRectMake(50, 300, 200, 200);
    shadowView.backgroundColor = [UIColor redColor];
    [shadowView LX_SetShadowPathWith:[UIColor yellowColor] shadowOpacity:0.3 shadowRadius:2 shadowSide:LXShadowPathLeftRight shadowPathWidth:10];
}

-(void)requestTest{
    [RequestData requestDataWithMethod:AFNetworkMethodGet WithUrl:@"/app/goHomePageNew.htm"  withData:nil success:^(NSDictionary *dic) {
        NSLog(@"%@",dic);
    } failure:^(NSError *error) {
    }];
}

-(void)shadow{
    UIView *view = [[UIView alloc]init];
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
        view.layer.borderWidth  = 0.0;
        view.layer.opaque = 0.10;
        view.layer.cornerRadius = 3.0;
        //栅格化处理
        view.layer.rasterizationScale = [[UIScreen mainScreen]scale];
        //正常矩形
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:view.bounds];
        view.layer.shadowPath = path.CGPath;
    //    [self createBtn];
        Singleton *single = [Singleton sharedInstance];
        single.num = 5;
}

-(void)createBtn{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:button];
    button.frame=CGRectMake(100, 150, 60, 60);
    button.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [button setImage:[UIImage imageNamed:@"demo.jpg"] forState:UIControlStateNormal];
    [button setClipsToBounds:YES];
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"点击按钮"); 
    }];
}

-(void)createView{
    // 渐变色测试
//    UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
//    [view setTitle:@"进入政策法规" forState:UIControlStateNormal];
//    [view setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.view addSubview:view];
//    view.frame = CGRectMake(100, 300, 160, 30);
//    view.backgroundColor = [UIColor gradientFromeColor:[UIColor colorWithHexString:@"2782C7"]  toColor:[UIColor colorWithHexString:@"191970"] withDirection:leftToRight withValue:160];
//    view.layer.masksToBounds = YES;
//    view.layer.cornerRadius = 15;
    
    UIView *view = [[UIView alloc]init];
    [self.view addSubview:view];
    view.frame = CGRectMake(100, 300, 100, 40);
    view.backgroundColor = [UIColor redColor];
    // FIXME:圆角测试
//    [view addRoundWithRadio:20 byRoundingCorners:UIRectCornerAllCorners Rect:view.bounds];
//    view.layer.borderColor = [[UIColor blackColor] CGColor];
//    view.layer.borderWidth = 1;
}

-(UIImage *)makeRoundImage:(UIImage *)image{
//    CGFloat imageSizeMin = MIN(image.size.width, image.size.height);
    CGSize imgSize = image.size;
    view *mview = [[view alloc]init];
    mview.image = image;
    UIGraphicsBeginImageContext(imgSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    mview.frame = CGRectMake(-10, -10, imgSize.width+20, imgSize.height+20);
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

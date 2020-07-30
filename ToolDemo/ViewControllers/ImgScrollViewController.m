//
//  ImgScrollViewController.m
//  ToolDemo
//
//  Created by liuqingyuan on 2018/12/10.
//  Copyright © 2018 liuqingyuan. All rights reserved.
//

#import "ImgScrollViewController.h"
#import "Singleton.h"
@interface ImgScrollViewController ()<UIScrollViewDelegate>

@property(nonatomic,retain)UIImageView *imageView;
@property(nonatomic,retain)UIScrollView *imgScroll;

@end

@implementation ImgScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"图片放大查看";
    [self createScroll];
    Singleton *sing = [Singleton sharedInstance];
    NSLog(@"单例的num=%d",sing.num);
    
}

-(void)createScroll
{
    self.imgScroll = [[UIScrollView alloc]init];
    [self.view addSubview:self.imgScroll];
    self.imgScroll.frame = CGRectMake(0, 0, SCREEN_WIDTH, (SCREEN_HEIGHT)-(SCREEN_TOP)-64);
    self.imgScroll.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    //    imgScroll.contentSize = image.size;v
    self.imgScroll.delegate = self;
    self.imgScroll.maximumZoomScale = 2.0;
    self.imgScroll.minimumZoomScale = 1.0;

    UIImage *image=[UIImage imageNamed:@"testdemo.jpeg"];
   self.imageView = [[UIImageView alloc]initWithImage:image];
    [self.imgScroll addSubview:self.imageView];
    self.imageView.center = self.imgScroll.center;
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
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

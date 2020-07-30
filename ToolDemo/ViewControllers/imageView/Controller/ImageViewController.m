//
//  ImageViewController.m
//  ToolDemo
//
//  Created by liuqingyuan on 2018/11/5.
//  Copyright © 2018 liuqingyuan. All rights reserved.
//

#import "ImageViewController.h"
// gif播放使用
#import <ImageIO/ImageIO.h>
#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "UIImage+ImageRotate.h"
#import "ImgageSolveViewController.h"

#import "GifViewController.h"
@interface ImageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *mainTable;
@property(nonatomic,copy)NSArray *listArr;

@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.listArr = @[@"gif",@"图片算法相关",@"图片旋转",@"图片裁剪",@"圆形切割",@"图片加水印",@"保存图片到相册"];
//    [self makeUI];
[self imageRotate];
}

-(void)makeUI{
    self.mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, SCREEN_HEIGHT - (TOP_HEIGHT) - 45) style:UITableViewStylePlain];
    [self.view addSubview:self.mainTable];
    self.mainTable.delegate = self;
    self.mainTable.dataSource = self;
    self.mainTable.estimatedRowHeight = 0;
    self.mainTable.estimatedSectionFooterHeight = 0;
    self.mainTable.estimatedSectionHeaderHeight = 0;
    self.mainTable.rowHeight = 60;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.textLabel.text = self.listArr[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        GifViewController *VC = [[GifViewController alloc]init];
        [self.navigationController pushViewController:VC animated:YES];
    }else if(indexPath.row == 1){
        ImgageSolveViewController *VC = [[ImgageSolveViewController alloc]init];
        [self.navigationController pushViewController:VC animated:YES];
    }
}

// 图片旋转
-(void)imageRotate{
    UIImage *image = [UIImage imageNamed:@"nsfw.jpg"];
    UIImage *newImage = [image imageRotateIndegree:45*0.01745/*3.14/180*/];
    UIImageView *imageView = [[UIImageView alloc]init];
    [self.view addSubview:imageView];
    imageView.bounds = CGRectMake(0, 0, 144, 205);
    imageView.center = self.view.center;
    imageView.image = newImage;
}

// 图片切割测试
-(void)cropImage{
    UIImage *image = [UIImage imageNamed:@"nsfw.jpg"];
    UIImage *newImg = [image cropImageSize:CGRectMake(20, 20, 300, 300)];
    UIImageView *imageView = [[UIImageView alloc]init];
    [self.view addSubview:imageView];
    imageView.bounds = CGRectMake(0, 0, 200, 197);
    imageView.center = self.view.center;
    imageView.image = newImg;
}

// 圆形切割
-(void)cropCircleImage{
    UIImage *image = [UIImage imageNamed:@"nsfw.jpg"];
    UIImage *newImg = [image cropRoundImage];
    
    UIImageView *imageView = [[UIImageView alloc]init];
    [self.view addSubview:imageView];
    imageView.bounds = CGRectMake(0, 0, 150, 150);
    imageView.center = self.view.center;
    imageView.image = newImg;
}

-(void)scaleImage{
    UIImage *image = [UIImage imageNamed:@"nsfw.jpg"];
    UIImage *newImg = [image imageScaleSize:CGSizeMake(100, 300)];
    UIImageView *imageView = [[UIImageView alloc]init];
    [self.view addSubview:imageView];
    imageView.bounds = CGRectMake(0, 0, 150, 300);
    imageView.backgroundColor = [UIColor redColor];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.center = self.view.center;
    imageView.image = newImg;
}

-(void)saveShortCut{
    //FIXME:此处实现有问题
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]){
        UIGraphicsBeginImageContextWithOptions(self.view.window.bounds.size, NO, [UIScreen mainScreen].scale);
    } else {
        UIGraphicsBeginImageContext(self.view.window.bounds.size);
    }
    [self.view.window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *ScreenImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(ScreenImage, self, @selector(image: didFinishSavingWithError:contextInfo:), nil);
}
// 图片加水印
-(void)imageAddWater{
    UIImageView *imageView = [[UIImageView alloc]init];
    [self.view addSubview:imageView];
    imageView.bounds = CGRectMake(0, 0, 360, 540);
    imageView.center = self.view.center;
    UIImage *image = [UIImage imageNamed:@"nsfw.jpg"];
    imageView.image = [image imageWater:[UIImage imageNamed:@"w"] waterString:@"this is water"];
}

// 图片类型转化
-(void)jpgToPng{
    UIImage *image = [UIImage imageNamed:@"nsfw.jpg"];
    NSData *imgData = UIImagePNGRepresentation(image);
    UIImage *imagePng = [UIImage imageWithData:imgData];
}

-(void)PngTojpg{
    UIImage *image = [UIImage imageNamed:@"lt_zqp.png"];
    NSData *imgData = UIImageJPEGRepresentation(image,1);
    UIImage *imageJpg = [UIImage imageWithData:imgData];
}

// 保存图片到本地
-(void)createImageView
{
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"testdemo.jpeg"]];
    [self.view addSubview:imageView];
    imageView.center = self.view.center;
    imageView.bounds = CGRectMake(0, 0, 400, 598);
    imageView.backgroundColor=[UIColor redColor];
}
-(void)createBtn
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:button];
    button.frame=CGRectMake((SCREEN_WIDTH-100)/2, SCREEN_HEIGHT-50, 100, 45);
    [button setTitle:@"保存到本地" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

-(void)saveImage
{
    UIImage *image = [UIImage imageNamed:@"testdemo.jepg"];
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image: didFinishSavingWithError:contextInfo:), nil);
}
    
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error == nil) {
        NSLog(@"保存成功");
    }
    else{
        ///图片未能保存到本地
        NSLog(@"保存失败%@",error);
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

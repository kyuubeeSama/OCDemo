//
//  CropImgViewController.m
//  ToolDemo
//
//  Created by liuqingyuan on 2019/3/7.
//  Copyright © 2019 liuqingyuan. All rights reserved.
//

#import "CropImgViewController.h"
#import "CropImageController.h"
#import "UIImage+Crop.h"
#import "Masonry.h"
#import "TZImagePickerController.h"
#import "ZYQAssetPickerController.h"
@interface CropImgViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,TZImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *ImageView;


@end

@implementation CropImgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"图片选取切割";
    NSLog(@"视网膜倍数%f",[UIScreen mainScreen].scale);
}
- (IBAction)chooseImg:(UIButton *)sender {
    // 从相册读取图片（原生）
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.allowsEditing =NO;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (IBAction)tzImagePickerBtnClick:(id)sender {
    //TODO:实现图片裁剪功能
    /*
    TZImagePickerController *VC = [[TZImagePickerController alloc]initWithMaxImagesCount:3 delegate:self];
    [VC setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        self.ImageView.image = photos[0];
    }];
    [self presentViewController:VC animated:YES completion:nil];
     */
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
       picker.maximumNumberOfSelection = 5;
       picker.assetsFilter = ZYQAssetsFilterAllAssets;
       picker.showEmptyGroups=NO;
       picker.delegate=self;
       picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
           
           if ([(ZYQAsset*)evaluatedObject mediaType]==ZYQAssetMediaTypeVideo) {
               NSTimeInterval duration = [(ZYQAsset*)evaluatedObject duration];
               return duration >= 5;
           } else {
               return YES;
           }

           
       }];
       
       [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)fileToolBtnClick:(id)sender {
    
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^{
//        UIImage *image = info[UIImagePickerControllerEditedImage];
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        CropImageController * con = [[CropImageController alloc] initWithImage:image delegate:self];
        con.imgSize = CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH);
        con.ovalClip = YES;
        [self presentViewController:con animated:YES completion:nil];
    }];
}

- (void)cropImageDidFinishedWithImage:(UIImage *)image {
    NSLog(@"%f,%f",image.size.width,image.size.height);
    self.ImageView.image = image;
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

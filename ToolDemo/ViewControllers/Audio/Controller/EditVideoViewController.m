//
//  EditVideoViewController.m
//  ToolDemo
//
//  Created by liuqingyuan on 2020/4/14.
//  Copyright © 2020 liuqingyuan. All rights reserved.
//

#import "EditVideoViewController.h"

@interface EditVideoViewController ()<UIVideoEditorControllerDelegate,UINavigationControllerDelegate>

@end

@implementation EditVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self editVideo];
}

-(void)editVideo{
    NSString *videoPath = [[NSBundle mainBundle] pathForResource:@"When I Find Love Again" ofType:@"mp4"];
    if ([UIVideoEditorController canEditVideoAtPath:videoPath]) {
        UIVideoEditorController *videoEditor = [[UIVideoEditorController alloc]init];
        videoEditor.delegate = self;
        videoEditor.videoPath = videoPath;
        [self presentViewController:videoEditor animated:YES completion:nil];
    }else{
        [self showAlertWithTitle:@"该视频无法播放"];
    }
}

-(void)videoEditorController:(UIVideoEditorController *)editor didSaveEditedVideoToPath:(NSString *)editedVideoPath{
    [editor dismissViewControllerAnimated:YES completion:nil];
    if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(editedVideoPath)) {
        UISaveVideoAtPathToSavedPhotosAlbum(editedVideoPath, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
    }
}

-(void)videoEditorController:(UIVideoEditorController *)editor didFailWithError:(NSError *)error{
    NSLog(@"编辑视频出错");
    [editor dismissViewControllerAnimated:YES completion:nil];
}

-(void)videoEditorControllerDidCancel:(UIVideoEditorController *)editor{
    NSLog(@"取消编辑");
    [editor dismissViewControllerAnimated:YES completion:nil];
}

-(void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(NSString *)contextInfo{
    if (!error) {
        NSLog(@"保存成功");
    }else{
        NSLog(@"保存失败");
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

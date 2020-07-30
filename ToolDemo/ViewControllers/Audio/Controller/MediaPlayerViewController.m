//
//  MediaPlayerViewController.m
//  ToolDemo
//
//  Created by liuqingyuan on 2020/4/14.
//  Copyright © 2020 liuqingyuan. All rights reserved.
//  TODO:视频播放，暂停，续播实现。随手机方向颠倒实现

#import "MediaPlayerViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>
@interface MediaPlayerViewController ()
{
    id timeObserver;
    BOOL isPlaying;
}

//@property(nonatomic,strong)AVPlayerViewController *avPlayer;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UISlider *slider;

@property(nonatomic,weak)AVPlayer *avPlayer;
@property(nonatomic,weak)AVPlayerLayer *layer;
@property(nonatomic,strong)AVPlayerItem *playerItem;



@end

@implementation MediaPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:[self movieUrl] options:nil];
    self.playerItem = [AVPlayerItem playerItemWithAsset:asset];
    self.avPlayer = [AVPlayer playerWithPlayerItem:self.playerItem];
    self.layer = [AVPlayerLayer playerLayerWithPlayer:self.avPlayer];
    self.layer.frame = CGRectMake(0, 100, SCREEN_WIDTH, SCREEN_HEIGHT-300);
    [self.view.layer insertSublayer:self.layer atIndex:0];
    double duration = CMTimeGetSeconds(asset.duration);
    self.slider.maximumValue = duration;
    self.slider.minimumValue = 0;
    isPlaying = NO;
}

- (IBAction)play:(id)sender {
    UIBarButtonItem *item1;
    if (!isPlaying) {
        // 播放
        [self.avPlayer seekToTime:kCMTimeZero];
        [self.avPlayer play];
        isPlaying = YES;
        item1 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(play:)];
    }else{
        // 暂停
        isPlaying = NO;
        item1 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(play:)];
        [self.avPlayer pause];
    }
    NSMutableArray *items = [[NSMutableArray alloc]initWithArray:[self.toolBar items]];
    [items replaceObjectAtIndex:0 withObject:item1];
    [self.toolBar setItems:items];
}

- (IBAction)sliderValueChange:(UISlider *)sender {
    float value = [self.slider value];
    [self.avPlayer seekToTime:CMTimeMakeWithSeconds(value, 10)];
}

-(void)addObserver{
    if (timeObserver == nil) {
        // 添加通知，当视频播放完成后执行通知方法
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playerItemDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
        // 创建avplayer定时器事件观察者对象
        timeObserver = [self.avPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1, 10) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
            float duration = CMTimeGetSeconds(self.avPlayer.currentTime);
            self.slider.value = duration;
        }];
    }
}

-(void)playerItemDidReachEnd:(NSNotification *)notification{
    if (timeObserver) {
        [self.avPlayer removeTimeObserver:timeObserver];
        timeObserver = nil;
        self.slider = 0;
        isPlaying = NO;
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(play:)];
        NSMutableArray *items = [[NSMutableArray alloc]initWithArray:[self.toolBar items]];
        [items replaceObjectAtIndex:0 withObject:item];
        [self.toolBar setItems:items];
    }
}

-(NSURL *)movieUrl{
    NSURL *fileUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"When I Find Love Again" ofType:@"mp4"]];
    if (fileUrl) {
        return fileUrl;
    }else{
        return nil;
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

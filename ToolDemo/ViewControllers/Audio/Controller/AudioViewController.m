//
//  AudioViewController.m
//  ToolDemo
//
//  Created by liuqingyuan on 2020/4/7.
//  Copyright © 2020 liuqingyuan. All rights reserved.
//

#import "AudioViewController.h"
// 获取音频信息
#import <AudioToolbox/AudioToolbox.h>
// 音频播放
#import <MediaPlayer/MediaPlayer.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import <AVFoundation/AVFoundation.h>
@interface AudioViewController ()<MPMediaPickerControllerDelegate,AVAudioPlayerDelegate,AVSpeechSynthesizerDelegate>
{
MPMediaPickerController *musicVC;
MPMusicPlayerController *musicPlayerVC;
    
    AVAudioPlayer *audioPlayer;
    NSTimer *timer;
    
    // 语音识别
    AVSpeechSynthesizer *speechManager;
}

@property (weak, nonatomic) IBOutlet UIProgressView *musicProcess;
@property (weak, nonatomic) IBOutlet UITextView *audioInfo;
@property (weak, nonatomic) IBOutlet UISwitch *silenceSwitch;
@property (weak, nonatomic) IBOutlet UIStepper *loopStep;

@property (weak, nonatomic) IBOutlet UISlider *voiceNum;
@property (weak, nonatomic) IBOutlet UISlider *timeNum;


@end

@implementation AudioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    AudioQueue 音频队列
    // OpenAL 设置音源
    /*
     音视频控制中使用
     MediaPlayer
     音频单元类型，底层音频交互
     audioUnit
     3D效果
     OpenAL
     全能型。大部分音视频处理都可以
     AVFoundation
     音频编解码格式转换
     AUdioToolbox
     */
    /*
     audioToolBox
     audio systemSound 播放提示音，时长<30s，也可以震动
     
     */
    
//    [self getAudioInfo];
    [self speech];
    [self createAudio];
}

-(void)speech{
    speechManager = [[AVSpeechSynthesizer alloc]init];
    speechManager.delegate = self;
    AVSpeechUtterance *aut = [AVSpeechUtterance speechUtteranceWithString:@"welcome to 慕课网"];
    // 播放速率 数值越大，越快
    aut.rate = 0.5;
    [speechManager speakUtterance:aut];
}

-(void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didPauseSpeechUtterance:(AVSpeechUtterance *)utterance{
    NSLog(@"语音处理完成");
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didStartSpeechUtterance:(AVSpeechUtterance *)utterance{
    NSLog(@"开始语音处理");
}



-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    
}

-(void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error{
    
}
//FIXME:初始音量设置，初始时间设置，播放与暂停按钮合并，循环次数显示，audio info信息展示
-(void)createAudio{
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"hope" withExtension:@"mp3"] error:nil];
    audioPlayer.delegate = self;
    // 自动播放
    audioPlayer.meteringEnabled = YES;
    self.voiceNum.value = audioPlayer.volume;
    self.timeNum.value = audioPlayer.currentTime/audioPlayer.duration;
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(monitor) userInfo:nil repeats:YES];
}

- (IBAction)playBtnClick:(id)sender {
    [audioPlayer play];
}

-(void)monitor{
//    通道个数
    NSUInteger channels = audioPlayer.numberOfChannels;
    NSTimeInterval duration = audioPlayer.duration;
    [audioPlayer updateMeters];
    NSString *peakValue = [NSString stringWithFormat:@"通道1峰值功率%f,通道2峰值功率%f,通道个数%lu,周期%lu,当前时间%f",[audioPlayer peakPowerForChannel:0],[audioPlayer peakPowerForChannel:1],channels,(unsigned long)duration,audioPlayer.currentTime];
    self.musicProcess.progress = audioPlayer.currentTime/audioPlayer.duration;
    self.audioInfo.text = peakValue;
}

- (IBAction)pauseBtnClick:(id)sender {
    if ([audioPlayer isPlaying]) {
        [audioPlayer pause];
    }else{
        [audioPlayer play];
    }
}

- (IBAction)stopBtnClick:(id)sender {
    [audioPlayer stop];
    // 修改时间为0
    // 修改进度为0
    self.musicProcess = 0;
}

- (IBAction)silentSwitch:(id)sender {
    // 静音
    audioPlayer.volume = self.silenceSwitch.isOn;
}

- (IBAction)loopCount:(id)sender {
    audioPlayer.numberOfLoops = self.loopStep.value;
}

- (IBAction)voiceNum:(id)sender {
    audioPlayer.volume = self.voiceNum.value;
}

- (IBAction)timeNum:(id)sender {
    [audioPlayer pause];
    [audioPlayer setCurrentTime:(NSTimeInterval)self.timeNum.value*audioPlayer.duration];
    [audioPlayer play];
}


-(void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker{
    NSLog(@"取消");
    [mediaPicker dismissViewControllerAnimated:YES completion:nil];
}

-(void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection{
    musicPlayerVC = [MPMusicPlayerController applicationMusicPlayer];
    [musicPlayerVC setQueueWithItemCollection:mediaItemCollection];
    [musicPlayerVC play];
}


- (IBAction)zhendongBtnClick:(id)sender {
    NSString *deviceModel = [[UIDevice currentDevice] model];
    if ([deviceModel isEqualToString:@"iPhone"]) {
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
    }else{
        [self showAlertWithTitle:@"设备不支持震动"];
    }
}

- (IBAction)MPMediaPickerClick:(id)sender {
    //FIXME:无法弹出界面，（疑似国内不支持apple music所致）
    musicVC = [[MPMediaPickerController alloc]initWithMediaTypes:MPMediaTypeAnyAudio];
    musicVC.delegate = self;
    musicVC.prompt = @"选择歌曲";
    [self.navigationController presentViewController:musicVC animated:YES completion:nil];

}


- (IBAction)systemBtnClick:(id)sender {
    NSURL *systemSoundUrl = [[NSBundle mainBundle] URLForResource:@"hope" withExtension:@"caf"];
//    NSURL *systemSoundUrl = [NSURL URLWithString:[[NSBundle mainBundle]pathForResource:@"hope" ofType:@"caf"]];
    SystemSoundID systemSoundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)systemSoundUrl, &systemSoundID);
    // 注册回调方法
    AudioServicesAddSystemSoundCompletion(systemSoundID, nil, nil, MySoundFinishedPlayingCallback, nil);
    //播放系统声音
    // 静音式无反应
    AudioServicesPlaySystemSound(systemSoundID);
}

void MySoundFinishedPlayingCallback(SystemSoundID sound_id, void* user_data)
{
    AudioServicesDisposeSystemSoundID(sound_id);
}

- (IBAction)remindBtnClick:(id)sender {
    NSURL *systemSoundUrl = [[NSBundle mainBundle] URLForResource:@"hope" withExtension:@"caf"];
        SystemSoundID systemSoundID;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)systemSoundUrl, &systemSoundID);
        // 注册回调方法
        AudioServicesAddSystemSoundCompletion(systemSoundID, nil, nil, MySoundFinishedPlayingCallback, nil);
//    该方法静音时，手机会有震动
    AudioServicesPlayAlertSound(systemSoundID);
}

// 获取音频文件栏类型
-(void)getAudioInfo{
    NSString *audioFile = [[NSBundle mainBundle] pathForResource:@"hope" ofType:@"mp3"];
    NSURL *url = [NSURL URLWithString:audioFile];
//    NSURL *audioUrl = [[NSBundle mainBundle] URLForResource:@"hope" withExtension:@"mp3"];
    // 打开文件
    AudioFileID audioFileID;
    AudioFileOpenURL((__bridge CFURLRef)url, kAudioFileReadPermission, 0, &audioFileID);
    // 读取
    UInt32 ioDataSize = 0;
    AudioFileGetPropertyInfo(audioFileID, kAudioFilePropertyInfoDictionary, &ioDataSize, 0);
    CFDictionaryRef dictionary;
    AudioFileGetProperty(audioFileID, kAudioFilePropertyInfoDictionary, &ioDataSize, &dictionary);
    NSDictionary *audioDic = (__bridge NSDictionary *)dictionary;
    for (int i=0; i<[audioDic allKeys].count; i++) {
        NSString *key = [[audioDic allKeys]objectAtIndex:i];
        NSString *value = [audioDic objectForKey:key];
        NSLog(@"%@=%@",key,value);
    }
    CFRelease(dictionary);
    AudioFileClose(audioFileID);
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

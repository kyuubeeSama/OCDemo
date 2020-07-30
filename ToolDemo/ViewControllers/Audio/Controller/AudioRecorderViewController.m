//
//  AudioRecorderViewController.m
//  ToolDemo
//
//  Created by liuqingyuan on 2020/4/13.
//  Copyright © 2020 liuqingyuan. All rights reserved.
//

#import "AudioRecorderViewController.h"
#import "Tool.h"
@interface AudioRecorderViewController ()<AVAudioRecorderDelegate>

@property (weak, nonatomic) IBOutlet UILabel *statusLab;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;

@property(nonatomic,strong)AVAudioRecorder *audioRecorder;
@property(nonatomic,strong)AVAudioPlayer *player;

@end

@implementation AudioRecorderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}

-(AVAudioRecorder *)audioRecorder{
    if (!_audioRecorder) {
        NSString *filePath = [NSString stringWithFormat:@"%@/rec_audio.caf",[Tool getDocumentPath]];
        NSURL *fileURl = [NSURL fileURLWithPath:filePath];
        NSError *error = nil;
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryRecord error:&error];
        [[AVAudioSession sharedInstance] setActive:YES error:&error];
        NSDictionary *setting = @{AVFormatIDKey:@(kAudioFormatLinearPCM),
                                  AVSampleRateKey:@(44100.0),
                                  AVNumberOfChannelsKey:@(1),
                                  AVLinearPCMBitDepthKey:@(16),
                                  AVLinearPCMIsBigEndianKey:@(NO),
                                  AVLinearPCMIsFloatKey:@(NO)
        };
        _audioRecorder = [[AVAudioRecorder alloc]initWithURL:fileURl settings:setting error:&error];
        _audioRecorder.delegate = self;
    }
    return _audioRecorder;
}

-(AVAudioPlayer *)player{
    if (!_player) {
        NSString *filePath = [NSString stringWithFormat:@"%@/rec_audio.caf",[Tool getDocumentPath]];
        NSURL *fileURl = [NSURL fileURLWithPath:filePath];
        NSError *error = nil;
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
        [[AVAudioSession sharedInstance] setActive:YES error:&error];
        _player = [[AVAudioPlayer alloc]initWithContentsOfURL:fileURl error:&error];
    }
    return _player;
}

- (IBAction)playBtn:(UIButton *)sender {
    NSString *string;
    if ([self.player isPlaying]) {
        [self.player stop];
        string = @"播放录音";
    }else{
        [self.player play];
        string = @"停止播放";
    }
    [sender setTitle:string forState:UIControlStateNormal];
}


- (IBAction)beginBtn:(UIButton *)sender {
    if (self.player&&self.player.isPlaying) {
        [self.player stop];
    }
    if (self.audioRecorder.isRecording) {
        [self.startBtn setTitle:@"停止录制" forState:UIControlStateNormal];
        [self.audioRecorder stop];
        self.statusLab.text = @"录制结束";
    }else{
        [self.startBtn setTitle:@"开始录制" forState:UIControlStateNormal];
        [self.audioRecorder record];
        self.statusLab.text = @"录制中";
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

//
//  VideoViewController.m
//  ToolDemo
//
//  Created by liuqingyuan on 2020/3/5.
//  Copyright © 2020 liuqingyuan. All rights reserved.
//

#import "VideoViewController.h"
#import "VideoTableViewCell.h"
#import <SJVideoPlayer/SJVideoPlayer.h>
@interface VideoViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *mainTable;
@property (nonatomic, strong, readonly) SJVideoPlayer *player;

@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self makeUI];
}

-(void)makeUI{
    self.mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    [self.view addSubview:self.mainTable];
    self.mainTable.delegate = self;
    self.mainTable.dataSource = self;
    self.mainTable.estimatedRowHeight = 0;
    self.mainTable.estimatedSectionFooterHeight = 0;
    self.mainTable.estimatedSectionHeaderHeight = 0;
    self.mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.mainTable registerNib:[UINib nibWithNibName:@"VideoTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

// 视频地址：http://123.58.241.153:8082/files/null2020/02/29/20200229105037511.mp4

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSURL *url = [NSURL URLWithString:@"http://123.58.241.153:8082/files/null2020/02/29/20200229105037511.mp4"];
    VideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    WeakSelf(cell)
    cell.videoBlock = ^{
        if (!self->_player) {
            self->_player = [SJVideoPlayer player];
            UIView *playerSuperview = weakcell.videoBackView;
            SJPlayModel *playModel = [SJPlayModel UITableViewCellPlayModelWithPlayerSuperviewTag:playerSuperview.tag atIndexPath:indexPath tableView:self.mainTable];
            self->_player.URLAsset = [[SJVideoPlayerURLAsset alloc] initWithURL:url playModel:playModel];
        }
    };
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
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

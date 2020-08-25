//
//  IndexViewController.m
//  ToolDemo
//
//  Created by liuqingyuan on 2018/4/8.
//  Copyright © 2018年 liuqingyuan. All rights reserved.
//

#import "IndexViewController.h"
//#import "RequestData.h"
#import "Tool.h"
#import "ThirdHeader.h"
#import "ShareViewController.h"
#import "AddressListViewController.h"
#import "ThirdLoginViewController.h"
#import "TimeDateViewController.h"
#import "QRCodeViewController.h"
#import "ImageViewController.h"
#import "WaveAnimationViewController.h"
#import "ProximityViewController.h"
#import "TouchidViewController.h"
#import "DemoViewController.h"
#import "ImgScrollViewController.h"
#import "GestureViewController.h"
#import "KVO1ViewController.h"
#import "UIColor+Category.h"
#import "CropImgViewController.h"
#import "SliderViewController.h"
#import "PointNineViewController.h"
#import "FileListViewController.h"
#import "WkWebViewController.h"
#import "FileManagerViewController.h"
#import "YaoViewController.h"
#import "PushDemoViewController.h"
#import "SafariViewController.h"
#import "QYTabbarViewController.h"
#import "EchartsViewController.h"
#import "VideoViewController.h"
#import "AudioViewController.h"
#import "DanMuViewController.h"
#import "QuartzViewController.h"
#import "AnimationViewController.h"
#import "AudioRecorderViewController.h"
#import "MediaPlayerViewController.h"
#import "RecordVideoViewController.h"
#import "EditVideoViewController.h"

@interface IndexViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property(nonatomic, retain) UITableView *mainTable;
@property(nonatomic, retain) NSMutableArray *listArr;
@property(nonatomic, retain) NSMutableArray *VCArr;
@property(nonatomic, strong) UISearchBar *searchBar;

@end

@implementation IndexViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNav];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.searchBar removeFromSuperview];
    self.searchBar = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // touchid 和 手势密码一套
    self.listArr = [[NSMutableArray alloc] initWithArray:@[@"编辑视频",@"录制视频",@"avplayer",@"录音",@"动画",@"Quartz",@"弹幕",@"多媒体操作",@"视频播放",@"友盟分享", @"获取通讯录", @"友盟第三方登录", @"时间选择器", @"二维码&条形码",  @"距离传感器", @"图片相关操作", @"波浪动画", @"指纹验证", @"demo", @"图片放大查看", @"手势密码", @"KVO", @"图片裁剪", @"屏幕滑动显示菜单", @".9图片", @"系统相册", @"WKWebView", @"获取本地图片", @"摇一摇", @"推送测试", @"safari", @"tabbar测试", @"柱状图"]];
    self.VCArr = [[NSMutableArray alloc] initWithArray:@[[EditVideoViewController description],[RecordVideoViewController description],[MediaPlayerViewController description],[AudioRecorderViewController description],[AnimationViewController description],[QuartzViewController description],[DanMuViewController description],[AudioViewController description],[VideoViewController description],[ShareViewController description], [AddressListViewController description], [ThirdLoginViewController description], [TimeDateViewController description],  [QRCodeViewController description], [ProximityViewController description], [ImageViewController description], [WaveAnimationViewController description], [TouchidViewController description], [DemoViewController description], [ImgScrollViewController description], [GestureViewController description], [KVO1ViewController description], [CropImgViewController description], [SliderViewController description], [PointNineViewController description], [FileListViewController description], [WkWebViewController description], [FileManagerViewController description], [YaoViewController description], [PushDemoViewController description], [SafariViewController description], [QYTabbarViewController description], [EchartsViewController description]]];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createTableView];
}

- (void)setNav {
    self.searchBar = [[UISearchBar alloc] init];
    [self.navigationController.view addSubview:self.searchBar];
    self.searchBar.delegate = self;
    self.searchBar.frame = CGRectMake(0, (TOP_HEIGHT)-45, SCREEN_WIDTH, 45);
}

- (void)createTableView {
    self.mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    [self.view addSubview:self.mainTable];
    self.mainTable.estimatedRowHeight = 0;
    self.mainTable.estimatedSectionHeaderHeight = 0;
    self.mainTable.estimatedSectionFooterHeight = 0;
    self.mainTable.dataSource = self;
    self.mainTable.delegate = self;
    [self.mainTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top).offset((SCREEN_TOP));
        make.bottom.equalTo(self.view.mas_bottom).offset(SCREEN_BOTTOM);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.textLabel.text = self.listArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *VC = (UIViewController *)[[NSClassFromString(self.VCArr[indexPath.row]) alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"%@", searchBar.text);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

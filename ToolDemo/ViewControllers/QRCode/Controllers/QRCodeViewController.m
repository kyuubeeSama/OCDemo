//
//  QRCodeViewController.m
//  ToolDemo
//
//  Created by liuqingyuan on 2019/11/19.
//  Copyright © 2019 liuqingyuan. All rights reserved.
//

#import "QRCodeViewController.h"
#import "ScanQRCodeViewController.h"
#import "CreateBarcodeViewController.h"
#import "CreateQRCodeViewController.h"
#import "Tool.h"
@interface QRCodeViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView *mainTable;
@property (nonatomic, copy)NSArray *listArr;
@property (nonatomic, copy)NSArray *VCArr;

@end

@implementation QRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.title = @"二维码&条形码";
    self.title = @"二维码&条形码";
    self.listArr = @[@"创建二维码",@"创建条形码",@"扫描二维码"];
    self.VCArr = @[[CreateQRCodeViewController description],[CreateBarcodeViewController description],[ScanQRCodeViewController description]];
    [self makeUI];
}

-(void)makeUI{
    self.mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, SCREEN_HEIGHT - (TOP_HEIGHT) - 45) style:UITableViewStylePlain];
    [self.view addSubview:self.mainTable];
    self.mainTable.delegate = self;
    self.mainTable.dataSource = self;
    self.mainTable.estimatedRowHeight = 0;
    self.mainTable.estimatedSectionFooterHeight = 0;
    self.mainTable.estimatedSectionHeaderHeight = 0;
    self.mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = self.listArr[(NSUInteger)indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIViewController *VC = (UIViewController *)[[NSClassFromString(self.VCArr[(NSUInteger)indexPath.row]) alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
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

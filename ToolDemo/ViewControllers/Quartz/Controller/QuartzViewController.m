//
//  QuartzViewController.m
//  ToolDemo
//
//  Created by liuqingyuan on 2020/4/12.
//  Copyright © 2020 liuqingyuan. All rights reserved.
//

#import "QuartzViewController.h"
#import "FillingView.h"
#import "CoreImageViewController.h"
#import "GetFaceViewController.h"
@interface QuartzViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,retain)UITableView *mainTable;
@property(nonatomic,retain)NSArray *listArr;
@end

@implementation QuartzViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self makeUI];
}

-(NSArray *)listArr{
    if (!_listArr) {
        _listArr = @[@"绘制视图+图形上下文+路径+坐标变换",@"CoreImage",@"人脸识别"];
    }
    return _listArr;
}

-(void)makeUI{
    self.mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    [self.view addSubview:self.mainTable];
    self.mainTable.delegate = self;
    self.mainTable.dataSource = self;
    self.mainTable.estimatedRowHeight = 0;
    self.mainTable.estimatedSectionFooterHeight = 0;
    self.mainTable.estimatedSectionHeaderHeight = 0;
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
    if (indexPath.row == 0){
        FillingView *fillingView = [[FillingView alloc] init];
        [self.view addSubview:fillingView];
        fillingView.center = self.view.center;
        fillingView.bounds = CGRectMake(0, 0, 300, 500);
    }else if(indexPath.row == 1){
        CoreImageViewController *VC = [[CoreImageViewController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    }else if(indexPath.row == 2){
        GetFaceViewController *VC = [[GetFaceViewController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
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

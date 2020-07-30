//
//  FileListViewController.m
//  ToolDemo
//
//  Created by liuqingyuan on 2019/3/28.
//  Copyright © 2019 liuqingyuan. All rights reserved.
//

#import "FileListViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface FileListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,retain)UITableView *mainTable;
@property(nonatomic,retain)NSMutableArray *listArr;

@end

@implementation FileListViewController
{
    ALAssetsLibrary *library;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"系统相册";
    //创建可变数组,存储资源文件
    self.listArr = [NSMutableArray array];
    [self makeUI];
    [self getImgArr];
    
}

-(void)makeUI{
    self.mainTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    [self.view addSubview:self.mainTable];
    self.mainTable.estimatedRowHeight =0;
    self.mainTable.estimatedSectionHeaderHeight =0;
    self.mainTable.estimatedSectionFooterHeight =0;
    self.mainTable.dataSource=self;
    self.mainTable.delegate=self;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    ALAsset *result = self.listArr[indexPath.row];
    CGImageRef  thumbnailRef = [result thumbnail];
//    UIImage *thumbnailImg =
    cell.imageView.image = [[UIImage alloc]initWithCGImage:thumbnailRef];
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(void)getImgArr
{
    //创建资源库,用于访问相册资源
    library = [[ALAssetsLibrary alloc] init];
    
    //遍历资源库中所有的相册,有多少个相册,usingBlock会调用多少次
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        
        //如果存在相册,再遍历
        if (group) {
            
            //遍历相册中所有的资源(照片,视频)
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if (result) {
                    //将资源存储到数组中
                    ALAssetRepresentation *imageRep = [result defaultRepresentation];
                    
                    NSLog(@"[imageRep filename] : %@", [imageRep filename]);
                    [self.listArr addObject:result];
                }
                
            }];
        }
        
        //刷新_collectionView reloadData;
        [self.mainTable reloadData];
        
    } failureBlock:^(NSError *error) {
        
        NSLog(@"访问失败");
    }];
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

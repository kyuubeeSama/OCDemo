//
//  CategoryViewController.m
//  ToolDemo
//
//  Created by Galaxy on 2021/2/2.
//  Copyright © 2021 liuqingyuan. All rights reserved.
//


#import "CategoryViewController.h"
#import "CategoryTableView.h"
#import <JXCategoryView/JXCategoryView.h>
#import "ListTableViewController.h"
#import "Masonry.h"
@interface CategoryViewController ()<JXCategoryListContainerViewDelegate,JXCategoryViewDelegate>

@property (nonatomic, strong) JXCategoryNumberView *categoryView;
//@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;
@property(nonatomic,strong)NSMutableArray *listArr;
@property(nonatomic, assign) NSInteger index;

@end

@implementation CategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self makeUI];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"刷新" style:UIBarButtonItemStylePlain target:self action:@selector(refreshBtnClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

-(void)refreshBtnClick{
    [self.listContainerView reloadData];
}

-(NSMutableArray *)listArr{
    if (!_listArr) {
        _listArr = [[NSMutableArray alloc] init];
        for (int i = 0; i < 5; ++i) {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (int j = 0; j < 15; ++j) {
                [array addObject:[NSString stringWithFormat:@"%d",i*100+j]];
            }
            [_listArr addObject:array];
        }
    }
    return _listArr;
}
// 官方提供
-(void)makeUI{
    self.categoryView = [[JXCategoryNumberView alloc]initWithFrame:CGRectMake(0, TOP_HEIGHT, SCREEN_WIDTH, 40)];
//    self.categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, TOP_HEIGHT, SCREEN_WIDTH, 40)];
    self.categoryView.delegate = self;
    [self.view addSubview:self.categoryView];
    self.categoryView.titles = @[@"标题1",@"标题2",@"标题3",@"标题4",@"标题5"];
    // 如果是需要显示数字，使用jxcategorynumberview
    NSArray *numArr = @[@1,@0,@12,@0,@0];
    self.categoryView.counts = numArr;
    self.categoryView.titleColorGradientEnabled = YES;
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorColor = [UIColor redColor];
    lineView.indicatorWidth = JXCategoryViewAutomaticDimension;
    self.categoryView.indicators = @[lineView];
    
    // 列表容器
    self.listContainerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_CollectionView delegate:self];
    [self.view addSubview:self.listContainerView];
    self.listContainerView.frame = CGRectMake(0, 40+(TOP_HEIGHT), SCREEN_WIDTH, SCREEN_HEIGHT-40-(TOP_HEIGHT)); 
    self.categoryView.listContainer = self.listContainerView;
}
// 自定义
-(void)makeUI2{
    
}

-(NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.listArr.count;
}

-(id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
//    CategoryTableView *tableView = [[CategoryTableView alloc]init];
    ListTableViewController *tableView = [[ListTableViewController alloc] init];
    tableView.listArr = self.listArr[index];
    return tableView;
}

-(void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    if (index == 4){
        [categoryView selectItemAtIndex:self.index];
    }else{
        self.index = index;
    }
}

-(void)categoryView:(JXCategoryBaseView *)categoryView didScrollSelectedItemAtIndex:(NSInteger)index {
    if (index == 4){
        [categoryView selectItemAtIndex:3];
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

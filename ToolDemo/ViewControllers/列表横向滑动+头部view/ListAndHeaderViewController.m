//
//  ListAndHeaderViewController.m
//  ToolDemo
//
//  Created by Galaxy on 2021/3/2.
//  Copyright © 2021 liuqingyuan. All rights reserved.
//  界面内容包括，header头，横向滑动titleview，列表listview

#import "ListAndHeaderViewController.h"
#import <JXPagingView/JXPagerView.h>
#import <JXCategoryView/JXCategoryView.h>
#import "PagerListViewController.h"
#import <MJRefresh/MJRefresh.h>
@interface ListAndHeaderViewController ()<JXPagerViewDelegate,JXPagerMainTableViewGestureDelegate,JXCategoryViewDelegate>

@property(nonatomic,strong)JXPagerView *pagerView;
@property (nonatomic, strong) JXCategoryNumberView *categoryView;
@property(nonatomic,strong)NSMutableArray *listArr;
@property(nonatomic,strong)UIView *headerView;
@property(nonatomic, assign) NSInteger index;

@end

@implementation ListAndHeaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self makeUI];
    self.index = 0;
    self.pagerView.mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        NSLog(@"下拉刷新");
    }];
}

-(void)makeUI{
    self.headerView = [[UIView alloc]init];
    self.headerView.backgroundColor = [UIColor redColor];
    self.headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 200);

    self.categoryView = [[JXCategoryNumberView alloc]initWithFrame:CGRectMake(0, TOP_HEIGHT, SCREEN_WIDTH, 40)];
    self.categoryView.delegate = self;
    self.categoryView.titles = @[@"标题1",@"标题2",@"标题3",@"标题4",@"标题5"];
    // 如果是需要显示数字，使用jxcategorynumberview
    NSArray *numArr = @[@1,@0,@12,@0,@0];
    self.categoryView.counts = numArr;
    self.categoryView.titleColorGradientEnabled = YES;
    
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorColor = [UIColor redColor];
    lineView.indicatorWidth = JXCategoryViewAutomaticDimension;
    self.categoryView.indicators = @[lineView];
    
    self.pagerView = [[JXPagerView alloc]initWithDelegate:self];
    self.pagerView.mainTableView.gestureDelegate = self;
    self.pagerView.frame = self.view.bounds;
    [self.view addSubview:self.pagerView];
    
    self.categoryView.listContainer = (id<JXCategoryViewListContainer>)self.pagerView.listContainerView;
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

-(UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView{
    // 设置头部view
    return self.headerView;
}

-(NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView{
    //设置头部view的高度
    return 200;
}

-(NSUInteger)heightForPinSectionHeaderInPagerView:(JXPagerView *)pagerView{
    // 设置选择view的高度
    return 40;
}

-(UIView *)viewForPinSectionHeaderInPagerView:(JXPagerView *)pagerView{
    return self.categoryView;
}

-(NSInteger)numberOfListsInPagerView:(JXPagerView *)pagerView{
    return self.categoryView.titles.count;
}

-(id<JXPagerViewListViewDelegate>)pagerView:(JXPagerView *)pagerView initListAtIndex:(NSInteger)index{
    PagerListViewController *tableView = [[PagerListViewController alloc]init];
    tableView.listArr = self.listArr[index];
    return tableView;
}

#pragma mark - JXCategoryViewDelegate

//- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
//    self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);
//    NSLog(@"%ld",(long)index);
//    if (index == 4) {
//        [categoryView selectItemAtIndex:3];
//    }
//}

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

#pragma mark - JXPagerMainTableViewGestureDelegate

- (BOOL)mainTableViewGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    //禁止categoryView左右滑动的时候，上下和左右都可以滚动
    if (otherGestureRecognizer == self.categoryView.collectionView.panGestureRecognizer) {
        return NO;
    }
    return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
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


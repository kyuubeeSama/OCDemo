//
//  EchartsViewController.m
//  ToolDemo
//
//  Created by liuqingyuan on 2019/8/29.
//  Copyright © 2019 liuqingyuan. All rights reserved.
//

#import "EchartsViewController.h"
#import "PYEchartsView.h"
#import "iOS-Echarts.h"

@interface EchartsViewController ()

@property(nonatomic,strong)PYEchartsView *kEchartView;

@end

@implementation EchartsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self makeUI];
}

-(void)makeUI{
    self.title = @"柱状图";
    self.kEchartView = [[PYEchartsView alloc]initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 400)];
    [self.view addSubview:self.kEchartView];
    PYOption *option = [self basicColumnOption];
    [self.kEchartView setOption:option];
    [self.kEchartView loadEcharts];

}

- (PYOption *)basicColumnOption {
    return [PYOption initPYOptionWithBlock:^(PYOption *option) {
        option.titleEqual([PYTitle initPYTitleWithBlock:^(PYTitle *title) {
            // 标题 和 副标题
            title.textEqual(@"某地区蒸发量和降水量").subtextEqual(@"纯属虚构");
        }])
        .gridEqual([PYGrid initPYGridWithBlock:^(PYGrid *grid) {
            // 视图左距离，右距离
            grid.xEqual(@40).x2Equal(@50);
        }])
        //        .tooltipEqual([PYTooltip initPYTooltipWithBlock:^(PYTooltip *tooltip) {
        //            tooltip.triggerEqual(PYTooltipTriggerAxis);
        //        }])
        //        .legendEqual([PYLegend initPYLegendWithBlock:^(PYLegend *legend) {
        //            // 柱形图示例
        //            legend.dataEqual(@[@"蒸发量",@"降水量"]);
        //        }])
        //        .toolboxEqual([PYToolbox initPYToolboxWithBlock:^(PYToolbox *toolbox) {
        //            toolbox.showEqual(YES)
        //            .featureEqual([PYToolboxFeature initPYToolboxFeatureWithBlock:^(PYToolboxFeature *feature) {
        //                feature.markEqual([PYToolboxFeatureMark initPYToolboxFeatureMarkWithBlock:^(PYToolboxFeatureMark *mark) {
        //                    mark.showEqual(YES);
        //                }])
        //                .dataViewEqual([PYToolboxFeatureDataView initPYToolboxFeatureDataViewWithBlock:^(PYToolboxFeatureDataView *dataView) {
        //                    dataView.showEqual(YES).readOnlyEqual(NO);
        //                }])
        //                .magicTypeEqual([PYToolboxFeatureMagicType initPYToolboxFeatureMagicTypeWithBlock:^(PYToolboxFeatureMagicType *magicType) {
        //                    magicType.showEqual(YES).typeEqual(@[PYSeriesTypeLine, PYSeriesTypeBar]);
        //                }])
        //                .restoreEqual([PYToolboxFeatureRestore initPYToolboxFeatureRestoreWithBlock:^(PYToolboxFeatureRestore *restore) {
        //                    restore.showEqual(YES);
        //                }]);
        //            }]);
        //        }])
        //        柱状图是否允许拖动相加
        //        .calculableEqual(YES)
        // 设置x轴
        .addXAxis([PYAxis initPYAxisWithBlock:^(PYAxis *axis) {
            axis.typeEqual(PYAxisTypeCategory)
            .addDataArr(@[@"1月",@"2月",@"3月",@"4月",@"5月",@"6月",@"7月",@"8月",@"9月",@"10月",@"11月",@"12月"]);
        }])
        // 设置y轴以柱状图内容自动设置值
        .addYAxis([PYAxis initPYAxisWithBlock:^(PYAxis *axis) {
            axis.typeEqual(PYAxisTypeValue);
            //            axis.typeEqual(PYAxisTypeCategory).addDataArr(@[@"50",@"100",@"150",@"200"]);
        }])
        // 添加圆柱数据
        .addSeries([PYCartesianSeries initPYSeriesWithBlock:^(PYSeries *series) {
            series.nameEqual(@"蒸发量")
            // 设置类型为柱状图
            .typeEqual(PYSeriesTypeBar)
            // 设置背景颜色
            .itemStyleEqual([PYItemStyle initPYItemStyleWithBlock:^(PYItemStyle *itemStyle) {
                itemStyle.normalEqual([PYItemStyleProp initPYItemStylePropWithBlock:^(PYItemStyleProp *normal) {
                    //                    ？？？
                    normal.barBorderColorEqual(PYRGBA(255,215,0, 1))
                    // 柱形颜色
                    .colorEqual(PYRGBA(255, 0, 0, 1));
                }]);
            }])
            // 设置具体
            .addDataArr(@[@2.0, @4.9, @7.0, @23.2, @25.6, @76.7, @135.6, @162.2, @32.6, @20.0, @6.4, @3.3])
            // 计算出最大值和最下值
            .markPointEqual([PYMarkPoint initPYMarkPointWithBlock:^(PYMarkPoint *point) {
                point.addData(@{@"type":@"max", @"name":@"最大值"})
                .addData(@{@"type":@"min", @"name":@"最小值"});
            }])
            // 添加平均值线
            .markLineEqual([PYMarkLine initPYMarkLineWithBlock:^(PYMarkLine *markLine) {
                markLine.addData(@{@"type":@"average", @"name":@"平均值"});
            }]);
        }]);
        //        .addSeries([PYCartesianSeries initPYSeriesWithBlock:^(PYSeries *series) {
        //            series.nameEqual(@"降水量")
        //            .typeEqual(PYSeriesTypeBar)
        //            .addDataArr(@[@2.6, @5.9, @9.0, @26.4, @28.7, @70.7, @175.6, @182.2, @48.7, @18.8, @6.0, @2.3])
        //            .markPointEqual([PYMarkPoint initPYMarkPointWithBlock:^(PYMarkPoint *point) {
        //                point.addData(@{@"name":@"年最高", @"value":@182.2, @"xAxis":@7, @"yAxis":@183, @"symbolSize":@18})
        //                .addData(@{@"name":@"年最低", @"value":@2.3, @"xAxis":@11, @"yAxis":@3});
        //            }])
        //            .markLineEqual([PYMarkLine initPYMarkLineWithBlock:^(PYMarkLine *markLine) {
        //                markLine.addData(@{@"type":@"average", @"name":@"平均值"});
        //            }]);
        //        }]);
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

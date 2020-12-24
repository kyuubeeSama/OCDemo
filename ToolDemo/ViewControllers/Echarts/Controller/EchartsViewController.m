//
//  EchartsViewController.m
//  ToolDemo
//
//  Created by liuqingyuan on 2019/8/29.
//  Copyright © 2019 liuqingyuan. All rights reserved.
//

#import "EchartsViewController.h"
#import <AAChartKit/AAChartKit.h>
@interface EchartsViewController ()

@end

@implementation EchartsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self makeColumnView];
    [self pieView];
}

// 创建一个柱状图
-(void)makeColumnView{
    AAChartView *aachartView = [[AAChartView alloc]init];
    [self.view addSubview:aachartView];
    aachartView.scrollEnabled = NO;
    aachartView.frame = CGRectMake(0, 100, SCREEN_WIDTH, 300);
    AAChartModel *aaChartModel= AAObject(AAChartModel)
    .chartTypeSet(AAChartTypeColumn)//设置图表的类型(这里以设置的为折线面积图为例)
    .categoriesSet(@[@"Java",@"Swift",@"Python",@"Ruby", @"PHP",@"Go",@"C",@"C#",@"C++"])//图表横轴的内容
    .yAxisTitleSet(@"挂牌数量")//设置图表 y 轴的单位
    .seriesSet(@[
            AAObject(AASeriesElement)
            .nameSet(@"")
            .dataSet(@[@7.0, @6.9, @9.5, @14.5, @18.2, @21.5, @25.2, @26.5, @23.3, @18.3, @13.9, @9.6])
                     ]);
    [aachartView aa_drawChartWithChartModel:aaChartModel];
}

// 创建一个饼图
-(void)pieView{
    AAChartView *aachartView = [[AAChartView alloc]init];
    [self.view addSubview:aachartView];
    aachartView.scrollEnabled = NO;
    aachartView.frame = CGRectMake(0, 450, SCREEN_WIDTH, 300);
    [aachartView aa_drawChartWithChartModel:[self configurePieChart]];
}

- (AAChartModel *)configurePieChart {
    AASeriesElement *element = AASeriesElement.new
    .innerSizeSet(@"0%")//内部圆环半径大小占比
    .sizeSet(@200)//尺寸大小
    .borderWidthSet(@0)//描边的宽度
    .allowPointSelectSet(true)//是否允许在点击数据点标记(扇形图点击选中的块发生位移)
    .statesSet(AAStates.new
               .hoverSet(AAHover.new
                         .enabledSet(false)//禁用点击区块之后出现的半透明遮罩层
                         ))
    .dataSet(@[
        @[@"Firefox",   @3336.2],
        @[@"IE",          @26.8],
        @{@"sliced": @true,
          @"selected": @true,
          @"name": @"Chrome",
          @"y": @666.8,        },
        @[@"Safari",      @88.5],
        @[@"Opera",       @46.0],
        @[@"Others",     @223.0],
    ]);
    
    return AAChartModel.new
    .chartTypeSet(AAChartTypePie)
    .colorsThemeSet(@[@"#0c9674",@"#7dffc0",@"#ff3333",@"#facd32",@"#ffffa0",@"#EA007B"])
    .dataLabelsEnabledSet(false)//是否直接显示扇形图数据
    .titleSet(@"成交项目类别百分比")
    .seriesSet(@[element])
    ;
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

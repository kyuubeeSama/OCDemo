//
//  XPathViewController.m
//  ToolDemo
//
//  Created by liuqingyuan on 2020/5/20.
//  Copyright © 2020 liuqingyuan. All rights reserved.
//  XPath 测试项目，使用第三方库Ono
#import "XPathViewController.h"
#import "TFHpple.h"
@interface XPathViewController ()

@end

@implementation XPathViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = @"xpath";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getData];
}

-(void)getData{
// 获取一段html文字，并从html中读取参数
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://369qyh.com/"]];
    TFHpple * doc       = [[TFHpple alloc] initWithHTMLData:data];
    NSString *xpath = @"//*[@id=\"wrap-nav\"]/ul/li/h3/a";
    NSArray *elements = [doc searchWithXPathQuery:xpath];
    for (TFHppleElement *element in elements) {
        NSLog(@"xpath 结果是 %@",element.text);
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

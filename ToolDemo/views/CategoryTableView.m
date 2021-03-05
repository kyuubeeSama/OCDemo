//
//  CategoryTableView.m
//  ToolDemo
//
//  Created by Galaxy on 2021/2/3.
//  Copyright © 2021 liuqingyuan. All rights reserved.
//

#import "CategoryTableView.h"
@implementation CategoryTableView

-(void)setListArr:(NSArray *)listArr {
    _listArr = listArr;
    [self reloadData];
}

-(instancetype)init{
    self = [super init];
    if (self){
        self.delegate = self;
        self.dataSource  = self;
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self){

    }
    return self;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.textLabel.text = self.listArr[indexPath.row];
    return cell;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (UIView *)listView {
    return self;
}




@end

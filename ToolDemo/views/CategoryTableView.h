//
//  CategoryTableView.h
//  ToolDemo
//
//  Created by Galaxy on 2021/2/3.
//  Copyright © 2021 liuqingyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JXCategoryView/JXCategoryView.h>

NS_ASSUME_NONNULL_BEGIN

@interface CategoryTableView : UITableView<UITableViewDataSource,UITableViewDelegate,JXCategoryListContentViewDelegate>

@property(nonatomic, copy)NSArray *listArr;

@end

NS_ASSUME_NONNULL_END

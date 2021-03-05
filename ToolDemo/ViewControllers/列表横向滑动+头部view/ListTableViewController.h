//
//  ListTableViewController.h
//  ToolDemo
//
//  Created by Galaxy on 2021/2/4.
//  Copyright © 2021 liuqingyuan. All rights reserved.
//

#import <JXCategoryView/JXCategoryView.h>
NS_ASSUME_NONNULL_BEGIN

@interface ListTableViewController : UITableViewController<JXCategoryListContentViewDelegate>

@property(nonatomic, copy)NSArray *listArr;

@end

NS_ASSUME_NONNULL_END

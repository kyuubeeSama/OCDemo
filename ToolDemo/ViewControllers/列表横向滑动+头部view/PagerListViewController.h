//
//  PagerListViewController.h
//  ToolDemo
//
//  Created by Galaxy on 2021/3/2.
//  Copyright © 2021 liuqingyuan. All rights reserved.
//

#import "BaseViewController.h"
#import <JXPagingView/JXPagerView.h>
NS_ASSUME_NONNULL_BEGIN

@interface PagerListViewController : BaseViewController<JXPagerViewListViewDelegate>

@property(nonatomic, copy)NSArray *listArr;

@end

NS_ASSUME_NONNULL_END

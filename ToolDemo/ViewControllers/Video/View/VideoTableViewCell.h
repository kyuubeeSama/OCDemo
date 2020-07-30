//
//  VideoTableViewCell.h
//  ToolDemo
//
//  Created by liuqingyuan on 2020/3/5.
//  Copyright © 2020 liuqingyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoTableViewCell : UITableViewCell

@property (nonatomic, copy)void(^videoBlock)(void);
@property (weak, nonatomic) IBOutlet UIImageView *videoBackView;


@end

NS_ASSUME_NONNULL_END

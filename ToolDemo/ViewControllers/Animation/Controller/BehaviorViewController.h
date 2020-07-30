//
//  BehaviorViewController.h
//  ToolDemo
//
//  Created by liuqingyuan on 2020/4/13.
//  Copyright © 2020 liuqingyuan. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    Grayvity,
    Collision,
    Attachment,
    Push,
    Snap
} Behavior;

@interface BehaviorViewController : BaseViewController

@property (nonatomic, assign)Behavior behavior;

@end

NS_ASSUME_NONNULL_END

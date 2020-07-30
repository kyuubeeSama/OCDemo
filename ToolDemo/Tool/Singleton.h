//
//  Singleton.h
//  ToolDemo
//
//  Created by liuqingyuan on 2018/12/13.
//  Copyright © 2018 liuqingyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Singleton : NSObject

@property(nonatomic,assign)int num;

+ (Singleton *) sharedInstance;
+ (id)copyWithZone:(struct _NSZone *)zone;
+ (id)mutableCopyWithZone:(struct _NSZone *)zone;


@end

NS_ASSUME_NONNULL_END

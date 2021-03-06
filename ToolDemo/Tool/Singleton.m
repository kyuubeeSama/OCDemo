//
//  Singleton.m
//  ToolDemo
//
//  Created by liuqingyuan on 2018/12/13.
//  Copyright © 2018 liuqingyuan. All rights reserved.
//

#import "Singleton.h"

@implementation Singleton

static Singleton * _instance = nil;
static id sharedSingleton = nil;
+ (id)allocWithZone:(struct _NSZone *)zone
{
    if (_instance == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedSingleton = [super allocWithZone:zone];
            });
        }
    return sharedSingleton;
}

- (id)init
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSingleton = [super init];
    });
    return sharedSingleton;
}

+ (instancetype)sharedInstance
{
    return [[self alloc] init];
}

+ (id)copyWithZone:(struct _NSZone *)zone
{
    return sharedSingleton;
}

+ (id)mutableCopyWithZone:(struct _NSZone *)zone
{
    return sharedSingleton;
}

@end

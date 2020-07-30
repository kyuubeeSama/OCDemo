//
//  FileManagerViewController.h
//  quanyihui
//
//  Created by liuqingyuan on 2019/3/28.
//  Copyright © 2019 qyhl. All rights reserved.
//

#import "BaseViewController.h"
#import <Photos/Photos.h>
NS_ASSUME_NONNULL_BEGIN

@interface FileManagerViewController : BaseViewController
// 1.普通文件 2.签约文件
@property(nonatomic,assign)int type;
@property(nonatomic,assign)BOOL isProject;
@property(nonatomic,copy)NSString *project_id;

@end

NS_ASSUME_NONNULL_END

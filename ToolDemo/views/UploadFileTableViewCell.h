//
//  UploadFileTableViewCell.h
//  quanyihui
//
//  Created by liuqingyuan on 2019/3/28.
//  Copyright © 2019 qyhl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UploadFileTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *icoImg;
@property (weak, nonatomic) IBOutlet UILabel *TitleLab;
@property (weak, nonatomic) IBOutlet UILabel *SizeLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (nonatomic,copy) void(^uploadBlock)(int indexpath);

@end

NS_ASSUME_NONNULL_END

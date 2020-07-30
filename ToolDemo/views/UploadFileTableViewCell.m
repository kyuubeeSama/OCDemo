//
//  UploadFileTableViewCell.m
//  quanyihui
//
//  Created by liuqingyuan on 2019/3/28.
//  Copyright © 2019 qyhl. All rights reserved.
//

#import "UploadFileTableViewCell.h"

@implementation UploadFileTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)uploadBtnClick:(UIButton *)sender {
    if (self.uploadBlock) {
        self.uploadBlock((int)self.tag);
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  VideoTableViewCell.m
//  ToolDemo
//
//  Created by liuqingyuan on 2020/3/5.
//  Copyright © 2020 liuqingyuan. All rights reserved.
//

#import "VideoTableViewCell.h"
#import "UIView+WebCache.h"
@implementation VideoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _videoBackView.contentMode = UIViewContentModeScaleAspectFit;
    _videoBackView.backgroundColor = UIColor.clearColor;
    _videoBackView.sd_imageTransition = [SDWebImageTransition fadeTransition];
    _videoBackView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [_videoBackView addGestureRecognizer:tap];
}

- (void)handleTapGesture:(id)sender {
    if (self.videoBlock) {
        self.videoBlock();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

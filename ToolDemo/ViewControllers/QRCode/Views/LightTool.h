//
//  LightTool.h
//  ErWeiMa
//
//  Created by liuqingyuan on 2018/1/7.
//  Copyright © 2018年 liuqingyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <ImageIO/ImageIO.h>
@interface LightTool : NSObject<AVCaptureVideoDataOutputSampleBufferDelegate>
@property(nonatomic,retain)AVCaptureSession * session;//输入输出的中间桥梁

@end

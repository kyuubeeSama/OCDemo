//
//  UIImage+ImageRotate.h
//  ToolDemo
//
//  Created by liuqingyuan on 2020/4/6.
//  Copyright © 2020 liuqingyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface view : UIView

@property(nonatomic,retain)UIImage *image;

@end

@interface UIImage (ImageRotate)

-(UIImage *)imageRotateIndegree:(float)degree;
-(UIImage *)cropImageSize:(CGRect)rect;
-(UIImage *)cropRoundImage;
-(UIImage *)imageScaleSize:(CGSize)size;
-(UIImage *)imageWater:(UIImage *)waterImage waterString:(NSString *)waterString;
 
/**
 * 生成一张带有边框的圆形图片
 *
 * @param borderW   边框宽度
 * @param borderColor 边框颜色
 * @param image    要添加边框的图片
 *
 * @return 生成的带有边框的圆形图片
 */
+ (UIImage *)imageWithBorder:(CGFloat)borderW color:(UIColor *)borderColor image:(UIImage *)image;
 
@end

NS_ASSUME_NONNULL_END

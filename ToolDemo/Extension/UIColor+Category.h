//
//  UIColor+Extension.h
//  knowledgeBase
//
//  Created by 王洪亮 on 16/9/21.
//  Copyright © 2016年 wanghongliang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    leftToRight,
    topToBottom,
} colorDirection;

@interface UIColor (Category)

/**
 *  @brief  随机颜色
 *
 *  @return UIColor
 */
+ (UIColor *)RandomColor;

/**
 *  @brief  渐变颜色
 *
 *  @param c1     开始颜色
 *  @param c2     结束颜色
 *  @param height 渐变高度
 *
 *  @return 渐变颜色
 */
+ (UIColor*)gradientFromColor:(UIColor*)c1 toColor:(UIColor*)c2 withHeight:(int)height;


/// 渐变颜色
/// @param fromColor 开始颜色
/// @param toColor 结束颜色
/// @param direction 颜色渐变发方向
/// @param value 渐变高度或者宽度
+ (UIColor *)gradientFromeColor:(UIColor *)fromColor toColor:(UIColor *)toColor withDirection:(colorDirection)direction withValue:(int)value;
/**
 *  @brief  获取canvas用的颜色字符串
 *
 *  @return canvas颜色
 */
- (NSString *)canvasColorString;
/**
 *  @brief  获取网页颜色字串
 *
 *  @return 网页颜色
 */
- (NSString *)webColorString;

/**
 *  @brief  不同方法设置颜色
 *
 *  @return UIColor
 */

+ (UIColor *)colorWithHex:(UInt32)hex;
+ (UIColor *)colorWithHex:(UInt32)hex andAlpha:(CGFloat)alpha;
+ (UIColor *)colorWithHexString:(NSString *)hexString;
+(UIColor *)colorWithHexString:(NSString *)hexString andAlpha:(CGFloat)alpha;
- (NSString *)HEXString;
+ (UIColor *)colorWithWholeRed:(CGFloat)red
                         green:(CGFloat)green
                          blue:(CGFloat)blue
                         alpha:(CGFloat)alpha;
+ (UIColor *)colorWithWholeRed:(CGFloat)red
                         green:(CGFloat)green
                          blue:(CGFloat)blue;
@end

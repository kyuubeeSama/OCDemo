//
//  Tool.h
//  ouyiku
//
//  Created by Mac on 16/2/29.
//  Copyright © 2016年 Kyuubee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface Tool : NSObject

#define SCREEN_WIDTH [[UIScreen mainScreen]bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen]bounds].size.height
#define SCREEN_TOP (SCREEN_HEIGHT>=812)?44:20
#define SCREEN_BOTTOM (SCREEN_HEIGHT>=812)?-34:0
#define DEVICE_VERSION [UIDevice currentDevice].systemVersion.doubleValue
#define TOP_HEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height+self.navigationController.navigationBar.frame.size.height
// 弱引用
#define WeakSelf(type)  __weak __typeof(type) weak##type = type;//弱引用
#define StrongSelf(type)  __strong __typeof(self) strongself = type;//强引用


#define YWUnlock_WKSELF __weak __typeof(self)weakSelf = self
#define YWUIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define YWUnlock_KW [UIApplication sharedApplication].keyWindow
#define YWUnlock_BD [NSBundle mainBundle]

///获取设备IP
+ (NSString *)getIPAddress:(BOOL)preferIPv4;
//解析时间
+(NSMutableArray *)AnalysisTimeString:(NSString *)timeStr;

// 获取颜色
+(UIColor *)getColorWithValue:(int)value;

// 获取文字高度
+(CGSize)getSizeWithText:(NSString *)text font:(UIFont *)font size:(CGSize)size;

// 文字加横线
+(NSMutableAttributedString *)addLineToLabelWithText:(NSString *)text;

// 手机号正则验证
+(BOOL)validatePhone:(NSString *)phone;

//设置view圆角
+(void)setViewRoundWithView:(UIView *)view value:(CGFloat)num;

// 设置view局部圆角
/*
UIRectCorner有五种
UIRectCornerTopLeft //上左
UIRectCornerTopRight //上右
UIRectCornerBottomLeft // 下左
UIRectCornerBottomRight // 下右
UIRectCornerAllCorners // 全部
*/
+ (void)setPartRoundWithView:(UIView *)view corners:(UIRectCorner)corners cornerRadius:(float)cornerRadius;

//设置view边框大小以及颜色
+(void)setViewBorderLineWithView:(UIView *)view width:(CGFloat)num Color:(UIColor *)color;
//设置view颜色
+(UIColor *)setViewColorWithred:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;
///创建横线
+(UIView *)lineViewWithX:(CGFloat)X Y:(CGFloat)Y Width:(CGFloat)width Height:(CGFloat)height;

//获取Documents文件路径路径
+(NSString *)getDocumentPath;
//获取Library文件夹路径
+(NSString *)getLibraryPath;
//获取tmp文件夹路径
+(NSString *)getTmpPath;

// 判断手机机型
+(BOOL)isIphoneX;
// 打电话发短信
/// 1.电话 2.短信
+(void)callOrSendMessageToPhonenum:(NSString *)phone type:(int)type;
// 压缩图片
+(UIImage *)imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;
// 指定大小压缩图片
+ (NSData *)compressImageQuality:(UIImage *)image toByte:(NSInteger)maxLength;

// 是否存在闪光灯
+(BOOL)isLightExist;
// 打开闪光灯
+(void)openLight;
// 关闭闪光灯
+(void)closeLight;

@end

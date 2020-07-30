//
//  Tool.m
//  ouyiku
//
//  Created by Mac on 16/2/29.
//  Copyright © 2016年 Kyuubee. All rights reserved.
//

#import "Tool.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <net/if.h>

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_VPN         @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

@implementation Tool

#pragma mark - 获取设备当前网络IP地址
+ (NSString *)getIPAddress:(BOOL)preferIPv4
{
    NSArray *searchArray = preferIPv4 ?
    @[ IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = [self getIPAddresses];
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         address = addresses[key];
         //筛选出IP地址格式
         if([self isValidatIP:address]) *stop = YES;
     } ];
    return address ? address : @"0.0.0.0";
}

+ (BOOL)isValidatIP:(NSString *)ipAddress {
    if (ipAddress.length == 0) {
        return NO;
    }
    NSString *urlRegEx = @"^([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])$";
    
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:urlRegEx options:0 error:&error];
    if (regex != nil) {
        NSTextCheckingResult *firstMatch=[regex firstMatchInString:ipAddress options:0 range:NSMakeRange(0, [ipAddress length])];
        if (firstMatch) {
            NSRange resultRange = [firstMatch rangeAtIndex:0];
            NSString *result=[ipAddress substringWithRange:resultRange];
            //输出结果
            NSLog(@"%@",result);

            return YES;
        }
    }
    return NO;
}

+ (void)setPartRoundWithView:(UIView *)view corners:(UIRectCorner)corners cornerRadius:(float)cornerRadius {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(cornerRadius, cornerRadius)].CGPath;
    view.layer.mask = shapeLayer;
}


+ (NSDictionary *)getIPAddresses
{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}

+(NSMutableArray *)AnalysisTimeString:(NSString *)timeStr
{
    NSMutableArray *timeArr=[[NSMutableArray alloc]init];
    NSString *endTime=timeStr;
    NSArray *array=[endTime componentsSeparatedByString:@" "];
    NSString *dateStr=array[0];
    NSString *hourStr=array[1];
    NSArray *arrayOne=[dateStr componentsSeparatedByString:@"-"];
    NSArray *arrayTwo=[hourStr componentsSeparatedByString:@":"];
    [timeArr addObjectsFromArray:arrayOne];
    [timeArr addObjectsFromArray:arrayTwo];
    return timeArr;
}

+(UIColor *)getColorWithValue:(int)value
{
    return [UIColor colorWithRed:((float)((value & 0xFF0000) >> 16))/255.0 green:((float)((value & 0xFF00) >> 8))/255.0 blue:((float)(value & 0xFF))/255.0 alpha:1.0];
}

+(CGSize)getSizeWithText:(NSString *)text font:(UIFont *)font size:(CGSize)size
{
    return [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil].size;
}

+(NSMutableAttributedString *)addLineToLabelWithText:(NSString *)text
{
    NSMutableAttributedString *attr=[[NSMutableAttributedString alloc]initWithString:text];
    [attr addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, text.length)];
    return attr;
}

//电话号码正则表达式
+ (BOOL)validatePhone:(NSString *)phone
{
    if (phone.length < 11) {
        return NO;
    }
    else
    {
        /**
         * 手机号码:
         * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[6, 7, 8], 18[0-9], 170[0-9]
         * 移动号段: 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
         * 联通号段: 130,131,132,155,156,185,186,145,176,1709
         * 电信号段: 133,153,180,181,189,177,1700
         */
        NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[0678])\\d{8}$";
        /**
         * 中国移动：China Mobile
         * 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
         */
        NSString *CM = @"(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)";
        /**
         * 中国联通：China Unicom
         * 130,131,132,155,156,185,186,145,176,1709
         */
        NSString *CU = @"(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)";
        /**
         * 中国电信：China Telecom
         * 133,153,180,181,189,177,1700
         */
        NSString *CT = @"(^1(33|53|77|8[019])\\d{8}$)|(^1700\\d{7}$)";
        /**
         25     * 大陆地区固话及小灵通
         26     * 区号：010,020,021,022,023,024,025,027,028,029
         27     * 号码：七位或八位
         28     */
//        NSString * PHS = @"^(0[0-9]{2})\\d{8}$|^(0[0-9]{3}(\\d{7,8}))$";
        
        NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
        NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
        NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
        NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
        
        if (([regextestmobile evaluateWithObject:phone])
            || ([regextestcm evaluateWithObject:phone])
            || ([regextestct evaluateWithObject:phone])
            || ([regextestcu evaluateWithObject:phone]))
        {
            if([regextestcm evaluateWithObject:phone]) {
                // NSLog(@"China Mobile");
            } else if([regextestct evaluateWithObject:phone]) {
                // NSLog(@"China Telecom");
            } else if ([regextestcu evaluateWithObject:phone]) {
                // NSLog(@"China Unicom");
            } else {
                // NSLog(@"Unknow");
            }
            
            return YES;
        }
        else
        {
            return NO;
        }
    }
}

+(void)setViewRoundWithView:(UIView *)view value:(CGFloat)num
{
    [view.layer setMasksToBounds:YES];
    [view.layer setCornerRadius:num];
}

+(void)setViewRoundWithView:(UIView *)view withValue:(CGFloat)num withDirection:(NSString *)direction
{
    UIBezierPath *fieldPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(5 , 5)];
    CAShapeLayer *fieldLayer = [[CAShapeLayer alloc] init];
    fieldLayer.frame = view.bounds;
    fieldLayer.path = fieldPath.CGPath;
    view.layer.mask = fieldLayer;
}

+(void)setViewBorderLineWithView:(UIView *)view width:(CGFloat)num Color:(UIColor *)color
{
    view.layer.borderWidth=num;
    view.layer.borderColor=[color CGColor];
}

+(UIColor *)setViewColorWithred:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:red/255.f green:green/255.f blue:blue/255.f alpha:alpha];
}

//创建横线
+(UIView *)lineViewWithX:(CGFloat)X Y:(CGFloat)Y Width:(CGFloat)width Height:(CGFloat)height
{
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(X, Y, width, height)];
    lineView.backgroundColor=[UIColor colorWithRed:230/255.f green:230/255.f blue:230/255.f alpha:1];
    return lineView;
}

//获取document路径
+(NSString *)getDocumentPath
{
    NSString *documentPath=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    return documentPath;
}
//获取Library路径
+(NSString *)getLibraryPath
{
    NSString *libraryPath=NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0];
    return libraryPath;
}
//获取tmp路径
+(NSString *)getTmpPath
{
    NSString *tmpPath=NSTemporaryDirectory();
    return tmpPath;
}

//获取沙盒录路径
+(NSString *)getPath
{
    NSString *documentpath=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *filepath=[documentpath stringByAppendingPathComponent:@"database.db"];
    return filepath;
}

+(BOOL)isIphoneX
{
    if (SCREEN_HEIGHT>=812) {
        return YES;
    }
    else
    {
        return NO;
    }
}

+(void)callOrSendMessageToPhonenum:(NSString *)phone type:(int)type
{
    NSString *str =@"";
    if (type == 1) {
        str =[NSString stringWithFormat:@"tel:%@",phone];
    }
    else
    {
        str = [NSString stringWithFormat:@"sms:%@",phone];
    }
    int vasion = [[UIDevice currentDevice].systemVersion intValue];
    if (vasion <= 8) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:str]];
    }
    else
    {
        NSDictionary *dic=@{};
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:str] options:dic completionHandler:^(BOOL success) {
            
        }];
    }
}

+(UIImage *)imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth
{
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = (targetWidth / width) * height;
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [sourceImage drawInRect:CGRectMake(0,0,targetWidth,  targetHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (NSData *)compressImageQuality:(UIImage *)image toByte:(NSInteger)maxLength {
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength) return data;
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    return data;
}

+(BOOL)isLightExist
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    BOOL result = [device hasTorch];// 判断设备是否有闪光灯
    return result;
}

+(void)openLight{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [device lockForConfiguration:nil];
    [device setTorchMode: AVCaptureTorchModeOn];//开
    [device unlockForConfiguration];
}

+(void)closeLight{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [device lockForConfiguration:nil];
    [device setTorchMode: AVCaptureTorchModeOff];//关
    [device unlockForConfiguration];
}

@end

//
//  RequestData.h
//  ouyiku
//
//  Created by Mac on 16/1/3.
//  Copyright © 2016年 Kyuubee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"

@interface uploadFileModel : NSObject

/// 文件名称
@property(nonatomic,strong)NSString *fileName;
/// 文件路径
@property(nonatomic,strong)NSString *filePath;
/// 数据流
@property(nonatomic,strong)NSData *fileData;
/// 文件类型
@property(nonatomic,copy)NSString *fileMimeType;

@end

//**网络请求状态*/
typedef NS_ENUM(NSUInteger, MethodType) {
    /**get*/
        AFNetworkMethodGet,
    /**post*/
        AFNetworkMethodPost
};

typedef enum : NSUInteger {
    FilePath,
    FileData
} uploadFileType;

//**网络状态*/
typedef NS_ENUM(NSUInteger, AFNetworkStatusType) {
    /**未知网络*/
        AFNetworkStatusUnknown,
    /**无网路*/
        AFNetworkStatusNotReachable,
    /**手机网络*/
        AFNetworkstatusReachableWWAN,
    /**WiFi网络*/
        AFNetworkStatusReachableWiFi
};

typedef void(^NetworkStatus)(AFNetworkStatusType status);

@interface RequestData : NSObject

+ (void)networkStatusWithBlock:(NetworkStatus)networkStatus;

// 请求数据
+ (void)requestDataWithMethod:(MethodType)method WithUrl:(NSString *)urlStr withData:(NSDictionary *)dic success:(void (^)(NSDictionary *dic))success failure:(void (^)(NSError *error))failure;

// 获取用户sessionid
+ (void)requestSessionWithMethod:(MethodType)method WithUrl:(NSString *)urlStr withData:(NSDictionary *)dic success:(void (^)(NSDictionary *dic))success faileure:(void (^)(NSError *error))failure;

// 下载文件
+(void)downloadingFileWithUrl:(NSString *)urlStr savePath:(NSString *)savePath downloadProgress:(void(^)(NSProgress *progress))progress success:(void(^)(void))success failure:(void(^)(NSError *error))failure;

// 上传整合为单个方法
+ (void)uploadFileWithUrl:(NSString *)urlStr DataDic:(NSDictionary *)parameter fileType:(uploadFileType)fileType File:(NSArray *)fileDataArr progress:(void(^)(NSProgress *progress))progress success:(void(^)(NSDictionary *dic))success failure:(void(^)(NSError *error))failure;

@end

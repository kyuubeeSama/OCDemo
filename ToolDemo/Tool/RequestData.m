//
//  RequestData.m
//  ouyiku
//
//  Created by Mac on 16/1/3.
//  Copyright © 2016年 Kyuubee. All rights reserved.
//

#import "RequestData.h"
#import "BaseViewController.h"
#define BaseUrl @"http://app.369qyh.com/"
#define webFileUrl @"http://www.369qyh.com/files/"

@implementation RequestData

+ (AFHTTPSessionManager *)makeBaseManager {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setTimeoutInterval:40.0f];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/css", @"text/xml", @"text/plain", @"application/javascript", @"application/x-www-form-urlencoded", @"image/*", nil];
    return manager;
}

+ (void)networkStatusWithBlock:(NetworkStatus)networkStatus {
    // 1.获得网络监控的管理者
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    // 2.设置网络状态改变后的处理
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变了, 就会调用这个block
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                networkStatus(AFNetworkStatusUnknown);
                break;
                
            case AFNetworkReachabilityStatusNotReachable:
                networkStatus(AFNetworkStatusNotReachable);
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                networkStatus(AFNetworkstatusReachableWWAN);
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
                networkStatus(AFNetworkStatusReachableWiFi);
                break;
        }
    }];
    // 3.开始监控
    [mgr startMonitoring];
}

#pragma mark 获取网络请求
+ (void)requestDataWithMethod:(MethodType)method WithUrl:(NSString *)urlStr withData:(NSDictionary *)dic success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure {
    AFHTTPSessionManager *manager = [self makeBaseManager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    if ([dic[@"Connection"] isEqualToString:@"keep-alive"]) {
        //        manager.requestSerializer = [AFJSONRequestSerializer serializer];//将token封装入请求头
        [manager.requestSerializer setValue:@"keep-alive" forHTTPHeaderField:@"Connection"];
    }
    NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"cookie"]];
    if (cookies.count > 0) {
        NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (NSHTTPCookie *cookie in cookies) {
            [cookieStorage setCookie:cookie];
            //            NSLog(@"读取的cookie%@",cookie);
        }
    } else {
        NSArray *cookiesArray = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
        for (NSHTTPCookie *cookie in cookiesArray) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        }
    }
    urlStr = [NSString stringWithFormat:@"%@%@", BaseUrl, urlStr];
    NSLog(@"%@", urlStr);
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSDictionary *parameters = dic;
    if (method == AFNetworkMethodGet) {
        [manager GET:urlStr parameters:parameters headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *dataStr=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"%@",dataStr);
            responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"%@", responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(error);
        }];
    } else if (method == AFNetworkMethodPost) {
        [manager POST:urlStr parameters:parameters headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //                    NSString *dataStr=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
            //                    NSLog(@"%@",dataStr);
            responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"%@", responseObject);
            success(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(error);
            NSInteger codeint = error.code;
            NSLog(@"%ld",(long)codeint);
            NSLog(@"错误信息是%@",error);
            if (codeint == (-1001)) {
                NSLog(@"链接超时");
                failure(error);
            }else if(codeint == (-1004)){
                NSLog(@"未能连接到服务器");
            } else {
                failure(error);
            }
            
            //            if (codeint == (-999)) {
            //                DLog(@"网络状态输出====>>> 网络请求已取消")
            //            }
            //            else if(codeint == (-1001)){
            //                DLog(@"网络状态输出====>>> 网络请求超时");
            //            }
            //            else {
            //                [XPToast showWithText:@"网络请求失败"];
            //            }
            //
            //            //错误的值域(NSURLErrorDomain)
            //            NSLog(@"%@",error.domain);
            //            //错误信息
            //            NSLog(@"%@",error.description)
            //            //错误状态的本地化描述
            //            NSLog(@"%@", [error localizedDescription])
        }];
    }
}

+ (void)requestSessionWithMethod:(MethodType)method WithUrl:(NSString *)urlStr withData:(NSDictionary *)dic success:(void (^)(NSDictionary *dic))success faileure:(void (^)(NSError *error))failure {
    AFHTTPSessionManager *manager = [self makeBaseManager];
    urlStr = [NSString stringWithFormat:@"%@%@", BaseUrl, urlStr];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSDictionary *parameters = dic;
    if (method == AFNetworkMethodGet) {
        [manager GET:urlStr parameters:parameters headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //            NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"cookie"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            //            for(NSHTTPCookie *cookie in [cookieJar cookies]){
            //                NSLog(@"保存的%@", cookie);
            //            }
            success(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(error);
        }];
    } else if (method == AFNetworkMethodPost) {
        [manager POST:urlStr parameters:parameters headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //            NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"cookie"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            //            for(NSHTTPCookie *cookie in [cookieJar cookies]) {
            //                NSLog(@"保存的%@", cookie);
            //            }
            success(responseObject);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSInteger codeint = error.code;
            if (codeint == (-1001)) {
                NSLog(@"链接超时");
            }else if(codeint == (-1004)){
                NSLog(@"未能连接到服务器");
            }else if(codeint == (-1011)){
                NSLog(@"数据错误");
                failure(error);
            }else {
                failure(error);
            }
        }];
    }
}

// 文件下载
+(void)downloadingFileWithUrl:(NSString *)urlStr savePath:(NSString *)savePath downloadProgress:(void (^)(NSProgress *))progress success:(void (^)(void))success failure:(void (^)(NSError *))failure{
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    /* 下载地址 */
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    /* 开始请求下载 */
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress *downloadProgress) {
        progress(downloadProgress);
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        return [NSURL fileURLWithPath:savePath];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        if (!error) {
            success();
        }else{
            failure(error);
        }
    }];
    [downloadTask resume];
}

// 文件上传
+(void)uploadFileWithUrl:(NSString *)urlStr DataDic:(NSDictionary *)parameter fileType:(uploadFileType)fileType File:(NSArray *)fileDataArr progress:(void (^)(NSProgress *))progress success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure{
    AFHTTPSessionManager *manager = [self makeBaseManager];
    urlStr = [NSString stringWithFormat:@"%@%@", BaseUrl, urlStr];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [manager POST:urlStr parameters:parameter headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (fileType == FilePath) {
            for (uploadFileModel *model in fileDataArr) {
                model.filePath = [model.filePath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                NSURL *fileUrl = [NSURL URLWithString:model.filePath];
                [formData appendPartWithFileURL:fileUrl name:model.fileName fileName:model.fileName mimeType:model.fileMimeType error:nil];
            }
        }else if(fileType == FileData){
            for (uploadFileModel *model in fileDataArr) {
                [formData appendPartWithFileData:model.fileData name:model.fileName fileName:model.fileName mimeType:model.fileMimeType];
            }
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        progress(uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

@end

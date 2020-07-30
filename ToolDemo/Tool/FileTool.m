//
//  FileTool.m
//  myimage
//
//  Created by liuqingyuan on 2018-12-18.
//  Copyright © 2018 liuqingyuan. All rights reserved.
//

#import "FileTool.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
@implementation QYFileModel

-(void)getImageAndInfoComplete:(void (^)(void))complete{
    // 获取图片和图片信息
    [[PHImageManager defaultManager] requestImageDataForAsset:_set options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        NSURL *url = [info valueForKey:@"PHImageFileURLKey"];
        self->_fileurl = [url absoluteString];
        NSInteger sizelength = imageData.length;
        NSString *fileSize;
        if (sizelength > 1024 && sizelength < (1024 * 1024)) {
            fileSize = [NSString stringWithFormat:@"%.2fK", (float) sizelength / 1024];
        } else if (sizelength < 1024) {
            fileSize = [NSString stringWithFormat:@"%luB", (unsigned long) sizelength];
        } else if (sizelength > (1024 * 1024) && sizelength < (1024 * 1024 * 1024)) {
            fileSize = [NSString stringWithFormat:@"%.2fM", (float) sizelength / (1024 * 1024)];
        } else {
            fileSize = [NSString stringWithFormat:@"%.2fG", (float) sizelength / (1024 * 1024 * 1024)];
        }
        self->_size = fileSize;
        UIImage *image = [UIImage imageWithData:imageData];
        //                    获取缩略图
        self->_image = [self thumbnailWithImageWithoutScale:image size:CGSizeMake(100, image.size.height * 100 / image.size.width)];
        if (complete) {
            complete();
        }
    }];
}

// 获取指定大小的缩略图
- (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize {
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    } else {
        CGSize oldsize = image.size;
        CGRect rect;
        if (asize.width / asize.height > oldsize.width / oldsize.height) {
            rect.size.width = asize.height * oldsize.width / oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width) / 2;
            rect.origin.y = 0;
        } else {
            rect.size.width = asize.width;
            rect.size.height = asize.width * oldsize.height / oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height) / 2;
        }
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}

@end

@implementation FileTool
// 获取document地址
+ (NSString *)getDocumentPath {
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    return documentPath;
}

+ (NSString *)createFilePathWithName:(NSString *)name {
    NSString *path = [[self getDocumentPath] stringByAppendingPathComponent:name];
    return path;
}

// 创建文件并返回地址
+ (NSString *)createDocumentWithname:(NSString *)name {
    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:name];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = FALSE;
    BOOL isDirExist = [fileManager fileExistsAtPath:path isDirectory:&isDir];
    if (!(isDirExist && isDir)) {
        BOOL bCreateDir = [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        if (!bCreateDir) {
            return nil;
        }
        return path;
    } else {
        return path;
    }
}

// 创建文件,返回创建成功与否
+ (BOOL)createFileWithPath:(NSString *)path WithData:(NSData *)data {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]){
        if ([fileManager createFileAtPath:path contents:data attributes:nil]) {
            NSLog(@"文件创建成功");
            return YES;
        }else{
            return NO;
        }
    } else{
        return YES;
    }
    return nil;
}

// 删除指定位置文件
+ (BOOL)deleteDataWithPath:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager removeItemAtPath:path error:nil];
}

// 遍历获取本地文件
+ (NSMutableDictionary *)localFile {
    NSString *path = [self getDocumentPath];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSDirectoryEnumerator *dirEnum = [fm enumeratorAtPath:path];
    NSString *fileName;
    NSMutableDictionary *R = [NSMutableDictionary dictionary];
    while (fileName = [dirEnum nextObject]) {
        NSString *key = [fileName componentsSeparatedByString:@"/"].lastObject;
        [R setObject:fileName forKey:key];
    }
    return R;
}

// 判断是否有相册读取权限，加载图片
- (void)loadImageWithNum:(int)num {
    self.imageArr = [[NSMutableArray alloc] init];
    self.assets = [[NSMutableArray alloc] init];
    BOOL ischoose = YES;
    __weak __typeof(self) weakself = self;
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized) {
            //code
            if (weakself.assets.count == 0 && ischoose) {
                [self getImgWithNum:num];
            }
        }else if(status == PHAuthorizationStatusDenied){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"imageStatusDenied" object:nil userInfo:nil];
        }
    }];
}

// 获取相册所有图片
- (void)getImgWithNum:(int)num {
    self.assets = [self getAllAssetInPhotoAblumWithAscending:NO];
    if (_assets.count > 0) {
        for (PHAsset *set in self.assets) {
            //        }
            //        for(int i=num; i<;i++){
            //            PHAsset *set = _assets[(NSUInteger)i];
            PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
            options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
            // 获取文件名
            NSArray *nameArr = [[set valueForKey:@"filename"] componentsSeparatedByString:@"."];
            if ([nameArr[1] isEqualToString:@"jpg"] || [nameArr[1] isEqualToString:@"png"] || [nameArr[1] isEqualToString:@"jpeg"] || [nameArr[1] isEqualToString:@"JPG"] || [nameArr[1] isEqualToString:@"PNG"] || [nameArr[1] isEqualToString:@"JPEG"] || [nameArr[1] isEqualToString:@"HEIC"] || [nameArr[1] isEqualToString:@"heic"]) {
                QYFileModel *model = [[QYFileModel alloc] init];
                model.has_upload = NO;
                // 创建时间
                NSDate *pictureDate = [set creationDate];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                formatter.timeZone = [NSTimeZone localTimeZone];//要换成本地的时区，才能获得正确的时间
                NSString *pictureTime = [formatter stringFromDate:pictureDate];
                model.time = pictureTime;
                //文件名
                model.filename = [set valueForKey:@"filename"];
                model.name = nameArr[0];
                //        图片url
                model.set = set;
                model.filetype = @"image/png/jpg/jpeg/gif";
                [self.imageArr addObject:model];
            }
        }
        if (self.getImageFinishBlock) {
            self.getImageFinishBlock(self.imageArr);
        }
        if (_assets.count!=num) {
            int allnum = num+1000;
            if (_assets.count<=allnum) {
                allnum = (int)_assets.count;
            }
            
        }else{
            if (self.getImageFinishBlock) {
                self.getImageFinishBlock(self.imageArr);
            }
        }
    } else {
        NSLog(@"相册数据为空");
        if (self.getImageFinishBlock) {
            self.getImageFinishBlock(self.imageArr);
        }
    }
}

// 获取指定大小的缩略图
- (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize {
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    } else {
        CGSize oldsize = image.size;
        CGRect rect;
        if (asize.width / asize.height > oldsize.width / oldsize.height) {
            rect.size.width = asize.height * oldsize.width / oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width) / 2;
            rect.origin.y = 0;
        } else {
            rect.size.width = asize.width;
            rect.size.height = asize.width * oldsize.height / oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height) / 2;
        }
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}

#pragma mark - 获取相册内所有照片资源
- (NSMutableArray<PHAsset *> *)getAllAssetInPhotoAblumWithAscending:(BOOL)ascending {
    NSMutableArray<PHAsset *> *assets = [NSMutableArray array];
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    //ascending 为YES时，按照照片的创建时间升序排列;为NO时，则降序排列
    NSLog(@"开始任务");
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:ascending]];
    PHFetchResult *result = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:option];
    [result enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        PHAsset *asset = (PHAsset *) obj;
        [assets addObject:asset];
    }];
    NSLog(@"获取全部图片");
    return assets;
}

// 获取对应文件类型的文件
- (NSMutableArray *)GetDocumentsFilesWithType:(QYFileType)QYFileType WithNum:(int)num{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if (QYFileType == QYFileTypeImage) {
        [self loadImageWithNum:num];
    } else {
        NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSDirectoryEnumerator *dirEnum = [fileManager enumeratorAtPath:path];
        NSString *fileName;
        while (fileName = [dirEnum nextObject]) {
            QYFileModel *model = [[QYFileModel alloc] init];
            switch (QYFileType) {
                case QYFileTypeLocalImage: {
                    // 图片
                    if ([fileName hasSuffix:@".png"] || [fileName hasSuffix:@".jpg"] || [fileName hasSuffix:@".jpeg"] || [fileName hasSuffix:@".bmp"] || [fileName hasSuffix:@".gif"] || [fileName hasSuffix:@".PNG"] || [fileName hasSuffix:@".JPG"] || [fileName hasSuffix:@".JPEG"] || [fileName hasSuffix:@".BMP"] || [fileName hasSuffix:@".GIF"] || [fileName isEqualToString:@"HEIC"] || [fileName isEqualToString:@"heic"]) {
                        model.filetype = @"image/png/jpg/jpeg/gif";
                    } else {
                        continue;
                    }
                }
                    break;
                case QYFileTypeWord: {
                    // word 文档
                    if ([fileName hasSuffix:@".doc"] || [fileName hasSuffix:@".docx"]) {
                        model.filetype = @"application/msword/vnd.openxmlformats-officedocument.wordprocessingml.document";
                    } else {
                        continue;
                    }
                }
                    break;
                case QYFileTypeExcel: {
                    // excel 文件
                    if ([fileName hasSuffix:@".xls"] || [fileName hasSuffix:@".xlsx"]) {
                        model.filetype = @"application/vnd.ms-excel/x-excel/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                    } else {
                        continue;
                    }
                }
                    break;
                case QYFileTypePPT: {
                    //                ppt文件
                    if ([fileName hasSuffix:@".ppt"] || [fileName hasSuffix:@".pptx"]) {
                        model.filetype = @"application/vnd.ms-powerpoint/vnd.openxmlformats-officedocument.presentationml.presentation";
                    } else {
                        continue;
                    }
                }
                    break;
                case QYFileTypePDF: {
                    //                pdf文件
                    if ([fileName hasSuffix:@".pdf"]) {
                        model.filetype = @"application/pdf";
                    } else {
                        continue;
                    }
                }
                    break;
                case QYFileTypeImage: {
                    
                    break;
                }
                case QYFileTypeAll: {
                    
                    break;
                }
            }
            NSDictionary *fileInfo = [dirEnum fileAttributes];
            //            NSLog(@"%@",fileInfo);
            NSArray *pathArr = [fileName componentsSeparatedByString:@"/"];
            model.filename = [pathArr lastObject];
            NSArray *nameArr = [fileName componentsSeparatedByString:@"."];
            model.name = nameArr[0];
            NSString *time = [NSString stringWithFormat:@"%@", fileInfo[@"NSFileModificationDate"]];
            model.time = [time substringToIndex:19];
            NSInteger sizelength = [[NSString stringWithFormat:@"%@", fileInfo[@"NSFileSize"]] integerValue];
            NSString *fileSize;
            if (sizelength > 1024) {
                fileSize = [NSString stringWithFormat:@"%.0luK", sizelength / 1024];
            } else if (sizelength < 1024) {
                fileSize = [NSString stringWithFormat:@"%luB", (unsigned long) sizelength];
            } else if (sizelength > (1024 * 1024)) {
                fileSize = [NSString stringWithFormat:@"%.0luM", sizelength / (1024 * 2014)];
            } else {
                fileSize = [NSString stringWithFormat:@"%.0luG", sizelength / (1024 * 1024 * 1024)];
            }
            model.size = fileSize;
            model.filePath = [path stringByAppendingPathComponent:fileName];
            [array addObject:model];
        }
    }
    return array;
}

// 判断文件是否存在
+ (BOOL)fileIsExistWithFileName:(NSString *)fileName {
    NSString *documentPath = [self getDocumentPath];
    NSString *filePath = [documentPath stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        return YES;
    } else {
        return NO;
    }
}

// 根据路径判断文件是否存在
+ (BOOL)fileIsExistWithFilePath:(NSString *)filePath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        return YES;
    } else {
        return NO;
    }
}

@end

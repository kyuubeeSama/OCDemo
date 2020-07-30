//
//  FileTool.h
//  myimage
//
//  Created by liuqingyuan on 2018-12-18.
//  Copyright © 2018 liuqingyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface QYFileModel : NSObject

@property(nonatomic, copy) NSString *filename;
@property(nonatomic, copy) NSString *size;
@property(nonatomic, copy) NSString *time;
@property(nonatomic, copy) NSString *filePath;
@property(nonatomic, strong) UIImage *image;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *filetype;
@property(nonatomic, copy) NSString *fileurl;
@property(nonatomic, strong) PHAsset *set;
@property (nonatomic, assign) BOOL has_upload;
-(void)getImageAndInfoComplete:(void(^)(void))complete;


@end

//**网络状态*/
typedef NS_ENUM(NSUInteger, QYFileType) {
    /**word*/
        QYFileTypeWord,
    /**excel*/
        QYFileTypeExcel,
    /*pdf*/
        QYFileTypePDF,
    /*PPT*/
        QYFileTypePPT,
    /*image*/
        QYFileTypeImage,
    /*全部类型*/
        QYFileTypeAll,
    QYFileTypeLocalImage
};

@interface FileTool : NSObject

@property(nonatomic, copy) void (^getImageBlock)(NSMutableArray *array);
@property(nonatomic, copy) void (^getImageFinishBlock)(NSMutableArray *array);
@property (nonatomic, copy) void (^imageDenide)(void);
@property(nonatomic, strong) NSMutableArray <PHAsset *> *assets;
@property(nonatomic, strong) NSMutableArray *imageArr;

+ (NSString *)getDocumentPath;

+ (NSString *)createFilePathWithName:(NSString *)name;

+ (NSString *)createDocumentWithname:(NSString *)name;

+ (BOOL)createFileWithPath:(NSString *)path WithData:(NSData *)data;

+ (BOOL)deleteDataWithPath:(NSString *)path;

+ (NSMutableDictionary *)localFile;

- (NSMutableArray *)GetDocumentsFilesWithType:(QYFileType)QYFileType WithNum:(int)num;

+ (BOOL)fileIsExistWithFileName:(NSString *)fileName;

+ (BOOL)fileIsExistWithFilePath:(NSString *)filePath;

- (void)loadImageWithNum:(int)num;

@end

NS_ASSUME_NONNULL_END

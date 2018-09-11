//
//  WLOSSUploadFileTool.h
//  Welian
//
//  Created by weLian on 16/8/3.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AliyunOSSiOS/OSSService.h>
#import <AliyunOSSiOS/OSSCompat.h>

/**
 *  阿里云上传文件
 */
@interface WLOSSUploadFileTool : NSObject
    
+ (instancetype)sharedInstance;

/**
 *  取消文件上传
 */
- (void)cancelUploadFile;

- (void)uploadData:(NSData *)data
          dataName:(NSString *)dataName
           Success:(SuccessBlock)success
            Failed:(FailedBlock)failed;

/**
 *  分片上传文件到服务器
 *
 *  @param filePath 文件路径
 *  @param pid      对应的项目id
 *  @param success  成功（对应的文件名称）
 *  @param failed   失败
 */
- (void)uploadFileInfoOSService:(NSString *)filePath
                            pid:(NSNumber *)pid
                 updateProgress:(WLUploadProgressBlock)updateProgress
                        Success:(SuccessBlock)success
                         Failed:(FailedBlock)failed;

/**
 *  下载阿里云服务器上的文件到本地
 *
 *  @param filePath 文件路径
 *  @param toFolder 下载到本地的文件路径
 *  @param success  成功（对应的文件名称）
 *  @param failed   失败
 */
- (void)downLoadFileFromOSServiceWithFilePath:(NSString *)filePath
                                     ToFolder:(NSString *)toFolder
                                      Success:(SuccessBlock)success
                                       Failed:(FailedBlock)failed;

/**
 *  阿里云上传图片
 *
 *  @param imagePathArray 图片沙盒路径数组
 *  @param success        成功回调 （把路径返回）
 *  @param failed         失败
 */
- (void)uploadImagesTOOSSService:(NSArray *)imagePathArray
                         Success:(SuccessBlock)success
                          Failed:(FailedBlock)failed;

///阿里云上传单张图片
- (void)uploadImageToOSSService:(UIImage *)image
                        Success:(SuccessBlock)success
                         Failed:(FailedBlock)failed;



@end

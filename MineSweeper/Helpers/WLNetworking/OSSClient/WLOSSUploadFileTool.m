//
//  WLOSSUploadFileTool.m
//  Welian
//
//  Created by weLian on 16/8/3.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import "WLOSSUploadFileTool.h"

#import "WLNetworkingConfiguration.h"
#import "WLNetworkPrivate.h"

@interface WLOSSUploadFileTool ()

@property (nonatomic, strong) OSSClient *ossClient;
@property (nonatomic, strong) OSSResumableUploadRequest *resumableUpload;

@end

@implementation WLOSSUploadFileTool

+ (instancetype)sharedInstance
{
    static WLOSSUploadFileTool *_uploadImage = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _uploadImage = [[WLOSSUploadFileTool alloc] init];
    });
    return _uploadImage;
}

/**
 *  取消文件上传
 */
- (void)cancelUploadFile
{
    if (!self.resumableUpload.isCancelled) {
        //取消上传
        [self.resumableUpload cancel];
    }
}

- (void)uploadData:(NSData *)data
          dataName:(NSString *)dataName
           Success:(SuccessBlock)success
            Failed:(FailedBlock)failed {
    
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    put.bucketName = [WLServiceInfo sharedServiceInfo].ossFileBucket;
    put.objectKey = dataName;
//    put.objectKey = [NSString stringWithFormat:@"voice/%@",dataName];
    put.uploadingData = data;
    put.contentType = dataName.pathExtension;
    
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        DLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
    };
    
    OSSTask * putTask = [self.ossClient putObject:put];
    [putTask continueWithBlock:^id(OSSTask *task) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!task.error) {
                SAFE_BLOCK_CALL(success, dataName);
                DLog(@"Upload success!");
            } else {
                SAFE_BLOCK_CALL(failed, task.error);
                DLog(@"上传失败-------\n上传失败-------\n上传失败-------\n上传失败-------\n, error: %@" , putTask.error);
            }
        });
        return nil;
    }];
}

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
                         Failed:(FailedBlock)failed
{
    __block NSString * uploadId = nil;
    NSString *servername = @"";
    //上次未上传的项目
    NSString *upKey = [NSString stringWithFormat:@"Last_Upload_BPFile_%@_%@",filePath,(pid ? : @"")];
    NSDictionary *lastLocalUpdateDict = [NSUserDefaults objectForKey:upKey];
    if (lastLocalUpdateDict) {
        //上次未上传完成的
        uploadId = lastLocalUpdateDict[@"uploadId"];
        servername = lastLocalUpdateDict[@"servername"];
    }
    if (uploadId.length == 0 && servername.length == 0) {
        //第一次上传的文件
        //上传的文件名称
        servername = [NSString stringWithFormat:@"%@%@o.%@",[NSString wl_randomString:4],[NSString wl_timeStamp],@"pdf"];
        DLog(@"servername ----- >%@",servername);
        OSSInitMultipartUploadRequest * init = [OSSInitMultipartUploadRequest new];
        init.bucketName = [WLServiceInfo sharedServiceInfo].ossFileBucket;
        init.objectKey = servername;//本地自己生成的文件名称规则
        
        // 以下可选字段的含义参考：https://docs.aliyun.com/#/pub/oss/api-reference/multipart-upload&InitiateMultipartUpload
        // append.contentType = @"";
        // append.contentMd5 = @"";
        // append.contentEncoding = @"";//指定该Object被下载时的内容编码格式；
        // append.contentDisposition = @"";//指定该Object被下载时的名称
        // init.objectMeta = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"value1", @"x-oss-meta-name1", nil];
        
        
        // 先获取到用来标识整个上传事件的UploadId
        OSSTask * task = [self.ossClient multipartUploadInit:init];
        [[task continueWithBlock:^id(OSSTask *task) {
            if (!task.error) {
                OSSInitMultipartUploadResult * result = task.result;
                uploadId = result.uploadId;
                //保存
                [NSUserDefaults setObject:@{@"uploadId":uploadId,@"servername":servername} forKey:upKey];
            } else {
                SAFE_BLOCK_CALL(failed, task.error);
                DLog(@"init uploadid failed, error: %@", task.error);
            }
            return nil;
        }] waitUntilFinished];
    }
    //判断是否被取消上传，取消的，设置为不在取消
    if (self.resumableUpload.isCancelled) {
        self.resumableUpload.isCancelled = NO;
    }
    
    // 获得UploadId进行上传，如果任务失败并且可以续传，利用同一个UploadId可以上传同一文件到同一个OSS上的存储对象
    self.resumableUpload.bucketName = [WLServiceInfo sharedServiceInfo].ossFileBucket;
    self.resumableUpload.objectKey = servername;
    self.resumableUpload.uploadId = uploadId;
    self.resumableUpload.partSize = 1024 * 1024;
    //    WEAKSELF
    __block WLUploadProgressBlock progressBlock = updateProgress;
    self.resumableUpload.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        DLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
        if (progressBlock) {
            progressBlock(bytesSent, totalByteSent, totalBytesExpectedToSend);
        }
    };
    
    //开始上传
    self.resumableUpload.uploadingFileURL = [NSURL fileURLWithPath:filePath];
    OSSTask * resumeTask = [self.ossClient resumableUpload:self.resumableUpload];
    [resumeTask continueWithBlock:^id(OSSTask *task) {
        if (task.error) {
            DLog(@"error: %@", task.error);
            SAFE_BLOCK_CALL(failed, task.error);
            if ([task.error.domain isEqualToString:OSSClientErrorDomain] && task.error.code == OSSClientErrorCodeCannotResumeUpload) {
                // 该任务无法续传，需要获取新的uploadId重新上传
            }
        } else {
            //设置已经上传完成
            [NSUserDefaults removeObjectForKey:upKey];
            
            SAFE_BLOCK_CALL(success, servername);
            DLog(@"Upload file success");
            
            //移动BP到查看BP的文件夹中，方便查看的时候，直接查看
            NSString *folder = [[WLNetworkPrivate userResourcePath] stringByAppendingPathComponent:@"ChatDocument/ProjectBP/"];
            if (![[NSFileManager defaultManager] fileExistsAtPath:folder]) {
                DLog(@"创建home cover 目录!");
                [[NSFileManager defaultManager] createDirectoryAtPath:folder
                                          withIntermediateDirectories:YES
                                                           attributes:nil
                                                                error:nil];
            }
            NSString *toPath = [folder stringByAppendingPathComponent:servername];
            //下载成功，位置中是否存在
            BOOL hasPDF = [WLNetworkPrivate fileExistByPath:toPath];
            if (!hasPDF) {
                //                BOOL ismove = [ResManager filesMove:filePath TargetName:toPath];
                BOOL iscopy = [WLNetworkPrivate filesCopy:filePath TargetName:toPath];
                if (iscopy) {
                    DLog(@"复制成功");
                }
            }
        }
        return nil;
    }];
}

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
                                       Failed:(FailedBlock)failed
{
    OSSGetObjectRequest * request = [OSSGetObjectRequest new];
    
    // 必填字段
    request.bucketName = [WLServiceInfo sharedServiceInfo].ossFileBucket;
    request.objectKey = [NSString stringWithFormat:@"voice/%@",[filePath lastPathComponent]];;
    
    // 可选字段
    request.downloadProgress = ^(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
        // 当前下载段长度、当前已经下载总长度、一共需要下载的总长度
        DLog(@"%lld, %lld, %lld", bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
    };
    request.downloadToFileURL = [NSURL fileURLWithPath:toFolder]; // 如果需要直接下载到文件，需要指明目标文件地址
    
    OSSTask * getTask = [self.ossClient getObject:request];
    
    [getTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            SAFE_BLOCK_CALL(success, toFolder);
            DLog(@"download object success!");
            OSSGetObjectResult * getResult = task.result;
            DLog(@"download result: %@", getResult.downloadedData);
        } else {
            SAFE_BLOCK_CALL(failed, task.error);
            DLog(@"download object failed, error: %@" ,task.error);
        }
        return nil;
    }];
}


- (void)uploadImagesTOOSSService:(NSArray *)imagePathArray
                         Success:(SuccessBlock)success
                          Failed:(FailedBlock)failed {
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = imagePathArray.count;
    
    __block NSError *error = nil;
    for (NSString *imagepath in imagePathArray) {
        NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
            NSString *type = [imagepath pathExtension].length?[imagepath pathExtension]:@"file";
            OSSPutObjectRequest * put = [OSSPutObjectRequest new];
            put.bucketName = [WLServiceInfo sharedServiceInfo].ossBucket;;
            put.objectKey = imagepath;
            NSString *filePath = [WLNetworkPrivate filePathForCachesPath:imagepath];
            put.uploadingFileURL = [NSURL fileURLWithPath:filePath];
            
            put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
                DLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
            };
            put.contentType = type;
            
            OSSTask *putTask = [self.ossClient putObject:put];
            [putTask waitUntilFinished]; // 阻塞直到上传完成

            if (!putTask.error) {
                DLog(@"upload object success!");
            } else {
                error = putTask.error;
                DLog(@"图片上传失败-------\n图片上传失败-------\n图片上传失败-------\n图片上传失败-------\n, error: %@" , putTask.error);
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!error) {
                    if (imagepath == imagePathArray.lastObject) {
                        SAFE_BLOCK_CALL(success, imagePathArray);
                    }
                }else{
                    DLog(@"%@",error);
                    SAFE_BLOCK_CALL(failed, error);
                    [queue cancelAllOperations];
                }
            });
        }];
        
        if (queue.operations.count != 0) {
            [operation addDependency:queue.operations.lastObject];
        }
        [queue addOperation:operation];
        
    }
    
//    dispatch_queue_t concurrentQ = dispatch_queue_create("eg.gcd.ConcurrentQueue", DISPATCH_QUEUE_CONCURRENT);
//    dispatch_group_t group = dispatch_group_create();
//    __block NSError *error = nil;
//    for (NSString *imagepath in imagePathArray) {
//        dispatch_group_async(group, concurrentQ, ^{
//            NSString *type = [imagepath pathExtension].length?[imagepath pathExtension]:@"file";
//            OSSPutObjectRequest * put = [OSSPutObjectRequest new];
//            put.bucketName = [WLServiceInfo sharedServiceInfo].ossBucket;;
//            put.objectKey = imagepath;
//            NSString *filePath = [WLNetworkPrivate filePathForCachesPath:imagepath];
//            put.uploadingFileURL = [NSURL fileURLWithPath:filePath];
//
//            // optional fields
//            put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
//                DLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
//            };
//            put.contentType = type;
//
//            OSSTask *putTask = [self.ossClient putObject:put];
//            [putTask waitUntilFinished]; // 阻塞直到上传完成
//            if (!putTask.error) {
//                DLog(@"upload object success!");
//            } else {
//                error = putTask.error;
//                DLog(@"图片上传失败-------\n图片上传失败-------\n图片上传失败-------\n图片上传失败-------\n, error: %@" , putTask.error);
//            }
//        });
//    }
//    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
//        if (!error) {
//            SAFE_BLOCK_CALL(success, imagePathArray);
//        }else{
//            DLog(@"%@",error);
//            SAFE_BLOCK_CALL(failed, error);
//        }
//    });
}


///阿里云上传单张图片
- (void)uploadImageToOSSService:(UIImage *)image
                        Success:(SuccessBlock)success
                         Failed:(FailedBlock)failed {

    
    //    OSSClient *client = [self createOSSClient];
//    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
//
//    put.bucketName = [WLServiceInfo sharedServiceInfo].ossBucket;
//    NSString *exestr = @"jpg";
//    NSString *widthStr = [NSString stringWithFormat:@"%.0f",image.size.width];
//    NSString *heightStr = [NSString stringWithFormat:@"%.0f",image.size.height];
//    NSData *imageData = UIImageJPEGRepresentation(image, 0.9);
//
//    NSString *imageName = [NSString stringWithFormat:@"%@%@_%@_%@_%lu.%@",[NSString wl_randomString:4],[NSString wl_timeStamp],widthStr,heightStr,(unsigned long)imageData.length/1024,exestr];
//
//    put.objectKey = imageName;
//    put.uploadingData = imageData;
//
//    // optional fields
//    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
//        DLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
//    };
//    put.contentType = exestr;
//
//    OSSTask * putTask = [self.ossClient putObject:put];
//    [putTask continueWithBlock:^id(OSSTask *task) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (!task.error) {
//                SAFE_BLOCK_CALL(success, imageName);
//                DLog(@"Upload success!");
//            } else {
//                SAFE_BLOCK_CALL(failed, task.error);
//                DLog(@"图片上传失败-------\n图片上传失败-------\n图片上传失败-------\n图片上传失败-------\n, error: %@" , putTask.error);
//            }
//        });
//        return nil;
//    }];
}

#pragma mark - getter & setter
- (OSSResumableUploadRequest *)resumableUpload
{
    if (!_resumableUpload) {
        _resumableUpload = [OSSResumableUploadRequest new];
    }
    return _resumableUpload;
}

///阿里云上传
- (OSSClient *)ossClient {
    
    if (_ossClient == nil) {
        id<OSSCredentialProvider> credential = [[OSSPlainTextAKSKPairCredentialProvider alloc] initWithPlainTextAccessKey:kWL_ossAccessId secretKey:kWL_ossAccessKey];
        OSSClientConfiguration * conf = [OSSClientConfiguration new];
        conf.maxRetryCount = 3;//最大重试次数
        conf.enableBackgroundTransmitService = NO; // 是否开启后台传输服务
        conf.timeoutIntervalForRequest = 30;//请求超时时间
        conf.timeoutIntervalForResource = 24 * 60 * 60;//单个Object下载的最长持续时间
        
        OSSClient *client = [[OSSClient alloc] initWithEndpoint:kWL_ossEndpoint
                                             credentialProvider:credential
                                            clientConfiguration:conf];
        self.ossClient = client;
    }
    
    return _ossClient;
}

@end

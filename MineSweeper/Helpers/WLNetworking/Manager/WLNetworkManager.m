//
//  WLNetworkManager.m
//  Welian_Network_Demo
//
//  Created by weLian on 16/7/5.
//  Copyright © 2016年 杭州传送门网络科技有限公司. All rights reserved.
//

#import "WLNetworkManager.h"

#import "WLRequest+WLAdd.h"
#import "WLNetworkPrivate.h"

#import <AFNetworking/AFNetworking.h>

/**
 *  SSL 证书名称，仅支持cer格式。“app.bishe.com.cer”,则填“app.bishe.com”
 */
//#define certificate @"adn"

@interface WLNetworkManager ()

///网络访问管理者
@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation WLNetworkManager

#pragma mark - publice 

/*!
 *  网络请求方法,block回调
 *
 *  @param type         get / post
 *  @param urlString    请求的地址
 *  @param paraments    请求的参数
 *  @param successBlock 请求成功的回调
 *  @param failureBlock 请求失败的回调
 *  @param progress 进度
 */
- (NSURLSessionTask *)wl_requestWithType:(WLHttpRequestType)type
                               UrlString:(NSString *)urlString
                              Parameters:(NSDictionary *)parameters
                            SuccessBlock:(WLResponseSuccess)successBlock
                            FailureBlock:(WLResponseFailed)failureBlock {
    if (urlString == nil) {
        return nil;
    }
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURLSessionTask *sessionTask = nil;
    switch (type) {
        case WLHttpRequestTypeTypeGet: {
            sessionTask = [self.manager GET:urlString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (successBlock) {
                    successBlock(task, responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failureBlock) {
                    failureBlock(task, error);
                }
            }];
            break;
        }
        case WLHttpRequestTypePost: {
            sessionTask = [self.manager POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (successBlock) {
                    successBlock(task, responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failureBlock) {
                    failureBlock(task, error);
                }
            }];
            break;
        }
        case WLHttpRequestTypePUT:{
            sessionTask = [self.manager PUT:urlString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (successBlock) {
                    successBlock(task, responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failureBlock) {
                    failureBlock(task, error);
                }
            }];
            break;
        }
        case WLHttpRequestTypeDelete: {
            sessionTask = [self.manager DELETE:urlString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (successBlock) {
                    successBlock(task, responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failureBlock) {
                    failureBlock(task, error);
                }
            }];
            break;
        }
        case WLHttpRequestTypePatch: {
            sessionTask = [self.manager PATCH:urlString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (successBlock) {
                    successBlock(task, responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failureBlock) {
                    failureBlock(task, error);
                }
            }];
            break;
        }
    }
    return sessionTask;
}


/*!
 *  文件下载
 *
 *  @param operations   文件下载预留参数---视具体情况而定 可移除
 *  @param savePath     下载文件保存路径
 *  @param urlString        请求的url
 *  @param successBlock 下载文件成功的回调
 *  @param failureBlock 下载文件失败的回调
 *  @param progress     下载文件的进度显示
 */
- (NSURLSessionTask *)wl_downLoadFileWithUrlString:(NSString *)urlString
                                        parameters:(NSDictionary *)parameters
                                          SavaPath:(NSString *)savePath
                                      SuccessBlock:(WLResponseSuccess)successBlock
                                      FailureBlock:(WLResponseFailed)failureBlock
                                  DownLoadProgress:(WLDownloadProgress)progress {
    if (urlString == nil) return nil;
    NSURLRequest *downloadRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    //    NSLog(@"******************** 请求参数 ***************************");
    //    NSLog(@"请求头: %@\n请求方式: %@\n请求URL: %@\n请求param: %@\n\n",self.manager.requestSerializer.HTTPRequestHeaders, @"download",urlString, parameters);
    //    NSLog(@"******************************************************");
    NSURLSessionTask *sessionTask = nil;
    sessionTask = [self.manager downloadTaskWithRequest:downloadRequest progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"下载进度：%.2lld%%",100 * downloadProgress.completedUnitCount/downloadProgress.totalUnitCount);
        /*! 回到主线程刷新UI */
        dispatch_async(dispatch_get_main_queue(), ^{
            if (progress) {
                progress(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
            }
        });
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        if (savePath) {
            return [NSURL fileURLWithPath:savePath];
        } else {
            NSURL *downloadURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
            NSLog(@"默认路径--%@",downloadURL);
            return [downloadURL URLByAppendingPathComponent:[response suggestedFilename]];
        }
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error == nil) {
            if (successBlock) {
                NSLog(@"下载文件成功");
                /*! 返回完整路径 */
                successBlock(nil, filePath);
            }else {
                if (failureBlock) {
                    failureBlock(nil, error);
                }
            }
        }
    }];
    
    /*! 开始启动任务 */
    [sessionTask resume];
    return sessionTask;
}

// 上传图片
- (NSURLSessionUploadTask *)wl_updateFileWithUrlString:(NSString *)urlString
                                            parameters:(NSDictionary *)parameters
                                                 image:(UIImage *)image
                                          SuccessBlock:(WLResponseSuccess)successBlock
                                          FailureBlock:(WLResponseFailed)failureBlock
                                      DownLoadProgress:(WLDownloadProgress)progress {
    if (urlString == nil) return nil;
//    NSError* error = NULL;
    NSURLSessionUploadTask *task = [self.manager POST:urlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *imageData = UIImageJPEGRepresentation(image, .5);
        //        [formData appendPartWithFileData:imageData name:@"file" fileName:@"file" mimeType:@"multipart/form-data"];
        [formData appendPartWithFileData:imageData name:@"file" fileName:@"file.jpg" mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"上传进度：%.2lld%%",100 * uploadProgress.completedUnitCount/uploadProgress.totalUnitCount);
        /*! 回到主线程刷新UI */
        dispatch_async(dispatch_get_main_queue(), ^{
            if (progress) {
                progress(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
            }
        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"文件上传成功");
        if (successBlock) {
            NSLog(@"文件上传成功");
            /*! 返回完整路径 */
            successBlock(nil, responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failureBlock) {
            failureBlock(nil, error);
        }
    }];
    
//    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:urlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        NSData* imageData = UIImageJPEGRepresentation(image, 1.0);
////        [formData appendPartWithFileData:imageData name:@"file" fileName:@"file" mimeType:@"multipart/form-data"];
//        [formData appendPartWithFileData:imageData name:@"file" fileName:@"file.jpg" mimeType:@"image/jpeg"];
//    } error:&error];
//
//    NSURLSessionUploadTask *task = [self.manager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
//        NSLog(@"上传进度：%.2lld%%",100 * uploadProgress.completedUnitCount/uploadProgress.totalUnitCount);
//        /*! 回到主线程刷新UI */
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (progress) {
//                progress(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
//            }
//        });
//    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//        if (error == nil) {
//            if (successBlock) {
//                NSLog(@"文件上传成功");
//                /*! 返回完整路径 */
//                successBlock(nil, responseObject);
//            }else {
//                if (failureBlock) {
//                    failureBlock(nil, error);
//                }
//            }
//        }
//    }];
    return task;
}

#pragma mark - Getter & Setter
///网络接口管理者
- (AFHTTPSessionManager *)manager {
    if (_manager == nil) {
        _manager = [AFHTTPSessionManager manager];
        ///设置请求回调的内容方式
        self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"text/html",@"text/plain"]];
        // 加上这行代码，https ssl 验证。
        if([WLNetwokingConfig sharedInstance].openHttpsSSL) {
            _manager.securityPolicy = [WLNetwokingConfig sharedInstance].securityPolicy;
        }
    }
    return _manager;
}

- (void)setRequestSerializer:(AFHTTPRequestSerializer *)requestSerializer {
    _requestSerializer = requestSerializer;
    
    self.manager.requestSerializer = _requestSerializer;
}

- (void)setResponseSerializer:(AFHTTPResponseSerializer *)responseSerializer {
    _responseSerializer = responseSerializer;
    
    self.manager.responseSerializer = _responseSerializer;
}

- (void)setTimeOutInterval:(NSTimeInterval)timeOutInterval {
    _timeOutInterval = timeOutInterval;
    
    self.manager.requestSerializer.timeoutInterval = _timeOutInterval;
}


- (AFSecurityPolicy *)customSecurityPolicy
{
    // /先导入证书
    NSString *certFilePath = [[NSBundle mainBundle] pathForResource:@"server" ofType:@"der"];
    NSData *certData = [NSData dataWithContentsOfFile:certFilePath];
    if (certData == nil) {
        NSLog(@"sever.der or cer is not exit");
        return nil;
    }
    // AFSSLPinningModeCertificate 使用证书验证模式
    NSSet *certSet = [NSSet setWithObject:certData];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate withPinnedCertificates:certSet];
    //    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
    
    return securityPolicy;
}


/**
 *  @author Haodi, 16-03-18 16:03:04
 *
 *  配置 https 请求
 */
- (void)loadHttpsConfig{
    //    self.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    
    NSString *certFilePath = [[NSBundle mainBundle] pathForResource:@"server" ofType:@"der"];
    NSData *certData = [NSData dataWithContentsOfFile:certFilePath];
    if (certData == nil) {
        NSLog(@"sever.der or cer is not exit");
        return;
    }
    NSSet *certSet = [NSSet setWithObject:certData];
    AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate withPinnedCertificates:certSet];
    //allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO//如果是需要验证自建证书，需要设置为YES
    policy.allowInvalidCertificates = YES;
    //validatesDomainName 是否需要验证域名，默认为YES；
    policy.validatesDomainName = NO;
    //设置https 参数配置
    self.manager.securityPolicy = policy;
    
    
    __weak typeof(self)weakSelf = self;
    [self.manager setSessionDidReceiveAuthenticationChallengeBlock:^NSURLSessionAuthChallengeDisposition(NSURLSession * _Nonnull session, NSURLAuthenticationChallenge * _Nonnull challenge, NSURLCredential *__autoreleasing  _Nullable * _Nullable credential) {
        NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
        __autoreleasing NSURLCredential *dcredential = nil;
        if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
            // 验证服务端是否受信
            if([weakSelf.manager.securityPolicy evaluateServerTrust:challenge.protectionSpace.serverTrust forDomain:challenge.protectionSpace.host]) {
                dcredential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
                if(credential) {
                    disposition = NSURLSessionAuthChallengeUseCredential;
                } else {
                    disposition = NSURLSessionAuthChallengePerformDefaultHandling;
                }
            } else {
                disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
            }
        } else {
            // client authentication
            SecIdentityRef identity = NULL;
            SecTrustRef trust = NULL;
            NSString *p12 = [[NSBundle mainBundle] pathForResource:@"client"ofType:@"p12"];
            NSFileManager *fileManager =[NSFileManager defaultManager];
            
            if(![fileManager fileExistsAtPath:p12])
            {
                NSLog(@"client.p12:not exist");
            }else {
                NSData *PKCS12Data = [NSData dataWithContentsOfFile:p12];
                
                if ([[weakSelf class]extractIdentity:&identity andTrust:&trust fromPKCS12Data:PKCS12Data])
                {
                    SecCertificateRef certificate = NULL;
                    SecIdentityCopyCertificate(identity, &certificate);
                    const void*certs[] = {certificate};
                    CFArrayRef certArray =CFArrayCreate(kCFAllocatorDefault, certs,1,NULL);
                    dcredential = [NSURLCredential credentialWithIdentity:identity certificates:(__bridge  NSArray*)certArray persistence:NSURLCredentialPersistencePermanent];
                    disposition = NSURLSessionAuthChallengeUseCredential;
                }
            }
        }
        //                *_credential = dcredential;
        return disposition;
    }];
}

+ (BOOL)extractIdentity:(SecIdentityRef*)outIdentity andTrust:(SecTrustRef *)outTrust fromPKCS12Data:(NSData *)inPKCS12Data {
    OSStatus securityError = errSecSuccess;
    //client certificate password
    NSDictionary*optionsDictionary = [NSDictionary dictionaryWithObject:@"welian"
                                                                 forKey:(__bridge id)kSecImportExportPassphrase];
    
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    securityError = SecPKCS12Import((__bridge CFDataRef)inPKCS12Data,(__bridge CFDictionaryRef)optionsDictionary,&items);
    
    if(securityError == 0) {
        CFDictionaryRef myIdentityAndTrust =CFArrayGetValueAtIndex(items,0);
        const void*tempIdentity =NULL;
        tempIdentity= CFDictionaryGetValue (myIdentityAndTrust,kSecImportItemIdentity);
        *outIdentity = (SecIdentityRef)tempIdentity;
        const void*tempTrust =NULL;
        tempTrust = CFDictionaryGetValue(myIdentityAndTrust,kSecImportItemTrust);
        *outTrust = (SecTrustRef)tempTrust;
    } else {
        NSLog(@"Failedwith error code %d",(int)securityError);
        return NO;
    }
    return YES;
}

@end

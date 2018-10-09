//
//  BaseModelClient.h
//  MineSweeper
//
//  Created by liuwu on 2018/9/19.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModelClient : NSObject

// post请求
+ (WLRequest *)postWithParams:(NSDictionary *)params
                apiMethodName:(NSString *)apiMethodName
 ignoreUnifiedResponseProcess:(BOOL)ignoreUnifiedResponseProcess
                   checkToken:(BOOL)checkToken
                      Success:(SuccessBlock)success
                       Failed:(FailedBlock)failed;

// get请求
+ (WLRequest *)getWithParams:(NSDictionary *)params
               apiMethodName:(NSString *)apiMethodName
ignoreUnifiedResponseProcess:(BOOL)ignoreUnifiedResponseProcess
                  checkToken:(BOOL)checkToken
                     Success:(SuccessBlock)success
                      Failed:(FailedBlock)failed;

+ (WLRequest *)updateFileWithParams:(NSDictionary *)params
                      apiMethodName:(NSString *)apiMethodName
                              image:(UIImage *)image
                            Success:(SuccessBlock)success
                             Failed:(FailedBlock)failed ;

@end

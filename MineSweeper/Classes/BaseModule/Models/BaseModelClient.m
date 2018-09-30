//
//  BaseModelClient.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/19.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "BaseModelClient.h"
#import "BaseResultModel.h"
#import <YYKit/YYKit.h>
#import "AppDelegate.h"

@implementation BaseModelClient

+ (WLRequest *)postWithParams:(NSDictionary *)params
                apiMethodName:(NSString *)apiMethodName
                      Success:(SuccessBlock)success
                       Failed:(FailedBlock)failed {
    NSMutableDictionary *paramsMutableDic = [NSMutableDictionary dictionaryWithDictionary:params];
    //    [params setValue:@"AppStore" forKey:@"channel"];
    WLRequestCriteria *requestCriteria = [[WLRequestCriteria alloc] init];
    requestCriteria.apiMethodName = apiMethodName;
    requestCriteria.requestParams = paramsMutableDic;
    requestCriteria.ignoreDecryptAES256Value = YES;
    requestCriteria.requestSerializerType = WLRequestSerializerTypeHTTP;
    requestCriteria.reponseSerializerType = WLResponseSerializerTypeJSON;
    // 忽略统一返回数据处理
    requestCriteria.ignoreUnifiedResponseProcess = NO;
    WLRequest *api = [[WLRequest alloc] initWithRequestCriteria:requestCriteria];
    [api startWithCompletionBlockWithSuccess:^(WLRequest *request) {
        // 解析返回的数据
        SAFE_BLOCK_CALL(success, request.responseJSONObject);
         [[AppDelegate sharedAppDelegate] checkRefreshToken];
    } failure:^(WLRequest *request) {
//        if (request.error.code != 2604 && request.error.code != 2602) {
//            // 统一错误处理
//            [WLNetWorkingProcessFilter checkErrorWithRequest:request customMsg:nil];
//        }
        //系统普通错误，如果服务器返回有错误，弹出hub提醒
//        if (request.error.localizedDescription.length > 0) {
//            [WLHUDView showErrorHUD:request.error.localizedDescription Duration:2.5f];
//        }
        SAFE_BLOCK_CALL(failed, request.error);
    }];
    return api;
}

+ (WLRequest *)getWithParams:(NSDictionary *)params
               apiMethodName:(NSString *)apiMethodName
                     Success:(SuccessBlock)success
                      Failed:(FailedBlock)failed {
    NSMutableDictionary *paramsMutableDic = [NSMutableDictionary dictionaryWithDictionary:params];
    //    [params setValue:@"AppStore" forKey:@"channel"];
    WLRequestCriteria *requestCriteria = [[WLRequestCriteria alloc] init];
    requestCriteria.apiMethodName = apiMethodName;
    requestCriteria.requestParams = paramsMutableDic;
    requestCriteria.requestMethodType = WLRequestMethodTypeGet;
    requestCriteria.ignoreDecryptAES256Value = YES;
    requestCriteria.requestSerializerType = WLRequestSerializerTypeHTTP;
    requestCriteria.reponseSerializerType = WLResponseSerializerTypeJSON;
    // 忽略统一返回数据处理
    requestCriteria.ignoreUnifiedResponseProcess = NO;
    WLRequest *api = [[WLRequest alloc] initWithRequestCriteria:requestCriteria];
    [api startWithCompletionBlockWithSuccess:^(WLRequest *request) {
        // 解析返回的数据
        SAFE_BLOCK_CALL(success, request.responseJSONObject);
         [[AppDelegate sharedAppDelegate] checkRefreshToken];
    } failure:^(WLRequest *request) {
//        if (request.error.code != 2604 && request.error.code != 2602) {
//            // 统一错误处理
//            [WLNetWorkingProcessFilter checkErrorWithRequest:request customMsg:nil];
//        }
        //系统普通错误，如果服务器返回有错误，弹出hub提醒
//        if (request.error.localizedDescription.length > 0) {
//            [WLHUDView showErrorHUD:request.error.localizedDescription Duration:2.5f];
//        }
        SAFE_BLOCK_CALL(failed, request.error);
    }];
    return api;
}


+ (WLRequest *)updateFileWithParams:(NSDictionary *)params
                    apiMethodName:(NSString *)apiMethodName
                            image:(UIImage *)image
                          Success:(SuccessBlock)success
                           Failed:(FailedBlock)failed {
    NSMutableDictionary *paramsMutableDic = [NSMutableDictionary dictionaryWithDictionary:params];
    //    [params setValue:@"AppStore" forKey:@"channel"];
    WLRequestCriteria *requestCriteria = [[WLRequestCriteria alloc] init];
    requestCriteria.apiMethodName = apiMethodName;
    requestCriteria.requestParams = paramsMutableDic;
    requestCriteria.ignoreDecryptAES256Value = YES;
    requestCriteria.requestSerializerType = WLRequestSerializerTypeHTTP;
    requestCriteria.reponseSerializerType = WLResponseSerializerTypeJSON;
    // 忽略统一返回数据处理
    requestCriteria.ignoreUnifiedResponseProcess = NO;
    requestCriteria.requestMethodType = WLRequestMethodTypeUpdateImage;
    requestCriteria.updateImage = image;
    WLRequest *api = [[WLRequest alloc] initWithRequestCriteria:requestCriteria];
    [api startWithCompletionBlockWithSuccess:^(WLRequest *request) {
        // 解析返回的数据
        SAFE_BLOCK_CALL(success, request.responseJSONObject);
    } failure:^(WLRequest *request) {
        if (request.error.code != 2604 && request.error.code != 2602) {
            // 统一错误处理
            [WLNetWorkingProcessFilter checkErrorWithRequest:request customMsg:nil];
        }
        SAFE_BLOCK_CALL(failed, request.error);
    }];
    return api;
}

@end

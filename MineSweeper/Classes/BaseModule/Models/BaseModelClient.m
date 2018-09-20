//
//  BaseModelClient.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/19.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "BaseModelClient.h"

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
        SAFE_BLOCK_CALL(success,[request.responseJSONObject wl_jsonValueDecoded]);
    } failure:^(WLRequest *request) {
        if (request.error.code != 2604 && request.error.code != 2602) {
            // 统一错误处理
            [WLNetWorkingProcessFilter checkErrorWithRequest:request customMsg:nil];
        }
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
        SAFE_BLOCK_CALL(success,[request.responseJSONObject wl_jsonValueDecoded]);
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

//
//  WLLogger.m
//  Welian_Network_Demo
//
//  Created by weLian on 16/7/13.
//  Copyright © 2016年 杭州传送门网络科技有限公司. All rights reserved.
//

#import "WLLogger.h"
#import "WLRequest+WLAdd.h"

@implementation WLLogger

+ (instancetype)sharedInstance
{
    static WLLogger *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

/**
 *  打印请求信息
 */
+ (void)logDebugInfoWithRequest:(WLRequest *)request {
#ifdef DEBUG
    NSMutableString *logString = [NSMutableString stringWithString:@"\n\n**************************************************************\n*                       Request Start                        *\n**************************************************************\n"];
    
    [logString appendFormat:@"HTTP Header:%@ \n", request.requestSerializer.HTTPRequestHeaders];
    
    [logString appendFormat:@"URL :\t\t%@\n", request.urlString];
    [logString appendFormat:@"Type:\t\t%@\n", (request.requestMethodType == WLRequestMethodTypePost) ? @"POST":@"GET"];
    [logString appendFormat:@"Method:\t\t%@\n",request.apiMethodName];
    [logString appendFormat:@"Params:\t\t%@\n", request.requestParamInfos];
    
    [logString appendFormat:@"**************************************************************\n*                         Request End                        *\n**************************************************************\n\n\n"];
    DLog(@"%@", logString);
#endif
}

/**
 *  打印请求返回的内容
 *  @param request Api请求
 */
+ (void)logDebugInfoWithResponse:(WLRequest *)request {
#ifdef DEBUG
    BOOL shouldLogError = request.error ? YES : NO;
    NSError *error = request.error;
    
    NSMutableString *logString = [NSMutableString stringWithString:@"\n\n==============================================================\n=                        API Response                        =\n==============================================================\n"];
    
    [logString appendFormat:@"URL :%@\n", request.requestDataTask.originalRequest.URL];
    [logString appendFormat:@"HTTP Header:%@\n", request.requestDataTask.originalRequest.allHTTPHeaderFields];
    
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)request.requestDataTask.response;
    [logString appendFormat:@"Status:\t%ld\t(%@)\n",(long)request.responseStatusCode,[NSHTTPURLResponse localizedStringForStatusCode:response.statusCode]];
    if (request.error) {
        [logString appendFormat:@"Content:\n\t%@\n", request.error];
    }else{
        [logString appendFormat:@"Content:\n\t%@\n", describe(request.responseJSONObject)];
//        [logString appendFormat:@"Content:\n\t%@\n\n", [request.responseJSONObject modelDescription]];
    }
    if (shouldLogError) {
        [logString appendFormat:@"Error Domain:\t\t\t\t\t\t\t%@\n", error.domain];
        [logString appendFormat:@"Error Domain Code:\t\t\t\t\t\t%ld\n", (long)error.code];
        [logString appendFormat:@"Error Localized Description:\t\t\t%@\n", error.localizedDescription];
//        [logString appendFormat:@"Error Localized Failure Reason:\t\t\t%@\n", error.localizedFailureReason];
//        [logString appendFormat:@"Error Localized Recovery Suggestion:\t%@", error.localizedRecoverySuggestion];
    }
    [logString appendFormat:@"==============================================================\n=                        Response End                        =\n==============================================================\n\n"];
    
    DLog(@"%@", logString);
#endif
}

/**
 *  读取缓存的内容
 *  @param request Api请求
 */
+ (void)logDebugInfoWithCachedResponse:(WLRequest *)request {
#ifdef DEBUG
    NSMutableString *logString = [NSMutableString stringWithString:@"\n\n==============================================================\n=                      Cached Response                       =\n==============================================================\n"];
    
    [logString appendFormat:@"API Name:\t\t%@\n", request.urlString];
    [logString appendFormat:@"Params:\t\t%@", request.requestParamInfos];
    if (request.error) {
        [logString appendFormat:@"Content:\n\t%@\n\n", request.error];
    }else{
        [logString appendFormat:@"Content:\n\t%@\n\n", describe(request.responseJSONObject)];
        //        [logString appendFormat:@"Content:\n\t%@\n\n", [request.responseJSONObject modelDescription]];
    }
    
    [logString appendFormat:@"\n==============================================================\n=                        Response End                        =\n==============================================================\n\n\n\n"];
    DLog(@"%@", logString);
#endif
}

@end

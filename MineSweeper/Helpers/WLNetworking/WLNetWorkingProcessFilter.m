//
//  WLNetWorkingProcessFilter.m
//  Welian
//
//  Created by weLian on 16/8/2.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import "WLNetWorkingProcessFilter.h"
#import "WLPackAlertController.h"
#import "AppDelegate.h"


/// --------- NSNotification -----------
///需要绑定手机号的通知
NSString *const kWLNeedBindPhoneNotification = @"kWLNeedBindPhoneNoti";
///需要完善信息的通知
NSString *const kWLNeedCompleteInfoNotification = @"kWLNeedCompleteInfoNoti";

@implementation WLNetWorkingProcessFilter

/// 在接口错误的回调的地方，进行其它错误的处理
+ (void)checkErrorWithRequest:(WLRequest *)request customMsg:(NSString *)customMsg {
    if (request.error.code != WLNetWorkingResultStateTypeHub) {
        [WLHUDView hiddenHud];
    }
    if (!request.isIgnoreResponseError) {
        //没有统一处理的错误，在这里处理
        switch (request.error.code) {
            case WLNetWorkingResultStateTypeSystem:
                //系统级错误
                break;
            case WLNetWorkingResultStateTypeNormal:
            {
                //系统普通错误，如果服务器返回有错误，弹出hub提醒
                if (request.error.localizedDescription.length > 0) {
                    [WLHUDView showErrorHUD:request.error.localizedDescription Duration:2.5f];
                }
                return;
            }
                break;
            default:
                break;
        }
        
        //没有做统一处理的错误，并且新的code有错误信息
#ifdef DEBUG
        NSString *msg = customMsg ? : [NSString stringWithFormat: @"%@\n%@（%ld）",request.apiMethodName, request.error.localizedDescription, (long)request.error.code];
#else
        NSString *msg = customMsg ? : @"网络连接失败，请重试！";
#endif
        if (request.errorType == WLErrorTypeNoContent && !request.isIgnoreResponseError) {
            if (request.error.localizedDescription.length > 0) {
                [WLHUDView showErrorHUD:request.error.localizedDescription];
            }else{
                if (msg.length > 0) {
#ifdef DEBUG
                    [[WLPackAlertController alertWithTitle:msg message:nil alertStyle:UIAlertControllerStyleAlert actionStyle:UIAlertActionStyleDefault text1:@"确定" handler1:nil] show];
#else
                    // 网络请求错误或无网络错误等做特殊提醒，也可以判断特殊错误
                    [WLHUDView showErrorHUD:msg];
#endif
                }
            }
        }
        
        // 网络请求错误或无网络错误等做特殊提醒，也可以判断特殊错误
        if (request.errorType == WLErrorTypeNoNetWork) {
            msg = customMsg ? : @"网络无法连接，请检测网络连接状态！";
        }
        
        if (request.errorType == WLErrorTypeTimeOut) {
            msg = customMsg ? : @"网络请求超时，请重试！";
        }
        
        if (request.errorType == WLErrorTypeFailed ||
            request.errorType == WLErrorTypeNoNetWork ||
            request.errorType == WLErrorTypeTimeOut) {
            if (msg.length > 0) {
#ifdef DEBUG
                [[WLPackAlertController alertWithTitle:msg message:nil alertStyle:UIAlertControllerStyleAlert actionStyle:UIAlertActionStyleDefault text1:@"确定" handler1:nil] show];
#else
                // 网络请求错误或无网络错误等做特殊提醒，也可以判断特殊错误
                [WLHUDView showErrorHUD:msg];
#endif
            }
        }
    }
}


/**
 *  @author liuwu     , 16-08-02
 *
 *  接口的统一参数
 *  @return 参数
 *  @since V2.8.3
 */
- (NSDictionary *)urlArgumentsInfos {

//    WLUserJWTModel *jwtModel = [[WLUserDataCenter sharedInstance] getLoginUserJWT];
    /// 每次启动App时都会新生成
//    NSString *sessionId = jwtModel.sessionId?:[NSUserDefaults objectForKey:kWL_UserSessionIdKey];
    NSMutableDictionary *requestHeaderDic = [NSMutableDictionary dictionary];
//    [requestHeaderDic setValue:sessionId forKey:@"sessionid"];
    [requestHeaderDic setValue:kAppVersion forKey:@"version"];
    [requestHeaderDic setValue:kPlatformType forKey:@"platform"];
    [requestHeaderDic setValue:kDeviceUdid forKey:@"platform"];
    return [NSDictionary dictionaryWithDictionary:requestHeaderDic];
}

- (NSDictionary *)httpHeaderInfos {
//    WLUserJWTModel *jwtModel = [[WLUserDataCenter sharedInstance] getLoginUserJWT];
    /// 每次启动App时都会新生成
//    NSString *sessionId = jwtModel.sessionId?:[NSUserDefaults objectForKey:kWL_UserSessionIdKey];
//    NSString *userJWT = jwtModel.jwt;
    NSMutableDictionary *requestHeaderDic = [NSMutableDictionary dictionary];
//    [requestHeaderDic setValue:sessionId forKey:@"sessionid"];
//    [requestHeaderDic setValue:userJWT forKey:@"jwt"];
    [requestHeaderDic setValue:kAppVersion forKey:@"version"];
    [requestHeaderDic setValue:kPlatformType forKey:@"platform"];
    [requestHeaderDic setValue:kDeviceUdid forKey:@"platform"];
    return [NSDictionary dictionaryWithDictionary:requestHeaderDic];
}

/**
 *  用于统一加工response，返回处理后response
 *
 *  @param response response
 *  @return 处理后的response
 */
- (id)processResponseWithRequest:(id)request ignoreDecryptAES256:(BOOL)ignoreDecryptAES256 {
    ///接口返回的错误
    if ([request isKindOfClass:[NSError class]]) {
        /// 对错误统一处理
        NSLog(@"NSError Request: %@", request);
        if ([request code] == NSURLErrorTimedOut) {
            NSLog(@"请求超时，请检查网络");
        }
        return request;
    }else{
        if ([request isKindOfClass:[NSString class]] || [request isKindOfClass:[NSURL class]]) {
            return request;
        }
        if (ignoreDecryptAES256) {
            request = [request jsonValueDecoded];
        }else{
            request = [[request wl_decryptAES256Value] jsonValueDecoded];
        }

        if ([request isKindOfClass:[NSDictionary class]]) {
            NSDictionary *resultInfo = request;
            NSString *errormsg = resultInfo[@"errormsg"] ? : @"";
            NSNumber *state = resultInfo[@"state"];
            NSString *sessionid = resultInfo[@"sessionid"];
            id data = resultInfo[@"data"];
            
            //1100 1200 1201 聊天室相关，已废弃，没有用，当前普通错误处理
            //很多地方校验参数失败都返回的是1020,当作普通错误处理
            if (state.integerValue == WLNetWorkingResultStateTypeSuccess) {
                /// 接口返回成功，且数据正确
                if (sessionid.length > 0) {
                    ///保存sessionid
//                    [NSUserDefaults setObject:sessionid forKey:kWL_UserSessionIdKey];
                }
                return data;
            }else{
                /*
                 1  错误码：1101，App通过toast提示服务端通过errormsg传回的内容
                 2. 错误码：1102，App通过Alert提示服务端通过errormsg传回的内容
                 3. 错误码：3101，App通过Alert提示服务端通过errormsg传回的内容，并在用户点击“确定”以后退出登录
                 4. 错误码：3102，App通过Alert提示服务端通过errormsg传回的内容，并在用户点击“确定”以后跳转到服务端通过url传回的链接
                 5. 错误码：3103，App通过Alert提示服务端通过errormsg传回的内容。用户点击"取消"不做操作，点击“确定”以后跳转到服务端通过url传回的链接
                 */
                NSInteger errorCode = state.integerValue;
                if (state.integerValue > WLNetWorkingResultStateTypeSuccess && state.integerValue < WLNetWorkingResultStateTypeService) {
                    errorCode = state.integerValue;
                    
                }else if (state.integerValue >= WLNetWorkingResultStateTypeService && state.integerValue < WLNetWorkingResultStateTypeSystem) {
                    errorCode = state.integerValue;
                }else if (state.integerValue >= WLNetWorkingResultStateTypeSystem) {
                    switch (errorCode) {
                        case WLNetWorkingResultStateTypeSystemAlertCancelOrJump:
                        case WLNetWorkingResultStateTypeSystemAlertAndJump:
                        case WLNetWorkingResultStateTypeSystemLogout:{
                            errorCode = state.integerValue;
                        }
                            break;
                        default:
                            errorCode = state.integerValue;
                            break;
                    }
                    
                }else {
                    //其它，都当作普通的错误，在这里不做统一提醒处理，交给接口调用的地方进行处理
                    errorCode = WLNetWorkingResultStateTypeNormal;
                }
                
                NSMutableDictionary *info = [NSMutableDictionary dictionary];
                /// 错误信息
                [info setObject:errormsg forKey:NSLocalizedDescriptionKey];
                
                /// 跳转的页面url
                NSString *jumpUrl = resultInfo[@"url"];
                if (jumpUrl.length > 0) {
                    [info setObject:jumpUrl forKey:@"url"];
                }
                NSError *error = [NSError errorWithDomain:@"SystemError" code:errorCode userInfo:[NSDictionary dictionaryWithDictionary:info]];
                return error;
            }
        }
    }
    return request;
}

///**
// *  用于统一加工response，返回是否数据返回正确
// *
// *  @param response response
// *  @return 处理后的response，判断是否接口调用成功
// */
//- (BOOL)processResponseValidator:(id)response {
//    BOOL success = YES;
//    ///接口返回的错误
//    if ([response isKindOfClass:[NSError class]]) {
//        success = NO;
//    }else{
//        if ([response isKindOfClass:[NSString class]]) {
//            success = YES;
//        }else{
//            id request = [[response wl_decryptAES256Value] jsonValueDecoded];
//            if ([request isKindOfClass:[NSDictionary class]]) {
//                NSDictionary *resultInfo = request;
//                NSNumber *state = resultInfo[@"state"];
//                
//                //1100 1200 1201 聊天室相关，已废弃，没有用，当前普通错误处理
//                //很多地方校验参数失败都返回的是1020,当作普通错误处理
//                if (state.integerValue == WLNetWorkingResultStateTypeSuccess) {
//                    /// 接口返回成功，且数据正确
//                    success = YES;
//                }else{
//                    success = NO;
//                }
//            }
//        }
//    }
//    return success;
//}

/**
 *  用于统一的NSError错误处理
 *  @param error 接口错误信息
 *  @param errorType 错误类型
 */
- (BOOL)processResponseWithError:(id)error errorType:(WLErrorType)errorType {
    //隐藏接口外面的加载动画
    [WLHUDView hiddenHud];
    BOOL isProcessResponse = NO;
    switch (errorType) {
        case WLErrorTypeNoContent: {
            if ([error isKindOfClass:[NSError class]]) {
                NSError *errorInfo = error;
                NSString *errorMsg = @"";
                WLNetWorkingResultStateType errorType = errorInfo.code;
                switch (errorType) {
                    case WLNetWorkingResultStateTypeHub: {
                        //统一处理错误
                        isProcessResponse = YES;
                        /// 进行hub提醒
                        errorMsg = errorInfo.localizedDescription;
                        if (errorMsg.length > 0) {
                            [WLHUDView showErrorHUD:errorMsg];
                        }
                        break;
                    }
                    case WLNetWorkingResultStateTypeAlert: {
                        //统一处理错误
                        isProcessResponse = YES;
                        /// 进行Alert提醒
                        errorMsg = errorInfo.localizedDescription;
                        if (errorMsg.length > 0) {
                            [[LGAlertView alertViewWithTitle:errorMsg
                                                     message:nil
                                                       style:LGAlertViewStyleAlert
                                                buttonTitles:nil
                                           cancelButtonTitle:nil
                                      destructiveButtonTitle:@"确定"
                                               actionHandler:nil
                                               cancelHandler:nil
                                          destructiveHandler:nil] showAnimated:YES completionHandler:nil];
                        }
                        break;
                    }
                    case WLNetWorkingResultStateTypeSystemAlertAndJump: {
                        //统一处理错误
                        isProcessResponse = YES;
                        /// 进行Alert提醒，并可以点击确定跳转
                        errorMsg = errorInfo.localizedDescription;
                        NSString *url = [[error userInfo] objectForKey:@"url"];
                        if (errorMsg.length > 0) {
                            [[LGAlertView alertViewWithTitle:errorMsg
                                                     message:nil
                                                       style:LGAlertViewStyleAlert
                                                buttonTitles:nil
                                           cancelButtonTitle:nil
                                      destructiveButtonTitle:@"确定"
                                               actionHandler:nil
                                               cancelHandler:nil
                                          destructiveHandler:^(LGAlertView *alertView) {
                                              if (url.length > 0) {
                                                  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                                              }

                            }] showAnimated:YES completionHandler:nil];
                        }
                        break;
                    }
                    case WLNetWorkingResultStateTypeSystemAlertCancelOrJump: {
                        //统一处理错误
                        isProcessResponse = YES;
                        /// 进行Alert提醒，并可以点击确定跳转
                        errorMsg = errorInfo.localizedDescription;
                        NSString *url = [[error userInfo] objectForKey:@"url"];
                        if (errorMsg.length > 0) {
                            NSString *cancelTitle = url.length > 0 ? @"取消" : @"确定";
                            NSString *okTitle = url.length > 0 ? @"确定" : nil;
                            [[LGAlertView alertViewWithTitle:errorMsg
                                                     message:nil
                                                       style:LGAlertViewStyleAlert
                                                buttonTitles:nil
                                           cancelButtonTitle:cancelTitle
                                      destructiveButtonTitle:okTitle
                                               actionHandler:nil
                                               cancelHandler:nil
                                          destructiveHandler:^(LGAlertView *alertView) {
                                              if (url.length > 0) {
                                                  //已经登录，跳转页面
//                                                  [[AppDelegate sharedAppDelegate] wlopenURLString:url sourceViewControl:nil];
                                              }
                                              
                                          }] showAnimated:YES completionHandler:nil];
                        }
                        break;
                    }
                    case WLNetWorkingResultStateTypeNoLogin:
                    case WLNetWorkingResultStateTypeSystemLogout: {
                        //统一处理错误
                        isProcessResponse = YES;
                        /// 被踢出，需要重新登录
                        errorMsg = errorInfo.localizedDescription;
                        //退出登录
                        [[AppDelegate sharedAppDelegate] logoutWithErrormsg:errorMsg];
                        
                        break;
                    }
                    case WLNetWorkingResultStateTypeService: {
                        /// 服务器错误，不做提醒
                        errorMsg = errorInfo.localizedDescription;
                        DLog(@"Service Error ----- >: %@",errorMsg);
                        break;
                    }
                    case WLNetWorkingResultStateTypeNormal:
                    case WLNetWorkingResultStateTypeSystem: {
                        /// 系统级错误，不做提醒
                        errorMsg = errorInfo.localizedDescription;
                        DLog(@"System Error ----- >: %@",errorMsg);
                        break;
                    }
                    default:{
                        /// 其它错误类型，不做任何处理
                        errorMsg = errorInfo.localizedDescription;
                        DLog(@"Other Error ----- >: %@",errorMsg);
                        break;
                    }
                }
            }
            break;
        }
        case WLErrorTypeSuccess: {
            ///接口成功，不做处理
            break;
        }
        case WLErrorTypeTimeOut:
        case WLErrorTypeFailed: {
            ///接口调用失败，交给接口调用的地方来决定是否弹出订制性的错误提醒
            /*
            code -1001:请求超时，请检查网络！
             code -1004:未能连接到服务器，请检查网络！
             */
            break;
        }
        case WLErrorTypeNoNetWork: {
            /// 无网络连接，交给接口调用的地方来决定是否弹出订制性的错误提醒
            break;
        }
    }
    return isProcessResponse;
}

@end


//
//  WLNetWorkingProcessFilter.h
//  Welian
//
//  Created by weLian on 16/8/2.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WLNetwokingConfig.h"

/// 网络库的数据统一处理类,对网络请求的返回信息统一处理
@interface WLNetWorkingProcessFilter : NSObject<WLNetwokingProcessDelegate>


/**
 *  @author liuwu     , 16-08-03
 *
 *  在接口错误的回调的地方，进行其它错误的处理
 *  @param request   接口请求
 *  @param customMsg 自定义的错误提醒
 */
+ (void)checkErrorWithRequest:(WLRequest *)request customMsg:(NSString *)customMsg;

@end

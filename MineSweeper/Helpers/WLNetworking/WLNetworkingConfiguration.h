//
//  WLNetworkingConfiguration.h
//  Welian_MVP
//
//  Created by weLian on 16/6/29.
//  Copyright © 2016年 杭州传送门网络科技有限公司. All rights reserved.
//

#ifndef WLNetworkingConfiguration_h
#define WLNetworkingConfiguration_h


/*! 进度block */
typedef void( ^ WLDownloadProgress)(int64_t bytesProgress,int64_t totalBytesProgress);

// 接口的全局超时时间
static NSTimeInterval kWLNetworkingTimeoutSeconds = 60.0f;
// 全局的cache过期时间，5分钟.过期后，会清除所有缓存
static NSTimeInterval kWLCacheOutdateTimeSeconds = 300.f;

/// 本地监控无网络时的错误通知提醒内容
static NSString *kNetworkNoContent = @"网络无法连接，正在加载中...";


/// --------- NSNotification -----------
///需要绑定手机号的通知
extern NSString *const kWLNeedBindPhoneNotification;
///需要完善信息的通知
extern NSString *const kWLNeedCompleteInfoNotification;
/// 网络连接无法连接
extern NSString *const kWLNetworkNoContentNotification;
/// 网络连接已恢复
extern NSString *const kWLNetworkReContentNotification;


#endif /* WLNetworkingConfiguration_h */

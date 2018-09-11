//
//  WLServiceInfo.h
//  Welian_MVP
//
//  Created by weLian on 16/6/29.
//  Copyright © 2016年 杭州传送门网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef WELIANST
static NSString *groupIdentifier = @"group.com.chuansongmen.welianST";
#elif WELIANPRO
static NSString *groupIdentifier = @"group.com.chuansongmen.welianPro";
#else
static NSString *groupIdentifier = @"group.com.chuansongmen.welian";
#endif

static NSString *httpServerUserDefaults = @"httpServer";
static NSString *isTestUserDefaults = @"isTest";

/**
 *  配置相关的信息
 */
@interface WLServiceInfo : NSObject

+ (instancetype)sharedServiceInfo;

- (void)popUpFavorableGuidance;

// 好评引导
@property (nonatomic, assign, readonly) BOOL favorableGuidanceBoole;

///---------------- 配置的信息------------

@property (nonatomic, assign, readonly) BOOL isTest;

///服务的地址
@property (nonatomic, copy, readonly) NSString *serviceBaseUrl;
///h5服务器地址
@property (nonatomic, copy, readonly) NSString *h5ServiceBaseUrl;

///阿里云 图片上传目录
@property (nonatomic, copy, readonly) NSString *ossBucket;
/// 阿里云 文件信息上传目录
@property (nonatomic, copy, readonly) NSString *ossFileBucket;

// 融云
@property (nonatomic, copy, readonly) NSString *rongCloudAppKey;
// 友盟
@property (nonatomic, copy, readonly) NSString *uMengAppKey;

// 七鱼客服
@property (nonatomic, copy, readonly) NSString *QYSDKAppKey;
@property (nonatomic, copy, readonly) NSString *QYSDKAppName;
// 客服问题模板id
@property (nonatomic, assign, readonly) int64_t QYWalletTemplateId;
@property (nonatomic, assign, readonly) int64_t QYInvestTemplateId;
@property (nonatomic, assign, readonly) int64_t QYLoginTemplateId;
// 客服组id
@property (nonatomic, assign, readonly) int64_t QYDefaultGroupId;
@property (nonatomic, assign, readonly) int64_t QYWalletGroupId;
@property (nonatomic, assign, readonly) int64_t QYInvestGroupId;
@property (nonatomic, assign, readonly) int64_t QYLoginGroupId;
// 魔窗
@property (nonatomic, copy, readonly) NSString *magicWindowAppKey;

// 微信分享
@property (nonatomic, copy, readonly) NSString *weChatAppId;
@property (nonatomic, copy, readonly) NSString *weChatAppSecret;

@property (nonatomic, copy, readonly) NSString *alipayAppScheme;
// App StoreID
@property (nonatomic, copy, readonly) NSString *appStoreID;

// 百度地图key
@property (nonatomic, copy, readonly) NSString *BMKKey;

@end

//
//  WLServiceInfo.m
//  Welian_MVP
//
//  Created by weLian on 16/6/29.
//  Copyright © 2016年 杭州传送门网络科技有限公司. All rights reserved.
//

#import "WLServiceInfo.h"
#import <StoreKit/StoreKit.h>

@interface WLServiceInfo()

// 好评引导
@property (nonatomic, assign, readwrite) BOOL favorableGuidanceBoole;

///---------------- 配置的信息------------
@property (nonatomic, assign, readwrite) BOOL isTest;

///服务的地址
@property (nonatomic, copy, readwrite) NSString *serviceBaseUrl;
///h5服务器地址
@property (nonatomic, copy, readwrite) NSString *h5ServiceBaseUrl;

///阿里云 图片上传目录
@property (nonatomic, copy, readwrite) NSString *ossBucket;
/// 阿里云 文件信息上传目录
@property (nonatomic, copy, readwrite) NSString *ossFileBucket;

// 融云

@property (nonatomic, copy, readwrite) NSString *rongCloudAppKey;

// 友盟
@property (nonatomic, copy, readwrite) NSString *uMengAppKey;

// 七鱼客服
@property (nonatomic, copy, readwrite) NSString *QYSDKAppKey;
@property (nonatomic, copy, readwrite) NSString *QYSDKAppName;
// 客服问题模板id
@property (nonatomic, assign, readwrite) int64_t QYWalletTemplateId;
@property (nonatomic, assign, readwrite) int64_t QYInvestTemplateId;
@property (nonatomic, assign, readwrite) int64_t QYLoginTemplateId;
// 客服组id
@property (nonatomic, assign, readwrite) int64_t QYDefaultGroupId;
@property (nonatomic, assign, readwrite) int64_t QYWalletGroupId;
@property (nonatomic, assign, readwrite) int64_t QYInvestGroupId;
@property (nonatomic, assign, readwrite) int64_t QYLoginGroupId;

// 魔窗
@property (nonatomic, copy, readwrite) NSString *magicWindowAppKey;

@property (nonatomic, copy, readwrite) NSString *weChatAppId;
@property (nonatomic, copy, readwrite) NSString *weChatAppSecret;

@property (nonatomic, copy, readwrite) NSString *alipayAppScheme;

// App StoreID
@property (nonatomic, copy, readwrite) NSString *appStoreID;

// 百度地图key
@property (nonatomic, copy, readwrite) NSString *BMKKey;

@end


@implementation WLServiceInfo

///实例化
+ (instancetype)sharedServiceInfo {
    static WLServiceInfo *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[WLServiceInfo alloc] init];
        NSUserDefaults *shareDefaults = [[NSUserDefaults alloc] initWithSuiteName:groupIdentifier];
        BOOL isTest = [shareDefaults boolForKey:isTestUserDefaults];
        sharedInstance.isTest = isTest;
        NSString *httpServer = [shareDefaults objectForKey:httpServerUserDefaults];
#ifdef WELIANST
        sharedInstance.weChatAppId = @"wx243964c9ec1c73e4";
        sharedInstance.weChatAppSecret = @"539ade18f1d1d870369e0fcc865ff4b2";
        
        sharedInstance.alipayAppScheme = @"AlipayWeLianST";
        sharedInstance.BMKKey = @"VUD2yOi03HyShZo4NBqTX9AOuIs1B4oi";
        sharedInstance.appStoreID = @"1232131699";
#elif WELIANPRO
        sharedInstance.weChatAppId = @"wx14cb03ecc615d838";
        sharedInstance.weChatAppSecret = @"3b2d3f9a31bbf4392a80e81507cdaf00";
        
        sharedInstance.alipayAppScheme = @"AlipayWeLianPro";
        sharedInstance.BMKKey = @"qgtmvcL0vnS2Tc587rb1BgwR2ajRilDg";
        sharedInstance.appStoreID = @"944154493";
#else
        sharedInstance.weChatAppId = @"wx5e4e9a58776baed3";
        sharedInstance.weChatAppSecret = @"1272e0c65919830d1fffa9ca098f6a72";
        
        sharedInstance.alipayAppScheme = @"AlipayWeLian";
        sharedInstance.BMKKey = @"qIW4r8CBSUtiKjtupTgflivqMX1F8O0r";
        sharedInstance.appStoreID = @"944154493";
#endif
        
        sharedInstance.QYSDKAppKey = @"283097b66d9e0ce7adc7ec410ca663a0";
        // 客服问题模板id
        sharedInstance.QYInvestTemplateId = 10071;
        sharedInstance.QYWalletTemplateId = 9009;
        sharedInstance.QYLoginTemplateId = 50020;
        
        sharedInstance.magicWindowAppKey = @"UDK8G0ZQ0M5GNLITC8GBK4NXDVHMG0IK";
        
        if (isTest) {
            sharedInstance.serviceBaseUrl = httpServer ? httpServer : @"https://test.cnsunrun.com/saoleiapp/";
//            sharedInstance.ossBucket = kWL_ossBucketTest;
//            sharedInstance.ossFileBucket = kWL_ossFileBucketTest;
            
            sharedInstance.rongCloudAppKey = @"lmxuhwagx82sd";
            sharedInstance.uMengAppKey = @"56ca9c0ee0f55a52970028bf";
            
            
#ifdef WELIANST
            sharedInstance.QYSDKAppName = @"welianSTDev";
#elif WELIANPRO
            sharedInstance.QYSDKAppName = @"welianProDev";
#else
            sharedInstance.QYSDKAppName = @"微链dev";
#endif
            
            sharedInstance.QYDefaultGroupId = 309612;
            sharedInstance.QYWalletGroupId = 309612;
            sharedInstance.QYInvestGroupId = 309612;
            sharedInstance.QYLoginGroupId = 309612;
//            sharedInstance.h5ServiceBaseUrl = kWL_H5ServiceUrlTest;
        }else{
            sharedInstance.serviceBaseUrl = httpServer ? httpServer : @"https://test.cnsunrun.com/saoleiapp/";
//            sharedInstance.ossBucket = kWL_ossBucket;
//            sharedInstance.ossFileBucket = kWL_ossFileBucket;
            
            sharedInstance.rongCloudAppKey = @"z3v5yqkbvojw0";
            sharedInstance.uMengAppKey = @"545c8c97fd98c59807006c67";
            
#ifdef WELIANST
            sharedInstance.QYSDKAppName = @"welianSTDis";
#elif WELIANPRO
            sharedInstance.QYSDKAppName = @"welianProDis";
#else
            sharedInstance.QYSDKAppName = @"微链";
#endif
            sharedInstance.QYDefaultGroupId = 337695;
            sharedInstance.QYWalletGroupId = 339432;
            sharedInstance.QYInvestGroupId = 398452;
            sharedInstance.QYLoginGroupId = 1240676;
//            sharedInstance.h5ServiceBaseUrl = kWL_H5ServiceUrl;
        }
        
        sharedInstance.favorableGuidanceBoole = NO;
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            if (![NSUserDefaults boolForKey:kWLAlreadyFavorableGuidanceBoole]) {
//                NSDate *lastTime = [NSUserDefaults objectForKey:kWLLastTimeStartApplicationDate];
//                [NSUserDefaults setObject:[NSDate date] forKey:kWLLastTimeStartApplicationDate];
//                if ([lastTime isYesterday]) {
//                    NSInteger count = [NSUserDefaults intForKey:kWLStartApplicationCount] + 1;
//                    [NSUserDefaults setInteger:count forKey:kWLStartApplicationCount];
//                    if (count >= 2) {
//                        sharedInstance.favorableGuidanceBoole = YES;
//                    }
//                }else {
//                    [NSUserDefaults setInteger:0 forKey:kWLStartApplicationCount];
//                }
//            }
//        });
        
    });
    return sharedInstance;
}

- (void)popUpFavorableGuidance {
    if ([WLServiceInfo sharedServiceInfo].favorableGuidanceBoole) {
        if (kSystemVersion >= 10.3) {
            [SKStoreReviewController requestReview];
            [WLServiceInfo sharedServiceInfo].favorableGuidanceBoole = NO;
//            [NSUserDefaults setBool:YES forKey:kWLAlreadyFavorableGuidanceBoole];
        }
    }
}

@end

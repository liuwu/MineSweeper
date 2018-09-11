//
//  WLSystemAuth.h
//  Welian
//
//  Created by 好迪 on 16/5/5.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//  系统硬件设备授权
//  iOS 8 以上 授权状态获取 需要修改！！！！！

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, WLSystemAuthType) {
    // 相机摄像头
    WLSystemAuthTypeCamera,
    // 相册
    WLSystemAuthTypePhotos,
    // 通讯录
    WLSystemAuthTypeContacts,
    // 位置
    WLSystemAuthTypeLocation,
    // 邮箱
    WLSystemAuthTypeEmail,
    // 网络
    WLSystemAuthTypeNetwork,
    /// 麦克风
    WLSystemAuthTypeMicrophone,
    /// 日历
    WLSystemAuthTypeEKEvent
};

typedef NS_ENUM(NSUInteger, WLSystemAuthStatus) {
    // 未授权，或者授权失败
    WLSystemAuthStatusUnknownError = 0 ,
    // 授权成功
    WLSystemAuthStatusAuthorized,
    // 其他状态
    WLSystemAuthStatusOther
};

@interface WLSystemAuth : NSObject<UIAlertViewDelegate>

+ (instancetype)shareInstance;

/**
 *  @author Haodi, 16-05-05 10:05:13
 *
 *  提供 welian app 系统授权，在未授权或者授权失败的状态 会显示AlertView  成功则不显示
 *
 *  @param authType 类型 WLSystemAuthTypeCamera ...
 *  @param handler  返回授权的状态 WLSystemAuthStatusAuth ...
 */
+ (void)showAlertWithAuthType:(WLSystemAuthType)authType completionHandler:(void (^)(WLSystemAuthStatus status))handler;

@end


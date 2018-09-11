//
//  WLShareTool.h
//  Welian
//
//  Created by dong on 2016/11/24.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WLActivity.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDK/SSDKTypeDefine.h>

/** 要分享的数据模型，必须是一一对应的已有数据模型*/
typedef NS_ENUM(NSInteger, WLActivityModelClass) {
    WLActivityModelClassMe = 14,                 /** 自己 -> WLUserDetailInfoModel */
    WLActivityModelClassStatus = 23,             /** 动态 -> WLTopicFeed */
    WLActivityModelClassEvent = 3,              /** 活动 -> IActivityInfo */
    WLActivityModelClassEventInvitation = 4,    /** 活动邀请函 -> image */
    WLActivityModelClassProject = 10,            /** 项目 -> IProjectDetailInfo */
    WLActivityModelClassTopic = 16,              /** 话题 -> WLTopicModel */
    WLActivityModelClassInvestor = 21,           /** 投资人 -> InvestorUserModel */
    WLActivityModelClassInvestorCard = 5,       /** 投资人名片 -> image */
    WLActivityModelClassWLApp = 1,              /** 微链应用 -> WLConfigTool */
    WLActivityModelClassProjectBP = 24,          /** 项目BP -> IProjectInfo */
    WLActivityModelClassWeb = 11,                /** 网页 ->  */
    WLActivityModelClassOTTservices = 6,        /** 第三方服务 ->  */
    WLActivityModelClassCourse = 25,            /** 课程 ->  */
//    WLActivityModelClassCourseMiniProgram = 26,            /** 课程微信小程序 ->  */
};

/** 事件类型，主要是分享事件. 自定义事件需要自己处理*/
typedef NS_OPTIONS(NSUInteger, WLActivityType) {
    WLActivityTypeCustom               =  0,        /** 自定义*/
    WLActivityTypeWLFriend             = 1 << 0,    /** 微链好友*/
    WLActivityTypeWLCircle             = 1 << 1,    /** 创业圈*/
    WLActivityTypeWXFriend             = 1 << 2,    /** 微信好友*/
    WLActivityTypeWXCircle             = 1 << 3,    /** 微信朋友圈*/
//    WLActivityTypeWXMiniProgram        = 1 << 4,    /** 微信小程序*/
    WLActivityTypeWLAll                = WLActivityTypeWLFriend | WLActivityTypeWLCircle,  /** 微链好友 创业圈*/
    WLActivityTypeWXAll                = WLActivityTypeWXFriend | WLActivityTypeWXCircle, /** 微信好友 微信朋友圈*/
    WLActivityTypeAll                  = WLActivityTypeWLAll | WLActivityTypeWXAll, /** 微链好友 创业圈 微信好友 微信朋友圈*/
};

/** 事件处理所需要的所有数据*/
@interface WLBlockModel : NSObject
/** 要分享的数据模型*/
@property (nonatomic, assign) WLActivityModelClass modelClass;
/** 必须根据modelClass传入对应的model*/
@property (nonatomic, strong) id dataModel;
/** 主要用于分享微信图片使用，可以为nil*/
@property (nonatomic, strong) UIImage *image;
/** 只用于项目BP分享微信朋友圈， 其他时候为nil*/
@property (nonatomic, copy) NSString *shareBPURL;

- (void)modelClass:(WLActivityModelClass)modelClass model:(id)model;
- (void)modelClass:(WLActivityModelClass)modelClass model:(id)model image:(UIImage *)image;

@end


@interface WLShareTool : NSObject
single_interface(WLShareTool)
/** 只自定义*/
- (void)showCustomActions:(NSArray <WLActivity *>*)customActions;
/** 只分享*/
- (void)showActivityWithType:(WLActivityType)type completion:(void(^)(WLBlockModel *blockModel))completion;
/** 分享加自定义*/
- (void)showActivityWithType:(WLActivityType)type customActions:(NSArray <WLActivity *>*)customActions completion:(void(^)(WLBlockModel *blockModel))completion;

/** 分享加自定义*/
- (void)showActivityWithTitle:(NSAttributedString *)title shareActions:(NSArray <WLActivity *>*)shareActions customActions:(NSArray <WLActivity *>*)customActions;

/** 不带UI分享事件触发*/
- (void)activityHandlerWithType:(WLActivityType)type completion:(void(^)(WLBlockModel *blockModel))completion;

// 分享到微信
- (void)activityWXImage:(id)image forPlatformSubType:(SSDKPlatformType)platformSubType;

- (void)activityWXWebPageWithTitle:(NSString *)title description:(NSString *)description thumbImage:(id)thumbImage shareURLStr:(NSString *)shareURLStr forPlatformSubType:(SSDKPlatformType)platformSubType;

- (void)activityWXMiniprogram:(NSString *)title description:(NSString *)description thumbImage:(id)thumbImage shareURLStr:(NSString *)shareURLStr miniprogramPage:(NSString *)miniprogramPage miniprogramUsername:(NSString *)miniprogramUsername;

- (void)activityWXFriendWithTitle:(NSString *)title description:(NSString *)description thumbImage:(id)thumbImage shareURLStr:(NSString *)shareURLStr image:(id)image miniprogramPage:(NSString *)miniprogramPage miniprogramUsername:(NSString *)miniprogramUsername type:(SSDKContentType)type forPlatformSubType:(SSDKPlatformType)platformSubType;
@end

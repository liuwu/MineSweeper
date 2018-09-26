//
//  WLRongCloudDataSource.h
//  Welian
//
//  Created by weLian on 15/10/12.
//  Copyright © 2015年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RongIMKit/RongIMKit.h>

@class IFriendModel,IGameGroupModel;

#define RCDDataSource [WLRongCloudDataSource shareInstance]

/**
 *  用户信息和群组信息都要通过回传id请求服务器获取。
 */
@interface WLRongCloudDataSource : NSObject<RCIMUserInfoDataSource,RCIMGroupInfoDataSource, RCIMGroupMemberDataSource>


+ (WLRongCloudDataSource *)shareInstance;

//获取本地用户信息
- (void)getLocalUserInfoWithUserId:(NSString*)userId completion:(void (^)(IFriendModel*))completion;
//获取本地群组信息
- (void)getLocalGroupInfoWithGroupId:(NSString*)groupId completion:(void (^)(IGameGroupModel*))completion;
// 刷新融云用户基本信息
- (void)refreshLogUserInfoCache:(IFriendModel *)profileM;
@end

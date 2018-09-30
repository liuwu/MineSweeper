//
//  WLRongCloudDataSource.m
//  Welian
//
//  Created by weLian on 15/10/12.
//  Copyright © 2015年 chuansongmen. All rights reserved.
//

#import "WLRongCloudDataSource.h"

#import "IFriendModel.h"
#import "ILoginUserModel.h"
#import "IFriendDetailInfoModel.h"

#import "IGameGroupModel.h"
#import "IGroupDetailInfo.h"

#import "FriendModelClient.h"
#import "ImGroupModelClient.h"

//#import "WLUserModel.h"
//#import "IGroupChatInfo.h"

//#import "WLChatInfoDataCenter.h"
//#import "WLUserDataCenter.h"
//
//#import "WLUserModuleClient.h"
//#import "WLChatModuleClient.h"
//#import "WLChatModuleClient.h"

@implementation WLRongCloudDataSource

+ (WLRongCloudDataSource *)shareInstance
{
    static WLRongCloudDataSource *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}


#pragma mark - Private
//获取本地用户信息
- (void)getLocalUserInfoWithUserId:(NSString*)userId completion:(void (^)(IFriendModel*))completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        DLog(@"getUserInfoWithUserId ----- %@", userId);
        // 此处最终代码逻辑实现需要您从本地缓存或服务器端获取用户信息。
        IFriendModel *user = nil;
        if (userId == nil || [userId length] == 0)
        {
            user = [IFriendModel new];
            user.uid = userId;
            user.avatar = @"";
            user.nickname = @"";
            user.mobile = @"";
            user.remark = @"";
            completion(user);
            return ;
        }
        ILoginUserModel *loginUser = configTool.loginUser;
        //自己的用户信息
        if (userId.longLongValue == loginUser.uid.longLongValue) {
            user = [IFriendModel new];
            user.uid = loginUser.uid;
            user.nickname = loginUser.username.length > 0 ? loginUser.username : loginUser.mobile;
            if (configTool.userInfoModel) {
                user.avatar = configTool.userInfoModel.avatar;
                user.nickname = configTool.userInfoModel.nickname.length > 0 ? configTool.userInfoModel.nickname : configTool.userInfoModel.mobile;
            }
            return completion(user);
        }
//        //调用接口刷新数据
        NSDictionary *params = @{@"uid" : @(userId.longLongValue)};
//        WEAKSELF
        [FriendModelClient getImMemberInfoWithParams:params Success:^(id resultInfo) {
//            IFriendDetailInfoModel *userModel = [IFriendDetailInfoModel modelWithDictionary:resultInfo];
            IFriendModel *userModel = [IFriendModel modelWithDictionary:resultInfo];
            return completion(userModel);
        } Failed:^(NSError *error) {
            return completion(nil);
            DLog(@"getMember error:%@",error.localizedDescription);
        }];
    });
}

//获取本地群组信息
- (void)getLocalGroupInfoWithGroupId:(NSString*)groupId completion:(void (^)(IGameGroupModel*))completion {
    IGameGroupModel *group;
    if (groupId == nil || [groupId length] == 0)
    {
        group = [IGameGroupModel new];
        group.groupId = groupId;
        return completion(group);
    }
    
    [ImGroupModelClient getImGroupInfoWithParams:@{@"id" : @(groupId.integerValue)}
                                         Success:^(id resultInfo) {
                                             IGameGroupModel *group = [IGameGroupModel new];
                                             group.groupId = groupId;
                                             IGroupDetailInfo *groupDetailInfo = [IGroupDetailInfo modelWithDictionary:resultInfo];
                                             group.title = groupDetailInfo.title;
                                             group.image = groupDetailInfo.image;
                                             return completion(group);
                                         } Failed:^(NSError *error) {
                                             [WLHUDView hiddenHud];
                                             return completion(nil);
                                             DLog(@"getGroup error:%@",error.localizedDescription);
                                         }];
}

#pragma mark - GroupInfoFetcherDelegate
- (void)getGroupInfoWithGroupId:(NSString*)groupId completion:(void (^)(RCGroup*))completion {
//    RCGroup *group;
    if (groupId == nil || [groupId length] == 0) {
        return completion(nil);
    }
    //开发者调自己的服务器接口根据userID异步请求数据
    [ImGroupModelClient getImGroupInfoWithParams:@{@"id" : @(groupId.integerValue)}
                                         Success:^(id resultInfo) {
                                             RCGroup *group = [RCGroup new];
                                             group.groupId = groupId;
                                             IGroupDetailInfo *groupDetailInfo = [IGroupDetailInfo modelWithDictionary:resultInfo];
                                             group.groupName = groupDetailInfo.title;
                                             [[RCIM sharedRCIM] refreshGroupInfoCache:group withGroupId:groupId];
                                             group.portraitUri = groupDetailInfo.image;
//                                             group.portraitUri = [groupInfo.logo wl_imageUrlDownloadImageSceneAvatar];
                                             return completion(group);
                                         } Failed:^(NSError *error) {
                                             [WLHUDView hiddenHud];
                                             return completion(nil);
                                             DLog(@"getGroup error:%@",error.localizedDescription);
                                         }];
}

#pragma mark - RCIMUserInfoDataSource
- (void)getUserInfoWithUserId:(NSString*)userId completion:(void (^)(RCUserInfo*))completion {
    if (userId == nil || [userId length] == 0) {
        return completion(nil);
    }
    RCUserInfo *user = [RCUserInfo new];
    
    ILoginUserModel *loginUser = configTool.loginUser;
    //自己的用户信息
    if (userId.longLongValue == loginUser.uid.longLongValue) {
        user = [RCUserInfo new];
        user.userId = loginUser.uid;
        //            user.avatar = loginUser.a;
        user.name = loginUser.username.length > 0 ? loginUser.username : loginUser.mobile;
        if (configTool.userInfoModel) {
            user.portraitUri = configTool.userInfoModel.avatar;
            user.name = configTool.userInfoModel.nickname.length > 0 ? configTool.userInfoModel.nickname : configTool.userInfoModel.mobile;
        }
        return completion(user);
    }
    
    NSDictionary *params = @{@"uid" : @(userId.integerValue)};
    //        WEAKSELF
    [FriendModelClient getImMemberInfoWithParams:params Success:^(id resultInfo) {
        //            IFriendDetailInfoModel *userModel = [IFriendDetailInfoModel modelWithDictionary:resultInfo];
        IFriendModel *userModel = [IFriendModel modelWithDictionary:resultInfo];
//        return completion(userModel);
        
        RCUserInfo *user = [[RCUserInfo alloc]init];
        user.userId = userModel.uid;
        user.name = userModel.nickname;
//        user.portraitUri = [userModel.avatar wl_imageUrlDownloadImageSceneAvatar];
        user.portraitUri = userModel.avatar;
        [[RCIM sharedRCIM] refreshUserInfoCache:user withUserId:userId];
//        [[WLUserDataCenter sharedInstance] saveUserWithInfo:userModel isAsync:YES];
        return completion(user);
    } Failed:^(NSError *error) {
        return completion(nil);
        DLog(@"getMember error:%@",error.localizedDescription);
    }];
}

- (void)getAllMembersOfGroup:(NSString *)groupId result:(void (^)(NSArray<NSString *> *))resultBlock {
//    [WLChatModuleClient getGroupUserListWithId:groupId.numberValue Keyword:@"" Page:@(1) Size:@(3000) Success:^(id resultInfo) {
//        NSArray *users = [NSArray arrayWithArray:resultInfo];
//        NSMutableSet *setM = [NSMutableSet setWithCapacity:users.count];
//        for (WLUserModel *userM in users) {
//            if (!userM.uid.stringValue) continue;
//            [setM addObject:userM.uid.stringValue];
//        }
//        resultBlock([setM allObjects]);
//    } Failed:^(NSError *error) {
//
//    }];
}


- (void)refreshLogUserInfoCache:(IUserInfoModel *)profileM {
    RCUserInfo *user = [[RCUserInfo alloc]init];
    user.userId = profileM.userId;
    user.name = profileM.nickname.length > 0 ? profileM.nickname : profileM.mobile;
    user.portraitUri = profileM.avatar;
    [[RCIM sharedRCIM] refreshUserInfoCache:user withUserId:user.userId];
}


@end

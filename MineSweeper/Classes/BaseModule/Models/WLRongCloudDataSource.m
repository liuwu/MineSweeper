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
//            user.avatar = loginUser.a;
            user.nickname = loginUser.username.length > 0 ? loginUser.username : loginUser.mobile;
            if (configTool.userInfoModel) {
                user.avatar = configTool.userInfoModel.avatar;
                user.nickname = configTool.userInfoModel.nickname;
            }
            return completion(user);
        }
//        //判断好友里面是否有用户信息
//        WLUserModel *userModel = [[WLUserDataCenter sharedInstance] getUserModelWithUid:@(userId.longLongValue)];
//        if (userModel) {
//            //调用接口刷新数据
//            [WLUserModuleClient getMemberWithUid:@(userId.longLongValue) Success:^(id resultInfo) {
//                //保存用户信息
//                WLUserModel *userModel = [WLUserModel modelWithDictionary:resultInfo];
//                [[WLUserDataCenter sharedInstance] saveUserWithInfo:userModel isAsync:YES];
//            } Failed:^(NSError *error) {
//                DLog(@"getMember error:%@",error.localizedDescription);
//            }];
//
//            return completion(userModel);
//        }
//
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
        
//        [WLUserModuleClient getMemberWithUid:@(userId.longLongValue) Success:^(id resultInfo) {
//            //保存用户信息
//            WLUserModel *userModel = [WLUserModel modelWithDictionary:resultInfo];
//            [[WLUserDataCenter sharedInstance] saveUserWithInfo:userModel isAsync:YES];
//
//            return completion(userModel);
//        } Failed:^(NSError *error) {
//            return completion(nil);
//            DLog(@"getMember error:%@",error.localizedDescription);
//        }];
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
                                             
                                         } Failed:^(NSError *error) {
                                             [WLHUDView hiddenHud];
                                             return completion(nil);
                                             DLog(@"getGroup error:%@",error.localizedDescription);
                                         }];
    
//
//    //从数据库查询
//    group = [[WLChatInfoDataCenter sharedInstance] getGroupChatInfoWithChatID:@(groupId.longLongValue)];
//    if (group) {
//        //获取当前群组信息
//        [WLChatModuleClient getGroupInfoWithId:@(groupId.longLongValue) Ismemberlogos:@(2) Success:^(id resultInfo) {
//            IGroupChatInfo *groupInfo = resultInfo;
//            // 保存数据
//            [[WLChatInfoDataCenter sharedInstance] saveGroupChatInfoWithInfo:groupInfo];
//        } Failed:^(NSError *error) {
//            DLog(@"融云回调获取群聊信息失败");
//        }];
//        return completion(group);
//    }else{
//        //如果本地没有数据，调用接口获取
//        [WLChatModuleClient getGroupInfoWithId:@(groupId.longLongValue) Ismemberlogos:@(2) Success:^(id resultInfo) {
//            IGroupChatInfo *groupInfo = resultInfo;
//            // 保存数据
//            [[WLChatInfoDataCenter sharedInstance] saveGroupChatInfoWithInfo:groupInfo];
//            return completion(groupInfo);
//        } Failed:^(NSError *error) {
//            IGroupChatInfo *group = [IGroupChatInfo new];
//            group.groupchatid = @(groupId.longLongValue);
//            return completion(group);
//        }];
//    }
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
//                                             group.groupName = groupInfo.name;
//                                             group.portraitUri = [groupInfo.logo wl_imageUrlDownloadImageSceneAvatar];
                                             return completion(group);
                                         } Failed:^(NSError *error) {
                                             [WLHUDView hiddenHud];
                                             return completion(nil);
                                             DLog(@"getGroup error:%@",error.localizedDescription);
                                         }];
    
    //从数据库查询
//    IGroupChatInfo *iGroupChatInfo = [[WLChatInfoDataCenter sharedInstance] getGroupChatInfoWithChatID:@(groupId.longLongValue)];
//    if (iGroupChatInfo) {
//        group = [RCGroup new];
//        group.groupId = groupId;
//        group.groupName = iGroupChatInfo.name;
//        group.portraitUri = [iGroupChatInfo.logo wl_imageUrlDownloadImageSceneAvatar];
//        //获取当前群组信息
//        [WLChatModuleClient getGroupInfoWithId:@(groupId.longLongValue) Ismemberlogos:@(2) Success:^(id resultInfo) {
//            IGroupChatInfo *groupInfo = resultInfo;
//            // 保存数据
//            [[WLChatInfoDataCenter sharedInstance] saveGroupChatInfoWithInfo:groupInfo];
//        } Failed:^(NSError *error) {
//            DLog(@"融云回调获取群聊信息失败");
//        }];
//        return completion(group);
//    }else{
//        //如果本地没有数据，调用接口获取
//        [WLChatModuleClient getGroupInfoWithId:@(groupId.longLongValue) Ismemberlogos:@(2) Success:^(id resultInfo) {
//            IGroupChatInfo *groupInfo = resultInfo;
//            // 保存数据
//            [[WLChatInfoDataCenter sharedInstance] saveGroupChatInfoWithInfo:groupInfo];
//
//            RCGroup *group = [RCGroup new];
//            group.groupId = groupId;
//            group.groupName = groupInfo.name;
//            group.portraitUri = [groupInfo.logo wl_imageUrlDownloadImageSceneAvatar];
//            return completion(group);
//        } Failed:^(NSError *error) {
//            return completion(nil);
//        }];
//    }
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
            user.name = configTool.userInfoModel.nickname;
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
//        [[WLUserDataCenter sharedInstance] saveUserWithInfo:userModel isAsync:YES];
        return completion(user);
    } Failed:^(NSError *error) {
        return completion(nil);
        DLog(@"getMember error:%@",error.localizedDescription);
    }];
    
//        //判断好友里面是否有用户信息
//    WLUserModel *userModel = [[WLUserDataCenter sharedInstance] getUserModelWithUid:@(userId.longLongValue)];
//    if (userModel) {
//        user = [RCUserInfo new];
//        user.userId = [NSString stringWithFormat:@"%@",userModel.uid];
//        user.name = userModel.name;
//        user.portraitUri = [userModel.avatar wl_imageUrlDownloadImageSceneAvatar];
//        //调用接口刷新数据
//        [WLUserModuleClient getMemberWithUid:@(userId.longLongValue) Success:^(id resultInfo) {
//            //保存用户信息
//            WLUserModel *userModel = [WLUserModel modelWithDictionary:resultInfo];
//
//            RCUserInfo *user = [[RCUserInfo alloc]init];
//            user.userId = userModel.uid.stringValue;
//            user.name = userModel.name;
//            user.portraitUri = [userModel.avatar wl_imageUrlDownloadImageSceneAvatar];
//
//            [[WLUserDataCenter sharedInstance] saveUserWithInfo:userModel isAsync:YES];
//            [[RCIM sharedRCIM] refreshUserInfoCache:user withUserId:user.userId];
//        } Failed:^(NSError *error) {}];
//
//        return completion(user);
//    }else{
//        //调用接口刷新数据
//        [WLUserModuleClient getMemberWithUid:@(userId.longLongValue) Success:^(id resultInfo) {
//            //保存用户信息
//            WLUserModel *userModel = [WLUserModel modelWithDictionary:resultInfo];
//
//            RCUserInfo *user = [[RCUserInfo alloc]init];
//            user.userId = userModel.uid.stringValue;
//            user.name = userModel.name;
//            user.portraitUri = [userModel.avatar wl_imageUrlDownloadImageSceneAvatar];
//
//            [[WLUserDataCenter sharedInstance] saveUserWithInfo:userModel isAsync:YES];
//            return completion(user);
//        } Failed:^(NSError *error) {}];
//    }
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


- (void)refreshLogUserInfoCache:(IFriendModel *)profileM {
    RCUserInfo *user = [[RCUserInfo alloc]init];
    user.userId = profileM.uid;
    user.name = profileM.nickname;
    user.portraitUri = profileM.avatar;
    [[RCIM sharedRCIM] refreshUserInfoCache:user withUserId:user.userId];
}


@end

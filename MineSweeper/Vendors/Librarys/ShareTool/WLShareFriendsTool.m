//
//  WLShareFriendsTool.m
//  Welian
//
//  Created by dong on 2016/11/25.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import "WLShareFriendsTool.h"
#import "NavViewController.h"
#import "CardAlertView.h"
#import "CustomCardMessage.h"

@interface WLShareFriendsTool ()

@property (nonatomic, weak) UIViewController *controller;
@property (nonatomic, weak) ShareFriendsController *shareFriendsVC;

@end

@implementation WLShareFriendsTool
single_implementation(WLShareFriendsTool)

- (void)shareFriendsWithImage:(UIImage *)image {
    WLLoginJudgePresenter
    ShareFriendsController *shareFriendsVC = [[ShareFriendsController alloc] init];
    [self.controller presentViewController:[[NavViewController alloc] initWithRootViewController:shareFriendsVC] animated:YES completion:^{
    }];
    @weakify(self)
    [shareFriendsVC setSelectFriendBlock:^(){
        @strongify(self)
        [self shareToWeLianFriendWithImage:image];
    }];
    [shareFriendsVC setDismisCancelBlock:^(){}];
    self.shareFriendsVC = shareFriendsVC;
}

- (void)shareFriendsWithModel:(CardStatuModel *)cardStatuModel {
    ShareFriendsController *shareFriendsVC = [[ShareFriendsController alloc] init];
    [self.controller presentViewController:[[NavViewController alloc] initWithRootViewController:shareFriendsVC] animated:YES completion:^{}];
    @weakify(self)
    [shareFriendsVC setSelectFriendBlock:^(){
        @strongify(self)
        [self shareToWeLianFriendWithCardStatuModel:cardStatuModel];
    }];
    self.shareFriendsVC = shareFriendsVC;
}

- (void)shareToWeLianFriendWithImage:(UIImage *)image {
    WLUserModel *friendUser = self.shareFriendsVC.friendUser;
    IGroupChatInfo *iGroupChatInfo = self.shareFriendsVC.iGroupChatInfo;
    if (!(friendUser || iGroupChatInfo) || !image) {
        [WLHUDView showAttentionHUD:@"分享参数有误"];
        return;
    }
    BOOL isFriendUser = (nil != friendUser);
    NSString *name = isFriendUser ? friendUser.name : iGroupChatInfo.name;
    @weakify(self)
    [[LGAlertView alertViewWithTitle:[NSString stringWithFormat:@"确定分享给%@？",name]  message:nil style:LGAlertViewStyleAlert buttonTitles:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" actionHandler:nil cancelHandler:nil destructiveHandler:^(LGAlertView *alertView) {
        @strongify(self)
        [self sendRCIMImageWithUserInfo:friendUser IGroupChatInfo:iGroupChatInfo Image:image];
    }] showAnimated:YES completionHandler:nil];
}

- (void)sendRCIMImageWithUserInfo:(WLUserModel *)friendUser IGroupChatInfo:(IGroupChatInfo *)iGroupChatInfo Image:(UIImage *)image {
    
    RCConversationType conversationType = friendUser ? ConversationType_PRIVATE : ConversationType_GROUP;
    NSString *targetId = friendUser ? friendUser.uid.stringValue : iGroupChatInfo.groupchatid.stringValue;
    RCImageMessage *rcImage = [RCImageMessage messageWithImage:image];
    rcImage.full = YES;
    [[RCIM sharedRCIM] sendMediaMessage:conversationType targetId:targetId content:rcImage pushContent:@"图片" pushData:nil progress:nil success:^(long messageId) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [WLHUDView showSuccessHUD:@"已发送"];
        });
    } error:^(RCErrorCode errorCode, long messageId) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [WLHUDView showErrorHUD:@"发送失败"];
        });
    } cancel:^(long messageId) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [WLHUDView showAttentionHUD:@"已取消发送"];
        });
    }];
    [self.shareFriendsVC.searchVC dismissViewControllerAnimated:NO completion:nil];
    [self.shareFriendsVC.navigationController dismissViewControllerAnimated:YES completion:^{
        self.shareFriendsVC = nil;
    }];
}


//分享到微链好友
- (void)shareToWeLianFriendWithCardStatuModel:(CardStatuModel *)cardModel
{
    CardAlertView *alertView = [[CardAlertView alloc] initWithCardModel:cardModel];
    [alertView show];
    @weakify(self)
    [alertView setSendSuccessBlock:^(NSString *text, CardStatuModel *cardModel){
        @strongify(self)
        [self sendCardMessageToFriend:text cardModel:cardModel];
    }];
}


//发送卡片消息给好友
- (void)sendCardMessageToFriend:(NSString *)text cardModel:(CardStatuModel *)cardModel
{
    WLUserModel *friendUser = self.shareFriendsVC.friendUser;
    IGroupChatInfo *iGroupChatInfo = self.shareFriendsVC.iGroupChatInfo;
    if (!(friendUser || iGroupChatInfo)) {
        [WLHUDView showAttentionHUD:@"分享参数有误"];
        return;
    }
    BOOL isFriendUser = (nil != friendUser);
    cardModel.content = text?:@"";
    NSDictionary *cardDic = [cardModel modelToJSONObject];
    WLUserDetailInfoModel *loguser = configTool.loginUser;
    CustomCardMessage *cardMessage = [[CustomCardMessage alloc] init];
    cardMessage.fromuser = @{@"name":loguser.name,@"uid":loguser.uid.stringValue,@"avatar":loguser.avatar};
    cardMessage.card = cardDic;
    cardMessage.touser = isFriendUser ? friendUser.uid.stringValue : iGroupChatInfo.groupchatid.stringValue;
    cardMessage.msg = text;
    
    NSString *nameStr = isFriendUser?[NSString stringWithFormat:@"%@向你",loguser.name] : loguser.name;
    NSString *pushStr = [NSString stringWithFormat:@"%@%@", nameStr, cardMessage.conversationDigest];
    RCConversationType conversationType = isFriendUser ? ConversationType_PRIVATE : ConversationType_GROUP;
    NSString *targetId = isFriendUser ? friendUser.uid.stringValue : iGroupChatInfo.groupchatid.stringValue;
    
    [[RCIM sharedRCIM] sendMessage:conversationType targetId:targetId content:cardMessage pushContent:pushStr pushData:nil success:^(long messageId) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [WLHUDView showSuccessHUD:@"分享成功"];
        });
   } error:^(RCErrorCode nErrorCode, long messageId) {
       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
           [[RCIMClient sharedRCIMClient] deleteMessages:@[@(messageId)]];
           [WLHUDView showErrorHUD:@"分享失败"];
       });
   }];
    [self.shareFriendsVC.searchVC dismissViewControllerAnimated:NO completion:nil];
    [self.shareFriendsVC.navigationController dismissViewControllerAnimated:YES completion:^{
        self.shareFriendsVC = nil;
    }];
}

- (UIViewController *)controller {
    UIViewController *activeController = [UIApplication sharedApplication].keyWindow.rootViewController;
    if (activeController.presentedViewController) {
        activeController = activeController.presentedViewController;
    }
    return activeController;
}

@end

//
//  WLShareTool.m
//  Welian
//
//  Created by dong on 2016/11/24.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import "WLShareTool.h"
#import "WLActivityView.h"
#import "ShareFriendsController.h"
#import "WLPublishStatusTool.h"
#import <ShareSDK/ShareSDK.h>

#import "WLTopicStatusModel.h"
#import "IActivityInfo.h"
#import "InvestorUserModel.h"
#import "WLTopicModel.h"
#import "IProjectDetailInfo.h"
#import "IInvestIndustryModel.h"
#import "IProjectInfo.h"
#import "ITouTiaoModel.h"
#import "WLCourseModel.h"

#import "WLShareFriendsTool.h"

#import "WLUserBehaviorLog.h"
#import "WLAccessControlPresenter.h"

@implementation WLShareTool
single_implementation(WLShareTool)

- (void)showCustomActions:(NSArray <WLActivity *>*)customActions {
    [self showActivityWithType:WLActivityTypeCustom customActions:customActions completion:nil];
}
/// 分享
- (void)showActivityWithType:(WLActivityType)type completion:(void(^)(WLBlockModel *blockModel))completion {
    [self showActivityWithType:type customActions:nil completion:completion];
}
/// 自定义加分享
- (void)showActivityWithType:(WLActivityType)type customActions:(NSArray <WLActivity *>*)customActions completion:(void(^)(WLBlockModel *blockModel))completion {
    [self showActivityWithTitle:nil activityType:type customActions:customActions completion:completion];
}


- (void)showActivityWithTitle:(NSAttributedString *)title activityType:(WLActivityType)type customActions:(NSArray <WLActivity *>*)customActions completion:(void(^)(WLBlockModel *blockModel))completion {
    
    NSMutableArray *shareArrayM = [NSMutableArray arrayWithCapacity:4];
    @weakify(self)
    if (type & WLActivityTypeWLFriend) {
        WLActivity *activity = [WLActivity activityWithTitle:@"微链好友" image:[UIImage imageNamed:@"share_welianfriend.png"] handler:^{
            @strongify(self)
            [self activityHandlerWithType:WLActivityTypeWLFriend completion:completion];
        }];
        [shareArrayM addObject:activity];
    }
    if (type & WLActivityTypeWLCircle) {
        WLActivity *activity = [WLActivity activityWithTitle:@"创业圈" image:[UIImage imageNamed:@"share_welian.png"] handler:^{
            @strongify(self)
            [self activityHandlerWithType:WLActivityTypeWLCircle completion:completion];
        }];
        [shareArrayM addObject:activity];
    }
    if (type & WLActivityTypeWXFriend) {
        WLActivity *activity = [WLActivity activityWithTitle:@"微信好友" image:[UIImage imageNamed:@"share_wechat.png"] handler:^{
            @strongify(self)
            [self activityHandlerWithType:WLActivityTypeWXFriend completion:completion];
        }];
        [shareArrayM addObject:activity];
    }
    if (type & WLActivityTypeWXCircle) {
        WLActivity *activity = [WLActivity activityWithTitle:@"微信朋友圈" image:[UIImage imageNamed:@"share_friendcircle.png"] handler:^{
            @strongify(self)
            [self activityHandlerWithType:WLActivityTypeWXCircle completion:completion];
        }];
        [shareArrayM addObject:activity];
    }
    [self showActivityWithTitle:title shareActions:shareArrayM customActions:customActions];
}

- (void)showActivityWithTitle:(NSAttributedString *)title shareActions:(NSArray <WLActivity *>*)shareActions customActions:(NSArray <WLActivity *>*)customActions {
    WLActivityView *activityView = [[WLActivityView alloc] initWithTitle:title oneSectionArray:shareActions andTwoArray:customActions];
    [activityView show];
}

- (void)activityHandlerWithType:(WLActivityType)type completion:(void(^)(WLBlockModel *blockModel))completion {
    if (!(type & WLActivityTypeWXAll)) {
        WLLoginJudgePresenter
    }
    NSAssert(completion, @"WLBlockModel未赋值");
    if (!completion) return;
    WLBlockModel *model = [WLBlockModel new];
    completion(model);
    switch (model.modelClass) {
        case WLActivityModelClassMe:
            [self shareMeWithModelClass:model activityType:type];
            break;
        case WLActivityModelClassStatus:
            [self shareStatusWithModelClass:model activityType:type];
            break;
        case WLActivityModelClassEvent:
            [self shareEventWithModelClass:model activityType:type];
            break;
        case WLActivityModelClassEventInvitation:
            [self shareEventInvitationWithModelClass:model activityType:type];
            break;
        case WLActivityModelClassProject:
            [self shareProjectWithModelClass:model activityType:type];
            break;
        case WLActivityModelClassTopic:
            [self shareTopicWithModelClass:model activityType:type];
            break;
        case WLActivityModelClassWeb:
            [self shareWebWithModelClass:model activityType:type];
            break;
        case WLActivityModelClassInvestor:
            [self shareInvestorWithModelClass:model activityType:type];
            break;
        case WLActivityModelClassInvestorCard:
            [self shareInvestorCardWithModelClass:model activityType:type];
            break;
        case WLActivityModelClassWLApp:
            [self shareWLAppWithModelClass:model activityType:type];
            break;
        case WLActivityModelClassProjectBP:
            [self shareProjectBPWithModelClass:model activityType:type];
            break;
        case WLActivityModelClassOTTservices:
            [self shareOTTservicesWithModelClass:model activityType:type];
            break;
        case WLActivityModelClassCourse:
            [self shareCourseWithModelClass:model activityType:type];
            break;
        default:
            break;
    }
    completion = nil;
}

- (void)activityWXWebPageWithTitle:(NSString *)title description:(NSString *)description thumbImage:(id)thumbImage shareURLStr:(NSString *)shareURLStr forPlatformSubType:(SSDKPlatformType)platformSubType {
    [self activityWXFriendWithTitle:title description:description thumbImage:thumbImage shareURLStr:shareURLStr image:nil miniprogramPage:nil miniprogramUsername:nil type:SSDKContentTypeWebPage forPlatformSubType:platformSubType];
}

- (void)activityWXImage:(id)image forPlatformSubType:(SSDKPlatformType)platformSubType {
    [self activityWXFriendWithTitle:nil description:nil thumbImage:nil shareURLStr:nil image:image miniprogramPage:nil miniprogramUsername:nil type:SSDKContentTypeImage forPlatformSubType:platformSubType];
}

- (void)activityWXMiniprogram:(NSString *)title description:(NSString *)description thumbImage:(id)thumbImage shareURLStr:(NSString *)shareURLStr miniprogramPage:(NSString *)miniprogramPage miniprogramUsername:(NSString *)miniprogramUsername {
    [self activityWXFriendWithTitle:title description:description thumbImage:thumbImage shareURLStr:shareURLStr image:nil miniprogramPage:miniprogramPage miniprogramUsername:miniprogramUsername type:SSDKContentTypeMiniProgram forPlatformSubType:SSDKPlatformSubTypeWechatSession];
}

- (void)activityWXFriendWithTitle:(NSString *)title description:(NSString *)description thumbImage:(id)thumbImage shareURLStr:(NSString *)shareURLStr image:(id)image miniprogramPage:(NSString *)miniprogramPage miniprogramUsername:(NSString *)miniprogramUsername type:(SSDKContentType)type forPlatformSubType:(SSDKPlatformType)platformSubType {
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    if (!shareURLStr || !shareURLStr.length) {
        shareURLStr = @"http://www.welian.com";
    }
    thumbImage = thumbImage?:@"";
    NSURL *shareURL = [NSURL URLWithString:shareURLStr];
    if (type == SSDKContentTypeMiniProgram) {
        if ([thumbImage isKindOfClass:[NSString class]]) {
            thumbImage = [thumbImage wl_imageUrlManageScene:WLDownloadImageSceneBig condenseSize:CGSizeZero];
        }
        
        [shareParams SSDKSetupWeChatParamsByTitle:title description:description webpageUrl:shareURL path:miniprogramPage thumbImage:thumbImage userName:miniprogramUsername forPlatformSubType:SSDKPlatformSubTypeWechatSession];
    }else{
        if ([thumbImage isKindOfClass:[NSString class]]) {
            thumbImage = [thumbImage wl_imageUrlDownloadImageSceneAvatar];
        }
        [shareParams SSDKSetupWeChatParamsByText:description title:title url:shareURL thumbImage:thumbImage image:image musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:type forPlatformSubType:platformSubType];
    }
    [ShareSDK share:platformSubType parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        switch (state) {
            case SSDKResponseStateSuccess:
                [WLHUDView showSuccessHUD:@"分享成功！"];
                break;
            case SSDKResponseStateFail:
                [WLHUDView showAttentionHUD:error.userInfo[@"error_message"]];
                break;
            case SSDKResponseStateCancel:
                
                break;
            default:
                break;
        }
    }];
}

/// 分享自己名片
- (void)shareMeWithModelClass:(WLBlockModel *)model activityType:(WLActivityType)type{
    NSAssert([model.dataModel isKindOfClass:[WLUserDetailInfoModel class]], @"分享动态，缺少对应");
    if (![model.dataModel isKindOfClass:[WLUserDetailInfoModel class]]) return;
    WLUserDetailInfoModel *user = model.dataModel;
    NSString *title = user.name?[NSString stringWithFormat:@"%@的微链名片",user.name]:@"微链名片";
    
    NSString *description = [NSString stringWithFormat:@"%@\n%@\n%@",[user dispalyCompanyAndPosition]?:@"",user.cityname?:@"",user.mobile?:@""];
    switch (type) {
        case WLActivityTypeWXFriend:
            [self activityWXWebPageWithTitle:title description:description thumbImage:user.avatar shareURLStr:user.shareurl forPlatformSubType:SSDKPlatformSubTypeWechatSession];
            
            break;
        case WLActivityTypeWXCircle:
            [self activityWXWebPageWithTitle:title description:description thumbImage:user.avatar shareURLStr:user.shareurl forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
            break;
        default:
            break;
    }
    [[WLUserBehaviorLog sharedWLUserBehaviorLog] shareRecordID:user.uid dataType:model.modelClass shareType:type];
}

/// 分享动态
- (void)shareStatusWithModelClass:(WLBlockModel *)model activityType:(WLActivityType)type{
    NSAssert([model.dataModel isKindOfClass:[WLTopicFeed class]], @"分享缺少对应model");
    if (![model.dataModel isKindOfClass:[WLTopicFeed class]]) return;
    WLTopicFeed *feedModel = model.dataModel;
    switch (type) {
        case WLActivityTypeWXFriend:
            [self activityWXWebPageWithTitle:[feedModel shareTitleweChat] description:[feedModel shareSubTitle] thumbImage:feedModel.user.avatar shareURLStr:feedModel.shareurl forPlatformSubType:SSDKPlatformSubTypeWechatSession];
            break;
        case WLActivityTypeWXCircle:
            [self activityWXWebPageWithTitle:[feedModel shareTitleweChatFriend] description:[feedModel shareSubTitle] thumbImage:feedModel.user.avatar shareURLStr:feedModel.shareurl forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
            break;
        default:
            break;
    }
    [[WLUserBehaviorLog sharedWLUserBehaviorLog] shareRecordID:feedModel.feed_id dataType:model.modelClass shareType:type];
}

/// 分享活动
- (void)shareEventWithModelClass:(WLBlockModel *)model activityType:(WLActivityType)type{
    NSAssert([model.dataModel isKindOfClass:[IActivityInfo class]], @"分享缺少对应model");
    if (![model.dataModel isKindOfClass:[IActivityInfo class]]) return;
    IActivityInfo *eventModel = model.dataModel;
    switch (type) {
        case WLActivityTypeWLFriend:
        case WLActivityTypeWLCircle:
        {
            CardStatuModel *newCardM = [[CardStatuModel alloc] init];
            newCardM.cid = eventModel.activeid;
            if (eventModel.activestyle == WLActivityStyleFinancing){ // 融资活动
                newCardM.type = @(22);
            }else{ // 创业活动
                newCardM.type = @(3);
            }
            newCardM.logo = eventModel.logo;
            newCardM.url = eventModel.shareurl;
            newCardM.title = eventModel.name;
            NSString *cityStr = eventModel.city.length > 0 ? [NSString stringWithFormat:@"%@ ",eventModel.city] : @"";
            newCardM.intro = [NSString stringWithFormat:@"%@%@",cityStr,[[eventModel.starttime wl_dateFormartNormalString] formattedDateWithFormat:@"yyyy-MM-dd"]];
            if (type == WLActivityTypeWLFriend) {
                [[WLShareFriendsTool sharedWLShareFriendsTool] shareFriendsWithModel:newCardM];
            }else if (type == WLActivityTypeWLCircle){
                [[WLPublishStatusTool sharedWLPublishStatusTool] publishStatusForwardCard:newCardM];
            }
            break;
        }
        case WLActivityTypeWXFriend:
            [self activityWXWebPageWithTitle:eventModel.name description:[eventModel displayShareToWx] thumbImage:eventModel.logo shareURLStr:eventModel.shareurl forPlatformSubType:SSDKPlatformSubTypeWechatSession];
            break;
        case WLActivityTypeWXCircle:
            [self activityWXWebPageWithTitle:eventModel.name description:[eventModel displayShareToWx] thumbImage:eventModel.logo shareURLStr:eventModel.shareurl forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
            break;
        default:
            break;
    }
    if (eventModel.activestyle == WLActivityStyleFinancing){ // 融资活动
        [[WLUserBehaviorLog sharedWLUserBehaviorLog] shareRecordID:eventModel.activeid dataType:22 shareType:type];
    }else{ // 创业活动
        [[WLUserBehaviorLog sharedWLUserBehaviorLog] shareRecordID:eventModel.activeid dataType:model.modelClass shareType:type];
    }
    
}

/// 分享活动邀请函
- (void)shareEventInvitationWithModelClass:(WLBlockModel *)model activityType:(WLActivityType)type{
    NSAssert([model.image isKindOfClass:[UIImage class]], @"分享缺少对应model");
    if (![model.image isKindOfClass:[UIImage class]]) return;
    UIImage *eventImage = model.image;
    switch (type) {
        case WLActivityTypeWXFriend:
            [self activityWXImage:eventImage forPlatformSubType:SSDKPlatformSubTypeWechatSession];
            break;
        case WLActivityTypeWXCircle:
            [self activityWXImage:eventImage forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
            break;
        default:
            break;
    }
        [[WLUserBehaviorLog sharedWLUserBehaviorLog] shareRecordID:nil dataType:model.modelClass shareType:type];
}

/// 分享项目
- (void)shareProjectWithModelClass:(WLBlockModel *)model activityType:(WLActivityType)type{
    NSAssert([model.dataModel isKindOfClass:[IProjectDetailInfo class]], @"分享缺少对应model");
    if (![model.dataModel isKindOfClass:[IProjectDetailInfo class]]) return;
    IProjectDetailInfo *projectModel = model.dataModel;
    NSString *description = [NSString stringWithFormat:@"%@ %@\n要融资，上微链",projectModel.city.name,[projectModel displayIndustrys]];
    NSString *link =  projectModel.shareurl;
    NSString *titlStr = [NSString stringWithFormat:@"%@，%@",projectModel.name,projectModel.intro];;
    if (titlStr.length >23) {
        titlStr = [NSString stringWithFormat:@"%@...", [titlStr substringToIndex:22]];
    }
    switch (type) {
        case WLActivityTypeWLFriend:
        case WLActivityTypeWLCircle:
        {
            CardStatuModel *newCardM = [[CardStatuModel alloc] init];
            newCardM.cid = projectModel.pid;
            newCardM.type = @(10);
            newCardM.title = projectModel.name;
            newCardM.intro = projectModel.intro.length > 50 ? [projectModel.intro substringToIndex:50] : projectModel.intro;
            newCardM.url = projectModel.shareurl;
            newCardM.logo = projectModel.logo;
            if (type == WLActivityTypeWLFriend) {
                [[WLShareFriendsTool sharedWLShareFriendsTool] shareFriendsWithModel:newCardM];
            }else if (type == WLActivityTypeWLCircle){
                [[WLPublishStatusTool sharedWLPublishStatusTool] publishStatusForwardCard:newCardM];
            }
            break;
        }
        case WLActivityTypeWXFriend: {
            NSString *title = [NSString stringWithFormat:@"%@ | 要融资，上微链",titlStr];
            [self activityWXWebPageWithTitle:title description:description thumbImage:projectModel.logo shareURLStr:link forPlatformSubType:SSDKPlatformSubTypeWechatSession];
            break;
        }
        case WLActivityTypeWXCircle: {
            NSString *title = [NSString stringWithFormat:@"%@,%@",projectModel.name,projectModel.intro];
            [self activityWXWebPageWithTitle:title description:description thumbImage:projectModel.logo shareURLStr:link forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
            break;
        }
        default:
            break;
    }
    [[WLUserBehaviorLog sharedWLUserBehaviorLog] shareRecordID:projectModel.pid dataType:model.modelClass shareType:type];
}

/// 分享话题
- (void)shareTopicWithModelClass:(WLBlockModel *)model activityType:(WLActivityType)type{
    NSAssert([model.dataModel isKindOfClass:[WLTopicModel class]], @"分享缺少对应model");
    if (![model.dataModel isKindOfClass:[WLTopicModel class]]) return;
    WLTopicModel *topicModel = model.dataModel;
    switch (type) {
        case WLActivityTypeWLFriend: {
            CardStatuModel *newCardM = [[CardStatuModel alloc] init];
            newCardM.type = @(16);
            newCardM.title = topicModel.topicName;
            newCardM.intro = topicModel.subSting;
            newCardM.cid = topicModel.topic_id;
            newCardM.logo = topicModel.background_image;
            newCardM.url = topicModel.shareurl;
            [[WLShareFriendsTool sharedWLShareFriendsTool] shareFriendsWithModel:newCardM];
            break;
        }
        case WLActivityTypeWXFriend:
            [self activityWXWebPageWithTitle:[topicModel shareWXTitle] description:[topicModel shareWXSubtitle] thumbImage:topicModel.background_image shareURLStr:topicModel.shareurl forPlatformSubType:SSDKPlatformSubTypeWechatSession];
            break;
        case WLActivityTypeWXCircle:
            [self activityWXWebPageWithTitle:[topicModel shareWXCircleTitle] description:[topicModel shareWXSubtitle] thumbImage:topicModel.background_image shareURLStr:topicModel.shareurl forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
            break;
        default:
            break;
    }
    [[WLUserBehaviorLog sharedWLUserBehaviorLog] shareRecordID:topicModel.topic_id dataType:model.modelClass shareType:type];
}

/// 分享网页
- (void)shareWebWithModelClass:(WLBlockModel *)model activityType:(WLActivityType)type{
    NSAssert([model.dataModel isKindOfClass:[CardStatuModel class]], @"分享缺少对应model");
    if (![model.dataModel isKindOfClass:[CardStatuModel class]]) return;
    CardStatuModel *newCardM = model.dataModel;
    switch (type) {
        case WLActivityTypeWLFriend:
        case WLActivityTypeWLCircle:
        {
            if (type == WLActivityTypeWLFriend) {
                [[WLShareFriendsTool sharedWLShareFriendsTool] shareFriendsWithModel:newCardM];
            }else if (type == WLActivityTypeWLCircle){
                [[WLPublishStatusTool sharedWLPublishStatusTool] publishStatusForwardCard:newCardM];
            }
            break;
        }
        case WLActivityTypeWXFriend:
            [self activityWXWebPageWithTitle:newCardM.title description:newCardM.intro thumbImage:newCardM.logo shareURLStr:newCardM.url forPlatformSubType:SSDKPlatformSubTypeWechatSession];
            break;
        case WLActivityTypeWXCircle:
            [self activityWXWebPageWithTitle:newCardM.title description:newCardM.intro thumbImage:newCardM.logo shareURLStr:newCardM.url forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
            break;
        default:
            break;
    }
    [[WLUserBehaviorLog sharedWLUserBehaviorLog] shareRecordID:nil dataType:model.modelClass shareType:type];
}

/// 分享投资人
- (void)shareInvestorWithModelClass:(WLBlockModel *)model activityType:(WLActivityType)type{
    NSAssert([model.dataModel isKindOfClass:[InvestorUserModel class]], @"分享缺少对应model");
    if (![model.dataModel isKindOfClass:[InvestorUserModel class]]) return;
    InvestorUserModel *investorUserModel = model.dataModel;
    NSString *firm = investorUserModel.firm.title ? : @"";
    NSString *description = [NSString stringWithFormat:@"专注于%@",[investorUserModel displayInvestStageInfoWithSubStr:@"/" defaultStr:@""]];
    switch (type) {
        case WLActivityTypeWLFriend:
        case WLActivityTypeWLCircle:
        {
            CardStatuModel *newCardM = [[CardStatuModel alloc] init];
            newCardM.cid = investorUserModel.user.uid;
            newCardM.type = @(21);
            newCardM.logo = investorUserModel.user.avatar;
            newCardM.url = investorUserModel.shareurl;
            newCardM.title = investorUserModel.user.name;
            newCardM.intro = [investorUserModel.user dispalyCompanyAndPosition];
            if (type == WLActivityTypeWLFriend) {
                [[WLShareFriendsTool sharedWLShareFriendsTool] shareFriendsWithModel:newCardM];
            }else if (type == WLActivityTypeWLCircle){
                [[WLPublishStatusTool sharedWLPublishStatusTool] publishStatusForwardCard:newCardM];
            }
            break;
        }
        case WLActivityTypeWXFriend:{
            NSString *title = [NSString stringWithFormat:@"「投资人」%@%@",firm, investorUserModel.user.name];
            [self activityWXWebPageWithTitle:title description:description thumbImage:investorUserModel.user.avatar shareURLStr:investorUserModel.shareurl forPlatformSubType:SSDKPlatformSubTypeWechatSession];
            break;
        }
        case WLActivityTypeWXCircle:{
            NSString *titlStr = [NSString stringWithFormat:@"「投资人」%@%@，%@",firm, investorUserModel.user.name,description];
            [self activityWXWebPageWithTitle:titlStr description:description thumbImage:investorUserModel.user.avatar shareURLStr:investorUserModel.shareurl forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
            break;
        }
        default:
            break;
    }
    [[WLUserBehaviorLog sharedWLUserBehaviorLog] shareRecordID:investorUserModel.user.uid dataType:model.modelClass shareType:type];
}

/// 分享投资人名片
- (void)shareInvestorCardWithModelClass:(WLBlockModel *)model activityType:(WLActivityType)type{
    NSAssert([model.image isKindOfClass:[UIImage class]], @"分享缺少对应model");
    if (![model.image isKindOfClass:[UIImage class]]) return;
    UIImage *investorImage = model.image;
    switch (type) {
        case WLActivityTypeWXFriend:
            [self activityWXImage:investorImage forPlatformSubType:SSDKPlatformSubTypeWechatSession];
            break;
        case WLActivityTypeWXCircle:
            [self activityWXImage:investorImage forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
            break;
        default:
            break;
    }
    [[WLUserBehaviorLog sharedWLUserBehaviorLog] shareRecordID:nil dataType:model.modelClass shareType:type];
}

/// 分享微链app
- (void)shareWLAppWithModelClass:(WLBlockModel *)model activityType:(WLActivityType)type{
    if (![model.dataModel isKindOfClass:[WLConfigTool class]]) return;
    WLConfigTool *configModel = model.dataModel;
    NSString *title = [NSString stringWithFormat:@"%@邀请你加入微链",configModel.loginUser.name];
    NSString *description = @"要创业，上微链 \n投资人等你来融资";
    switch (type) {
        case WLActivityTypeWXFriend:
            [self activityWXWebPageWithTitle:title description:description thumbImage:configModel.loginUser.avatar shareURLStr:configModel.loginUser.inviteurl forPlatformSubType:SSDKPlatformSubTypeWechatSession];
            break;
        case WLActivityTypeWXCircle:
            [self activityWXWebPageWithTitle:title description:description thumbImage:configModel.loginUser.avatar shareURLStr:configModel.loginUser.inviteurl forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
            break;
        default:
            break;
    }
    [[WLUserBehaviorLog sharedWLUserBehaviorLog] shareRecordID:nil dataType:model.modelClass shareType:type];
}

/// 分享项目BP
- (void)shareProjectBPWithModelClass:(WLBlockModel *)model activityType:(WLActivityType)type{
    if (![model.dataModel isKindOfClass:[IProjectInfo class]]) return;
    IProjectInfo *proInfo =  model.dataModel;
    IInvestIndustryModel *industryModel =  proInfo.industrys.firstObject;
    NSString *industryString = industryModel.industryname?industryModel.industryname:@"";
    NSString *shareTitle = [NSString stringWithFormat:@"【BP】%@ - %@",proInfo.name,proInfo.intro];
    NSString *descString = [NSString stringWithFormat:@"%@ %@\n要融资，上微链",industryString,proInfo.city.name?proInfo.city.name:@""];
    switch (type) {
        case WLActivityTypeWXFriend:
            [self activityWXWebPageWithTitle:shareTitle description:descString thumbImage:proInfo.logo shareURLStr:model.shareBPURL forPlatformSubType:SSDKPlatformSubTypeWechatSession];
            break;
        default:
            break;
    }
    [[WLUserBehaviorLog sharedWLUserBehaviorLog] shareRecordID:proInfo.pid dataType:model.modelClass shareType:type];
}

/// 分享第三方服务
- (void)shareOTTservicesWithModelClass:(WLBlockModel *)model activityType:(WLActivityType)type{
    NSAssert([model.dataModel isKindOfClass:[CardStatuModel class]], @"分享缺少对应model");
    if (![model.dataModel isKindOfClass:[CardStatuModel class]]) return;
    CardStatuModel *newCardM = model.dataModel;
    switch (type) {
        case WLActivityTypeWLFriend:
        case WLActivityTypeWLCircle:
        {
            newCardM.title = [NSString stringWithFormat:@"%@ | %@",newCardM.title, newCardM.intro];
            if (type == WLActivityTypeWLFriend) {
                [[WLShareFriendsTool sharedWLShareFriendsTool] shareFriendsWithModel:newCardM];
            }else if (type == WLActivityTypeWLCircle){
                [[WLPublishStatusTool sharedWLPublishStatusTool] publishStatusForwardCard:newCardM];
            }
            break;
        }
        case WLActivityTypeWXFriend:
            [self activityWXWebPageWithTitle:newCardM.title description:newCardM.intro thumbImage:newCardM.logo shareURLStr:newCardM.url forPlatformSubType:SSDKPlatformSubTypeWechatSession];
            break;
        case WLActivityTypeWXCircle:
            [self activityWXWebPageWithTitle:[newCardM.title stringByAppendingFormat:@" | %@",newCardM.intro] description:nil thumbImage:newCardM.logo shareURLStr:newCardM.url forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
            break;
        default:
            break;
    }
    [[WLUserBehaviorLog sharedWLUserBehaviorLog] shareRecordID:nil dataType:model.modelClass shareType:type];
}

/// 分享课程
- (void)shareCourseWithModelClass:(WLBlockModel *)model activityType:(WLActivityType)type{
    NSAssert([model.dataModel isKindOfClass:[WLCourseModel class]], @"分享缺少对应model");
    if (![model.dataModel isKindOfClass:[WLCourseModel class]]) return;
    WLCourseModel *courseModel = model.dataModel;
    switch (type) {
        case WLActivityTypeWXFriend:
            [self activityWXMiniprogram:courseModel.name description:courseModel.title thumbImage:courseModel.icon shareURLStr:courseModel.shareH5Url miniprogramPage:courseModel.miniprogramPage miniprogramUsername:courseModel.miniprogramUsername];
            break;
        case WLActivityTypeWXCircle:{
            if (![model.image isKindOfClass:[UIImage class]]) return;
            UIImage *eventImage = model.image;
            [self activityWXImage:eventImage forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
        }
            break;
        default:
            break;
    }
    [[WLUserBehaviorLog sharedWLUserBehaviorLog] shareRecordID:@(courseModel.courseId) dataType:model.modelClass shareType:type];
}
@end


@implementation WLBlockModel
- (void)modelClass:(WLActivityModelClass)modelClass model:(id)model {
    [self modelClass:modelClass model:model image:nil];
}

- (void)modelClass:(WLActivityModelClass)modelClass model:(id)model image:(UIImage *)image {
    self.modelClass = modelClass;
    self.dataModel = model;
    self.image = image;
}

@end

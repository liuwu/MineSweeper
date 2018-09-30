//
//  WLChatBaseViewController.m
//  Welian
//
//  Created by dong on 15/10/12.
//  Copyright © 2015年 chuansongmen. All rights reserved.
//

#import "WLChatBaseViewController.h"
#import "UserInfoViewController.h"
#import "WLChatLocationViewController.h"
#import "ActivityMapViewController.h"
#import "WLPhotoViewController.h"

#import "AXWebViewController.h"

//
#import "KSPhotoBrowser.h"

#import "ChatRedPacketCell.h"
#import "ChatGetRedPacketCell.h"

#import "IGameGroupModel.h"

#import "WLSystemAuth.h"
#import "WLAssetsManager.h"
#import "WLRongCloudDataSource.h"

#import "RCRedPacketMessage.h"
#import "RCRedPacketGetMessage.h"


#define kImageMsgMaxCount 5000


@interface WLChatBaseViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,RCMessageCellDelegate, WLPhotoViewControllerDelegate>

@end

static NSString *redPacketCellid = @"redPacketCellid";
static NSString *customCardCellid = @"customCardCellid";
static NSString *newcardCellid = @"newcardCellid";
static NSString *cardlistCellid = @"cardlistCellid";
static NSString *paylistCellid = @"paylistCellid";

@implementation WLChatBaseViewController

- (void)dealloc {
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:[UIColor whiteColor]]];
    // bar背景颜色
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    // 返回按钮颜色
    self.navigationController.navigationBar.tintColor =  WLColoerRGB(51.f);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (id)initWithConversationType:(RCConversationType)conversationType targetId:(NSString *)targetId
{
    self = [super initWithConversationType:conversationType targetId:targetId];
    if (self) {
        @weakify(self)
        if (conversationType == ConversationType_PRIVATE) {
            [[WLRongCloudDataSource shareInstance] getLocalUserInfoWithUserId:targetId completion:^(IFriendModel *userM) {
                @strongify(self)
                self.navigationItem.title = userM.nickname;
            }];
        }else if(conversationType == ConversationType_GROUP){
            [[WLRongCloudDataSource shareInstance] getLocalGroupInfoWithGroupId:targetId completion:^(IGameGroupModel *groupInfo) {
                @strongify(self)
                self.navigationItem.title = groupInfo.title;
            }];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //* 注册消息类型，如果使用IMKit，使用此方法，不再使用RongIMLib的同名方法。如果对消息类型进行扩展，可以忽略此方法。
//    [self registerClass:[ChatRedPacketCell class] forCellWithReuseIdentifier:redPacketCellid];
    [self registerClass:ChatRedPacketCell.class forMessageClass:RCRedPacketMessage.class];
    [self registerClass:ChatGetRedPacketCell.class forMessageClass:RCRedPacketGetMessage.class];
    self.enableUnreadMessageIcon = YES;
    self.enableNewComingMessageIcon = YES;
}

/**
 *  @author dong, 15-11-17 18:11:12
 *  取消WLChatCardListCell里融云手势
 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    NSString *viewClass = [NSString stringWithFormat:@"%@",touch.view.class];
    DLog(@"shouldReceiveTouch : %@", viewClass);
//    if ([viewClass isEqualToString:@"UITableViewCellContentView"]||[viewClass isEqualToString:@"MLEmojiLabel"]) {
//        return NO;
//    }
    return NO;
}

/*!
 自定义消息 Cell 的 Size
 
 @param model               要显示的消息model
 @param collectionViewWidth cell所在的collectionView的宽度
 @param extraHeight         cell内容区域之外的高度
 
 @return 自定义消息Cell的Size
 
 @discussion 当应用自定义消息时，必须实现该方法来返回cell的Size。
 其中，extraHeight是Cell根据界面上下文，需要额外显示的高度（比如时间、用户名的高度等）。
 一般而言，Cell的高度应该是内容显示的高度再加上extraHeight的高度。
 */
//+ (CGSize)sizeForMessageModel:(RCMessageModel *)model
//      withCollectionViewWidth:(CGFloat)collectionViewWidth
//         referenceExtraHeight:(CGFloat)extraHeight {
////    RCMessageModel *model = self.conversationDataRepository[indexPath.row];
//    RCMessageContent *msgContent = model.content;
//    if ([msgContent isMemberOfClass:[RCRedPacketMessage class]]) {
//        // 红包cell
//        return [ChatRedPacketCell cellHigetWithModel:model];// CGSizeMake(200.f, 65.f);
//    }
//    return CGSizeZero;
//}

/**
 *  重写方法实现自定义消息的显示的高度
 *  @param collectionView       collectionView
 *  @param collectionViewLayout collectionViewLayout
 *  @param indexPath            indexPath
 *  @return 显示的高度
 */
//- (CGSize)rcConversationCollectionView:(UICollectionView *)collectionView
//                                layout:(UICollectionViewLayout *)collectionViewLayout
//                sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    RCMessageModel *model = self.conversationDataRepository[indexPath.row];
//    RCMessageContent *msgContent = model.content;
////    if ([msgContent isMemberOfClass:[CustomCardMessage class]]) {
////        CustomCardMessage *customCardM = (CustomCardMessage *)model.content;
//////        CardStatuModel *cardM = [CardStatuModel modelWithDictionary:customCardM.card];
//////        if (cardM.viewType.integerValue) {
//////            return [WLChatNewCardCell cellHigetWithModel:model];
//////        }else{
//////            return [WLChatCustomCardCell getCellSizeWithCardMessage:model];
//////        }
////    }else if ([msgContent isMemberOfClass:[WLCardListMessage class]]){
////        return [WLChatCardListCell cellHigetWithModel:model];
////    }
////    else if ([msgContent isMemberOfClass:[WLPayRemindMessage class]]){
////        return  [WLPayHelperCell sizeForMessageModel:model
////                             withCollectionViewWidth:ScreenWidth
////                                referenceExtraHeight:0];
////    }
//    if ([msgContent isMemberOfClass:[RCRedPacketMessage class]]) {
//        // 红包cell
//        return [ChatRedPacketCell sizeForMessageModel:model withCollectionViewWidth:65.f referenceExtraHeight:20.f];
////        return [ChatRedPacketCell cellHigetWithModel:model];// CGSizeMake(200.f, 65.f);
//    }
//    if ([msgContent isMemberOfClass:[RCRedPacketGetMessage class]]) {
//        // 红包cell
//        return [ChatGetRedPacketCell sizeForMessageModel:model withCollectionViewWidth:DEVICE_WIDTH referenceExtraHeight:120.f];
//        //        return [ChatRedPacketCell cellHigetWithModel:model];// CGSizeMake(200.f, 65.f);
//    }
//    return CGSizeZero;
//}

#pragma mark override
/**
 *  重写方法实现自定义消息的显示
 *  @param collectionView collectionView
 *  @param indexPath      indexPath
 *  @return RCMessageTemplateCell
 */
- (RCMessageBaseCell *)rcConversationCollectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RCMessageModel *model = self.conversationDataRepository[indexPath.row];
    RCMessageContent *msgContent = model.content;
    if ([msgContent isMemberOfClass:[RCRedPacketMessage class]]) {
        // 红包cell
        ChatRedPacketCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:redPacketCellid forIndexPath:indexPath];
        cell.delegate = self;
//        cell.cellDelegate = self;
//        cell.isDisplayMessageTime = YES;
//        cell.isDisplayMessageTime = YES;
        if ([(RCRedPacketMessage *)msgContent uid].integerValue == configTool.loginUser.uid.integerValue) {
            cell.messageDirection = MessageDirection_SEND;
        } else {
            cell.messageDirection = MessageDirection_RECEIVE;
        }
        [cell setDataModel:model];
//        [cell wl_setDebug:YES];
        return cell;
    }
    return nil;
}

#pragma mark override
// 点击cell中url
- (void)didTapUrlInMessageCell:(NSString *)url model:(RCMessageModel *)model {
    DLog(@"didTapUrlInMessageCell");
    if (url.length > 0) {
        AXWebViewController *webVC = [[AXWebViewController alloc] initWithAddress:url];
        webVC.showsToolBar = NO;
        webVC.title = @"网页";
        // webVC.showsNavigationCloseBarButtonItem = NO;
        if (AX_WEB_VIEW_CONTROLLER_iOS9_0_AVAILABLE()) {
            webVC.webView.allowsLinkPreview = YES;
        }
        [self.navigationController pushViewController:webVC animated:YES];
    }
}

/*!
 点击Cell中电话号码的回调
 
 @param phoneNumber 点击的电话号码
 @param model       消息Cell的数据模型
 */
- (void)didTapPhoneNumberInMessageCell:(NSString *)phoneNumber
                                 model:(RCMessageModel *)model {
    DLog(@"didTapPhoneNumberInMessageCell-----------");
    if (phoneNumber.length > 0) {
        QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
            DLog(@"取消");
        }];
        QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"拨打电话" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
            DLog(@"拨打电话");
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", phoneNumber]]];
        }];
        QMUIAlertAction *action3 = [QMUIAlertAction actionWithTitle:@"发短信" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
            DLog(@"发短信");
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms://%@", phoneNumber]]];
        }];
        QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:nil message:nil preferredStyle:QMUIAlertControllerStyleActionSheet];
        [alertController addAction:action1];
        [alertController addAction:action2];
        [alertController addAction:action3];
        [alertController showWithAnimated:YES];
    }
}

- (void)onBeginRecordEvent {
    [super onBeginRecordEvent];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationPlayVoice object:nil];
}

- (void)onEndRecordEvent {
    [super onEndRecordEvent];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationStopVoicePlayer object:nil];
}

- (void)onCancelRecordEvent {
    [super onCancelRecordEvent];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationStopVoicePlayer object:nil];
}

/**
 *  打开大图。开发者可以重写，自己下载并且展示图片。默认使用内置controller
 *
 *  @param model 图片消息model
 */
- (void)presentImagePreviewController:(RCMessageModel *)model
{
    
    [self.chatSessionInputBarControl endEditing:YES];
    NSArray *messageArray = [[RCIMClient sharedRCIMClient] getLatestMessages:self.conversationType targetId:self.targetId count:1];
    if (!messageArray.count) return;
    RCMessage *lastMessage = messageArray.firstObject;
    RCMessageContent *lastMessageContent = lastMessage.content;
    
    NSMutableArray *allImageArrayM = [NSMutableArray array];
    NSArray *imageMessageM = [[RCIMClient sharedRCIMClient] getHistoryMessages:self.conversationType targetId:self.targetId objectName:RCImageMessageTypeIdentifier oldestMessageId:lastMessage.messageId count:kImageMsgMaxCount];
    NSMutableArray *imageMutableArray = [NSMutableArray arrayWithArray:imageMessageM];
    if ([lastMessageContent isMemberOfClass:[RCImageMessage class]]) {
        [imageMutableArray insertObject:lastMessage atIndex:0];
    }
    __block NSInteger selectedRow = 0;
    [imageMutableArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        RCMessage *message = obj;
        if ([message.content isMemberOfClass:[RCImageMessage class]]) {
            RCImageMessage *imageMsgContent = (RCImageMessage *)message.content;
            NSString *imageURL = imageMsgContent.imageUrl;
            if (imageMsgContent.localPath && imageMsgContent.localPath.length) {
                NSString *cacheFolder = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
                NSString *aaaa = [[imageMsgContent.localPath componentsSeparatedByString:@"/Caches/"] lastObject];
                NSString *localpath = [cacheFolder stringByAppendingPathComponent:aaaa];
                KSPhotoItem *photo = [KSPhotoItem itemWithSourceView:nil image:[UIImage imageWithContentsOfFile:localpath]];
                [allImageArrayM addObject:photo];
            }else if ([imageURL hasPrefix:@"http://"] || [imageURL hasPrefix:@"https://"]) {
                KSPhotoItem *photo = [KSPhotoItem itemWithThumbImage:imageMsgContent.thumbnailImage imageUrlString:imageURL];
                [allImageArrayM addObject:photo];
            }else{

            }
            if (message.messageId == model.messageId) {
                selectedRow = idx;
            }
        }
    }];
    // 2.显示相册
    KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:allImageArrayM selectedIndex:allImageArrayM.count - selectedRow-1];
    browser.pageindicatorStyle = KSPhotoBrowserPageIndicatorStyleText;
    [browser showFromViewController:self];
}

/**
 *  打开地理位置。开发者可以重写，自己根据经纬度打开地图显示位置。默认使用内置地图
 *
 *  @param locationMessageContent 位置消息
 */
- (void)presentLocationViewController:(RCLocationMessage *)locationMessageContent
{
    ActivityMapViewController *mapVC = [[ActivityMapViewController alloc] initWithRCLocationMsg:locationMessageContent];
    [self.navigationController pushViewController:mapVC animated:YES];
}

//- (void)selectedCardMessageWithCardM:(CardStatuModel *)cardModel
//{
//    //3 活动，10项目，11 网页  13 投递项目卡片 14 用户名片卡片 15 投资人索要项目卡片 20项目集 22 融资活动
//    switch (cardModel.type.integerValue) {
//        case WLBubbleMessageCardTypeActivity:{
//            WLActivityDetailInfoController *activityInfoVC = [[WLActivityDetailInfoController alloc] initWithActivityStyle:WLActivityStyleCarveout activityID:cardModel.cid];
//            if (activityInfoVC) {
//                [self.navigationController pushViewController:activityInfoVC animated:YES];
//            }
//        }
//            break;
//        case WLBubbleMessageCardTypeFinaceActivity:{
//            //查询本地有没有该活动
//            WLActivityDetailInfoController *activityInfoVC = [[WLActivityDetailInfoController alloc] initWithActivityStyle:WLActivityStyleFinancing activityID:cardModel.cid];
//            if (activityInfoVC) {
//                [self.navigationController pushViewController:activityInfoVC animated:YES];
//            }
//        }
//            break;
//        case WLBubbleMessageCardTypeProject: {
//            NSNumber *projectPid = nil;
//            NSNumber *orderId = nil;
//            WLProjectFromType fromtype = WLProjectFromTypeNormal;
//            if (cardModel.subType.integerValue == 1) {
//                // 判断自己是否是投资人
//                BOOL isinvert =  [self judgeInvestorAuth];
//                if (!isinvert) return;
//
//                //转推的项目
//                fromtype = WLProjectFromTypeForward;
//                projectPid = cardModel.cid;
//                orderId = cardModel.relationid;
//            } else if(cardModel.subType.integerValue == 2){
//                //微链推荐
//                fromtype = WLProjectFromTypeCommend;
//                projectPid = cardModel.cid;
//                orderId = cardModel.relationid;
//            } else{
//                projectPid = cardModel.cid;
//            }
//            //进入项目详情
//            [[AppDelegate sharedAppDelegate] showInfoWithType:JumpTypeProDetail
//                                                        param:projectPid.stringValue
//                                                     subparam:orderId.stringValue
//                                              projectFromType:fromtype
//                                                       fromVC:self];
//        }
//            break;
//        case WLBubbleMessageCardTypeWeb: {
//            [[AppDelegate sharedAppDelegate] wlopenURLString:cardModel.url sourceViewControl:self];
//        }
//            break;
//        case WLBubbleMessageCardTypeInvestorPost: {
//            // 判断自己是否是投资人
//            BOOL isinvert =  [self judgeInvestorAuth];
//            if (!isinvert) return;
//            //进入项目详情
//            [[AppDelegate sharedAppDelegate] showInfoWithType:JumpTypeProDetail
//                                                        param:cardModel.cid.stringValue
//                                                     subparam:cardModel.relationid.stringValue
//                                              projectFromType:WLProjectFromTypePost
//                                                       fromVC:self];
//        }
//            break;
//        case WLBubbleMessageCardTypeCircle: {
//            //圈子点击
//            [[AppDelegate sharedAppDelegate] showInfoWithType:JumpTypeCircle
//                                                        param:cardModel.cid.stringValue
//                                                     subparam:nil
//                                              projectFromType:WLProjectFromTypeNormal
//                                                       fromVC:self];
//        }
//            break;
//        case WLBubbleMessageCardTypeInvestorDetail: {
//            //投资人点击
//            [[AppDelegate sharedAppDelegate] showInfoWithType:JumpTypeInvestorDetail
//                                                        param:cardModel.cid.stringValue
//                                                     subparam:nil
//                                              projectFromType:WLProjectFromTypeNormal
//                                                       fromVC:self];
//        }
//            break;
//        default:
//            break;
//    }
//}
//
//#pragma mark - 判断自己是否是投资人
//- (BOOL)judgeInvestorAuth {
//    WLUserDetailInfoModel *loginUser = configTool.loginUser;
//    /**  投资者认证  0 默认状态  1  认证成功  -2 正在审核  -1 认证失败 */
//    switch (loginUser.investorauth.integerValue) {
//        case 0:
//        case -1:
//        {
//            WEAKSELF
//            [[LGAlertView alertViewWithTitle:@"你当前不是投资人，去认证？" message:nil style:LGAlertViewStyleAlert buttonTitles:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"去认证" actionHandler:nil cancelHandler:nil destructiveHandler:^(LGAlertView *alertView) {
//                InvestCerVC *investcerVC = [[InvestCerVC alloc] init];
//                [weakSelf.navigationController pushViewController:investcerVC animated:YES];
//
//            }] showAnimated:YES completionHandler:nil];
//        }
//            break;
//        case -2:
//        {
//            [[LGAlertView alertViewWithTitle:@"你当前投资状态正在审核中，请耐心等待" message:nil style:LGAlertViewStyleAlert buttonTitles:nil cancelButtonTitle:nil destructiveButtonTitle:@"知道了" actionHandler:nil cancelHandler:nil destructiveHandler:nil] showAnimated:YES completionHandler:nil];
//        }
//            break;
//        default:
//            break;
//    }
//    if (loginUser.investorauth.integerValue == 1) {
//        return YES;
//    }else{
//        return NO;
//    }
//}
//
//#pragma mark override
///**
// *  点击pluginBoardView上item响应事件
// *
// *  @param pluginBoardView 功能模板
// *  @param tag             标记
// */
- (void)pluginBoardView:(RCPluginBoardView*)pluginBoardView clickedItemWithTag:(NSInteger)tag {
//    DLog(@"pluginBoardView ----%d",tag);
    WEAKSELF
    switch (tag) {
        case 1001: {
            [WLSystemAuth showAlertWithAuthType:WLSystemAuthTypePhotos completionHandler:^(WLSystemAuthStatus status) {
                if (status == WLSystemAuthStatusAuthorized) {
                    [weakSelf showPicVC];
                }
            }];
        }
            break;
        case 1002: {
            [WLSystemAuth showAlertWithAuthType:WLSystemAuthTypeCamera completionHandler:^(WLSystemAuthStatus status) {
                if (status == WLSystemAuthStatusAuthorized) {
                    [weakSelf clickSheetCamera];
                }
            }];
        }
            break;
        case 1003: {
            [WLSystemAuth showAlertWithAuthType:WLSystemAuthTypeLocation completionHandler:^(WLSystemAuthStatus status) {
                if (status == WLSystemAuthStatusAuthorized) {
                    [weakSelf showLocationMapVC];
                }
            }];
        }
            break;
        default:
            [super pluginBoardView:pluginBoardView clickedItemWithTag:tag];
            break;
    }
}

- (void)showLocationMapVC {
    WEAKSELF
    WLChatLocationViewController *chatlocationVC = [[WLChatLocationViewController alloc] initWithSendLocationMsgeBlock:^(RCLocationMessage *locMessage) {
        [weakSelf sendMessage:locMessage pushContent:[NSString stringWithFormat:@"%@:[位置]",configTool.userInfoModel.nickname]];
    }];
    QMUINavigationController *navLocation = [[QMUINavigationController alloc] initWithRootViewController:chatlocationVC];
    [self presentViewController:navLocation animated:YES completion:nil];
}

- (void)showPicVC {
    WLPhotoViewController *imagePickerVC = [[WLPhotoViewController alloc] init];
    imagePickerVC.delegate = self;
    QMUINavigationController *navigationController = [[QMUINavigationController alloc] initWithRootViewController:imagePickerVC];
    [self presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark - WLPhotoViewControllerDelegate && WLPhotoPreviewControllerDelegate
- (void)photoViewControllerDidCancel:(WLPhotoViewController *)photoViewController {
    [photoViewController.navigationController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)photoViewController:(WLPhotoViewController *)photoViewController didFinishPickingImageWithImagesAssetArray:(NSMutableArray<WLAsset *> *)imagesAssetArray {
    [photoViewController.navigationController dismissViewControllerAnimated:YES completion:NULL];

    dispatch_queue_t queue = dispatch_queue_create("welian.sendimagemessage.gcd", DISPATCH_QUEUE_SERIAL);
    for (WLAsset *asset in imagesAssetArray) {
        dispatch_async(queue, ^{
            [asset requestPreviewImageWithCompletion:^(UIImage *image, NSDictionary *info) {
                BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
                if (image && downloadFinined) {
                    @autoreleasepool {
                        dispatch_async(queue, ^{
                            RCImageMessage *imageMessage = [RCImageMessage messageWithImage:image];
                            imageMessage.full = YES;
                            [self sendMessage:imageMessage pushContent:@"图片"];
                        });
                    }
                }
            } withProgressHandler:NULL];
        });
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:NULL];
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    RCImageMessage *imageMessage = [RCImageMessage messageWithImage:image];
    imageMessage.full = YES;
    [self sendMessage:imageMessage pushContent:@"图片"];
    [self sendMessage:[RCImageMessage messageWithImage:image] pushContent:@"图片"];
    
    WLImageWriteToSavedPhotosAlbumWithUserLibrary(image, ^(WLAsset *asset, NSError *error) {
        if (asset && !error) {
        }
    });
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

// 拍照
- (void)clickSheetCamera {
    UIImagePickerController *imagePickerVC = [[UIImagePickerController alloc] init];
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePickerVC.delegate = self;
    imagePickerVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

@end

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
#import "FriendListViewController.h"
#import "TransferViewController.h"

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

#import "ImModelClient.h"
#import "FriendModelClient.h"


#define kImageMsgMaxCount 5000


@interface WLChatBaseViewController ()<UIImagePickerControllerDelegate,RCMessageCellDelegate, WLPhotoViewControllerDelegate>

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
//    [self registerClass:[ChatGetRedPacketCell class] forCellWithReuseIdentifier:redPacketCellid];
    [self registerClass:ChatRedPacketCell.class forMessageClass:RCRedPacketMessage.class];
    [self registerClass:ChatGetRedPacketCell.class forMessageClass:RCRedPacketGetMessage.class];
    self.enableUnreadMessageIcon = YES;
    self.enableNewComingMessageIcon = YES;
    
    // 移除定位扩展
    [self.chatSessionInputBarControl.pluginBoardView removeItemWithTag:1003];
    if (configTool.userInfoModel.customer_id.intValue != self.targetId.intValue && self.conversationType == ConversationType_PRIVATE) {
        [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:[UIImage imageNamed:@"ic-transter"]
                                                                       title:@"转账"
                                                                         tag:6001];
    }
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
 即将显示消息Cell的回调
 
 @param cell        消息Cell
 @param indexPath   该Cell对应的消息Cell数据模型在数据源中的索引值
 
 @discussion 您可以在此回调中修改Cell的显示和某些属性。
 */
- (void)willDisplayMessageCell:(RCMessageBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[RCTextMessageCell class]]) {
        RCTextMessageCell *txtCell = (RCTextMessageCell *)cell;
        // 设置自定义聊天背景图
        if (txtCell.model.messageDirection == MessageDirection_SEND) {
            txtCell.textLabel.textColor = [UIColor whiteColor];
            // 发送
            txtCell.bubbleBackgroundView.image = [[UIImage imageNamed:@"chat_to_bg_normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(20.f, 30,20.f, 30.f)];
        } else {
            txtCell.textLabel.textColor = WLColoerRGB(51.f);
            txtCell.bubbleBackgroundView.image = [[UIImage imageNamed:@"chat_from_bg_normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(20.f, 30,20.f, 30.f)];
        }
        //        txtCell.bubbleBackgroundView.image = [txtCell.bubbleBackgroundView.image
        //                                           resizableImageWithCapInsets:UIEdgeInsetsMake(20.f, 30,20.f, 30.f)];
    }
    if ([cell isKindOfClass:[RCVoiceMessageCell class]]) {
        RCVoiceMessageCell *txtCell = (RCVoiceMessageCell *)cell;
        if (txtCell.model.messageDirection == MessageDirection_SEND) {
            txtCell.voiceDurationLabel.textColor = [UIColor whiteColor];
            // 发送
            txtCell.bubbleBackgroundView.image = [[UIImage imageNamed:@"chat_to_bg_normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(20.f, 30,20.f, 30.f)];
        } else {
            txtCell.voiceDurationLabel.textColor = WLColoerRGB(51.f);
            txtCell.bubbleBackgroundView.image = [[UIImage imageNamed:@"chat_from_bg_normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(20.f, 30,20.f, 30.f)];
        }
        //        txtCell.bubbleBackgroundView.image = [txtCell.bubbleBackgroundView.image
        //                                              resizableImageWithCapInsets:UIEdgeInsetsMake(20.f, 30,20.f, 30.f)];
    }
    if ([cell isKindOfClass:[RCImageMessageCell class]]) {
        //        RCImageMessageCell *txtCell = (RCImageMessageCell *)cell;
        
        //        txtCell.pictureView.image = [UIImage imageWithColor:[UIColor greenColor]];// txtCell.pictureView.image; //[txtCell.bubbleBackgroundView.image
        //        resizableImageWithCapInsets:UIEdgeInsetsMake(20.f, 30,
        //                                                   20.f, 30.f)];
    }
    //    if (self.conversationType == ConversationType_GROUP) {
    //        if ([cell isKindOfClass:[ChatRedPacketCell class]] || [cell isKindOfClass:[ChatGetRedPacketCell class]]) {
    //            BOOL isHis = [_historyMessages bk_any:^BOOL(id obj) {
    //                return [obj messageId] == cell.model.messageId;
    //            }];
    //            // 如果是历史消息：删除模型
    //            if (isHis) {
    //                dispatch_async_on_main_queue(^{
    ////                    [self deleteMessage:cell.model];
    ////                    NSMutableArray *data = self.conversationDataRepository;
    ////                    if (self.conversationDataRepository.count > 0) {
    ////                        [self.conversationDataRepository removeObjectAtIndex:indexPath.row];
    //////                        [self.conversationDataRepository removeObject:cell.model];
    ////                    }
    ////                    [self.conversationMessageCollectionView reloadData];
    //                });
    //            }
    //        }
    //    }
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
//- (RCMessageBaseCell *)rcConversationCollectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    RCMessageModel *model = self.conversationDataRepository[indexPath.row];
//    RCMessageContent *msgContent = model.content;
//    if ([model.objectName isEqualToString:RCRedPacketMessageTypeIdentifier] || [msgContent isMemberOfClass:[RCRedPacketMessage class]]) {
//        // 红包cell
//        ChatRedPacketCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:redPacketCellid forIndexPath:indexPath];
//        cell.delegate = self;
////        cell.cellDelegate = self;
////        cell.isDisplayMessageTime = YES;
////        cell.isDisplayMessageTime = YES;
//        if ([(RCRedPacketMessage *)msgContent uid].integerValue == configTool.loginUser.uid.integerValue) {
//            cell.messageDirection = MessageDirection_SEND;
//        } else {
//            cell.messageDirection = MessageDirection_RECEIVE;
//        }
//        [cell setDataModel:model];
////        [cell wl_setDebug:YES];
//        return cell;
//    }
//    return nil;
//}

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
//- (void)presentImagePreviewController:(RCMessageModel *)model
//{
//    [self.chatSessionInputBarControl endEditing:YES];
//    NSArray *messageArray = [[RCIMClient sharedRCIMClient] getLatestMessages:self.conversationType targetId:self.targetId count:1];
//    if (!messageArray.count) return;
//    RCMessage *lastMessage = messageArray.firstObject;
//    RCMessageContent *lastMessageContent = lastMessage.content;
//
//    NSMutableArray *allImageArrayM = [NSMutableArray array];
//    NSArray *imageMessageM = [[RCIMClient sharedRCIMClient] getHistoryMessages:self.conversationType targetId:self.targetId objectName:RCImageMessageTypeIdentifier oldestMessageId:lastMessage.messageId count:kImageMsgMaxCount];
//    NSMutableArray *imageMutableArray = [NSMutableArray arrayWithArray:imageMessageM];
//    if ([lastMessageContent isMemberOfClass:[RCImageMessage class]]) {
//        [imageMutableArray insertObject:lastMessage atIndex:0];
//    }
//    __block NSInteger selectedRow = 0;
//    [imageMutableArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        RCMessage *message = obj;
//        if ([message.content isMemberOfClass:[RCImageMessage class]]) {
//            RCImageMessage *imageMsgContent = (RCImageMessage *)message.content;
//            NSString *imageURL = imageMsgContent.imageUrl;
//            if (imageMsgContent.localPath && imageMsgContent.localPath.length) {
//                NSString *cacheFolder = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
//                NSString *aaaa = [[imageMsgContent.localPath componentsSeparatedByString:@"/Caches/"] lastObject];
//                NSString *localpath = [cacheFolder stringByAppendingPathComponent:aaaa];
//                KSPhotoItem *photo = [KSPhotoItem itemWithSourceView:nil image:[UIImage imageWithContentsOfFile:localpath]];
//                [allImageArrayM addObject:photo];
//            }else if ([imageURL hasPrefix:@"http://"] || [imageURL hasPrefix:@"https://"]) {
//                KSPhotoItem *photo = [KSPhotoItem itemWithThumbImage:imageMsgContent.thumbnailImage imageUrlString:imageURL];
//                [allImageArrayM addObject:photo];
//            }else{
//
//            }
//            if (message.messageId == model.messageId) {
//                selectedRow = idx;
//            }
//        }
//    }];
//    // 2.显示相册
//    KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:allImageArrayM selectedIndex:allImageArrayM.count - selectedRow-1];
//    browser.pageindicatorStyle = KSPhotoBrowserPageIndicatorStyleText;
//    [browser showFromViewController:self];
//}

/**
 *  打开地理位置。开发者可以重写，自己根据经纬度打开地图显示位置。默认使用内置地图
 *
 *  @param locationMessageContent 位置消息
 */
//- (void)presentLocationViewController:(RCLocationMessage *)locationMessageContent
//{
//    ActivityMapViewController *mapVC = [[ActivityMapViewController alloc] initWithRCLocationMsg:locationMessageContent];
//    [self.navigationController pushViewController:mapVC animated:YES];
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
    switch (tag) {
//        case 1001: {
//            [WLSystemAuth showAlertWithAuthType:WLSystemAuthTypePhotos completionHandler:^(WLSystemAuthStatus status) {
//                if (status == WLSystemAuthStatusAuthorized) {
//                    [weakSelf showPicVC];
//                }
//            }];
//        }
//            break;
        case 1002: {
            WEAKSELF
            [WLSystemAuth showAlertWithAuthType:WLSystemAuthTypeCamera completionHandler:^(WLSystemAuthStatus status) {
                if (status == WLSystemAuthStatusAuthorized) {
                    [weakSelf clickSheetCamera];
                }
            }];
        }
            break;
//        case 1003: {
//            [WLSystemAuth showAlertWithAuthType:WLSystemAuthTypeLocation completionHandler:^(WLSystemAuthStatus status) {
//                if (status == WLSystemAuthStatusAuthorized) {
//                    [weakSelf showLocationMapVC];
//                }
//            }];
//        }
//            break;
        case 6001: {
            WEAKSELF
            [WLHUDView showHUDWithStr:@"" dim:YES];
            [FriendModelClient getImMemberInfoWithParams:@{@"uid" : self.targetId} Success:^(id resultInfo) {
                [WLHUDView hiddenHud];
                IFriendModel *friendModel = [IFriendModel modelWithDictionary:resultInfo];
                // 转账
                TransferViewController *vc = [[TransferViewController alloc] init];
                vc.friendModel = friendModel;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            } Failed:^(NSError *error) {
                if (error.localizedDescription.length > 0) {
                    [WLHUDView showErrorHUD:error.localizedDescription];
                } else {
                    [WLHUDView showErrorHUD:@"获取信息失败，请重试"];
                }
            }];
//            FriendListViewController *vc = [[FriendListViewController alloc] initWithFriendListType:FriendListTypeForTransfer];
//            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            [super pluginBoardView:pluginBoardView clickedItemWithTag:tag];
            break;
    }
}


//#pragma mark - WLPhotoViewControllerDelegate && WLPhotoPreviewControllerDelegate
//- (void)photoViewControllerDidCancel:(WLPhotoViewController *)photoViewController {
//    [photoViewController.navigationController dismissViewControllerAnimated:YES completion:NULL];
//}
//
//- (void)photoViewController:(WLPhotoViewController *)photoViewController didFinishPickingImageWithImagesAssetArray:(NSMutableArray<WLAsset *> *)imagesAssetArray {
//    [photoViewController.navigationController dismissViewControllerAnimated:YES completion:NULL];
//
//    dispatch_queue_t queue = dispatch_queue_create("welian.sendimagemessage.gcd", DISPATCH_QUEUE_SERIAL);
//    for (WLAsset *asset in imagesAssetArray) {
//        dispatch_async(queue, ^{
//            [asset requestPreviewImageWithCompletion:^(UIImage *image, NSDictionary *info) {
//                BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
//                if (image && downloadFinined) {
//                    @autoreleasepool {
//                        dispatch_async(queue, ^{
//                            RCImageMessage *imageMessage = [RCImageMessage messageWithImage:image];
//                            imageMessage.full = YES;
//                            [self sendMessage:imageMessage pushContent:@"图片"];
//                        });
//                    }
//                }
//            } withProgressHandler:NULL];
//        });
//    }
//}
//
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:NULL];
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    RCImageMessage *imageMessage = [RCImageMessage messageWithImage:image];
    imageMessage.full = YES;
    [self sendMessage:imageMessage pushContent:@"图片"];
    WLImageWriteToSavedPhotosAlbumWithUserLibrary(image, ^(WLAsset *asset, NSError *error) {
        if (asset && !error) {
        }
    });
}
//
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
//
//// 拍照
- (void)clickSheetCamera {
    UIImagePickerController *imagePickerVC = [[UIImagePickerController alloc] init];
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePickerVC.delegate = self;
    imagePickerVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

@end

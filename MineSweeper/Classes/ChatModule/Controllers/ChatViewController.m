//
//  ChatViewController.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/19.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatGroupDetailViewController.h"
#import "SendRedPacketViewController.h"
#import "ChatInfoViewController.h"
#import "UserInfoViewController.h"
#import "RedPacketViewController.h"

#import "QMUINavigationButton.h"

#import "ChatRedPacketCell.h"

#import "RCRedPacketMessage.h"
#import "RCRedPacketGetMessage.h"
#import "RcRedPacketMessageExtraModel.h"

#import "ImGroupModelClient.h"
#import "IGroupDetailInfo.h"
#import "ImModelClient.h"
#import "IRedPacketModel.h"

@interface ChatViewController ()

@property (nonatomic , strong) QMUIModalPresentationViewController *packetModalViewController;
@property (nonatomic , strong) QMUIModalPresentationViewController *payModalViewController;

@property (nonatomic, strong) IGroupDetailInfo *groupDetailInfo;
@property (nonatomic, strong) IFriendModel *friendModel;

@property (nonatomic, strong) IRedPacketModel *openPacketModel;

@property (nonatomic, assign) BOOL isGotoNextVC;

@end

@implementation ChatViewController

- (NSString *)title {
    if (self.conversationType == ConversationType_GROUP) {
        return @"群组";
    }
    if (self.conversationType == ConversationType_CUSTOMERSERVICE) {
        return @"客服";
    }
    return @"聊天";
}

- (void)initSubviews {
    [super initSubviews];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.isGotoNextVC = NO;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (!_isGotoNextVC) {
        [NSUserDefaults setString:nil forKey:@"kNowRedGroupChatUserId"];
        [self clearRCMessagesWithRedPacket];
    }
}

- (void)clearRCMessagesWithRedPacket {
    if (self.conversationType == ConversationType_GROUP && _groupDetailInfo.type.integerValue == 1) {
        [[RCIMClient sharedRCIMClient] quitGroup:self.targetId success:^{
            DLog(@"退出群组聊天成功");
        } error:^(RCErrorCode status) {
            DLog(@"退出群组聊天失败");
        }];
        // 清除聊天记录
        BOOL success = [[RCIMClient sharedRCIMClient] clearMessages:ConversationType_GROUP targetId:self.targetId];
        if (success) {
            DLog(@"删除群组聊天消息成功");
        } else {
            DLog(@"删除群组聊天消息失败");
        }
        // 此方法从服务器端清除历史消息，但是必须先开通历史消息云存储功能。
        [[RCIMClient sharedRCIMClient] clearRemoteHistoryMessages:ConversationType_GROUP targetId:self.targetId recordTime:0 success:^{
            
            DLog(@"删除群组服务器聊天历史消息成功");
        } error:^(RCErrorCode status) {
            DLog(@"删除群组服务器聊天历史消息失败");
        }];
        //添加聊天用户改变监听
        [kNSNotification postNotificationName:kWL_ChatMsgNumChangedNotification object:nil];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.conversationType != ConversationType_CUSTOMERSERVICE) {
        if (configTool.userInfoModel.customer_id.intValue != self.targetId.intValue) {
            UIBarButtonItem *rightBtnItem = [UIBarButtonItem qmui_itemWithButton:[[QMUINavigationButton alloc] initWithImage:[[UIImage imageNamed:@"chats_more_btn"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]] target:self action:@selector(rightBtnItemClicked)];
            self.navigationItem.rightBarButtonItem = rightBtnItem;
        }
    }
    
    [self loadData];
    
    [kNSNotification addObserver:self selector:@selector(loadData) name:@"kChatUserInfoChanged" object:nil];
    //聊天消息数量改变监听
    [kNSNotification postNotificationName:kWL_ChatMsgNumChangedNotification object:nil];
    [kNSNotification addObserver:self selector:@selector(clearRCMessagesWithRedPacket) name:UIApplicationWillTerminateNotification object:nil];
    
    // 退出群聊
    [kNSNotification addObserver:self selector:@selector(quitGroup) name:@"kChatDidEnterBackground" object:nil];
    // 加入群聊
    [kNSNotification addObserver:self selector:@selector(joinGroup) name:@"kChatDidBecomeActive" object:nil];
}

- (void)quitGroup {
    if (self.conversationType == ConversationType_GROUP && _groupDetailInfo.type.integerValue == 1 && !_isGotoNextVC) {
        [[RCIMClient sharedRCIMClient] quitGroup:self.targetId success:^{
            DLog(@"退出群组聊天成功");
        } error:^(RCErrorCode status) {
            DLog(@"退出群组聊天失败");
            [self quitGroup];
        }];
    }
}

- (void)joinGroup {
    // 群组，没有扩展功能，只有发红包 设置扩展功能按钮图片
    if (self.conversationType == ConversationType_GROUP && _groupDetailInfo.type.integerValue == 1 && !_isGotoNextVC) {
        // 加入群聊
        [[RCIMClient sharedRCIMClient] joinGroup:self.targetId groupName:_groupDetailInfo.title success:^{
            DLog(@"加入群组聊天成功");
        } error:^(RCErrorCode status) {
            DLog(@"加入群组聊天失败");
            [self joinGroup];
        }];
    }
}

- (void)loadData {
    [self loadGroupInfo];
    [self loadFriendData];
}

// 获取个人聊天详情
- (void)loadFriendData {
    if (self.conversationType == ConversationType_PRIVATE) {
        WEAKSELF
        [ImModelClient getImChatInfoWithParams:@{@"fuid": @(self.targetId.integerValue)} Success:^(id resultInfo) {
            weakSelf.friendModel = [IFriendModel modelWithDictionary:resultInfo];
            weakSelf.title = weakSelf.friendModel.nickname;
        } Failed:^(NSError *error) {
        
        }];
    }
}

//- (void)dealloc {
//
//}

// 后去群聊详情数据
- (void)loadGroupInfo {
    if (self.conversationType == ConversationType_GROUP) {
//        [WLHUDView showHUDWithStr:@"" dim:YES];
        WEAKSELF
        [ImGroupModelClient getImGroupInfoWithParams:@{@"id" : [NSNumber numberWithInteger:self.targetId.integerValue]}
                                             Success:^(id resultInfo) {
//                                                 [WLHUDView hiddenHud];
                                                 weakSelf.groupDetailInfo = [IGroupDetailInfo modelWithDictionary:resultInfo];
                                                 [weakSelf loadUI];
                                             } Failed:^(NSError *error) {
//                                                 [WLHUDView hiddenHud];
                                             }];
    }
}

- (void)loadUI {
    self.title = _groupDetailInfo.title;
    // 群组，没有扩展功能，只有发红包 设置扩展功能按钮图片
    if (self.conversationType == ConversationType_GROUP && _groupDetailInfo.type.integerValue == 1) {
        [NSUserDefaults setString:self.targetId forKey:@"kNowRedGroupChatUserId"];
        // 加入群聊
        [[RCIMClient sharedRCIMClient] joinGroup:self.targetId groupName:_groupDetailInfo.title success:^{
            DLog(@"加入群组聊天成功");
        } error:^(RCErrorCode status) {
            DLog(@"加入群组聊天失败");
        }];
        
        [self.chatSessionInputBarControl.additionalButton setImage:[UIImage imageNamed:@"chats_redP_btn"] forState:UIControlStateNormal];
        [self.chatSessionInputBarControl.additionalButton setImage:[UIImage imageNamed:@"chats_redP_btn"] forState:UIControlStateSelected];
        [self.chatSessionInputBarControl.additionalButton setImage:[UIImage imageNamed:@"chats_redP_btn"] forState:UIControlStateHighlighted];
        [self.chatSessionInputBarControl.additionalButton addTarget:self action:@selector(redPacketClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        // 游戏群组聊天禁言
        QMUILabel *noteLabel = [[QMUILabel alloc] init];
        noteLabel.font = UIFontMake(14);
        noteLabel.textColor = WLColoerRGB(153.f);
        noteLabel.text = @"禁言中";
        [self.chatSessionInputBarControl.inputTextView addSubview:noteLabel];
        [noteLabel sizeToFit];
        [noteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.chatSessionInputBarControl.inputTextView).mas_offset(6.f);
            make.centerY.mas_equalTo(self.chatSessionInputBarControl.inputTextView);
        }];
        
//        self.chatSessionInputBarControl.inputTextView.text = @"";
        self.chatSessionInputBarControl.inputTextView.textColor = WLColoerRGB(153);
        self.chatSessionInputBarControl.inputTextView.backgroundColor = WLColoerRGB(248);
        self.chatSessionInputBarControl.inputTextView.editable = NO;
        self.chatSessionInputBarControl.switchButton.enabled = NO;
        self.chatSessionInputBarControl.emojiButton.enabled = NO;
        
//        if (!_isGotoNextVC) {
//            // 清除聊天记录
//            BOOL success = [[RCIMClient sharedRCIMClient] clearMessages:ConversationType_GROUP targetId:self.targetId];
//            if (success) {
//                DLog(@"删除群组聊天消息成功");
//            } else {
//                DLog(@"删除群组聊天消息失败");
//            }
//            // 此方法从服务器端清除历史消息，但是必须先开通历史消息云存储功能。
//            [[RCIMClient sharedRCIMClient] clearRemoteHistoryMessages:ConversationType_GROUP targetId:self.targetId recordTime:0 success:^{
//
//                DLog(@"删除群组服务器聊天历史消息成功");
//            } error:^(RCErrorCode status) {
//                DLog(@"删除群组服务器聊天历史消息失败");
//            }];
//        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*!
 点击Cell内容的回调
 
 @param model 消息Cell的数据模型
 */
- (void)didTapMessageCell:(RCMessageModel *)model {
    [super didTapMessageCell:model];
    if ([model.content isMemberOfClass:[RCRedPacketMessage class]]) {
        DLog(@"红包 didTapMessageCell");
        [self openRedPacketClicked:model];
    }
    if ([model.content isMemberOfClass:[RCRedPacketGetMessage class]]) {
        // 查看红包历史
        RCRedPacketGetMessage *message = (RCRedPacketGetMessage *) model.content;
        [self lookRedPacketHistory:message.pack_id];
    }
    if ([model.content isMemberOfClass:[RCLocationMessage class]]) {
        DLog(@"位置 RCLocationMessage");
        [self presentLocationViewController:(RCLocationMessage *)model.content];
    }
    DLog(@"didTapMessageCell");
}

// 打开红包点击
- (void)openRedPacketClicked:(RCMessageModel *)model {
    RCRedPacketMessage *message = (RCRedPacketMessage *) model.content;
        WEAKSELF
    [WLHUDView showHUDWithStr:@"" dim:YES];
    [ImModelClient imGrabRedpackWithParams:@{@"id" : @(message.pack_id.integerValue)} Success:^(id resultInfo) {
        [WLHUDView hiddenHud];
        IRedPacketModel * redmodel = [IRedPacketModel modelWithDictionary:resultInfo];
            // 更新聊天消息数据
//            [message setDrawed:@"1"];
//            [message setDrawUid:configTool.loginUser.uid];
//            [message setDrawName:configTool.userInfoModel.nickname];
        [message setPack_id:redmodel.redpack_id];
        [message setMoney:redmodel.money];
        wl_dispatch_sync_on_main_queue(^{
            // 设置发送红包的默认扩展属性
            RcRedPacketMessageExtraModel *extraModel = [RcRedPacketMessageExtraModel new];
            extraModel.status = @(1);
            // 设置扩展字段 红包状态 0：默认  1：已领取 2：红包已抢完 3：红包过期
            BOOL success = [[RCIMClient sharedRCIMClient] setMessageExtra:model.messageId value:[extraModel modelToJSONString]];
            if (success) {
                 [self.conversationMessageCollectionView reloadData];
            }
            // 设置未查看红包详情
//            [NSUserDefaults setBool:false forKey:redmodel.redpack_id];
            // 领到红包
            [weakSelf showOpenPacket:redmodel];
            
//            [weakSelf sendGetRedPacketImMessage:message drawName:@"我我额为"];
//            [weakSelf sendGetRedPacketImMessage:message drawName:@"维吾尔文二翁绕弯儿"];
//            [weakSelf sendGetRedPacketImMessage:message drawName:@"未亡人热翁绕弯儿翁绕弯儿翁绕弯儿"];
//            [weakSelf sendGetRedPacketImMessage:message drawName:@"地方大幅度"];
        });
    } Failed:^(NSError *error) {
            [WLHUDView hiddenHud];
            // 红包已被抢完
        if (error.localizedDescription.length > 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                // 设置发送红包的默认扩展属性
                RcRedPacketMessageExtraModel *extraModel = [RcRedPacketMessageExtraModel new];
                if ([error.localizedDescription isEqualToString:@"红包已抢完"]) {
                    extraModel.status = @(2);
                    [[RCIMClient sharedRCIMClient] setMessageExtra:model.messageId value:[extraModel modelToJSONString]];
                    [weakSelf.conversationMessageCollectionView reloadData];
                    [weakSelf showPacketGrabEnd:@"红包已经被抢完"];
                    return ;
                }
                if ([error.localizedDescription isEqualToString:@"红包已抢"]) {
                    // 查看红包历史
                    extraModel.status = @(1);
                    [[RCIMClient sharedRCIMClient] setMessageExtra:model.messageId value:[extraModel modelToJSONString]];
                    [weakSelf.conversationMessageCollectionView reloadData];
                    [self lookRedPacketHistory:message.pack_id];
                    return ;
                }
                if ([error.localizedDescription isEqualToString:@"红包过期"]) {
                    extraModel.status = @(3);
                    [[RCIMClient sharedRCIMClient] setMessageExtra:model.messageId value:[extraModel modelToJSONString]];
                    [weakSelf.conversationMessageCollectionView reloadData];
                    [weakSelf showPacketGrabEnd:@"红包已过期"];
                    return ;
                }
                [WLHUDView showErrorHUD:error.localizedDescription];
            });
        }
    }];
//    }
}

- (void)updateDataChangeUI {
    [self.conversationMessageCollectionView reloadData];
}

- (void)sendGetRedPacketImMessage:(RCRedPacketMessage *)redPacketMsg drawName:(NSString *)drawName {
    // 构建消息的内容，这里以文本消息为例。
    RCRedPacketGetMessage *msg = [[RCRedPacketGetMessage alloc] init];
    RCUserInfo *senderUserInfo = [[RCUserInfo alloc] initWithUserId:configTool.userInfoModel.userId
                                                               name:configTool.userInfoModel.nickname
                                                           portrait:configTool.userInfoModel.avatar];
    msg.senderUserInfo = senderUserInfo;
    msg.pack_id = redPacketMsg.pack_id;
    msg.title = redPacketMsg.title;
    msg.total_money = redPacketMsg.total_money;
    msg.num = redPacketMsg.num;
    msg.drawed = @"1";
    msg.drawUid = configTool.loginUser.uid;
    msg.drawName = drawName;// configTool.userInfoModel.nickname;
    msg.money = redPacketMsg.money;
    msg.thunder = redPacketMsg.thunder;
    msg.uid = @(configTool.loginUser.uid.integerValue);
    msg.avatar = configTool.userInfoModel.avatar;
    msg.name = configTool.userInfoModel.nickname;
    //    [self sendMessage:msg pushContent:@"hahha"];
    //    RCTextMessage *testMessage = [RCTextMessage messageWithContent:@"test"];
    // 调用RCIMClient的sendMessage方法进行发送，结果会通过回调进行反馈。
    
//    WEAKSELF
    [[RCIM sharedRCIM] sendMessage:ConversationType_GROUP
                          targetId:_groupDetailInfo.groupId
                           content:msg
                       pushContent:nil
                          pushData:nil
                           success:^(long messageId) {
                               DLog(@"发送成功。当前消息ID：%ld", messageId);
                           } error:^(RCErrorCode nErrorCode, long messageId) {
                               DLog(@"发送失败。消息ID：%ld， 错误码：%ld", messageId, nErrorCode);
                           }];
    
//    WEAKSELF
//    [[RCIMClient sharedRCIMClient] sendMessage:ConversationType_GROUP
//                                      targetId:_groupDetailInfo.groupId
//                                       content:msg
//                                   pushContent:nil
//                                      pushData:nil
//                                       success:^(long messageId) {
//                                           DLog(@"发送成功。当前消息ID：%ld", messageId);
//                                           [[RCIMClient sharedRCIMClient] insertOutgoingMessage:ConversationType_GROUP targetId: weakSelf.groupDetailInfo.groupId sentStatus:SentStatus_SENT content:msg];
//                                       } error:^(RCErrorCode nErrorCode, long messageId) {
//                                           DLog(@"发送失败。消息ID：%ld， 错误码：%ld", messageId, nErrorCode);
//                                       }];
}

#pragma mark 点击头像
- (void)didTapCellPortrait:(NSString *)userId {
    self.isGotoNextVC = YES;
    DLog(@"didTapCellPortrait-----------: %@", userId);
    UserInfoViewController *vc = [[UserInfoViewController alloc] init];
    vc.userId = userId;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 点击头像
//- (void)didLongPressCellPortrait:(NSString *)userId {
//    DLog(@"didLongPressCellPortrait-----------");
//}

#pragma mark - private
- (void)toGroupDetailInfo {
    self.isGotoNextVC = YES;
    ChatGroupDetailViewController *vc = [[ChatGroupDetailViewController alloc] init];
    vc.groupId = self.targetId;
    vc.groupDetailInfo = self.groupDetailInfo;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)toUserChatDetailInfo {
    self.isGotoNextVC = YES;
    ChatInfoViewController *vc = [[ChatInfoViewController alloc] init];
    vc.uid = self.targetId;
    vc.friendModel = self.friendModel;
    [self.navigationController pushViewController:vc animated:YES];
}

// 右侧按钮点击
- (void)rightBtnItemClicked {
    if (self.conversationType == ConversationType_GROUP) {
        if (_groupDetailInfo) {
            [self toGroupDetailInfo];
        } else {
            WEAKSELF
            [WLHUDView showHUDWithStr:@"" dim:YES];
            [ImGroupModelClient getImGroupInfoWithParams:@{@"id" : [NSNumber numberWithInteger:self.targetId.integerValue]}
                                                 Success:^(id resultInfo) {
                                                    [WLHUDView hiddenHud];
                                                     weakSelf.groupDetailInfo = [IGroupDetailInfo modelWithDictionary:resultInfo];
                                                     [weakSelf toGroupDetailInfo];
                                                 } Failed:^(NSError *error) {
                                                     if (error.localizedDescription.length > 0) {
                                                         [WLHUDView showErrorHUD:error.localizedDescription];
                                                     } else {
                                                         [WLHUDView hiddenHud];
                                                     }
                                                 }];
        }
    }
    if (self.conversationType == ConversationType_PRIVATE) {
        if (_friendModel) {
            [self toUserChatDetailInfo];
        } else {
            WEAKSELF
            [WLHUDView showHUDWithStr:@"" dim:YES];
            [ImModelClient getImChatInfoWithParams:@{@"fuid": @(self.targetId.integerValue)} Success:^(id resultInfo) {
                [WLHUDView hiddenHud];
                weakSelf.friendModel = [IFriendModel modelWithDictionary:resultInfo];
                [weakSelf toUserChatDetailInfo];
            } Failed:^(NSError *error) {
                if (error.localizedDescription.length > 0) {
                    [WLHUDView showErrorHUD:error.localizedDescription];
                } else {
                    [WLHUDView hiddenHud];
                }
            }];
        }
    }
}

// 发红包
- (void)redPacketClicked:(UIButton *)sender {
    self.isGotoNextVC = YES;
    DLog(@"redPacketClicked-----------");
    [self.chatSessionInputBarControl resetToDefaultStatus];
//     进入发红包页面
    SendRedPacketViewController *vc = [[SendRedPacketViewController alloc] init];
    vc.groupId = self.targetId;
    @weakify(self);
    vc.sendRedPacketBlock = ^(RCMessage *sendMsg) {
        @strongify(self);
        // 在会话页面中插入一条消息并展示
        [self appendAndDisplayMessage:sendMsg];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

// 输入支付密码
- (void)inputPayPwd {
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 270, 189.f)];
    contentView.backgroundColor = [UIColor whiteColor];
    [contentView wl_setCornerRadius:5.f];
    
    QMUILabel *titleLabel = [[QMUILabel alloc] init];
    titleLabel.font = UIFontMake(17);
    titleLabel.textColor = WLColoerRGB(51.f);
    titleLabel.text = @"支付";
    [contentView addSubview:titleLabel];
    [titleLabel sizeToFit];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(contentView);
        make.top.mas_equalTo(contentView).mas_offset(16.f);
    }];
    
    QMUILabel *moneyLabel = [[QMUILabel alloc] init];
    moneyLabel.font = UIFontMake(17);
    moneyLabel.textColor = WLColoerRGB(51.f);
    moneyLabel.text = @"50.00元";
    [contentView addSubview:moneyLabel];
    //    self.idLabel = nameLabel;
    [moneyLabel sizeToFit];
    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(contentView);
        make.top.mas_equalTo(titleLabel.mas_bottom).mas_offset(15.f);
    }];
    
    QMUITextField *moneyTextField = [[QMUITextField alloc] init];
    moneyTextField.placeholder = @"输入支付密码";
    moneyTextField.placeholderColor = WLColoerRGB(153.f);
    moneyTextField.font = UIFontMake(14.f);
    moneyTextField.textColor = WLColoerRGB(51.f);
    moneyTextField.secureTextEntry = YES;
    moneyTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    [contentView addSubview:moneyTextField];
    [moneyTextField wl_setCornerRadius:5.f];
    [moneyTextField wl_setBorderWidth:1.f color:WLColoerRGB(242.f)];
    [moneyTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(240.f, 36.f));
        make.centerX.mas_equalTo(contentView);
        make.top.mas_equalTo(moneyLabel.mas_bottom).mas_offset(15.f);
    }];
    
    QMUIFillButton *payBtn = [[QMUIFillButton alloc] initWithFillType:QMUIFillButtonColorRed];
    [payBtn setTitle:@"确认支付" forState:UIControlStateNormal];
    payBtn.titleLabel.font = WLFONT(14);
    [payBtn addTarget:self action:@selector(payBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [payBtn setCornerRadius:5.f];
    [contentView addSubview:payBtn];
    [payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(115.f, 36.f));
        make.left.mas_equalTo(moneyTextField);
        make.top.mas_equalTo(moneyTextField.mas_bottom).mas_offset(15.f);
    }];

    QMUIFillButton *cancelBtn = [[QMUIFillButton alloc] initWithFillType:QMUIFillButtonColorGray];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = WLFONT(14);
    [cancelBtn addTarget:self action:@selector(cancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setCornerRadius:5.f];
    [contentView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(payBtn);
        make.right.mas_equalTo(moneyTextField);
        make.top.mas_equalTo(moneyTextField.mas_bottom).mas_offset(15.f);
    }];
    
    QMUIModalPresentationViewController *modalViewController = [[QMUIModalPresentationViewController alloc] init];
    modalViewController.animationStyle = QMUIModalPresentationAnimationStylePopup;
    modalViewController.contentView = contentView;
    modalViewController.modal = YES;
    //    modalViewController.delegate = self;
    [modalViewController showWithAnimated:YES completion:nil];
    self.payModalViewController =  modalViewController;
    
    
//    QMUIDialogTextFieldViewController *dialogViewController = [[QMUIDialogTextFieldViewController alloc] init];
//    dialogViewController.title = @"支付";
//    [dialogViewController addTextFieldWithTitle:@"" configurationHandler:^(QMUILabel *titleLabel, QMUITextField *textField, CALayer *separatorLayer) {
//        titleLabel.text = @"测试";
//        textField.placeholder = @"请输入支付密码";
//        textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
////        textField.maximumTextLength = 6;
//        textField.secureTextEntry = YES;
//    }];
//    dialogViewController.enablesSubmitButtonAutomatically = NO;// 为了演示效果与第二个 cell 的区分开，这里手动置为 NO，平时的默认值为 YES
//    [dialogViewController addCancelButtonWithText:@"取消" block:nil];
//    [dialogViewController addSubmitButtonWithText:@"确定" block:^(QMUIDialogTextFieldViewController *aDialogViewController) {
//        if (aDialogViewController.textFields.firstObject.text.length > 0) {
//            [aDialogViewController hide];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [QMUITips showSucceed:@"提交成功" inView:self.view hideAfterDelay:1.2];
//            });
//        } else {
//            [QMUITips showInfo:@"请填写内容" inView:self.view hideAfterDelay:1.2];
//        }
//    }];
//    [dialogViewController show];
}

// 确认支付
- (void)payBtnClicked:(UIButton *)sender {
    
}

// 取消支付
- (void)cancelBtnClicked:(UIButton *)sender {
     [_payModalViewController hideWithAnimated:YES completion:nil];
    
}

// 打开红包被抢完
- (void)showPacketGrabEnd:(NSString *)title {
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 300)];
    
    UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"openRedP_redP_img"]];
    //    contentView.backgroundColor = UIColorWhite;
    [contentView addSubview:bgView];
    [bgView sizeToFit];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(contentView);
        make.centerY.mas_equalTo(contentView);
    }];
    
    QMUILabel *nameLabel = [[QMUILabel alloc] init];
    nameLabel.font = UIFontMake(14);
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.text = title.length > 0 ? title : @"红包已经被抢完";
    [contentView addSubview:nameLabel];
    //    self.idLabel = nameLabel;
    [nameLabel sizeToFit];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(contentView);
        make.top.mas_equalTo(bgView.mas_top).mas_offset(181.f);
    }];
    
    QMUIModalPresentationViewController *modalViewController = [[QMUIModalPresentationViewController alloc] init];
    modalViewController.animationStyle = QMUIModalPresentationAnimationStylePopup;
    modalViewController.contentView = contentView;
    //    modalViewController.delegate = self;
    [modalViewController showWithAnimated:YES completion:nil];
    self.packetModalViewController = modalViewController;
    //    QMUIModalPresentationViewControllerDelegate
}

// 打开红包页面
- (void)showOpenPacket:(IRedPacketModel *)model {
    self.openPacketModel = model;
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 300)];
    
    UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"openRedP_redP_img"]];
    //    contentView.backgroundColor = UIColorWhite;
    [contentView addSubview:bgView];
    [bgView sizeToFit];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(contentView);
        make.centerY.mas_equalTo(contentView);
    }];
    
    QMUILabel *nameLabel = [[QMUILabel alloc] init];
    nameLabel.font = UIFontMake(15);
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.text = @"你抢到了";
    [contentView addSubview:nameLabel];
    //    self.idLabel = nameLabel;
    [nameLabel sizeToFit];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(contentView);
        make.top.mas_equalTo(bgView.mas_top).mas_offset(165.f);
    }];
    
    QMUILabel *moneyLabel = [[QMUILabel alloc] init];
    moneyLabel.font = UIFontMake(30);
    moneyLabel.textColor = [UIColor whiteColor];
    NSString *moneyStr = [NSString stringWithFormat:@"%@元",model.money];
    moneyLabel.attributedText = [NSString wl_getAttributedInfoString:moneyStr
                                                           searchStr:@"元"
                                                               color:[UIColor whiteColor]
                                                                font:UIFontMake(10.f)] ;
    [contentView addSubview:moneyLabel];
    [moneyLabel sizeToFit];
    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(contentView);
        make.top.mas_equalTo(nameLabel.mas_bottom).mas_offset(8.f);
    }];
    
    UIButton *lookMoreBtn = [[UIButton alloc] init];
    [lookMoreBtn setTitle:@"查看全部" forState:UIControlStateNormal];
    [lookMoreBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    lookMoreBtn.titleLabel.font = WLFONT(14);
    [lookMoreBtn addTarget:self action:@selector(lookMoreBtnClickedBtn:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:lookMoreBtn];
    [lookMoreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(200.f);
        make.height.mas_equalTo(44.f);
        make.centerX.mas_equalTo(contentView);
        make.top.mas_equalTo(moneyLabel.mas_bottom).mas_offset(-5.f);
    }];
    
    QMUIModalPresentationViewController *modalViewController = [[QMUIModalPresentationViewController alloc] init];
    modalViewController.animationStyle = QMUIModalPresentationAnimationStylePopup;
    modalViewController.contentView = contentView;
    //    modalViewController.delegate = self;
    [modalViewController showWithAnimated:YES completion:nil];
    self.packetModalViewController = modalViewController;
    //    QMUIModalPresentationViewControllerDelegate
}

// 查看更多红包
- (void)lookMoreBtnClickedBtn:(UIButton *)sender {
    self.isGotoNextVC = YES;
    DLog(@"lookMoreBtnClickedBtn --------");
    [_packetModalViewController hideWithAnimated:YES completion:nil];
    // 查看红包历史
//    [self lookRedPacketHistory:_openPacketModel.redpack_id];
    RedPacketViewController *vc = [[RedPacketViewController alloc] init];
    vc.packetId = _openPacketModel.redpack_id;
    vc.isFirstLook = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)lookRedPacketHistory:(NSString *)packId {
    self.isGotoNextVC = YES;
    RedPacketViewController *vc = [[RedPacketViewController alloc] init];
    vc.packetId = packId;
    vc.isFirstLook = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

@end

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

/*!
 扩展功能板的点击回调
 
 @param pluginBoardView 输入扩展功能板View
 @param tag             输入扩展功能(Item)的唯一标示
 */
//- (void)pluginBoardView:(RCPluginBoardView *)pluginBoardView clickedItemWithTag:(NSInteger)tag {
//    DLog(@"pluginBoardView ------");
//}

//- (void)initSubviews {
//    [super initSubviews];
//    UIBarButtonItem *rightBtnItem = [UIBarButtonItem qmui_itemWithButton:[[QMUINavigationButton alloc] initWithImage:[[UIImage imageNamed:@"chats_more_btn"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]] target:self action:@selector(rightBtnItemClicked)];
//    self.navigationItem.rightBarButtonItem = rightBtnItem;

    // 隐藏分割线
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.backgroundColor = WLColoerRGB(248.f);
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *rightBtnItem = [UIBarButtonItem qmui_itemWithButton:[[QMUINavigationButton alloc] initWithImage:[[UIImage imageNamed:@"chats_more_btn"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]] target:self action:@selector(rightBtnItemClicked)];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
    
    [self loadData];
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
        } Failed:^(NSError *error) {
        
        }];
    }
}

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
    // 群组，没有扩展功能，只有发红包 设置扩展功能按钮图片
    if (self.conversationType == ConversationType_GROUP && _groupDetailInfo.type.integerValue == 1) {
        [self.chatSessionInputBarControl.additionalButton setImage:[UIImage imageNamed:@"chats_redP_btn"] forState:UIControlStateNormal];
        [self.chatSessionInputBarControl.additionalButton setImage:[UIImage imageNamed:@"chats_redP_btn"] forState:UIControlStateSelected];
        [self.chatSessionInputBarControl.additionalButton setImage:[UIImage imageNamed:@"chats_redP_btn"] forState:UIControlStateHighlighted];
        [self.chatSessionInputBarControl.additionalButton addTarget:self action:@selector(redPacketClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
}

//- (void)inputTextView:(UITextView *)inputTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
//    [super inputTextView:inputTextView shouldChangeTextInRange:range replacementText:text];
//
//    DLog(@"shouldChangeTextInRange-----------");
//}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*!
 点击Cell中URL的回调
 
 @param url   点击的URL
 @param model 消息Cell的数据模型
 */
//- (void)didTapUrlInMessageCell:(NSString *)url
//                         model:(RCMessageModel *)model {
//    DLog(@"didTapUrlInMessageCell-----------");
//}

/*!
 点击Cell中电话号码的回调
 
 @param phoneNumber 点击的电话号码
 @param model       消息Cell的数据模型
 */
//- (void)didTapPhoneNumberInMessageCell:(NSString *)phoneNumber
//                                 model:(RCMessageModel *)model {
//    DLog(@"didTapPhoneNumberInMessageCell-----------");
//}

/*!
 点击Cell内容的回调
 
 @param model 消息Cell的数据模型
 */
- (void)didTapMessageCell:(RCMessageModel *)model {
    [super didTapMessageCell:model];
    if ([model.content isMemberOfClass:[RCRedPacketMessage class]]) {
        DLog(@"红包 didTapMessageCell");
        RCRedPacketMessage *message = (RCRedPacketMessage *) model.content;
        if (message.isGet.integerValue == 1) {
            DLog(@"红包 已领过");
        }
        [ImModelClient imGrabRedpackWithParams:@{@"id" : @(message.pack_id.integerValue)} Success:^(id resultInfo) {
            IRedPacketModel * model = [IRedPacketModel modelWithDictionary:resultInfo];
            // 领到红包
            [self showOpenPacket:model];
        } Failed:^(NSError *error) {
            if (error.localizedDescription.length > 0) {
                if ([error.localizedDescription isEqualToString:@"红包已抢"]) {
                    
                } else {
                    [WLHUDView showErrorHUD:error.localizedDescription];
                }
            }
        }];
        
        // 领红包
//        [self showPacketGrabEnd];
        
    }
    if ([model.content isMemberOfClass:[RCLocationMessage class]]) {
        DLog(@"位置 RCLocationMessage");
        [self presentLocationViewController:(RCLocationMessage *)model.content];
    }
    DLog(@"didTapMessageCell");
}

#pragma mark 点击头像
- (void)didTapCellPortrait:(NSString *)userId {
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
    ChatGroupDetailViewController *vc = [[ChatGroupDetailViewController alloc] init];
    vc.groupId = self.targetId;
    vc.groupDetailInfo = self.groupDetailInfo;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)toUserChatDetailInfo {
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
                                                      [WLHUDView hiddenHud];
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
                [WLHUDView hiddenHud];
            }];
        }
    }
}

// 发红包
- (void)redPacketClicked:(UIButton *)sender {
    DLog(@"redPacketClicked-----------");
    [self.chatSessionInputBarControl resetToDefaultStatus];
//     进入发红包页面
    SendRedPacketViewController *vc = [[SendRedPacketViewController alloc] init];
    vc.groupId = self.targetId;
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
- (void)showPacketGrabEnd {
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
    nameLabel.text = @"红包已经被抢完";
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
    DLog(@"lookMoreBtnClickedBtn --------");
    [_packetModalViewController hideWithAnimated:YES completion:nil];
    
    RedPacketViewController *vc = [[RedPacketViewController alloc] init];
    vc.packetId = _openPacketModel.redpack_id;
    [self.navigationController pushViewController:vc animated:YES];
}

@end

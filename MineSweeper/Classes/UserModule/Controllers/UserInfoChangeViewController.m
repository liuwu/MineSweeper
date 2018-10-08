//
//  UserInfoChangeViewController.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/23.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "UserInfoChangeViewController.h"

#import "LWLoginTextField.h"
#import "LWLoginTextFieldView.h"

#import "UserModelClient.h"
#import "FriendModelClient.h"

@interface UserInfoChangeViewController ()

@property (nonatomic, strong) LWLoginTextFieldView *infoTxtView;
@property (nonatomic, strong) UIButton *loginBtn;

@property (nonatomic, strong) IFriendDetailInfoModel *userModel;

@end

@implementation UserInfoChangeViewController

- (NSString *)title {
    switch (_changeType) {
        case UserInfoChangeTypeNickName:
            return @"昵称";
            break;
        case UserInfoChangeTypeRealName:
            return @"真实姓名";
            break;
        case UserInfoChangeTypeSetFriendRemark:
            return @"设置备注";
            break;
        default:
            return @"";
            break;
    }
}

- (instancetype)initWithUserInfoChangeType:(UserInfoChangeType)changeType {
    self.changeType = changeType;
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[YYTextKeyboardManager defaultManager] addObserver:self];
    //    [DaiDodgeKeyboard addRegisterTheViewNeedDodgeKeyboard:self.view];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    //    [DaiDodgeKeyboard removeRegisterTheViewNeedDodgeKeyboard];
    [[YYTextKeyboardManager defaultManager] removeObserver:self];
}

- (void)initSubviews {
    UIBarButtonItem *rightBtnItem = [UIBarButtonItem qmui_itemWithTitle:@"保存" target:self action:@selector(rightBarButtonItemClicked)];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
    
    [super initSubviews];
    [self addSubviews];
    [self addConstrainsForSubviews];
    
    if (_changeType == UserInfoChangeTypeSetFriendRemark) {
        [self loadData];
    }
}

- (void)loadData {
    NSDictionary *params = @{@"uid" : _uid};
    WEAKSELF
    [WLHUDView showHUDWithStr:@"" dim:YES];
    [FriendModelClient getImMemberInfoWithParams:params Success:^(id resultInfo) {
        [WLHUDView hiddenHud];
        weakSelf.userModel = [IFriendDetailInfoModel modelWithDictionary:resultInfo];
        [weakSelf updateUI];
        //        [weakSelf.tableView reloadData];
    } Failed:^(NSError *error) {
        [WLHUDView hiddenHud];
    }];
}
- (void)updateUI {
    switch (_changeType) {
        case UserInfoChangeTypeNickName:
            _infoTxtView.textField.placeholder = @"昵称";
            _infoTxtView.textField.text = configTool.userInfoModel.nickname;
            break;
        case UserInfoChangeTypeRealName:
            _infoTxtView.textField.text = configTool.userInfoModel.realname;
            break;
        case UserInfoChangeTypeSetFriendRemark:
            _infoTxtView.textField.text = _userModel.remark;
            break;
        default:
            break;
    }
}

#pragma mark setup
// 添加页面UI组件
- (void)addSubviews {
    self.view.backgroundColor = WLColoerRGB(248.f);
    
    LWLoginTextFieldView *infoTxtView = [[LWLoginTextFieldView alloc] initWithTextFieldType:LWLoginTextFieldTypeDefault];
    [self.view addSubview:infoTxtView];
    self.infoTxtView = infoTxtView;
//    [infoTxtView.textField becomeFirstResponder];
    
    switch (_changeType) {
        case UserInfoChangeTypeNickName:
            infoTxtView.textField.placeholder = @"昵称";
            infoTxtView.textField.text = configTool.userInfoModel.nickname;
            break;
        case UserInfoChangeTypeRealName:
            infoTxtView.textField.placeholder = @"真实姓名";
            infoTxtView.textField.text = configTool.userInfoModel.realname;
            break;
        case UserInfoChangeTypeSetFriendRemark:
            infoTxtView.textField.placeholder = @"备注";
            infoTxtView.textField.text = _userModel.remark;
            break;
        default:
            break;
    }
//    QMUIFillButton *loginBtn = [[QMUIFillButton alloc] initWithFillType:QMUIFillButtonColorRed];
//    loginBtn.titleLabel.font = WLFONT(18);
//    [loginBtn addTarget:self action:@selector(didClickLoginBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [loginBtn setTitle:@"保存" forState:UIControlStateNormal];
//    [loginBtn setCornerRadius:5.f];
//    [self.view addSubview:loginBtn];
//    self.loginBtn = loginBtn;
    
    //添加单击手势
//    UITapGestureRecognizer *tap = [UITapGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
//        [[self.view wl_findFirstResponder] resignFirstResponder];
//    }];
//    [self.view addGestureRecognizer:tap];
}

- (BOOL)shouldHideKeyboardWhenTouchInView:(UIView *)view {
    // 表示点击空白区域都会降下键盘
    return YES;
}

// 布局控制
- (void)addConstrainsForSubviews {
    [_infoTxtView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(self.qmui_navigationBarMaxYInViewCoordinator + kWL_NormalMarginWidth_14);
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(DEVICE_WIDTH - kWL_NormalMarginWidth_10 * 2.f);
        make.height.mas_equalTo(kWL_NormalTextFieldHeight);
    }];
    
//    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(self.infoTxtView);
//        make.centerX.mas_equalTo(self.view);
//        make.top.mas_equalTo(self.infoTxtView.mas_bottom).offset(kWL_NormalMarginWidth_20);
//    }];
}


#pragma mark - Private
// 登录按钮点击
//- (void)didClickLoginBtn:(UIButton *)sender {
//    [[self.view wl_findFirstResponder] resignFirstResponder];
//
//    WEAKSELF
//    switch (_changeType) {
//        case UserInfoChangeTypeNickName:
//        {
//            if (_infoTxtView.textField.text.wl_trimWhitespaceAndNewlines.length == 0) {
//                [WLHUDView showOnlyTextHUD:@"请输入昵称"];
//                return;
//            }
//            NSDictionary *params = @{
//                                     @"nickname" : _infoTxtView.textField.text.wl_trimWhitespaceAndNewlines,
//                                     @"realname" : configTool.userInfoModel.realname ? : @"",
//                                     @"gender" : configTool.userInfoModel.gender ? : @"",
////                                     @"province" : configTool.userInfoModel.gender ? : @"",
////                                     @"city" : configTool.userInfoModel.gender ? : @"",
//                                     };
//
//            [UserModelClient changeUserInfoWithParams:params
//                                              Success:^(id resultInfo) {
//                                                  configTool.userInfoModel.nickname = weakSelf.infoTxtView.textField.text.wl_trimWhitespaceAndNewlines;
//                                                  [[NSNotificationCenter defaultCenter] postNotificationName:@"kNickNameChanged" object:nil];
//                                                  [weakSelf.navigationController popViewControllerAnimated:YES];
//                                              } Failed:^(NSError *error) {
//
//                                              }];
//        }
//            break;
//        case UserInfoChangeTypeRealName:
//        {
//            if (_infoTxtView.textField.text.wl_trimWhitespaceAndNewlines.length == 0) {
//                [WLHUDView showOnlyTextHUD:@"请输入真实姓名"];
//                return;
//            }
//            NSDictionary *params = @{@"realname" : _infoTxtView.textField.text.wl_trimWhitespaceAndNewlines};
//            [UserModelClient changeUserInfoWithParams:params
//                                              Success:^(id resultInfo) {
//                                                  configTool.userInfoModel.realname = weakSelf.infoTxtView.textField.text.wl_trimWhitespaceAndNewlines;
//                                                  [[NSNotificationCenter defaultCenter] postNotificationName:@"kRealNameChanged" object:nil];
//                                                  [weakSelf.navigationController popViewControllerAnimated:YES];
//                                              } Failed:^(NSError *error) {
//
//                                              }];
//        }
//            break;
//        default:
//            break;
//    }
//}

- (void)rightBarButtonItemClicked {
    [[self.view wl_findFirstResponder] resignFirstResponder];
    
    WEAKSELF
    switch (_changeType) {
        case UserInfoChangeTypeNickName:
        {
            if (_infoTxtView.textField.text.wl_trimWhitespaceAndNewlines.length == 0) {
                [WLHUDView showOnlyTextHUD:@"请输入昵称"];
                return;
            }
            NSDictionary *params = @{
                                     @"nickname" : _infoTxtView.textField.text.wl_trimWhitespaceAndNewlines,
                                     @"realname" : configTool.userInfoModel.realname ? : @"",
                                     @"gender" : configTool.userInfoModel.gender ? : @"",
                                     //                                     @"province" : configTool.userInfoModel.gender ? : @"",
                                     //                                     @"city" : configTool.userInfoModel.gender ? : @"",
                                     };
            [WLHUDView showHUDWithStr:@"" dim:YES];
            [UserModelClient changeUserInfoWithParams:params
                                              Success:^(id resultInfo) {
                                                  [WLHUDView hiddenHud];
                                                  configTool.userInfoModel.nickname = weakSelf.infoTxtView.textField.text.wl_trimWhitespaceAndNewlines;
                                                  [[NSNotificationCenter defaultCenter] postNotificationName:@"kNickNameChanged" object:nil];
                                                  [weakSelf.navigationController popViewControllerAnimated:YES];
                                              } Failed:^(NSError *error) {
                                                  if (error.localizedDescription.length > 0) {
                                                      [WLHUDView showErrorHUD:error.localizedDescription];
                                                  } else {
                                                      [WLHUDView hiddenHud];
                                                  }
                                              }];
        }
            break;
        case UserInfoChangeTypeRealName:
        {
            if (_infoTxtView.textField.text.wl_trimWhitespaceAndNewlines.length == 0) {
                [WLHUDView showOnlyTextHUD:@"请输入真实姓名"];
                return;
            }
            NSDictionary *params = @{
                                     @"nickname" : configTool.userInfoModel.nickname ? : @"",
                                     @"realname" : _infoTxtView.textField.text.wl_trimWhitespaceAndNewlines,
                                     @"gender" : configTool.userInfoModel.gender ? : @"",
                                     //                                     @"province" : configTool.userInfoModel.gender ? : @"",
                                     //                                     @"city" : configTool.userInfoModel.gender ? : @"",
                                     };
            [WLHUDView showHUDWithStr:@"" dim:YES];
            [UserModelClient changeUserInfoWithParams:params
                                              Success:^(id resultInfo) {
                                                  [WLHUDView hiddenHud];
                                                  configTool.userInfoModel.realname = weakSelf.infoTxtView.textField.text.wl_trimWhitespaceAndNewlines;
                                                  [[NSNotificationCenter defaultCenter] postNotificationName:@"kRealNameChanged" object:nil];
                                                  [weakSelf.navigationController popViewControllerAnimated:YES];
                                              } Failed:^(NSError *error) {
                                                  if (error.localizedDescription.length > 0) {
                                                      [WLHUDView showErrorHUD:error.localizedDescription];
                                                  } else {
                                                      [WLHUDView hiddenHud];
                                                  }
                                              }];
        }
            break;
        case UserInfoChangeTypeSetFriendRemark:
        {
            if (_infoTxtView.textField.text.wl_trimWhitespaceAndNewlines.length == 0) {
                [WLHUDView showOnlyTextHUD:@"请输入备注"];
                return;
            }
            NSDictionary *params = @{@"fuid" : _uid,
                                     @"remark" : _infoTxtView.textField.text.wl_trimWhitespaceAndNewlines
                                     };
            [WLHUDView showHUDWithStr:@"" dim:YES];
            [FriendModelClient setImFriendRemarkWithParams:params Success:^(id resultInfo) {
                [WLHUDView showSuccessHUD:@"设置成功"];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            } Failed:^(NSError *error) {
                if (error.localizedDescription.length > 0) {
                    [WLHUDView showErrorHUD:error.localizedDescription];
                } else {
                    [WLHUDView hiddenHud];
                }
            }];
        }
            break;
        default:
            break;
    }
}

@end

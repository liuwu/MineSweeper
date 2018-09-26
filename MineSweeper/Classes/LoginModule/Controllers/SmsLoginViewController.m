//
//  SmsLoginViewController.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/11.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "SmsLoginViewController.h"
#import "LWLoginTextField.h"
#import "LWLoginTextFieldView.h"

#import "LoginModuleClient.h"

#import "BaseResultModel.h"

#import <YYKit/YYKit.h>


@interface SmsLoginViewController ()

@property (nonatomic, strong) LWLoginTextFieldView *phoneTxtView;
@property (nonatomic, strong) LWLoginTextFieldView *imageVcodeTxtView;
@property (nonatomic, strong) LWLoginTextFieldView *vcodeTxtView;
@property (nonatomic, strong) LWLoginTextFieldView *pwdTxtView;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UIButton *pwdLoginBtn;

@end

@implementation SmsLoginViewController

- (NSString *)title {
    switch (_useType) {
        case UseTypeSMS:
            return @"短信登录";
            break;
        case UseTypeRegist:
            return @"注册";
            break;
        case UseTypeForget:
            return @"重置密码";
            break;
        case UseTypeRestPwd:
            return @"重置密码";
            break;
        default:
            return @"";
            break;
    }
}

- (instancetype)initWithUseType:(UseType)useType {
    self.useType = useType;
    return [super init];
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
    [super initSubviews];
    [self addSubviews];
    [self addConstrainsForSubviews];
}

#pragma mark setup
// 添加页面UI组件
- (void)addSubviews {
    LWLoginTextFieldView *phoneTxtView = [[LWLoginTextFieldView alloc] initWithTextFieldType:LWLoginTextFieldTypePhone];
    [self.view addSubview:phoneTxtView];
    self.phoneTxtView = phoneTxtView;
    [phoneTxtView.textField becomeFirstResponder];
    
    if (_useType != UseTypeForget || _useType != UseTypeRestPwd) {
        WEAKSELF
        [phoneTxtView.textField setBk_didEndEditingBlock:^(UITextField *textField) {
            [weakSelf reloadVcodeImage:textField.text];
        }];
    }
    
    LWLoginTextFieldView *imageVcodeTxtView = [[LWLoginTextFieldView alloc] initWithTextFieldType:LWLoginTextFieldTypeImageVcode];
    [self.view addSubview:imageVcodeTxtView];
    self.imageVcodeTxtView = imageVcodeTxtView;
    
    LWLoginTextFieldView *vcodeTxtView = [[LWLoginTextFieldView alloc] initWithTextFieldType:LWLoginTextFieldTypeVcode];
    [vcodeTxtView.rightButton addTarget:self action:@selector(getVcode) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:vcodeTxtView];
    self.vcodeTxtView = vcodeTxtView;
    
    if (_useType != UseTypeSMS) {
        LWLoginTextFieldView *pwdTxtView = [[LWLoginTextFieldView alloc] initWithTextFieldType:LWLoginTextFieldTypePassword];
//        pwdTxtView.textField.placeholder = @"规则6到18位数字加字母";
        [self.view addSubview:pwdTxtView];
        self.pwdTxtView = pwdTxtView;
    }
    
    QMUIFillButton *loginBtn = [[QMUIFillButton alloc] initWithFillType:QMUIFillButtonColorRed];
    loginBtn.titleLabel.font = WLFONT(18);
    [loginBtn addTarget:self action:@selector(didClickLoginBtn:) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn setCornerRadius:5.f];
    [self.view addSubview:loginBtn];
    self.loginBtn = loginBtn;
    
    switch (_useType) {
        case UseTypeSMS:
        {
            [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
            
            UIButton *pwdLoginBtn = [[UIButton alloc] init];
            [pwdLoginBtn setTitle:@"密码登录" forState:UIControlStateNormal];
            [pwdLoginBtn setTitleColor:WLRGB(249.f, 75.f, 44.f) forState:UIControlStateNormal];
            pwdLoginBtn.titleLabel.font = WLFONT(14);
            [pwdLoginBtn addTarget:self action:@selector(didPwdLoginBtn:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:pwdLoginBtn];
            self.pwdLoginBtn = pwdLoginBtn;
            
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注册"
                                                                                      style:UIBarButtonItemStylePlain
                                                                                     target:self
                                                                                     action:@selector(rightBarButtonItemClicked)];
        }
            break;
        case UseTypeRegist:
            [loginBtn setTitle:@"注册" forState:UIControlStateNormal];
            
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"登录"
                                                                                      style:UIBarButtonItemStylePlain
                                                                                     target:self
                                                                                     action:@selector(rightBarButtonItemClicked)];
            break;
        case UseTypeForget:
            [loginBtn setTitle:@"重置密码" forState:UIControlStateNormal];
            
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"登录"
                                                                                      style:UIBarButtonItemStylePlain
                                                                                     target:self
                                                                                     action:@selector(rightBarButtonItemClicked)];
            break;
        case UseTypeRestPwd:
            [loginBtn setTitle:@"重置密码" forState:UIControlStateNormal];
            break;
        default:
            [loginBtn setTitle:@"其他" forState:UIControlStateNormal];
            break;
    }
    
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
    [_phoneTxtView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(kWL_NormalMarginWidth_14);
        } else {
            make.top.mas_equalTo(self.view.mas_top).offset(kWL_NormalMarginWidth_14);
        }
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(ScreenWidth - kWL_NormalMarginWidth_10 * 2.f);
        make.height.mas_equalTo(kWL_NormalTextFieldHeight);
    }];
    
    switch (_useType) {
        case UseTypeSMS:
        {
            [_imageVcodeTxtView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.equalTo(self.phoneTxtView);
                make.centerX.mas_equalTo(self.view);
                make.top.mas_equalTo(self.phoneTxtView.mas_bottom).offset(kWL_NormalMarginWidth_11);
            }];
            
            [_vcodeTxtView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.equalTo(self.phoneTxtView);
                make.centerX.mas_equalTo(self.view);
                make.top.mas_equalTo(self.imageVcodeTxtView.mas_bottom).offset(kWL_NormalMarginWidth_11);
            }];
            
            [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.equalTo(self.phoneTxtView);
                make.centerX.mas_equalTo(self.view);
                make.top.mas_equalTo(self.vcodeTxtView.mas_bottom).offset(kWL_NormalMarginWidth_20);
            }];
            
            [_pwdLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.equalTo(self.loginBtn);
                make.centerX.mas_equalTo(self.view);
                make.top.mas_equalTo(self.loginBtn.mas_bottom).offset(kWL_NormalMarginWidth_15);
            }];
        }
            break;
        case UseTypeRegist:
           {
               [_imageVcodeTxtView mas_makeConstraints:^(MASConstraintMaker *make) {
                   make.size.equalTo(self.phoneTxtView);
                   make.centerX.mas_equalTo(self.view);
                   make.top.mas_equalTo(self.phoneTxtView.mas_bottom).offset(kWL_NormalMarginWidth_11);
               }];
               
               [_vcodeTxtView mas_makeConstraints:^(MASConstraintMaker *make) {
                   make.size.equalTo(self.phoneTxtView);
                   make.centerX.mas_equalTo(self.view);
                   make.top.mas_equalTo(self.imageVcodeTxtView.mas_bottom).offset(kWL_NormalMarginWidth_11);
               }];
               
               [_pwdTxtView mas_makeConstraints:^(MASConstraintMaker *make) {
                   make.size.equalTo(self.phoneTxtView);
                   make.centerX.mas_equalTo(self.view);
                   make.top.mas_equalTo(self.vcodeTxtView.mas_bottom).offset(kWL_NormalMarginWidth_11);
               }];
               
               [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                   make.size.equalTo(self.phoneTxtView);
                   make.centerX.mas_equalTo(self.view);
                   make.top.mas_equalTo(self.pwdTxtView.mas_bottom).offset(kWL_NormalMarginWidth_20);
               }];
           }
            break;
        case UseTypeRestPwd:
        case UseTypeForget:
        {
            _imageVcodeTxtView.hidden = YES;
            
            [_vcodeTxtView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(self.phoneTxtView);
                make.centerX.mas_equalTo(self.view);
                make.top.mas_equalTo(self.phoneTxtView.mas_bottom).offset(kWL_NormalMarginWidth_11);
            }];
            
            [_pwdTxtView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(self.phoneTxtView);
                make.centerX.mas_equalTo(self.view);
                make.top.mas_equalTo(self.vcodeTxtView.mas_bottom).offset(kWL_NormalMarginWidth_11);
            }];
            
            [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(self.phoneTxtView);
                make.centerX.mas_equalTo(self.view);
                make.top.mas_equalTo(self.pwdTxtView.mas_bottom).offset(kWL_NormalMarginWidth_20);
            }];
        }
            break;
        default:
            [_imageVcodeTxtView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.equalTo(self.phoneTxtView);
                make.centerX.mas_equalTo(self.view);
                make.top.mas_equalTo(self.phoneTxtView.mas_bottom).offset(kWL_NormalMarginWidth_11);
            }];
            
            [_vcodeTxtView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.equalTo(self.phoneTxtView);
                make.centerX.mas_equalTo(self.view);
                make.top.mas_equalTo(self.imageVcodeTxtView.mas_bottom).offset(kWL_NormalMarginWidth_11);
            }];
            
            [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.equalTo(self.phoneTxtView);
                make.centerX.mas_equalTo(self.view);
                make.top.mas_equalTo(self.vcodeTxtView.mas_bottom).offset(kWL_NormalMarginWidth_20);
            }];
            break;
    }
}

#pragma mark - Private
// 重新加载图片验证码
- (void)reloadVcodeImage:(NSString *)phone {
    if (phone.wl_trimWhitespaceAndNewlines.length != 11) {
//        [WLHUDView showOnlyTextHUD:@"请输入正确的手机号"];
        return;
    }
    NSDictionary *params = @{
                             @"mobile" : phone,
                             @"width" : @120,
                             @"height" : @30
                             };
    WEAKSELF
    [LoginModuleClient getImageVcodeWithParams:params
                                       Success:^(id resultInfo) {
                                           [weakSelf loadVcodeImage:[NSDictionary dictionaryWithDictionary:resultInfo]];
                                       } Failed:^(NSError *error) {
                                           
                                       }];
}

- (void)loadVcodeImage:(NSDictionary *)dataDic {
    NSString *imgUrl = [dataDic objectForKey:@"url"];
    [self.imageVcodeTxtView.vcodeImageView setImageWithURL:[NSURL URLWithString:imgUrl]
                                                   options:YYWebImageOptionProgressive | YYWebImageOptionProgressiveBlur];
}

// 获取短信验证码
- (void)getVcode {
    if (self.phoneTxtView.textField.text.wl_trimWhitespaceAndNewlines.length != 11) {
        [WLHUDView showOnlyTextHUD:@"请输入正确的手机号"];
        return;
    }
    NSDictionary *params = nil;
    switch (_useType) {
        case UseTypeSMS:
        {
            if (self.imageVcodeTxtView.textField.text.wl_trimWhitespaceAndNewlines.length == 0) {
                [WLHUDView showOnlyTextHUD:@"请输入图形验证码"];
                return;
            }
            params = @{
                       @"mobile" : self.phoneTxtView.textField.text.wl_trimWhitespaceAndNewlines,
                       @"verifi_code" : self.imageVcodeTxtView.textField.text.wl_trimWhitespaceAndNewlines
                       };
            [LoginModuleClient getLoginVcodeWithParams:params
                                               Success:^(id resultInfo) {
                                                   
                                               } Failed:^(NSError *error) {
                                                   
                                               }];
        }
            break;
        case UseTypeRegist:
        {
            if (self.imageVcodeTxtView.textField.text.wl_trimWhitespaceAndNewlines.length == 0) {
                [WLHUDView showOnlyTextHUD:@"请输入图形验证码"];
                return;
            }
            params = @{
              @"mobile" : self.phoneTxtView.textField.text.wl_trimWhitespaceAndNewlines,
              @"verifi_code" : self.imageVcodeTxtView.textField.text.wl_trimWhitespaceAndNewlines
              };
            [LoginModuleClient getRegistVcodeWithParams:params
                                               Success:^(id resultInfo) {
                                                   
                                               } Failed:^(NSError *error) {
                                                   [WLHUDView showOnlyTextHUD:error.localizedDescription];
                                               }];
        }
            break;
        case UseTypeRestPwd:
        case UseTypeForget:
        {
            params = @{
                       @"mobile" : self.phoneTxtView.textField.text.wl_trimWhitespaceAndNewlines
                       };
            [LoginModuleClient getForgetPwdVcodeWithParams:params
                                                   Success:^(id resultInfo) {
                                                       
                                                   } Failed:^(NSError *error) {
                                                       
                                                   }];
        }
            break;
        default:
            
            break;
    }
}

// 登录按钮点击
- (void)didClickLoginBtn:(UIButton *)sender {
    switch (_useType) {
        case UseTypeSMS:
        {
            [self smsLogin];
        }
            break;
        case UseTypeRegist:
        {
            [self userRegist];
        }
            break;
        case UseTypeRestPwd:
        case UseTypeForget:
        {
            [self resetPassword];
        }
            break;
        default:
            
            break;
    }
}

// 重置密码
- (void)resetPassword {
    if (self.phoneTxtView.textField.text.wl_trimWhitespaceAndNewlines.length != 11) {
        [WLHUDView showOnlyTextHUD:@"请输入正确的手机号"];
        return;
    }
    if (self.pwdTxtView.textField.text.wl_trimWhitespaceAndNewlines.length == 0) {
        [WLHUDView showOnlyTextHUD:@"请输入密码"];
        return;
    }
    if (self.vcodeTxtView.textField.text.wl_trimWhitespaceAndNewlines.length == 0) {
        [WLHUDView showOnlyTextHUD:@"请输入验证码"];
        return;
    }
    NSDictionary *params = @{
                             @"mobile" : self.phoneTxtView.textField.text.wl_trimWhitespaceAndNewlines,
                             @"password" : self.pwdTxtView.textField.text.wl_trimWhitespaceAndNewlines,
                             @"code" : self.vcodeTxtView.textField.text.wl_trimWhitespaceAndNewlines
                             };
    WEAKSELF
    [LoginModuleClient saveForgetPwdWithParams:params
                                       Success:^(id resultInfo) {
                                           [WLHUDView showSuccessHUD:@"密码修改成功"];
                                           if (weakSelf.useType == UseTypeRestPwd) {
                                               [NSUserDefaults setString:weakSelf.pwdTxtView.textField.text.wl_trimWhitespaceAndNewlines forKey:[NSString stringWithFormat:@"%@%@", configTool.loginUser.uid, configTool.loginUser.mobile]];
                                               [weakSelf.navigationController popViewControllerAnimated:YES];
                                           } else{
                                               [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                                           }
                                       } Failed:^(NSError *error) {
                                           
                                       }];
}

// 密码登录
- (void)smsLogin {
    if (self.phoneTxtView.textField.text.wl_trimWhitespaceAndNewlines.length != 11) {
        [WLHUDView showOnlyTextHUD:@"请输入正确的手机号"];
        return;
    }
    if (self.vcodeTxtView.textField.text.wl_trimWhitespaceAndNewlines.length == 0) {
        [WLHUDView showOnlyTextHUD:@"请输入验证码"];
        return;
    }
    NSDictionary *params = @{
                             @"username" : self.phoneTxtView.textField.text.wl_trimWhitespaceAndNewlines,
                             @"code" : self.vcodeTxtView.textField.text.wl_trimWhitespaceAndNewlines
                             };
//    WEAKSELF
    [LoginModuleClient loginByVcodeWithParams:params
                                      Success:^(id resultInfo) {
                                          // 设置登录用户信息
                                          [configTool initLoginUser:resultInfo];
                                      } Failed:^(NSError *error) {
                                          
                                      }];
}

// 用户注册
- (void)userRegist {
    if (self.phoneTxtView.textField.text.wl_trimWhitespaceAndNewlines.length != 11) {
        [WLHUDView showOnlyTextHUD:@"请输入正确的手机号"];
        return;
    }
    if (self.vcodeTxtView.textField.text.wl_trimWhitespaceAndNewlines.length == 0) {
        [WLHUDView showOnlyTextHUD:@"请输入验证码"];
        return;
    }
    if (self.pwdTxtView.textField.text.wl_trimWhitespaceAndNewlines.length == 0) {
        [WLHUDView showOnlyTextHUD:@"请输入密码"];
        return;
    }
    NSDictionary *params = @{
               @"mobile" : self.phoneTxtView.textField.text.wl_trimWhitespaceAndNewlines,
               @"password" : self.pwdTxtView.textField.text.wl_trimWhitespaceAndNewlines,
               @"repassword" : self.pwdTxtView.textField.text.wl_trimWhitespaceAndNewlines,
               @"code" : self.vcodeTxtView.textField.text.wl_trimWhitespaceAndNewlines,
               };
    WEAKSELF
    [LoginModuleClient registWithParams:params
                                Success:^(id resultInfo) {
                                    [WLHUDView showSuccessHUD:@"注册成功"];
                                    [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                                } Failed:^(NSError *error) {
                                    
                                }];
}


// 密码登录按钮点击
- (void)didPwdLoginBtn:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

// 右侧导航按钮点击
- (void)rightBarButtonItemClicked {
    switch (_useType) {
        case UseTypeSMS:
        {
            SmsLoginViewController *smsLoginVc = [[SmsLoginViewController alloc] initWithUseType:UseTypeRegist];
            [self.navigationController pushViewController:smsLoginVc animated:YES];
        }
            break;
        case UseTypeRegist:
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
            break;
        case UseTypeForget:
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
            break;
        default:
            
            break;
    }
}

@end

//
//  FriendRquestViewController.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/20.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "FriendRquestViewController.h"

#import "FriendModelClient.h"

@interface FriendRquestViewController ()<QMUITextViewDelegate>

@property(nonatomic, strong) QMUITextView *textView;
@property(nonatomic, assign) CGFloat textViewMinimumHeight;

@property(nonatomic, strong) QMUIFillButton *sendBtn;

@end

@implementation FriendRquestViewController

- (NSString *)title {
    return @"验证信息";
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
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.textViewMinimumHeight = 206;
    self.view.backgroundColor = WLColoerRGB(248.f);
    
    QMUITextView *textView = [[QMUITextView alloc] init];
    textView.delegate = self;
    textView.placeholder = @"验证信息……";
    textView.placeholderColor = UIColorPlaceholder; // 自定义 placeholder 的颜色
//    textView.text = @"";
    textView.editable = YES;
    textView.textContainerInset = UIEdgeInsetsMake(10, 7, 10, 7);
    textView.returnKeyType = UIReturnKeyDone;
    textView.enablesReturnKeyAutomatically = YES;
    textView.typingAttributes = @{NSFontAttributeName: UIFontMake(14),
                                  NSForegroundColorAttributeName: WLColoerRGB(51.f),
                                  NSParagraphStyleAttributeName: [NSMutableParagraphStyle qmui_paragraphStyleWithLineHeight:20]};
    // 限制可输入的字符长度
    textView.maximumTextLength = 1000;//100;
    // 限制输入框自增高的最大高度
    textView.maximumHeight = self.textViewMinimumHeight;//200;
    textView.layer.borderWidth = PixelOne;
    textView.layer.borderColor = UIColorSeparator.CGColor;
    //    self.textView.layer.cornerRadius = 4;
    [self.view addSubview:textView];
    self.textView = textView;
//    [textView wl_setDebug:YES];
    [textView becomeFirstResponder];
    
    QMUIFillButton *sendBtn = [[QMUIFillButton alloc] initWithFillType:QMUIFillButtonColorRed];
    sendBtn.titleLabel.font = WLFONT(18);
    [sendBtn addTarget:self action:@selector(didClickLoginBtn:) forControlEvents:UIControlEventTouchUpInside];
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendBtn setCornerRadius:5.f];
    [self.view addSubview:sendBtn];
    self.sendBtn = sendBtn;
    
    //添加单击手势
//    UITapGestureRecognizer *tap = [UITapGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
//        [[self.view wl_findFirstResponder] resignFirstResponder];
//    }];
//    [self.view addGestureRecognizer:tap];
}

// 布局控制
- (void)addConstrainsForSubviews {
    CGFloat height = self.qmui_navigationBarMaxYInViewCoordinator;
    if (height < 10) {
        height = NavigationContentTop;
    }
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).mas_offset(height);
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(DEVICE_WIDTH);
        make.height.mas_equalTo(206.f);
    }];
    
    [_sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.textView.mas_bottom).mas_offset(22.f);
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(DEVICE_WIDTH - kWL_NormalMarginWidth_10 * 2.f);
        make.height.mas_equalTo(44.f);
    }];
}

- (BOOL)shouldHideKeyboardWhenTouchInView:(UIView *)view {
    // 表示点击空白区域都会降下键盘
    return YES;
}

#pragma mark - <QMUITextViewDelegate>
// 实现这个 delegate 方法就可以实现自增高
- (void)textView:(QMUITextView *)textView newHeightAfterTextChanged:(CGFloat)height {
    height = fmax(height, self.textViewMinimumHeight);
    BOOL needsChangeHeight = CGRectGetHeight(textView.frame) != height;
    if (needsChangeHeight) {
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    }
}

- (void)textView:(QMUITextView *)textView didPreventTextChangeInRange:(NSRange)range replacementText:(NSString *)replacementText {
    [QMUITips showWithText:[NSString stringWithFormat:@"文字不能超过 %@ 个字符", @(textView.maximumTextLength)] inView:self.view hideAfterDelay:2.0];
}

// 可以利用这个 delegate 来监听发送按钮的事件，当然，如果你习惯以前的方式的话，也可以继续在 textView:shouldChangeTextInRange:replacementText: 里处理
- (BOOL)textViewShouldReturn:(QMUITextView *)textView {
    [QMUITips showSucceed:[NSString stringWithFormat:@"成功发送文字：%@", textView.text] inView:self.view hideAfterDelay:3.0];
    textView.text = nil;
    
    // return YES 表示这次 return 按钮的点击是为了触发“发送”，而不是为了输入一个换行符
    return YES;
}

#pragma mark - Private
- (void)didClickLoginBtn:(UIButton *)sender {
    [[self.view wl_findFirstResponder] resignFirstResponder];
    if (_textView.text.wl_trimWhitespaceAndNewlines.length == 0) {
        [WLHUDView showOnlyTextHUD:@"请输入请求内容"];
        return;
    }
    
    NSDictionary *params = @{@"uid" : [NSNumber numberWithInteger:_uid.integerValue],
                             @"message" : _textView.text.wl_trimWhitespaceAndNewlines
                             };
    [WLHUDView showHUDWithStr:@"发送中..." dim:YES];
    WEAKSELF
    [FriendModelClient sendImFriendRequestWithParams:params Success:^(id resultInfo) {
        [WLHUDView showSuccessHUD:@"已发送"];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } Failed:^(NSError *error) {
        [WLHUDView hiddenHud];
    }];
}

@end

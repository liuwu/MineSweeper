//
//  CardAlertView.m
//  Welian
//
//  Created by weLian on 15/3/20.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "CardAlertView.h"
#import "WLCellCardView.h"
#import "WLMessageTextView.h"

#define kContentViewHeight 180.f
#define kCardViewHeight 56.f
#define kLGAlertViewWidthStyleAlert                   (320.f - 20*2)
#define kLGAlertViewWidthStyleActionSheet             (320.f - 16*2)

@interface CardAlertView ()<UIGestureRecognizerDelegate,UITextViewDelegate>

@property (strong,nonatomic) CardStatuModel *cardModel;
@property (strong,nonatomic) UIImageView *bgImageView;
@property (strong,nonatomic) UIView *contentView;
@property (assign,nonatomic) WLCellCardView *cardView;
@property (assign,nonatomic) WLMessageTextView *textView;
@property (assign,nonatomic) UIButton *cancelBtn;
@property (assign,nonatomic) UIButton *sendBtn;

@end

@implementation CardAlertView

- (void)dealloc {
    [kNSNotification removeObserver:self];
    _cardModel = nil;
    _bgImageView = nil;
    _contentView = nil;
    _sendSuccessBlock = nil;
}

- (instancetype)initWithCardModel:(CardStatuModel *)cardModel
{
    self = [super init];
    if (self) {
        self.cardModel = cardModel;
        [self setup];
    }
    return self;
}

- (void)setNoteInfo:(NSString *)noteInfo
{
    _noteInfo = noteInfo;
    
    _textView.text = _noteInfo;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _bgImageView.frame = self.bounds;
    
    _contentView.size = CGSizeMake(kLGAlertViewWidthStyleAlert, kContentViewHeight);
    _contentView.centerX = _bgImageView.width / 2.f;
    _contentView.centerY = _bgImageView.height / 2.f;
    
    _cardView.size = CGSizeMake(_contentView.width - kWL_NormalMarginWidth_15 * 2.f, kCardViewHeight);
    _cardView.top = kWL_NormalMarginWidth_15;
    _cardView.centerX = _contentView.width / 2.f;
    
    _textView.size = CGSizeMake(_cardView.width , 35.f);
    _textView.top = _cardView.bottom + kWL_NormalMarginWidth_15;
    _textView.centerX = _contentView.width / 2.f;
    
    _cancelBtn.size = CGSizeMake(_contentView.width / 2.f, _contentView.height - _textView.bottom - kWL_NormalMarginWidth_15);
    _cancelBtn.left = 0.f;
    _cancelBtn.bottom = _contentView.height;
    
    _sendBtn.size = _cancelBtn.size;
    _sendBtn.left = _cancelBtn.right;
    _sendBtn.bottom = _cancelBtn.bottom;
    
    _cancelBtn.layer.borderColorFromUIColor = [UIColor wl_HexE5E5E5];
    _cancelBtn.layer.borderWidths = @"{0.5,0.5,0,0}";
    _cancelBtn.layer.masksToBounds = YES;
    _sendBtn.layer.borderColorFromUIColor = [UIColor wl_HexE5E5E5];
    _sendBtn.layer.borderWidths = @"{0.5,0,0,0}";
    _sendBtn.layer.masksToBounds = YES;
}

#pragma mark - Private
- (void)setup
{
    self.frame = [[UIScreen mainScreen] bounds];
    
    self.backgroundColor = [UIColor clearColor];
    
    UIImageView *bgImageView = [[UIImageView alloc] init];
    bgImageView.backgroundColor = [UIColor blackColor];
    [self addSubview:bgImageView];
    self.bgImageView = bgImageView;
    
    //内容
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor wl_HexF5F5F5];
    contentView.layer.cornerRadius = 6.f;
    contentView.layer.masksToBounds = YES;
    [self addSubview:contentView];
    self.contentView = contentView;
    
    ///卡片
    WLCellCardView *cardView = [[WLCellCardView alloc] init];
    cardView.cardM = _cardModel;
    [contentView addSubview:cardView];
    self.cardView = cardView;
    
    //文本输入框
    // 初始化输入框
    WLMessageTextView *textView = [[WLMessageTextView  alloc] initWithFrame:CGRectZero];
    textView.returnKeyType = UIReturnKeyDone;
    //    textView.enablesReturnKeyAutomatically = NO; // UITextView内部判断send按钮是否可以用
    textView.layer.borderColor = [UIColor wl_HexE5E5E5].CGColor;
    textView.layer.borderWidth = 0.4f;
    textView.layer.cornerRadius = 5.f;
    textView.layer.masksToBounds = YES;
    textView.textColor = kWLNormalTextColor_51;
    textView.placeHolder = @"给朋友留言";
    textView.delegate = self;
    [contentView addSubview:textView];
    self.textView = textView;
    
    //取消按钮
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.titleLabel.font = kNormal16Font;
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor wl_Hex666666] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:cancelBtn];
    self.cancelBtn = cancelBtn;
    
    //发送按钮
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.titleLabel.font = kNormal16Font;
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor wl_hex0F6EF4] forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(sendBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:sendBtn];
    self.sendBtn = sendBtn;
    
    //添加单击手势
    UITapGestureRecognizer *tap = [UITapGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        [[self wl_findFirstResponder] resignFirstResponder];
    }];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    //添加键盘监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

//取消按钮
- (void)cancelBtnClicked:(UIButton *)sender {
    [self dismiss];
}

//发送按钮
- (void)sendBtnClicked:(UIButton *)sender {
    [self dismiss];
    if (self.sendSuccessBlock) {
        self.sendSuccessBlock(self.textView.text, self.cardModel);
    }
}

//显示
- (void)show
{
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    [self fadeIn];
}

- (void)dismiss
{
    [[self wl_findFirstResponder] resignFirstResponder];
    [self fadeOut];
}

//回车隐藏键盘
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - KeyboardNoti
- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    [UIView animateWithDuration:0.3 animations:^(void) {
        _contentView.bottom = self.height - kbSize.height - 2.f;
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [UIView animateWithDuration:0.3 animations:^(void) {
        _contentView.centerY = self.height / 2.f;
    }];
}

#pragma mark - Show Animations
- (void)fadeIn
{
    _bgImageView.alpha = .0f;
    _contentView.alpha = .0f;
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         _bgImageView.alpha = 0.4f;
                         _contentView.alpha = 1;
                     }
                     completion:nil];
}

#pragma mark - Hide Animations
- (void)fadeOut
{
    WEAKSELF
    [UIView animateWithDuration:0.2f animations:^{
        weakSelf.bgImageView.alpha = 0.0f;
        weakSelf.contentView.alpha = 0.0f;
    } completion:^(BOOL completed) {
        [weakSelf.bgImageView removeFromSuperview];
        [weakSelf removeFromSuperview];
    }];
}

@end

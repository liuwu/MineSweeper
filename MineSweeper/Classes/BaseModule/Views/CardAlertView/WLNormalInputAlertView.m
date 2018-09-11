//
//  WLNormalInputAlertView.m
//  Welian
//
//  Created by weLian on 15/10/30.
//  Copyright © 2015年 chuansongmen. All rights reserved.
//

#import "WLNormalInputAlertView.h"
#import "WLMessageTextView.h"

#define kContentViewHeight 150.f
#define kMarginEdge 10.f
#define kInputViewHeight 35.f
#define kButtonHeight 45.f

#define kLGAlertViewWidthStyleAlert                   (320.f - 20*2)
#define kLGAlertViewWidthStyleActionSheet             (320.f - 16*2)

@interface WLNormalInputAlertView ()<UIGestureRecognizerDelegate,UITextViewDelegate>

@property (assign, nonatomic) UIImageView *bgImageView;
@property (assign, nonatomic) UIView *contentView;
@property (assign, nonatomic) WLMessageTextView *textView;
@property (assign, nonatomic) UIButton *cancelBtn;
@property (assign, nonatomic) UIButton *sendBtn;
@property (assign, nonatomic) UILabel *titleLabel;
@property (assign, nonatomic) UILabel *detailTitleLabel;

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *msg;
@property (strong, nonatomic) NSString *placeHolderStr;
@property (strong, nonatomic) NSString *cancelButtonTitle;
@property (strong, nonatomic) NSString *otherButtonTitle;

@end

@implementation WLNormalInputAlertView

- (void)dealloc {
    [kNSNotification removeObserver:self];
    _okBtnClickedBlock = nil;
    _cancelBtnClickedBlock = nil;
    
    _title = nil;
    _msg = nil;
    _placeHolderStr = nil;
    _cancelButtonTitle = nil;
    _otherButtonTitle = nil;
}

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)msg
               placeHolderStr:(NSString *)placeHolderStr
            cancelButtonTitle:(NSString *)cancelButtonTitle
             otherButtonTitle:(NSString *)otherButtonTitle
{
    self = [super init];
    if (self) {
        self.title = title;
        self.msg = msg;
        self.placeHolderStr = placeHolderStr;
        self.cancelButtonTitle = cancelButtonTitle;
        self.otherButtonTitle = otherButtonTitle;
        [self setup];
    }
    return self;
}

- (void)setInputViewHeight:(CGFloat)InputViewHeight
{
    _InputViewHeight = InputViewHeight;
}

- (void)setMaxInputLimit:(CGFloat)maxInputLimit
{
    _maxInputLimit = maxInputLimit;
    
    if (_maxInputLimit > 0) {
        //控制字数
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textViewEditChanged:)
                                                    name:UITextViewTextDidChangeNotification
                                                  object:_textView];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textViewEditChanged:)
                                                    name:UITextViewTextDidEndEditingNotification
                                                  object:_textView];
    }else{
        //清除监听
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _bgImageView.frame = self.bounds;
    
    _contentView.size = CGSizeMake(kLGAlertViewWidthStyleAlert, [self getContentHeight]);
    _contentView.centerX = _bgImageView.width / 2.f;
    _contentView.centerY = _bgImageView.height / 2.f;
    
    CGFloat maxWidth = _contentView.width - kWL_NormalMarginWidth_15 * 2.f;
    _titleLabel.width = maxWidth;
    [_titleLabel sizeToFit];
    _titleLabel.top = kWL_NormalMarginWidth_15;
    _titleLabel.centerX = _contentView.width / 2.f;
    
    _detailTitleLabel.width = maxWidth;
    [_detailTitleLabel sizeToFit];
    _detailTitleLabel.top = _title.length > 0 ? _titleLabel.bottom + kMarginEdge : kWL_NormalMarginWidth_15;
    _detailTitleLabel.centerX = _contentView.width / 2.f;
    
    _textView.size = CGSizeMake(_contentView.width - kWL_NormalMarginWidth_15 * 2.f, (_InputViewHeight > 0 ? _InputViewHeight : kInputViewHeight));
    _textView.top = _detailTitleLabel.bottom + kMarginEdge;
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
    contentView.backgroundColor = kWLNormalTextColor_239;
    contentView.layer.cornerRadius = 5.f;
    contentView.layer.masksToBounds = YES;
    [self addSubview:contentView];
    self.contentView = contentView;
    
    //标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.textColor = kWLNormalTextColor_51;
    titleLabel.font =  kNormal15Font;
    titleLabel.numberOfLines = 0.f;
    titleLabel.text = _title;
    [contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    //副标题
    UILabel *detailTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    detailTitleLabel.textColor = kWLNormalTextColor_51;
    detailTitleLabel.font = kNormal13Font;
    detailTitleLabel.numberOfLines = 0.f;
    detailTitleLabel.text = _msg;
    [contentView addSubview:detailTitleLabel];
    self.detailTitleLabel = detailTitleLabel;
    
    //文本输入框
    WLMessageTextView *textView = [[WLMessageTextView alloc] initWithFrame:CGRectZero];
    textView.returnKeyType = UIReturnKeyDone;
    //    textView.enablesReturnKeyAutomatically = NO; // UITextView内部判断send按钮是否可以用
    textView.layer.borderColor = WLRGB(220, 220, 220).CGColor;
    textView.layer.borderWidth = 0.4f;
    textView.layer.cornerRadius = 5.f;
    textView.layer.masksToBounds = YES;
    textView.textColor = kWLNormalTextColor_51;
    textView.placeHolder = _placeHolderStr;
    textView.delegate = self;
    [contentView addSubview:textView];
    self.textView = textView;
    
    //取消按钮
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.titleLabel.font = kNormal16Font;
    [cancelBtn setTitle:_cancelButtonTitle forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor wl_hex0F6EF4] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:cancelBtn];
    self.cancelBtn = cancelBtn;
    
    //发送按钮
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.titleLabel.font = kNormal16Font;
    [sendBtn setTitle:_otherButtonTitle forState:UIControlStateNormal];
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

//获取弹出框高度
- (CGFloat)getContentHeight
{
    CGFloat maxWidth = ScreenWidth - 40.f - kWL_NormalMarginWidth_15 * 2.f;
    //标题
    CGFloat titleHeight = [_title wl_heightWithFont:WLFONT(18) constrainedToWidth:maxWidth];
//    CGSize titleSize = [_title calculateSize:CGSizeMake(maxWidth, FLT_MAX) font:kNormalBlod18Font];
    //副标题
    CGFloat msgHeight = [_msg wl_heightWithFont:WLFONT(14) constrainedToWidth:maxWidth];
//    CGSize msgSize = [_msg calculateSize:CGSizeMake(maxWidth, FLT_MAX) font:kNormal14Font];
    CGFloat viewHeight = (_title.length > 0 ? titleHeight : 0.f) + (_msg.length > 0 ? msgHeight + kMarginEdge : 0.f) + (_InputViewHeight > 0 ? _InputViewHeight : kInputViewHeight) + kMarginEdge + kWL_NormalMarginWidth_15 * 2.f + kButtonHeight;
    if (viewHeight > ScreenHeight - 200.f) {
        return ScreenHeight - 200.f;
    }
    return viewHeight;
}

//取消按钮
- (void)cancelBtnClicked:(UIButton *)sender
{
    [self dismiss];
    if (_cancelBtnClickedBlock) {
        _cancelBtnClickedBlock();
    }
}

//发送按钮
- (void)sendBtnClicked:(UIButton *)sender
{
    [self dismiss];
    if (_okBtnClickedBlock) {
        _okBtnClickedBlock(_textView.text);
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
    //    [self removeFromSuperview];
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

/**
 *  @author liuwu     , 16-03-03
 *
 *  监听textView编辑内容发生改变
 *  @param obj 内容
 *  @since V2.7.3
 */
- (void)textViewEditChanged:(NSNotification *)obj{
    UITextView *textField = (UITextView *)obj.object;
    
    NSString *toBeString = textField.text;
    // 键盘输入模式(判断输入模式的方法是iOS7以后用到的,如果想做兼容,另外谷歌)
    NSArray * currentar = [UITextInputMode activeInputModes];
    UITextInputMode * current = [currentar firstObject];
    
    if ([current.primaryLanguage isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > _maxInputLimit) {
                textField.text = [toBeString substringToIndex:_maxInputLimit];
                //此方法是我引入的第三方警告框.读者可以自己完成警告弹窗.
            }
        }else{
            // 有高亮选择的字符串，则暂不对文字进行统计和限制
        }
    }else{
        // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        if (toBeString.length > _maxInputLimit) {
            textField.text = [toBeString substringToIndex:_maxInputLimit];
        }
    }
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
    //    [self removeFromSuperview];
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

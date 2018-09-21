//
//  ChatGroupNoteInfoViewController.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/20.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "ChatGroupNoteInfoViewController.h"
#import "ChatGourpNameViewController.h"

@interface ChatGroupNoteInfoViewController ()<QMUITextViewDelegate>

@property(nonatomic,strong) QMUITextView *textView;
@property(nonatomic, assign) CGFloat textViewMinimumHeight;

@end

@implementation ChatGroupNoteInfoViewController

- (NSString *)title {
    return @"群公告";
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
    
    UIBarButtonItem *rightBtnItem = [UIBarButtonItem qmui_itemWithTitle:@"保存" target:self action:@selector(rightBarButtonItemClicked)];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
    
    QMUITextView *textView = [[QMUITextView alloc] init];
    textView.delegate = self;
    textView.placeholder = @"支持 placeholder、支持自适应高度、支持限制文本输入长度";
    textView.placeholderColor = UIColorPlaceholder; // 自定义 placeholder 的颜色
    textView.text = @"adfasdfasdfasdfcd的发送到发沙发大是的发送到发送到发送到发送到发送到发送到";
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
    
    //添加单击手势
    UITapGestureRecognizer *tap = [UITapGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        [[self.view wl_findFirstResponder] resignFirstResponder];
    }];
    [self.view addGestureRecognizer:tap];
}

// 布局控制
- (void)addConstrainsForSubviews {
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.qmui_navigationBarMaxYInViewCoordinator);
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(DEVICE_WIDTH);
        make.height.mas_equalTo(206.f);
    }];
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
- (void)rightBarButtonItemClicked {
    [[self.view wl_findFirstResponder] resignFirstResponder];
    
    ChatGourpNameViewController *vc = [[ChatGourpNameViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end

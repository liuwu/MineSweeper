//
//  MessageNotifiDetailViewController.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/15.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "MessageNotifiDetailViewController.h"
#import "BaseTableViewCell.h"

#import "ImGroupModelClient.h"

@interface MessageNotifiDetailViewController ()<QMUITextViewDelegate, YYTextViewDelegate>

//@property (nonatomic,strong) QMUITextView *textView;
@property (nonatomic,strong) YYTextView *textView;
@property (nonatomic, assign) CGFloat textViewMinimumHeight;
@property (nonatomic, strong) NSArray *datasource;

@end

@implementation MessageNotifiDetailViewController

- (NSString *)title {
    return @"详情";
}

- (void)initSubviews {
    [super initSubviews];
    self.textViewMinimumHeight = self.view.height - 100 - self.qmui_navigationBarMaxYInViewCoordinator;
    
    [self addViews];
    [self intData];
}

- (void)addViews {
    // 隐藏分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = WLColoerRGB(248.f);
    
    
    YYTextView *textView = [[YYTextView alloc] initWithFrame:CGRectMake(0.f, 0.f, DEVICE_WIDTH, self.textViewMinimumHeight)];
    textView.delegate = self;
    textView.backgroundColor = [UIColor clearColor];
//    textView.placeholder = @"支持 placeholder、支持自适应高度、支持限制文本输入长度";
//    textView.placeholderColor = UIColorPlaceholder; // 自定义 placeholder 的颜色
    textView.editable = NO;
    textView.showsVerticalScrollIndicator = YES;
    textView.scrollEnabled = YES;
    textView.text = @"";
    textView.textContainerInset = UIEdgeInsetsMake(20, 7, 10, 7);
    textView.returnKeyType = UIReturnKeyDone;
    textView.enablesReturnKeyAutomatically = YES;
    textView.typingAttributes = @{NSFontAttributeName: UIFontMake(14),
                                  NSForegroundColorAttributeName: WLColoerRGB(51.f),
                                  NSParagraphStyleAttributeName: [NSMutableParagraphStyle qmui_paragraphStyleWithLineHeight:20]};
    // 限制可输入的字符长度
//    textView.maximumTextLength = 1000;//100;
    // 限制输入框自增高的最大高度
//    textView.maximumHeight = self.textViewMinimumHeight;//200;
    textView.layer.borderWidth = PixelOne;
    textView.layer.borderColor = UIColorSeparator.CGColor;
    //    self.textView.layer.cornerRadius = 4;
    [self.view addSubview:textView];
    self.textView = textView;
    
    self.tableView.tableFooterView = textView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private
- (void)intData {
    [self hideEmptyView];
    WEAKSELF
    [WLHUDView showHUDWithStr:@"加载中..." dim:YES];
    NSDictionary *params = @{@"id": self.noticeModel.titleId};
    [ImGroupModelClient getImSystemNoticeDetailWithParams:params Success:^(id resultInfo) {
        [WLHUDView hiddenHud];
        INoticeModel *data = [INoticeModel modelWithDictionary:resultInfo];
        [weakSelf updateInfo:data];
    } Failed:^(NSError *error) {
        if (error.localizedDescription.length > 0) {
            [WLHUDView showErrorHUD:error.localizedDescription];
        } else {
            [WLHUDView hiddenHud];
        }
    }];
}

- (void)updateInfo:(INoticeModel *)data {
    //将网页内容格式化
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[data.content dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
//    self.textView.text = data.content;
//    self.textView.attributedText = attrStr;
    [self.textView setAttributedText:attrStr];
    [self.textView scrollRangeToVisible:NSMakeRange(0, 0)];
//    self.textView.textVerticalAlignment = YYTextVerticalAlignmentTop;
    self.datasource = [NSArray arrayWithObject:data];
    if (self.datasource.count == 0) {
        [self showEmptyViewWithText:@"暂无数据" detailText:@"" buttonTitle:nil buttonAction:NULL];
    }
    [self.tableView reloadData];
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

#pragma mark - UITableView Datasource & Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"message_notifi_detail_cell"];
    if (!cell) {
        cell = [[BaseTableViewCell alloc] initForTableView:tableView withStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"message_notifi_detail_cell"];
    }
    cell.showBottomLine = YES;
    INoticeModel *model = _datasource[indexPath.row];
    cell.textLabel.text = model.title;// @"这里是公告标题";
    cell.textLabel.textColor = WLColoerRGB(51.f);
    cell.textLabel.font = UIFontMake(15.f);
    cell.textLabel.numberOfLines = 0.f;
    cell.detailTextLabel.text = model.add_time;// @"2017/09/12  12:30:23";
    cell.detailTextLabel.textColor = WLColoerRGB(153.f);
    cell.detailTextLabel.font = UIFontMake(11.f);
    cell.backgroundColor = [UIColor clearColor];
    
    cell.textLabelEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    cell.detailTextLabelEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    [cell updateCellAppearanceWithIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DLog(@"didSelectRowAtIndexPath------");
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    //    return kNoteHeight + kBannerHeight;
    return 0.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    INoticeModel *model = _datasource[indexPath.row];
    CGFloat maxWidth = DEVICE_WIDTH - 20.f;
    CGSize size2 = [model.title wl_sizeWithFont:WLFONT(15.f) constrainedToWidth:maxWidth];
    CGFloat height = size2.height + 32 + 15;
    if (height > 59.f) {
        return height;
    }
    return 59.f;
}

@end

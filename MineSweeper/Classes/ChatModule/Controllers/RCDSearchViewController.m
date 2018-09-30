//
//  RCDSearchViewController.m
//  RCloudMessage
//
//  Created by 张改红 on 16/9/18.
//  Copyright © 2016年 RongCloud. All rights reserved.
//

#import "RCDSearchViewController.h"
#import "ChatViewController.h"

#import "BaseImageTableViewCell.h"
#import "BaseImageSubTitleTableViewCell.h"

@interface RCDSearchViewController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource,
                                       UIGestureRecognizerDelegate>
@property(nonatomic, strong) NSMutableDictionary *resultDictionary;
@property(nonatomic, strong) NSMutableArray *groupTypeArray;
@property(nonatomic, strong) QMUISearchBar *searchBars;
@property(nonatomic, strong) UIButton *cancelButton;
@property(nonatomic, strong) UIView *searchView;
@property(nonatomic, strong) UITableView *resultTableView;
@property(nonatomic, strong) QMUILabel *emptyLabel;
@property(nonatomic, strong) UIView *searchBackgroundView;
@property(nonatomic, strong) NSDate *searchDate;


@property (nonatomic, strong) NSArray<RCSearchConversationResult *> *datasource;

@end

@implementation RCDSearchViewController

- (UITableView *)resultTableView {
    if (!_resultTableView) {
        _resultTableView =
            [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
                                         style:UITableViewStylePlain];
        _resultTableView.backgroundColor = [UIColor clearColor];
        _resultTableView.delegate = self;
        _resultTableView.dataSource = self;
        _resultTableView.tableFooterView = [UIView new];
        [_resultTableView setSeparatorColor:WLColoerRGB(248.f)];
        [self.view addSubview:_resultTableView];
    }
    return _resultTableView;
}

- (QMUILabel *)emptyLabel {
    if (!_emptyLabel) {
        _emptyLabel = [[QMUILabel alloc] initWithFrame:CGRectMake(10, 45, self.view.frame.size.width - 20, 16)];
        _emptyLabel.font = [UIFont systemFontOfSize:14.f];
        _emptyLabel.textAlignment = NSTextAlignmentCenter;
        _emptyLabel.numberOfLines = 0;
        [self.resultTableView addSubview:_emptyLabel];
    }
    return _emptyLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _groupTypeArray = [NSMutableArray array];
    _resultDictionary = [NSMutableDictionary dictionary];
    [self loadSearchView];
    self.navigationItem.titleView = self.searchView;
    self.view.backgroundColor = [UIColor colorWithWhite:1 alpha:0.95];

    UITapGestureRecognizer *tap =
        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideSerchBarWhenTapBackground:)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    if ([self.resultTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.resultTableView setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 0)];
    }
    if ([self.resultTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.resultTableView setLayoutMargins:UIEdgeInsetsMake(0, 10, 0, 0)];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.barTintColor = HEXCOLOR(0xf0f0f6);
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"0099ff" alpha:1.0f];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)loadSearchView {
    self.searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 44)];

    _searchBars = [[QMUISearchBar alloc] initWithFrame:CGRectZero];
    _searchBars.delegate = self;
    _searchBars.tintColor = [UIColor blueColor];
    [_searchBars becomeFirstResponder];
    _searchBars.frame = CGRectMake(0, 0, self.searchView.frame.size.width - 65, 44);
    [self.searchView addSubview:self.searchBars];

    _cancelButton = [[UIButton alloc]
        initWithFrame:CGRectMake(CGRectGetMaxX(_searchBars.frame) - 3, CGRectGetMinY(self.searchBars.frame), 55, 44)];
    [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _cancelButton.titleLabel.font = [UIFont systemFontOfSize:14.];
    [_cancelButton addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.searchView addSubview:_cancelButton];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    BaseImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[BaseImageTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    cell.showBottomLine = YES;
    RCSearchConversationResult *result = _datasource[indexPath.row];
    cell.conversationResult = result;
    
    cell.textLabel.font = UIFontMake(15);
    cell.textLabel.textColor = WLColoerRGB(51.f);
    
    cell.detailTextLabel.font = UIFontMake(14);
    cell.detailTextLabel.textColor = WLColoerRGB(102.f);
    
    QMUILabel *timeLabel = [[QMUILabel alloc] init];
    long time = result.conversation.lastestMessageDirection == MessageDirection_RECEIVE  ? result.conversation.receivedTime : result.conversation.sentTime;
    timeLabel.text = [[NSString dateTimeStampFormatTodate:time] wl_timeAgoSimple];
    timeLabel.textColor = WLColoerRGB(153.f);
    timeLabel.font = UIFontMake(12.f);
    [timeLabel sizeToFit];
    cell.accessoryView = timeLabel;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3) {
        return 45;
    }
    return 65;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.f;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
//    view.backgroundColor = [UIColor whiteColor];
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 40 - 16 - 7, self.view.frame.size.width, 16)];
//    label.font = [UIFont systemFontOfSize:14.];
////    label.text = _groupTypeArray[section];
////    label.textColor = HEXCOLOR(0x999999);
//    [view addSubview:label];
//    //添加与cell分割线等宽的session分割线
//    CGRect viewFrame = view.frame;
//    UIView *separatorLine =
//        [[UIView alloc] initWithFrame:CGRectMake(10, viewFrame.size.height - 1, viewFrame.size.width - 10, 1)];
//    separatorLine.backgroundColor = [UIColor colorWithRed:230 / 255.0 green:230 / 255.0 blue:230 / 255.0 alpha:1];
//    [view addSubview:separatorLine];
//    return view;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    if (section == self.groupTypeArray.count - 1) {
//        return nil;
//    }
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
////    view.backgroundColor = HEXCOLOR(0xf0f0f6);
//    return view;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == self.groupTypeArray.count - 1) {
        return 0;
    }
    return 5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.searchBars resignFirstResponder];
    RCSearchConversationResult *result = _datasource[indexPath.row];
    if (_delegate) {
        [_delegate didSelectChatModel:result];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self.resultDictionary removeAllObjects];
    [self.groupTypeArray removeAllObjects];
    NSArray<RCSearchConversationResult *> *result = [[RCIMClient sharedRCIMClient] searchConversations:@[@(ConversationType_PRIVATE),@(ConversationType_GROUP)] messageType:@[RCTextMessage.getObjectName] keyword:searchBar.text];
    self.datasource = result;
    [self.resultTableView reloadData];
//      dispatch_async(dispatch_get_global_queue(0, 0), ^{
//    [[RCDSearchDataManager shareInstance] searchDataWithSearchText:searchText
//                                                      bySearchType:RCDSearchAll
//                                                          complete:^(NSDictionary *dic, NSArray *array) {
//                                                              [self.resultDictionary setDictionary:dic];
//                                                              [self.groupTypeArray setArray:array];
//                                                              dispatch_async(dispatch_get_main_queue(), ^{
//                                                                  [self refreshSearchView:searchText];
//                                                              });
//                                                          }];
//      });
}

- (void)refreshSearchView:(NSString *)searchText {
    [self.resultTableView reloadData];
    NSString *searchStr = [searchText stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (!self.groupTypeArray.count && searchText.length > 0 && searchStr.length > 0) {
        NSString *str = [NSString stringWithFormat:@"没有搜索到“%@”相关的内容", searchText];
//        self.emptyLabel.textColor = HEXCOLOR(0x999999);
//        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
//        [attributedString addAttribute:NSForegroundColorAttributeName
//                                 value:HEXCOLOR(0x0099ff)
//                                 range:NSMakeRange(6, searchText.length)];
//        self.emptyLabel.attributedText = attributedString;
        CGFloat height = [self labelAdaptive:str];
        CGRect rect = self.emptyLabel.frame;
        rect.size.height = height;
        self.emptyLabel.frame = rect;
        self.emptyLabel.hidden = NO;
    } else {
        self.emptyLabel.hidden = YES;
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBars resignFirstResponder];
    
}

- (CGFloat)labelAdaptive:(NSString *)string {
    float maxWidth = self.view.frame.size.width - 20;
    CGRect textRect =
        [string boundingRectWithSize:CGSizeMake(maxWidth, 8000)
                             options:(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin |
                                      NSStringDrawingUsesFontLeading)
                          attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0]}
                             context:nil];
    textRect.size.height = ceilf(textRect.size.height);
    return textRect.size.height + 5;
}

- (NSString *)changeString:(NSString *)str appendStr:(NSString *)appendStr {
    if (str.length > 0) {
        str = [NSString stringWithFormat:@"%@,%@", str, appendStr];
    } else {
        str = appendStr;
    }
    return str;
}

- (void)cancelButtonClicked {
    if ([self.delegate respondsToSelector:@selector(onSearchCancelClick)]) {
        [self.delegate onSearchCancelClick];
    }
    [self.searchBars resignFirstResponder];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.searchBars resignFirstResponder];
}

- (void)hideSerchBarWhenTapBackground:(id)sender {
    [self.searchBars resignFirstResponder];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}

@end

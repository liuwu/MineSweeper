//
//  ChatHistoryMessageSearchViewController.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/29.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "ChatHistoryMessageSearchViewController.h"

#import "ChatHistoryTableViewCell.h"

@interface ChatHistoryMessageSearchViewController ()

@property(nonatomic, strong) NSArray<NSString *> *keywords;
@property(nonatomic, strong) NSMutableArray<NSString *> *searchResultsKeywords;
@property(nonatomic, strong) QMUISearchController *mySearchController;

@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, strong) NSArray *filterDatasource;
@property (nonatomic, assign) int size;

@end

@implementation ChatHistoryMessageSearchViewController

- (NSString *)title {
    return @"历史消息";
}

- (instancetype)initWithStyle:(UITableViewStyle)style ChatHistoryType:(ChatHistoryType)chatHistoryType {
    self.chatHistoryType = chatHistoryType;
    self = [super initWithStyle:style];
    return self;
}

- (void)initSubviews {
    [super initSubviews];
    self.size = 30;
    self.datasource = [NSMutableArray array];
    
    // 隐藏分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = WLColoerRGB(248.f);
    
    self.shouldShowSearchBar = YES;
    
    // QMUISearchController 有两种使用方式，一种是独立使用，一种是集成到 QMUICommonTableViewController 里使用。为了展示它的使用方式，这里使用第一种，不理会 QMUICommonTableViewController 内部自带的 QMUISearchController
//    self.mySearchController = [[QMUISearchController alloc] initWithContentsViewController:self];
//    self.mySearchController.searchResultsDelegate = self;
//    //    self.mySearchController.launchView = [[QDRecentSearchView alloc] init];// launchView 会自动布局，无需处理 frame
//    self.mySearchController.searchBar.qmui_usedAsTableHeaderView = YES;// 以 tableHeaderView 的方式使用 searchBar 的话，将其置为 YES，以辅助兼容一些系统 bug
////    self.tableView.tableHeaderView = self.mySearchController.searchBar;
//    [self.mySearchController setActive:YES animated:NO];
//    [self.mySearchController setActive:NO animated:NO];
//    [self.tableView wl_setDebug:YES];
    
//    [self.navigationController.view addSubview:self.mySearchController.searchBar];
    
    switch (_chatHistoryType) {
        case ChatHistoryTypeGroup:
            [self.datasource addObjectsFromArray:[[RCIMClient sharedRCIMClient] getLatestMessages:ConversationType_GROUP targetId:_targetId count:_size]];
            break;
        default:
            [self.datasource addObjectsFromArray:[[RCIMClient sharedRCIMClient] getLatestMessages:ConversationType_PRIVATE targetId:_targetId count:_size]];
            break;
    }
    
    
    //下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(beginPullDownRefreshingNew)];
    //上提加载更多
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(beginPullUpRefreshingNew)];
    self.tableView.mj_footer = footer;
    self.tableView.mj_footer.hidden = YES;
}

// 下拉刷新
- (void)beginPullDownRefreshingNew {
    self.datasource = [NSMutableArray array];
    switch (_chatHistoryType) {
        case ChatHistoryTypeGroup:
            [self.datasource addObjectsFromArray:[[RCIMClient sharedRCIMClient] getLatestMessages:ConversationType_GROUP targetId:_targetId count:_size]];
            break;
        default:
            [self.datasource addObjectsFromArray:[[RCIMClient sharedRCIMClient] getLatestMessages:ConversationType_PRIVATE targetId:_targetId count:_size]];
            break;
    }
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

// 上拉刷新
- (void)beginPullUpRefreshingNew {
    RCMessage *lastMsg = _datasource[_datasource.count - 1];
    
    NSArray *oldArray = [NSArray array];
    switch (_chatHistoryType) {
        case ChatHistoryTypeGroup:
             oldArray =  [[RCIMClient sharedRCIMClient] getHistoryMessages:ConversationType_GROUP targetId:_targetId oldestMessageId:lastMsg.messageId count:_size];
            break;
        default:
            oldArray =  [[RCIMClient sharedRCIMClient] getHistoryMessages:ConversationType_PRIVATE targetId:_targetId oldestMessageId:lastMsg.messageId count:_size];
            break;
    }
    if (oldArray.count == 0) {
        self.tableView.mj_footer.hidden = YES;
    } else {
        self.tableView.mj_footer.hidden = NO;
    }
    [_datasource addObjectsFromArray:oldArray];
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <QMUITableViewDataSource,QMUITableViewDelegate>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //    if (tableView == self.conversationListTableView) {
    //        return self.keywords.count;
    //    }
    if (tableView == self.tableView) {
        return _datasource.count;
    }
    return _filterDatasource.count;
//    return self.searchResultsKeywords.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"chat_history_cell";
    ChatHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[ChatHistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    cell.showBottomLine = YES;
    RCMessage *msg = nil;
    if (tableView == self.tableView) {
         msg = _datasource[indexPath.row];
    } else {
        msg = _filterDatasource[indexPath.row];
    }
    cell.message = msg;
//    if ([msg.content isMemberOfClass:[RCTextMessage class]]) {
//        RCTextMessage *message = (RCTextMessage *) msg.content;
//        cell.textLabel.text = message.content;
//    }
    
    [cell updateCellAppearanceWithIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCMessage *msg = nil;
    if (tableView == self.tableView) {
        msg = _datasource[indexPath.row];
    } else {
        msg = _filterDatasource[indexPath.row];
    }
    return [ChatHistoryTableViewCell configureWithMessage:msg];
//    return 94.f;
}

#pragma mark - <QMUISearchControllerDelegate>

- (void)searchController:(QMUISearchController *)searchController updateResultsForSearchString:(NSString *)searchString {
//    [self.searchResultsKeywords removeAllObjects];
    
    switch (_chatHistoryType) {
        case ChatHistoryTypeGroup:{
            self.filterDatasource = [[RCIMClient sharedRCIMClient] searchMessages:ConversationType_GROUP
                                                                         targetId:_targetId
                                                                          keyword:searchString
                                                                            count:_size
                                                                        startTime:0];
        }
            break;
        default:{
            self.filterDatasource = [[RCIMClient sharedRCIMClient] searchMessages:ConversationType_PRIVATE
                                                                        targetId:_targetId
                                                                            keyword:searchString
                                                                                count:_size
                                                                            startTime:0];
        }
            break;
    }
   
    
    [searchController.tableView reloadData];
    
    if (_filterDatasource.count == 0) {
        [searchController showEmptyViewWithText:@"没有匹配结果" detailText:nil buttonTitle:nil buttonAction:NULL];
    } else {
        [searchController hideEmptyView];
    }
}

- (void)willPresentSearchController:(QMUISearchController *)searchController {
    [QMUIHelper renderStatusBarStyleDark];
}

- (void)willDismissSearchController:(QMUISearchController *)searchController {
    BOOL oldStatusbarLight = NO;
    if ([self respondsToSelector:@selector(shouldSetStatusBarStyleLight)]) {
        oldStatusbarLight = [self shouldSetStatusBarStyleLight];
    }
    if (oldStatusbarLight) {
        [QMUIHelper renderStatusBarStyleLight];
    } else {
        [QMUIHelper renderStatusBarStyleDark];
    }
}

@end

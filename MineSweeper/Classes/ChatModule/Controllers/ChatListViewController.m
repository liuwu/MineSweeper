//
//  ChatListViewController.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/11.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "ChatListViewController.h"
#import "ChatViewController.h"
#import "RedPacketViewController.h"
#import "MessageNotifiListViewController.h"
#import "RCDSearchViewController.h"
//#import "QDRecentSearchView.h"

@interface ChatListViewController ()<UISearchBarDelegate, RCDSearchViewDelegate>

@property(nonatomic, strong) QMUINavigationController *searchNavigationController;
@property(nonatomic, strong) UIView *headerView;
@property(nonatomic, strong) QMUISearchBar *searchBar;

//@property (nonatomic, strong) QMUISearchBar *searchBar;
@property(nonatomic, strong) NSArray<NSString *> *keywords;
@property(nonatomic, strong) NSMutableArray<NSString *> *searchResultsKeywords;
@property(nonatomic, strong) QMUISearchController *mySearchController;



@end

@implementation ChatListViewController

- (NSString *)title {
    return @"消息";
}

- (QMUISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar =
        [[QMUISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.conversationListTableView.frame.size.width, 44)];
    }
    return _searchBar;
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView =
        [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.conversationListTableView.frame.size.width, 44)];
    }
    return _headerView;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        //设置要显示的会话类型
        [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),@(ConversationType_GROUP)]];
        //聚合会话类型
        [self setCollectionConversationType:@[@(ConversationType_SYSTEM)]];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)initSubviews {
    [super initSubviews];
//
//    // 隐藏分割线
////    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
////    self.tableView.backgroundColor = WLColoerRGB(248.f);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *leftBtnItem = [UIBarButtonItem qmui_itemWithButton:[[QMUINavigationButton alloc] initWithImage:[[UIImage imageNamed:@"home_notice_btn"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]] target:self action:@selector(leftBtnItemClicked)];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    // Do any additional setup after loading the view.
    
    // QMUISearchController 有两种使用方式，一种是独立使用，一种是集成到 QMUICommonTableViewController 里使用。为了展示它的使用方式，这里使用第一种，不理会 QMUICommonTableViewController 内部自带的 QMUISearchController
//    self.mySearchController = [[QMUISearchController alloc] initWithContentsViewController:self];
//    self.mySearchController.searchResultsDelegate = self;
//    self.mySearchController.launchView = [[QDRecentSearchView alloc] init];// launchView 会自动布局，无需处理 frame
//    self.mySearchController.searchBar.qmui_usedAsTableHeaderView = YES;// 以 tableHeaderView 的方式使用 searchBar 的话，将其置为 YES，以辅助兼容一些系统 bug
//    self.conversationListTableView.tableHeaderView = self.mySearchController.searchBar;
    
//    QMUISearchBar *searchBar = [[QMUISearchBar alloc] qmui_initWithSize:CGSizeMake(DEVICE_WIDTH, 44.f)];
//    searchBar.delegate = self;
//    self.searchBar = searchBar;
    //    searchBar.showsCancelButton = YES;
    self.searchBar.delegate = self;
    [self.headerView addSubview:self.searchBar];
    self.conversationListTableView.tableHeaderView = self.headerView;
    self.conversationListTableView.sectionHeaderHeight = 10.f;
    self.conversationListTableView.sectionFooterHeight = 0.f;
    self.conversationListTableView.backgroundColor = WLColoerRGB(248.f);
    /// 隐藏分割线
    self.conversationListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 设置在NavigatorBar中显示连接中的提示
    self.showConnectingStatusOnNavigatorBar = YES;
    
}

#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    RCDSearchViewController *searchViewController = [[RCDSearchViewController alloc] init];
    self.searchNavigationController = [[QMUINavigationController alloc] initWithRootViewController:searchViewController];
    searchViewController.delegate = self;
    [self.navigationController.view addSubview:self.searchNavigationController.view];
}

- (void)didSelectChatModel:(RCSearchConversationResult *)result {
    ChatViewController *vc = [[ChatViewController alloc] initWithConversationType:result.conversation.conversationType targetId:result.conversation.targetId];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    [self onSearchCancelClick];
}

- (void)onSearchCancelClick {
    [self.searchNavigationController.view removeFromSuperview];
    [self.searchNavigationController removeFromParentViewController];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self refreshConversationTableViewIfNeeded];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Cell加载显示的回调
/*!
 即将加载列表数据源的回调
 
 @param dataSource      即将加载的列表数据源（元素为RCConversationModel对象）
 @return                修改后的数据源（元素为RCConversationModel对象）
 
 @discussion 您可以在回调中修改、添加、删除数据源的元素来定制显示的内容，会话列表会根据您返回的修改后的数据源进行显示。
 数据源中存放的元素为会话Cell的数据模型，即RCConversationModel对象。
 */
//- (NSMutableArray *)willReloadTableData:(NSMutableArray *)dataSource {
//    if (configTool.loginUser.investorauth.integerValue == 1) {
//        [dataSource insertObjects:[WLChatProjectManager sharedInstance].dataSource atIndex:0];
//    }
//    return dataSource;
//}

/*!
 即将显示Cell的回调
 
 @param cell        即将显示的Cell
 @param indexPath   该Cell对应的会话Cell数据模型在数据源中的索引值
 
 @discussion 您可以在此回调中修改Cell的一些显示属性。
 */
- (void)willDisplayConversationTableCell:(RCConversationBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    RCConversationCell *rcCell = (RCConversationCell *)cell;
//    RCConversationModel *model = self.conversationListDataSource[indexPath.row];
    rcCell.conversationTitle.font = WLFONT(15);
    rcCell.conversationTitle.textColor = WLColoerRGB(51.f);
    rcCell.messageContentLabel.font = WLFONT(14);
    rcCell.messageContentLabel.textColor = WLColoerRGB(102.f);
    
    rcCell.messageCreatedTimeLabel.font = WLFONT(12);
    rcCell.messageCreatedTimeLabel.textColor = WLColoerRGB(153.f);
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = WLColoerRGB(242.f);
//    lineView.frame = CGRectMake(0.f, rcCell.contentView.size.height - .6f, DEVICE_WIDTH, .6f);
    [rcCell.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH, .6f));
        make.bottom.mas_equalTo(rcCell.contentView);
        make.centerX.mas_equalTo(rcCell.contentView);
    }];
}

#pragma mark - 自定义会话列表Cell

/*!
 自定义会话Cell显示时的回调
 
 @param tableView       当前TabelView
 @param indexPath       该Cell对应的会话Cell数据模型在数据源中的索引值
 @return                自定义会话需要显示的Cell
 */
//- (RCConversationBaseCell *)rcConversationListTableView:(UITableView *)tableView
//                                  cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    RCConversationCell *cell = [WLChatProjectManager sharedInstance].proPostFeedbackCell;
//    RCConversationModel *model = self.conversationListDataSource[0];
//    [cell setDataModel:model];
//    return cell;
//}

/*!
 自定义会话Cell显示时的回调
 
 @param tableView       当前TabelView
 @param indexPath       该Cell对应的会话Cell数据模型在数据源中的索引值
 @return                自定义会话需要显示的Cell的高度
 */
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RCConversationModel *rcmodel = self.conversationListDataSource[indexPath.row];
    if (rcmodel.conversationModelType == RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION) {
        return UITableViewCellEditingStyleNone;
    }else{
        return UITableViewCellEditingStyleDelete;
    }
}

/**
 *  点击进入会话界面
 *
 *  @param conversationModelType 会话类型
 *  @param model                 会话数据
 *  @param indexPath             indexPath description
 */
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath {
    ChatViewController *vc = [[ChatViewController alloc] initWithConversationType:model.conversationType targetId:model.targetId];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//#pragma mark - UITableView Datasource & Delegate
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 10.f;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"message_notifi_cell"];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"message_notifi_cell"];
//    }
//    return cell;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    DLog(@"didSelectRowAtIndexPath------");
//    RedPacketViewController *vc = [[RedPacketViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    //    return kNoteHeight + kBannerHeight;
//    return 0.01f;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 70.f;
//}


- (void)leftBtnItemClicked{
    // 有使用配置表的时候，最简单的代码就只是控制显隐即可，没使用配置表的话，还需要设置其他的属性才能使红点样式正确，具体请看 UIBarButton+QMUIBadge.h 注释
    self.navigationItem.leftBarButtonItem.qmui_shouldShowUpdatesIndicator = NO;
    
    MessageNotifiListViewController *messageNotifiVc = [[MessageNotifiListViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:messageNotifiVc animated:YES];
}

@end

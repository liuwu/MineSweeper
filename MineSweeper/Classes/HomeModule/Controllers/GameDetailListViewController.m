//
//  GameDetailListViewController.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/15.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "GameDetailListViewController.h"
#import "ChatViewController.h"

//#import "BaseTableViewCell.h"
#import "BaseImageTableViewCell.h"

#import "ImGroupModelClient.h"
#import "IGameGroupModel.h"

@interface GameDetailListViewController ()

@property (nonatomic, strong) NSArray *datasource;

@end

@implementation GameDetailListViewController

- (NSString *)title {
    return @"扫雷游戏";
}

- (void)initSubviews {
    [super initSubviews];
    
//    UIBarButtonItem *rightBtnItem = [UIBarButtonItem qmui_itemWithTitle:@"保存" target:self action:@selector(rightBarButtonItemClicked)];
//    self.navigationItem.rightBarButtonItem = rightBtnItem;
    
    
    // 隐藏分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = WLColoerRGB(248.f);
    
    //下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(beginPullDownRefreshingNew)];
    //上提加载更多
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(beginPullUpRefreshingNew)];
    self.tableView.mj_footer = footer;
    self.tableView.mj_footer.hidden = YES;
    
    [self.tableView.mj_header beginRefreshing];
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
- (void)rightBarButtonItemClicked {
    
}

// 数据初始化
- (void)intData {
    [self hideEmptyView];
    WEAKSELF
//    [WLHUDView showHUDWithStr:@"加载中..." dim:YES];
    [ImGroupModelClient setImGameGroupListWithParams:nil Success:^(id resultInfo) {
//        [WLHUDView hiddenHud];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        weakSelf.datasource = [NSArray modelArrayWithClass:[IGameGroupModel class] json:resultInfo];
        if (weakSelf.datasource.count == 0) {
            [weakSelf showEmptyViewWithText:@"暂无数据" detailText:@"" buttonTitle:nil buttonAction:NULL];
        }
        [weakSelf.tableView reloadData];
    } Failed:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [WLHUDView hiddenHud];
    }];
}

- (void)beginPullDownRefreshingNew {
    [self intData];
}

- (void)beginPullUpRefreshingNew {
   [self intData];
}

#pragma mark - UITableView Datasource & Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"game_group_list_cell"];
    if (!cell) {
        cell = [[BaseImageTableViewCell alloc] initForTableView:tableView withStyle:UITableViewCellStyleDefault reuseIdentifier:@"game_group_list_cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.showBottomLine = YES;
    IGameGroupModel *model = _datasource[indexPath.row];
    cell.groupModel = model;
    
//    [cell.imageView setImageWithURL:[NSURL URLWithString:model.image]
//                        placeholder:[UIImage imageNamed:@"game_group_icon"]
//                            options:YYWebImageOptionProgressive|YYWebImageOptionProgressiveBlur|YYWebImageOptionIgnorePlaceHolder completion:nil];
//    cell.textLabel.text = model.title;// @"5-10 赔率1.5倍  群组";
    cell.textLabel.textColor = WLColoerRGB(51.f);
    cell.textLabel.font = UIFontMake(15.f);
    
    // reset
//    cell.textLabelEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    [cell updateCellAppearanceWithIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DLog(@"didSelectRowAtIndexPath------");
    IGameGroupModel *model = _datasource[indexPath.row];
    if (!model) {
        return;
    }
    [self join:model];
//    WEAKSELF
//    QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:NULL];
//    QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"发送" style:QMUIAlertActionStyleDestructive handler:^(__kindof QMUIAlertController *aAlertController, QMUIAlertAction *action) {
//        [weakSelf join:model];
//    }];
//    QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"确定发送？" message:nil preferredStyle:QMUIAlertControllerStyleAlert];
//    [alertController addAction:action1];
//    [alertController addAction:action2];
//    [alertController showWithAnimated:YES];
}

- (void)join:(IGameGroupModel *)model {
    ChatViewController *chatVc = [[ChatViewController alloc] initWithConversationType:ConversationType_GROUP targetId:model.groupId];
    chatVc.title = model.title;// @"5-10 赔率1.5倍  群组";
    chatVc.isGameGroup = YES;
    [self.navigationController pushViewController:chatVc animated:YES];
//    [WLHUDView showHUDWithStr:@"" dim:YES];
//    WEAKSELF
//    NSDictionary *params = @{@"id" : @(model.groupId.integerValue),
//                             @"fuid" : @[configTool.loginUser.uid]
//                             };
//    [ImGroupModelClient setImGroupJoinWithParams:params Success:^(id resultInfo) {
//        [WLHUDView hiddenHud];
//        ChatViewController *chatVc = [[ChatViewController alloc] initWithConversationType:ConversationType_GROUP targetId:model.groupId];
//        chatVc.title = model.title;// @"5-10 赔率1.5倍  群组";
//        [weakSelf.navigationController pushViewController:chatVc animated:YES];
//    } Failed:^(NSError *error) {
//        [WLHUDView hiddenHud];
//    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    //    return kNoteHeight + kBannerHeight;
    return 0.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.f;
}

@end

//
//  MessageNotifiListViewController.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/15.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "MessageNotifiListViewController.h"
#import "MessageNotifiDetailViewController.h"

#import "BaseTableViewCell.h"

#import "ImGroupModelClient.h"
#import "INoticeModel.h"
#import "INoticeInfoModel.h"

@interface MessageNotifiListViewController ()

@property (nonatomic, strong) INoticeInfoModel *noticeInfoModel;
@property (nonatomic, strong) NSArray *datasource;

@end

@implementation MessageNotifiListViewController

- (NSString *)title {
    return @"消息通知";
}

- (void)initSubviews {
    [super initSubviews];
    
    // 隐藏分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = WLColoerRGB(248.f);
    
    [self initData];
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
- (void)initData {
    [self hideEmptyView];
    WEAKSELF
    [WLHUDView showHUDWithStr:@"加载中..." dim:YES];
    [ImGroupModelClient getImSystemNoticeWithParams:nil Success:^(id resultInfo) {
        [WLHUDView hiddenHud];
        weakSelf.noticeInfoModel = [INoticeInfoModel modelWithDictionary:resultInfo];
        weakSelf.datasource = weakSelf.noticeInfoModel.list;
        if (weakSelf.datasource.count == 0) {
            [weakSelf showEmptyViewWithText:@"暂无数据" detailText:@"" buttonTitle:nil buttonAction:NULL];
        }
        [weakSelf.tableView reloadData];
    } Failed:^(NSError *error) {
        [WLHUDView hiddenHud];
    }];
}

#pragma mark - UITableView Datasource & Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"message_notifi_list_cell"];
    if (!cell) {
        cell = [[BaseTableViewCell alloc] initForTableView:tableView withStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"message_notifi_list_cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.showBottomLine = YES;
    INoticeModel *model = _datasource[indexPath.row];
    cell.imageView.image = !model.is_read.boolValue ? [UIImage imageNamed:@"home_newNotice_icon"] : nil;
    cell.textLabel.text = model.title;// @"这是消息通知标题";
    cell.textLabel.textColor = WLColoerRGB(51.f);
    cell.textLabel.font = UIFontMake(15.f);
    cell.detailTextLabel.text = model.add_time;// @"2018-10-12 12:12:12";
    cell.detailTextLabel.textColor = WLColoerRGB(153.f);
    cell.detailTextLabel.font = UIFontMake(11.f);
    
    // reset
//    cell.imageEdgeInsets = UIEdgeInsetsZero;
//    cell.textLabelEdgeInsets = UIEdgeInsetsZero;
//    cell.detailTextLabelEdgeInsets = UIEdgeInsetsZero;
//    cell.accessoryEdgeInsets = UIEdgeInsetsZero;
//    cell.textLabelEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [cell updateCellAppearanceWithIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DLog(@"didSelectRowAtIndexPath------");
    MessageNotifiDetailViewController *detailVc = [[MessageNotifiDetailViewController alloc] init];
    detailVc.noticeModel = _datasource[indexPath.row];
    [self.navigationController pushViewController:detailVc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    //    return kNoteHeight + kBannerHeight;
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.f;
}

@end

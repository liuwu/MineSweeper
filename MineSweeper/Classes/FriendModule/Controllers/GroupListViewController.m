//
//  GroupListViewController.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/18.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "GroupListViewController.h"

#import "BaseTableViewCell.h"

#import "ImGroupModelClient.h"
#import "IGameGroupModel.h"

@interface GroupListViewController ()

@property (nonatomic, strong) NSArray *datasource;

@end

@implementation GroupListViewController

- (NSString *)title {
    return @"群组";
}

- (void)initSubviews {
    [super initSubviews];
    // 隐藏分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = WLColoerRGB(248.f);
    
    //下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(beginPullDownRefreshingNew)];
    
    [self loadData];
}

- (void)loadData {
    [self hideEmptyView];
    WEAKSELF
    [ImGroupModelClient getImGroupListWithParams:nil Success:^(id resultInfo) {
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
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 下拉刷新
- (void)beginPullDownRefreshingNew {
    [self loadData];
}

#pragma mark - UITableView Datasource & Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"group_list_cell"];
    if (!cell) {
        cell = [[BaseTableViewCell alloc] initForTableView:tableView withStyle:UITableViewCellStyleDefault reuseIdentifier:@"group_list_cell"];
    }
    cell.showBottomLine = YES;
    IGameGroupModel *model = _datasource[indexPath.row];
//    cell.imageView.image = [UIImage qmui_imageWithShape:QMUIImageShapeOval size:CGSizeMake(30, 30) lineWidth:2 tintColor:[QDCommonUI randomThemeColor]];
    [cell.imageView setImageWithURL:[NSURL URLWithString:model.image]
                        placeholder:[UIImage imageNamed:@"game_group_icon"]
                            options:YYWebImageOptionProgressive|YYWebImageOptionProgressiveBlur|YYWebImageOptionIgnorePlaceHolder completion:nil];
    
    cell.textLabel.text = model.title;// @"群组";
    cell.textLabel.textColor = WLColoerRGB(51.f);
    cell.textLabel.font = UIFontMake(15.f);
    
    // reset
    cell.textLabelEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.f;
}

@end

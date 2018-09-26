//
//  RecommendListViewController.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/15.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "RecommendListViewController.h"
#import "BaseTableViewCell.h"

#import "UserModelClient.h"
#import "IRecommendModel.h"
#import "IRecommendInfoModel.h"

@interface RecommendListViewController ()

@property (nonatomic, strong) NSArray *datasource;

@end

@implementation RecommendListViewController

- (NSString *)title {
    return @"一级推荐";
}

- (void)initSubviews {
    [super initSubviews];
    // 隐藏分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(beginPullDownRefreshingNew)];
    
    [self loadData];
}

- (void)loadData {
    NSDictionary *params = @{
                             @"member_pid": @713,
                             @"distance" : @1
                             };
    WEAKSELF
    [UserModelClient getRecommoneNextListWithParams:params Success:^(id resultInfo) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        IRecommendModel *model = [IRecommendModel modelWithDictionary:resultInfo];
        [weakSelf loadUI:model];
    } Failed:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

- (void)loadUI:(IRecommendModel *)model {
    self.datasource = model.list;
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Datasource & Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"recommend_list_cell"];
    if (!cell) {
        cell = [[BaseTableViewCell alloc] initForTableView:tableView withStyle:UITableViewCellStyleValue1 reuseIdentifier:@"recommend_list_cell"];
    }
    cell.showBottomLine = YES;
    IRecommendInfoModel *mode = _datasource[indexPath.row];
    cell.imageView.image = [UIImage qmui_imageWithShape:QMUIImageShapeOval size:CGSizeMake(30, 30) lineWidth:2 tintColor:[QDCommonUI randomThemeColor]];
    cell.textLabel.textColor = WLColoerRGB(51.f);
    cell.textLabel.font = UIFontMake(15.f);
    cell.detailTextLabel.textColor = WLColoerRGB(153.f);
    cell.detailTextLabel.font = UIFontMake(15.f);
    cell.textLabel.text = mode.from_nickname;
    cell.detailTextLabel.text = mode.add_time;// @"2018-8-12";
    
    // reset
    cell.imageEdgeInsets = UIEdgeInsetsZero;
    cell.textLabelEdgeInsets = UIEdgeInsetsZero;
    cell.detailTextLabelEdgeInsets = UIEdgeInsetsZero;
    cell.accessoryEdgeInsets = UIEdgeInsetsZero;

//    cell.imageEdgeInsets = UIEdgeInsetsMake(0, 40, 0, 0);
    cell.textLabelEdgeInsets = UIEdgeInsetsMake(0, 40, 0, 0);
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    [cell updateCellAppearanceWithIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DLog(@"didSelectRowAtIndexPath------");
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.f;
}


#pragma mark - private
// 下拉刷新
- (void)beginPullDownRefreshingNew {
    [self loadData];
}



@end

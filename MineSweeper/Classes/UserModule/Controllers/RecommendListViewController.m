//
//  RecommendListViewController.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/15.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "RecommendListViewController.h"
#import "BaseTableViewCell.h"
#import "BaseImageSubTitleTableViewCell.h"

#import "UserModelClient.h"
#import "IRecommendModel.h"
#import "IRecommendInfoModel.h"

@interface RecommendListViewController ()

@property (nonatomic, strong) NSArray *datasource;

@property (nonatomic, assign) NSInteger distance;

@end

@implementation RecommendListViewController

- (instancetype)initWithDistance:(NSInteger)distance {
    self.distance = distance;
    self = [super self];
    if (self) {
        
    }
    return self;
}

- (NSString *)title {
    switch (_distance) {
        case 1:
            return @"一级推荐";
            break;
        case 2:
            return @"二级推荐";
            break;
        case 3:
            return @"三级推荐";
            break;
        case 4:
            return @"四级推荐";
            break;
        case 5:
            return @"五级推荐";
            break;
        case 6:
            return @"六级推荐";
            break;
        case 7:
            return @"七级推荐";
            break;
        default:
            return @"";
            break;
    }
}

- (void)initSubviews {
    [super initSubviews];
    // 隐藏分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(beginPullDownRefreshingNew)];
    
    //上提加载更多
//    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(beginPullUpRefreshingNew)];
//    self.tableView.mj_footer = footer;
//    self.tableView.mj_footer.hidden = YES;
    
    [self loadData];
}

- (void)loadData {
    [self hideEmptyView];
    NSDictionary *params = @{
                             @"member_id": @(configTool.loginUser.uid.integerValue),
                             @"distance" : @(_distance)
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
    if (self.datasource.count == 0) {
        [self showEmptyViewWithText:@"暂无数据" detailText:@"" buttonTitle:nil buttonAction:NULL];
    }
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
    BaseImageSubTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"recommend_list_cell"];
    if (!cell) {
        cell = [[BaseImageSubTitleTableViewCell alloc] initForTableView:tableView withStyle:UITableViewCellStyleValue1 reuseIdentifier:@"recommend_list_cell"];
    }
    cell.showBottomLine = YES;
    IRecommendInfoModel *mode = _datasource[indexPath.row];
    cell.recommendModel = mode;
    
    cell.textLabel.textColor = WLColoerRGB(51.f);
    cell.textLabel.font = UIFontMake(15.f);
    cell.detailTextLabel.textColor = WLColoerRGB(153.f);
    cell.detailTextLabel.font = UIFontMake(15.f);
    
    // reset
//    cell.imageEdgeInsets = UIEdgeInsetsZero;
//    cell.textLabelEdgeInsets = UIEdgeInsetsZero;
//    cell.detailTextLabelEdgeInsets = UIEdgeInsetsZero;
//    cell.accessoryEdgeInsets = UIEdgeInsetsZero;
//
////    cell.imageEdgeInsets = UIEdgeInsetsMake(0, 40, 0, 0);
//    cell.textLabelEdgeInsets = UIEdgeInsetsMake(0, 40, 0, 0);
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    [cell updateCellAppearanceWithIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DLog(@"didSelectRowAtIndexPath------");
    if (_distance == 7) {
        return;
    }
    RecommendListViewController *recommendListVc = [[RecommendListViewController alloc] initWithDistance:_distance + 1];
    [self.navigationController pushViewController:recommendListVc animated:YES];
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

// 上拉刷新
//- (void)beginPullUpRefreshingNew {
//    [self loadData];
//}


@end

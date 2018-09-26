//
//  GameDetailListViewController.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/15.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "GameDetailListViewController.h"
#import "ChatViewController.h"
#import "ChatGroupNoteInfoViewController.h"

#import "BaseTableViewCell.h"

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
    
    UIBarButtonItem *rightBtnItem = [UIBarButtonItem qmui_itemWithTitle:@"保存" target:self action:@selector(rightBarButtonItemClicked)];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
    
    
    // 隐藏分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = WLColoerRGB(248.f);
    
    [self intData];
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
    ChatGroupNoteInfoViewController *vc = [[ChatGroupNoteInfoViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

// 数据初始化
- (void)intData {
    WEAKSELF
    [WLHUDView showHUDWithStr:@"加载中..." dim:YES];
    [ImGroupModelClient setImGameGroupListWithParams:nil Success:^(id resultInfo) {
        [WLHUDView hiddenHud];
        weakSelf.datasource = [NSArray modelArrayWithClass:[IGameGroupModel class] json:resultInfo];
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
    BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"game_group_list_cell"];
    if (!cell) {
        cell = [[BaseTableViewCell alloc] initForTableView:tableView withStyle:UITableViewCellStyleDefault reuseIdentifier:@"game_group_list_cell"];
    }
    cell.showBottomLine = YES;
    IGameGroupModel *model = _datasource[indexPath.row];
    [cell.imageView setImageWithURL:[NSURL URLWithString:model.image]
                        placeholder:[UIImage imageNamed:@"game_group_icon"]
                            options:YYWebImageOptionProgressive|YYWebImageOptionProgressiveBlur|YYWebImageOptionIgnorePlaceHolder completion:nil];
    cell.textLabel.text = model.title;// @"5-10 赔率1.5倍  群组";
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
    IGameGroupModel *model = _datasource[indexPath.row];
    ChatViewController *chatVc = [[ChatViewController alloc] initWithConversationType:ConversationType_GROUP targetId:model.groupId];
    chatVc.title = model.title;// @"5-10 赔率1.5倍  群组";
    [self.navigationController pushViewController:chatVc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    //    return kNoteHeight + kBannerHeight;
    return 0.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.f;
}

@end

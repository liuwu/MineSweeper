//
//  MyCardViewController.m
//  MineSweeper
//
//  Created by liuwu on 2018/10/8.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "MyCardViewController.h"
#import "AddCardViewController.h"

#import "UserModelClient.h"

#import "ICardModel.h"

#import "MyCardViewCell.h"


@interface MyCardViewController ()

@property (nonatomic, strong) NSArray *datasource;

@end

@implementation MyCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)title {
    return @"我的银行卡";
}

- (void)initSubviews {
    [super initSubviews];
    [self addSubViews];
//    [self addConstrainsForSubviews];
    
    [self initData];
    
    [kNSNotification addObserver:self selector:@selector(initData) name:@"kMyCardChanged" object:nil];
}

- (void)addSubViews {
    // 隐藏分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = WLColoerRGB(248.f);
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0., DEVICE_WIDTH, 80.f)];
    self.tableView.tableHeaderView = headerView;
    
    // 添加银行卡
    QMUIFillButton *addCardBtn = [[QMUIFillButton alloc] initWithFillType:QMUIFillButtonColorWhite];
    [addCardBtn setTitle:@"+ 添加银行卡" forState:UIControlStateNormal];
    addCardBtn.titleLabel.font = UIFontMake(15);
    [addCardBtn setTitleColor:WLColoerRGB(51.f) forState:UIControlStateNormal];
    [addCardBtn addTarget:self action:@selector(addCardBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [addCardBtn setCornerRadius:5.f];
    [headerView addSubview:addCardBtn];
    [addCardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH - 20.f, 44.f));
        make.centerY.mas_equalTo(headerView);
        make.centerX.mas_equalTo(headerView);
    }];
}

#pragma mark - Private
- (void)initData {
    WEAKSELF
    [WLHUDView showHUDWithStr:@"" dim:YES];
    [UserModelClient getBankCardListWithParams:nil Success:^(id resultInfo) {
        [WLHUDView hiddenHud];
        weakSelf.datasource = [NSArray modelArrayWithClass:[ICardModel class] json:resultInfo];
        [weakSelf.tableView reloadData];
    } Failed:^(NSError *error) {
        if (error.localizedDescription.length > 0) {
            [WLHUDView showErrorHUD:error.localizedDescription];
        } else {
            [WLHUDView hiddenHud];
        }
    }];
}


- (void)addCardBtnClicked:(UIButton *)sender {
    AddCardViewController *vc = [[AddCardViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)delBankCardWithIndexPath:(NSIndexPath *)indexPath {
    ICardModel *model = _datasource[indexPath.row];
    NSDictionary *params = @{@"id" : @(model.cardId.integerValue)};
    [WLHUDView showHUDWithStr:@"" dim:YES];
    WEAKSELF
    [UserModelClient delBankCardListWithParams:params Success:^(id resultInfo) {
        [WLHUDView hiddenHud];
        [weakSelf initData];
    } Failed:^(NSError *error) {
        if (error.localizedDescription.length > 0) {
            [WLHUDView showErrorHUD:error.localizedDescription];
        } else {
            [WLHUDView hiddenHud];
        }
    }];
}


#pragma mark - UITableView Datasource & Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyCardViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"my_card_cell"];
    if (!cell) {
        cell = [[MyCardViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"my_card_cell"];
    }
    
    ICardModel *model = _datasource[indexPath.row];
    cell.cardModel = model;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DLog(@"didSelectRowAtIndexPath------");
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.f;
}



//设置cell左滑后的删除按钮文字
//-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return @"解绑";
//}
//点击cell的删除按钮后调用该方法
//-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        [callRecordsArr removeObjectAtIndex:indexPath.row];
//        //数据源删除对应元素要在tableview删除对应的cell之前
//        [tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//        [NSKeyedArchiver archiveRootObject:callRecordsArr toFile:CALLRECORDSCACHEPATH];
//    }
//}

// 如需要显示多个按钮，参照如下代码（注意：当我们使用自定义按钮后，如上的系统默认方法将失去作用）
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return true;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    WEAKSELF
    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"解绑" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [weakSelf delBankCardWithIndexPath:indexPath];
    }];
    //此处UITableViewRowAction对象放入的顺序决定了对应按钮在cell中的顺序
    return@[action1];
}

@end

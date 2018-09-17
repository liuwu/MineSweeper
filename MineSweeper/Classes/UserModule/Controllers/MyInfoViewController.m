//
//  MyInfoViewController.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/15.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "MyInfoViewController.h"

#import "RETableViewManager.h"
#import "RETableViewItem.h"


@interface MyInfoViewController ()

@property (nonatomic, strong) RETableViewManager *manager;

@end

@implementation MyInfoViewController

- (NSString *)title {
    return @"个人资料";
}

- (void)initSubviews {
    [super initSubviews];
    [self addTableViewCell];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 添加表格内容
- (void)addTableViewCell {
    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView];
    // 显示自定义分割线
    self.manager.showBottomLine = YES;
    self.manager.defaultDetailLabelTextColor = WLColoerRGB(102.f);;
    // 隐藏默认分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = WLColoerRGB(248.f);
    
    RETableViewSection *section = [RETableViewSection section];
    section.headerHeight = 0.f;
    section.footerHeight = 0.f;
    [self.manager addSection:section];
    
    UIView *logoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50.f, 50.f)];
    logoView.backgroundColor = [UIColor redColor];
    
    RETableViewItem *logoItem = [RETableViewItem itemWithTitle:@"头像" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        item.logoImage = [[UIImage imageNamed:@"withdraw_ali_icon"] qmui_imageWithClippedCornerRadius:25.f];
        // 重新加载数据
        [item reloadRowWithAnimation:UITableViewRowAnimationNone];
    }];
    logoItem.logoImage = [[UIImage imageNamed:@"mine_award_icon"] qmui_imageWithClippedCornerRadius:25.f];
    logoItem.cellHeight = 75.f;
    logoItem.selectionStyle = UITableViewCellSelectionStyleNone;
    [section addItem:logoItem];
    
    RETableViewItem *nickNameItem = [RETableViewItem itemWithTitle:@"昵称" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item) {
        
    }];
    nickNameItem.style = UITableViewCellStyleValue1;
    nickNameItem.detailLabelText = @"笑笑";
    nickNameItem.selectionStyle = UITableViewCellSelectionStyleNone;
    [section addItem:nickNameItem];
    
    RETableViewItem *nameItem = [RETableViewItem itemWithTitle:@"真实姓名" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item) {
        
    }];
    nameItem.style = UITableViewCellStyleValue1;
    nameItem.detailLabelText = @"陈锋";
    nameItem.selectionStyle = UITableViewCellSelectionStyleNone;
    [section addItem:nameItem];
    
    RETableViewItem *sexItem = [RETableViewItem itemWithTitle:@"性别" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item) {
        
    }];
    sexItem.style = UITableViewCellStyleValue1;
    sexItem.detailLabelText = @"女";
    sexItem.selectionStyle = UITableViewCellSelectionStyleNone;
    [section addItem:sexItem];
    
    RETableViewItem *phoneItem = [RETableViewItem itemWithTitle:@"手机号" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item) {
        
    }];
    phoneItem.style = UITableViewCellStyleValue1;
    phoneItem.detailLabelText = @"138812121212";
    phoneItem.selectionStyle = UITableViewCellSelectionStyleNone;
    [section addItem:phoneItem];
    
    RETableViewItem *cityItem = [RETableViewItem itemWithTitle:@"城市" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        
    }];
    cityItem.style = UITableViewCellStyleValue1;
    cityItem.detailLabelText = @"湖北武汉";
    cityItem.selectionStyle = UITableViewCellSelectionStyleNone;
    [section addItem:cityItem];
}

@end

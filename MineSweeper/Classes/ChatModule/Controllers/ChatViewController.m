//
//  ChatViewController.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/19.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatGroupDetailViewController.h"

#import "QMUINavigationButton.h"

@interface ChatViewController ()

@end

@implementation ChatViewController

- (NSString *)title {
    return @"聊天";
}

//- (void)initSubviews {
//    [super initSubviews];
//    UIBarButtonItem *rightBtnItem = [UIBarButtonItem qmui_itemWithButton:[[QMUINavigationButton alloc] initWithImage:[[UIImage imageNamed:@"chats_more_btn"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]] target:self action:@selector(rightBtnItemClicked)];
//    self.navigationItem.rightBarButtonItem = rightBtnItem;

    // 隐藏分割线
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.backgroundColor = WLColoerRGB(248.f);
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *rightBtnItem = [UIBarButtonItem qmui_itemWithButton:[[QMUINavigationButton alloc] initWithImage:[[UIImage imageNamed:@"chats_more_btn"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]] target:self action:@selector(rightBtnItemClicked)];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
    
    // 设置扩展功能按钮图片
    [self.chatSessionInputBarControl.additionalButton setImage:[UIImage imageNamed:@"chats_redP_btn"] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - private
// 右侧按钮点击
- (void)rightBtnItemClicked {
    ChatGroupDetailViewController *vc = [[ChatGroupDetailViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end

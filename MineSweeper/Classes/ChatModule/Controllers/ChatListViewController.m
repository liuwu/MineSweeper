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

@interface ChatListViewController ()

@end

@implementation ChatListViewController

- (NSString *)title {
    return @"消息";
}

- (instancetype)init{
    self = [super init];
    if (self) {
        //设置要显示的会话类型
        [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),@(ConversationType_GROUP),@(ConversationType_SYSTEM)]];
        //聚合会话类型
        [self setCollectionConversationType:@[@(ConversationType_GROUP),@(ConversationType_SYSTEM)]];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:WLColoerRGB(255.f)] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:WLColoerRGB(255.f)]];
}

//- (void)initSubviews {
//    [super initSubviews];
//    
//    // 隐藏分割线
////    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
////    self.tableView.backgroundColor = WLColoerRGB(248.f);
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //重写显示相关的接口，必须先调用super，否则会屏蔽SDK默认的处理
//    [super viewDidLoad];
    
    //设置需要显示哪些类型的会话
//    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),
//                                        @(ConversationType_DISCUSSION),
//                                        @(ConversationType_CHATROOM),
//                                        @(ConversationType_GROUP),
//                                        @(ConversationType_APPSERVICE),
//                                        @(ConversationType_SYSTEM)]];
//    //设置需要将哪些类型的会话在会话列表中聚合显示
//    [self setCollectionConversationType:@[@(ConversationType_DISCUSSION),
//                                          @(ConversationType_GROUP)]];
    
    //设置需要显示哪些类型的会话，会话类型有很多，选择你需要的就好啦
//    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE), @(ConversationType_DISCUSSION), @(ConversationType_CHATROOM), @(ConversationType_GROUP), @(ConversationType_APPSERVICE), @(ConversationType_SYSTEM)]]; //设置需要将哪些类型的会话在会话列表中聚合显示
//    [self setCollectionConversationType:@[@(ConversationType_DISCUSSION), @(ConversationType_GROUP)]];
    
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
- (NSMutableArray *)willReloadTableData:(NSMutableArray *)dataSource {
//    if (configTool.loginUser.investorauth.integerValue == 1) {
//        [dataSource insertObjects:[WLChatProjectManager sharedInstance].dataSource atIndex:0];
//    }
    return dataSource;
}

/*!
 即将显示Cell的回调
 
 @param cell        即将显示的Cell
 @param indexPath   该Cell对应的会话Cell数据模型在数据源中的索引值
 
 @discussion 您可以在此回调中修改Cell的一些显示属性。
 */
- (void)willDisplayConversationTableCell:(RCConversationBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    RCConversationCell *rcCell = (RCConversationCell *)cell;
    RCConversationModel *model = self.conversationListDataSource[indexPath.row];
    rcCell.conversationTitle.textColor = [UIColor wl_Hex333333];
    rcCell.messageContentLabel.font = WLFONT(12);
    rcCell.messageContentLabel.textColor = [UIColor wl_Hex999999];
    rcCell.messageCreatedTimeLabel.font = WLFONT(10);
    rcCell.messageCreatedTimeLabel.textColor = [UIColor wl_HexCCCCCC];
    
//    if(model.conversationModelType==RC_CONVERSATION_MODEL_TYPE_COLLECTION){
//        NSInteger newBadge = configTool.systemCountModel.newfriendbcount.integerValue;
//        //        [rcCell.conversationTitle setText:@"好友请求"];
//        rcCell.conversationTitle.centery = rcCell.contentView.centery;
//        rcCell.messageContentLabel.text = @"";
//        if (newBadge) {
//            UIView *butView = [cell.contentView viewWithTag:self.numBtn.tag];
//            if (!butView) {
//                [cell.contentView addSubview:self.numBtn];
//            }
//        }else{
//            UIView *butView = [cell.contentView viewWithTag:self.numBtn.tag];
//            if (butView) {
//                [butView removeFromSuperview];
//            }
//        }
//
//        UIView *ifdasdad = [rcCell viewWithTag:10151016];
//        if (ifdasdad) {
//            [ifdasdad removeFromSuperview];
//        }
//    }else{
//        if (model.targetId.integerValue == 7) {
//            rcCell.messageContentLabel.text = nil;
//        }
//        if (model.conversationType == ConversationType_GROUP) {
//            UIView *ifdasdad = [rcCell.contentView viewWithTag:10151016];
//            if (!ifdasdad) {
//                UIImageView *ivew = [[UIImageView alloc] initWithFrame:CGRectMake(45, 40, 15, 15)];
//                ivew.tag = 10151016;
//                [ivew setImage:[UIImage imageNamed:@"Rectangle_group1362"]];
//                [rcCell.contentView addSubview:ivew];
//            }
//        }else{
//            UIView *ifdasdad = [rcCell viewWithTag:10151016];
//            if (ifdasdad) {
//                [ifdasdad removeFromSuperview];
//            }
//        }
//        UIView *butView = [cell.contentView viewWithTag:self.numBtn.tag];
//        if (butView) {
//            [butView removeFromSuperview];
//        }
//    }
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

@end

//
//  MyInfoViewController.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/15.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "MyInfoViewController.h"
#import "UserInfoChangeViewController.h"

#import "RETableViewManager.h"
#import "RETableViewItem.h"

#import "QDNavigationController.h"

#import "UIViewController+WLImagePicker.h"

#import "UserModelClient.h"
#import "YJLocationPicker.h"

#import "ICityModel.h"

@interface MyInfoViewController () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) RETableViewManager *manager;

@property(nonatomic, strong) UIImage *selectedAvatarImage;

@property (nonatomic, strong) RETableViewItem *nickNameItem;
@property (nonatomic, strong) RETableViewItem *realNameItem;

@end

@implementation MyInfoViewController

- (NSString *)title {
    return @"个人资料";
}

- (void)initSubviews {
    [super initSubviews];
    [self addTableViewCell];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nickNameChanged) name:@"kNickNameChanged" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(realNameChanged) name:@"kRealNameChanged" object:nil];
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
    
    WEAKSELF
    RETableViewItem *logoItem = [RETableViewItem itemWithTitle:@"头像" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        [weakSelf choosePictureimageBlock:^(UIImage *image) {
            
        } successBlock:^(UIImage *image, id resultInfo) {
            configTool.userInfoModel.avatar = resultInfo[@"avatar"];
            item.logoImageUrl = [NSURL URLWithString:configTool.userInfoModel.avatar];
            // 重新加载数据
            [item reloadRowWithAnimation:UITableViewRowAnimationNone];
        } imagePickerFailedBlock:^(NSError *error) {
            
        }];
    }];
    logoItem.showLogoImage = YES;
    logoItem.logoImageUrl = [NSURL URLWithString:configTool.userInfoModel.avatar];
//    logoItem.logoImage = [[UIImage imageNamed:@"mine_award_icon"] qmui_imageWithClippedCornerRadius:25.f];
    logoItem.cellHeight = 75.f;
    logoItem.selectionStyle = UITableViewCellSelectionStyleNone;
    [section addItem:logoItem];
    
    RETableViewItem *nickNameItem = [RETableViewItem itemWithTitle:@"昵称" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        [weakSelf changeUserNickName:item];
    }];
    nickNameItem.style = UITableViewCellStyleValue1;
    nickNameItem.detailLabelText = configTool.userInfoModel.nickname ? : @"未填写";// @"笑笑";
    nickNameItem.selectionStyle = UITableViewCellSelectionStyleNone;
    [section addItem:nickNameItem];
    self.nickNameItem = nickNameItem;
    
    RETableViewItem *nameItem = [RETableViewItem itemWithTitle:@"真实姓名" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        [weakSelf changeUserRealName:item];
    }];
    nameItem.style = UITableViewCellStyleValue1;
    nameItem.detailLabelText = configTool.userInfoModel.realname ? : @"未填写";//@"陈锋";
    nameItem.selectionStyle = UITableViewCellSelectionStyleNone;
    [section addItem:nameItem];
    self.realNameItem = nameItem;
    
    RETableViewItem *sexItem = [RETableViewItem itemWithTitle:@"性别" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        [weakSelf selectSex:item];
    }];
    sexItem.style = UITableViewCellStyleValue1;
    sexItem.detailLabelText = [configTool getLoginUserSexStr];//@"女";
    sexItem.selectionStyle = UITableViewCellSelectionStyleNone;
    [section addItem:sexItem];
    
    RETableViewItem *phoneItem = [RETableViewItem itemWithTitle:@"手机号" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item) {
        
    }];
    phoneItem.style = UITableViewCellStyleValue1;
    phoneItem.detailLabelText = configTool.userInfoModel.mobile ? : @"未填写";//@"138812121212";
    phoneItem.selectionStyle = UITableViewCellSelectionStyleNone;
    [section addItem:phoneItem];
    
    RETableViewItem *cityItem = [RETableViewItem itemWithTitle:@"城市" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        [weakSelf selectAddress:item];
    }];
    cityItem.style = UITableViewCellStyleValue1;
    cityItem.detailLabelText = configTool.userInfoModel.address ? : @"未填写";// @"湖北武汉";
    cityItem.selectionStyle = UITableViewCellSelectionStyleNone;
    [section addItem:cityItem];
}

- (void)changeUserNickName:(RETableViewItem *)item {
    UserInfoChangeViewController *vc = [[UserInfoChangeViewController alloc] initWithUserInfoChangeType:UserInfoChangeTypeNickName];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)changeUserRealName:(RETableViewItem *)item {
    UserInfoChangeViewController *vc = [[UserInfoChangeViewController alloc] initWithUserInfoChangeType:UserInfoChangeTypeRealName];
    [self.navigationController pushViewController:vc animated:YES];
}

// 选中城市信息
- (void)selectAddress:(RETableViewItem *)item {
    [UserModelClient getSystemCityListWithParams:nil Success:^(id resultInfo) {
        NSArray *allCitys = [NSArray modelArrayWithClass:[ICityModel class] json:resultInfo];
        [self printAllCity:allCitys];
    } Failed:^(NSError *error) {
        
    }];
    
    //初始化mainPickView
    //直接调用
    [[[YJLocationPicker alloc] initWithSlectedLocation:^(NSArray *locationArray) {
        
        //array里面放的是省市区三级
        NSLog(@"------%@", locationArray);
        //拼接后给button赋值
//        [sender setTitle:[locationArray componentsJoinedByString:@""] forState:UIControlStateNormal];
        
    }] show];
}

- (void)printAllCity:(NSArray *)allCitys {
    
//    NSMutableDictionary
//    for (ICityModel *cityModel in allCitys) {
//
//    }
    
}

// 修改地址
- (void)changeAddress:(RETableViewItem *)item {
    NSDictionary *params = @{@"province" : @1,
                             @"city" : @3
                             };
    [WLHUDView showHUDWithStr:@"" dim:YES];
    [UserModelClient changeUserInfoWithParams:params
                                      Success:^(id resultInfo) {
                                          [WLHUDView hiddenHud];
//                                          configTool.userInfoModel.gender = sex;
//                                          item.detailLabelText = [configTool getLoginUserSexStr];
                                          // 重新加载数据
                                          [item reloadRowWithAnimation:UITableViewRowAnimationNone];
                                      } Failed:^(NSError *error) {
                                          [WLHUDView hiddenHud];
                                      }];
}

// 选中性别
- (void)selectSex:(RETableViewItem *)item {
    WEAKSELF
    QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        DLog(@"取消");
    }];
    QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"男" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        [weakSelf changeSex:item sex:@"1"];
//        configTool.userInfoModel.gender = @"1";
//        item.detailLabelText = [configTool getLoginUserSexStr];
        // 重新加载数据
//        [item reloadRowWithAnimation:UITableViewRowAnimationNone];
//        [weakSelf changeSex:item sex:@"1"];
    }];
    QMUIAlertAction *action3 = [QMUIAlertAction actionWithTitle:@"女" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        [weakSelf changeSex:item sex:@"2"];
//        configTool.userInfoModel.gender = @"2";
//        item.detailLabelText = [configTool getLoginUserSexStr];
//        // 重新加载数据
//        [item reloadRowWithAnimation:UITableViewRowAnimationNone];
//        [weakSelf changeSex:item sex:@"2"];
    }];
    QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:nil message:@"性别" preferredStyle:QMUIAlertControllerStyleActionSheet];
    [alertController addAction:action1];
    [alertController addAction:action2];
    [alertController addAction:action3];
    [alertController showWithAnimated:YES];
}

- (void)changeSex:(RETableViewItem *)item sex:(NSString *)sex {
    NSDictionary *params = @{
                             @"nickname" : configTool.userInfoModel.nickname,
                             @"realname" : configTool.userInfoModel.realname ? : @"",
                             @"gender" : sex,
                             //                                     @"province" : configTool.userInfoModel.gender ? : @"",
                             //                                     @"city" : configTool.userInfoModel.gender ? : @"",
                             };
    [WLHUDView showHUDWithStr:@"" dim:YES];
    [UserModelClient changeUserInfoWithParams:params
                                      Success:^(id resultInfo) {
                                          [WLHUDView hiddenHud];
                                          configTool.userInfoModel.gender = sex;
                                          item.detailLabelText = [configTool getLoginUserSexStr];
                                          // 重新加载数据
                                          [item reloadRowWithAnimation:UITableViewRowAnimationNone];
                                      } Failed:^(NSError *error) {
                                          [WLHUDView hiddenHud];
                                      }];
}

- (void)nickNameChanged {
    _nickNameItem.detailLabelText = configTool.userInfoModel.nickname ? : @"未填写";// @"笑笑";
    // 重新加载数据
    [_nickNameItem reloadRowWithAnimation:UITableViewRowAnimationNone];
}

- (void)realNameChanged {
    _realNameItem.detailLabelText = configTool.userInfoModel.realname ? : @"未填写";// @"笑笑";
    // 重新加载数据
    [_realNameItem reloadRowWithAnimation:UITableViewRowAnimationNone];
}

@end

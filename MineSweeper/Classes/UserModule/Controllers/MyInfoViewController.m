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
    
    [self loadCityData];
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

// 获取城市数据
- (void)loadCityData {
    if (!configTool.allCityDic || !configTool.provinceArray) {
        [UserModelClient getSystemCityListWithParams:nil Success:^(id resultInfo) {
            NSArray *allCitys = [NSArray modelArrayWithClass:[ICityModel class] json:resultInfo];
            NSMutableArray *provinceArray = [NSMutableArray array];
            for (ICityModel *cityModel in allCitys) {
                if (cityModel.pid.integerValue == 0) {
                    [provinceArray addObject:cityModel];
                }
            }
            NSMutableDictionary *allCityDic = [NSMutableDictionary dictionary];
            for (ICityModel *cityModel in provinceArray) {
                NSArray *citys = [allCitys bk_select:^BOOL(id obj) {
                    return ([[(ICityModel *)obj pid] integerValue] == cityModel.cid.integerValue);
                }];
                if (citys.count > 0) {
                    [citys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                        return [obj1 cid] < [obj2 cid];
                    }];
                    [allCityDic setValue:citys forKey:cityModel.cid];
                }
            }
            // 对省进行排序
            [provinceArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                return [obj1 cid] < [obj2 cid];
            }];
            configTool.provinceArray = provinceArray;
            configTool.allCityDic = allCityDic;
        } Failed:^(NSError *error) {
            
        }];
    }
}

// 选中城市信息
- (void)selectAddress:(RETableViewItem *)item {
    //初始化mainPickView
    //直接调用
    if (configTool.allCityDic && configTool.provinceArray) {
        WEAKSELF
        [[[YJLocationPicker alloc] initWithProvince:configTool.provinceArray
                                           cityDict:configTool.allCityDic
                                    SlectedLocation:^(ICityModel *province, ICityModel *city) {
                                        DLog(@" %@------%@", province.title, city.title);
                                        [weakSelf changeAddress:item province:province city:city];
                                    }]show];
    }
}

// 修改地址
- (void)changeAddress:(RETableViewItem *)item province:(ICityModel *)province city:(ICityModel *)city {
    if (!province || !city) {
        return;
    }
    NSDictionary *params = @{
                             @"nickname" : configTool.userInfoModel.nickname,
                             @"realname" : configTool.userInfoModel.realname ? : @"",
                             @"gender" : configTool.userInfoModel.gender ? : @"",
                             @"province" : @(province.cid.integerValue),
                             @"city" : @(city.cid.integerValue)
                             };
    [WLHUDView showHUDWithStr:@"" dim:YES];
    [UserModelClient changeUserInfoWithParams:params
                                      Success:^(id resultInfo) {
                                          [WLHUDView hiddenHud];
                                          configTool.userInfoModel.address = [NSString stringWithFormat:@"%@%@", province.title, city.title];
//                                          configTool.userInfoModel.gender = sex;
//                                          item.detailLabelText = [configTool getLoginUserSexStr];
                                          // 重新加载数据
                                          item.detailLabelText = configTool.userInfoModel.address;
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

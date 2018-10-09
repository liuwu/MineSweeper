//
//  AddCardViewController.m
//  MineSweeper
//
//  Created by liuwu on 2018/10/8.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "AddCardViewController.h"
#import "LWLoginTextFieldView.h"

#import "UserModelClient.h"

#import "RETableViewManager.h"

@interface AddCardViewController ()

@property (nonatomic, strong) RETableViewManager *manager;

@end

@implementation AddCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)title {
    return @"添加银行卡";
}

- (void)initSubviews {
    [super initSubviews];
    [self addSubViews];
    //    [self addConstrainsForSubviews];
    
    [self addTableViewCell];
}

- (void)addSubViews {
    // 隐藏分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = WLColoerRGB(248.f);
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0., DEVICE_WIDTH, 231.f)];
    self.tableView.tableHeaderView = headerView;
    
    QMUILabel *idLabel = [[QMUILabel alloc] init];
    idLabel.font = UIFontMake(12);
    idLabel.textColor = WLColoerRGB(153.f);
    idLabel.text = @"请绑定持卡人本人的银行卡";
    [headerView addSubview:idLabel];
    [idLabel sizeToFit];
    [idLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(15.f);
    }];

//    LWLoginTextFieldView *userTxtView = [[LWLoginTextFieldView alloc] initWithTextFieldType:LWLoginTextFieldTypePhone];
//    userTxtView.titleLabel.text = @"持卡人";
//    userTxtView.textField.placeholder = @"姓名";
//    [headerView addSubview:userTxtView];
//
//    [userTxtView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH, 44.f));
//        make.top.mas_equalTo(idLabel.mas_bottom).mas_offset(10.f);
//        make.centerX.mas_equalTo(headerView);
//    }];
//
//    LWLoginTextFieldView *cardTxtView = [[LWLoginTextFieldView alloc] initWithTextFieldType:LWLoginTextFieldTypePhone];
//    cardTxtView.titleLabel.text = @"卡号";
//    cardTxtView.textField.placeholder = @"银行卡号";
//    [headerView addSubview:cardTxtView];
//    [cardTxtView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(userTxtView);
//        make.top.mas_equalTo(userTxtView.mas_bottom);
//        make.centerX.mas_equalTo(headerView);
//    }];
//
//    LWLoginTextFieldView *cardTypeTxtView = [[LWLoginTextFieldView alloc] initWithTextFieldType:LWLoginTextFieldTypePhone];
//    cardTypeTxtView.titleLabel.text = @"开户行";
//    cardTypeTxtView.textField.placeholder = @"开户银行";
//    [headerView addSubview:cardTypeTxtView];
//    [cardTypeTxtView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(userTxtView);
//        make.top.mas_equalTo(cardTxtView.mas_bottom);
//        make.centerX.mas_equalTo(headerView);
//    }];
    
    // 添加银行卡
    QMUIFillButton *bindBtn = [[QMUIFillButton alloc] initWithFillType:QMUIFillButtonColorRed];
    [bindBtn setTitle:@"绑定" forState:UIControlStateNormal];
    bindBtn.titleLabel.font = UIFontMake(18);
    [bindBtn setTitleColor:WLColoerRGB(51.f) forState:UIControlStateNormal];
    [bindBtn addTarget:self action:@selector(bindBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bindBtn setCornerRadius:5.f];
    [headerView addSubview:bindBtn];
    [bindBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH - 20.f, 44.f));
        make.bottom.mas_equalTo(headerView);
        make.centerX.mas_equalTo(headerView);
    }];
}

// 添加表格内容
- (void)addTableViewCell {
    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView];
    WEAKSELF
    RETableViewSection *section = [RETableViewSection sectionWithHeaderTitle:@"请绑定持卡人本人的银行卡"];
    
    RETextItem *commendItem = [RETextItem itemWithTitle:@"持卡人" value:nil placeholder:@"持卡人姓名"];
    commendItem.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    commendItem.style = UITableViewCellStyleValue1;
//    commendItem.detailLabelText = configTool.userInfoModel.invite_code;
//    commendItem.titleDetailTextColor = WLColoerRGB(153.f);
//    commendItem.titleDetailTextFont = UIFontMake(15.f);
//    commendItem.image = [UIImage imageNamed:@"mine_recommend_icon"];
    [section addItem:commendItem];
//    self.commendItem = commendItem;
    
    RECreditCardItem *cardItem = [RECreditCardItem item];
//    cardItem.style = UITableViewCellStyleValue1;
    //    cardItem.detailLabelText = configTool.userInfoModel.invite_code;
//    cardItem.titleDetailTextColor = WLColoerRGB(153.f);
//    cardItem.titleDetailTextFont = UIFontMake(15.f);
//    cardItem.image = [UIImage imageNamed:@"mine_card"];
//    cardItem.creditCardType = RECreditCardTypeUnknown;
    cardItem.title = @"卡号";
    cardItem.cvvRequired = NO;
    cardItem.keyboardAppearance = UIKeyboardAppearanceDefault;
    [section addItem:cardItem];
//    self.cardItem = cardItem;
    
    RETextItem *promotionPosterItem = [RETextItem itemWithTitle:@"开户行" value:nil placeholder:@"开户行"];
//    promotionPosterItem.image = [UIImage imageNamed:@"mine_share_icon"];
    [section addItem:promotionPosterItem];
    [self.manager addSection:section];
}


#pragma mark - Private
- (void)bindBtnClicked:(UIButton *)sender {
    NSDictionary *params = @{@"username" : @"持卡人姓名",
                             @"password" : @"支付密码",
                             @"account" : @"卡号",
                             @"bank_adress" : @"开户行"
                             };
    [UserModelClient addBankCardListWithParams:params Success:^(id resultInfo) {
        
    } Failed:^(NSError *error) {
        
    }];
}



@end

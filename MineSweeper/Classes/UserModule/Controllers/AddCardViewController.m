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

@interface AddCardViewController ()

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

    LWLoginTextFieldView *userTxtView = [[LWLoginTextFieldView alloc] initWithTextFieldType:LWLoginTextFieldTypePhone];
    userTxtView.titleLabel.text = @"持卡人";
    userTxtView.textField.placeholder = @"姓名";
    [headerView addSubview:userTxtView];
    
    [userTxtView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH, 44.f));
        make.top.mas_equalTo(idLabel.mas_bottom).mas_offset(10.f);
        make.centerX.mas_equalTo(headerView);
    }];
    
    LWLoginTextFieldView *cardTxtView = [[LWLoginTextFieldView alloc] initWithTextFieldType:LWLoginTextFieldTypePhone];
    cardTxtView.titleLabel.text = @"卡号";
    cardTxtView.textField.placeholder = @"银行卡号";
    [headerView addSubview:cardTxtView];
    [cardTxtView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(userTxtView);
        make.top.mas_equalTo(userTxtView.mas_bottom);
        make.centerX.mas_equalTo(headerView);
    }];
    
    LWLoginTextFieldView *cardTypeTxtView = [[LWLoginTextFieldView alloc] initWithTextFieldType:LWLoginTextFieldTypePhone];
    cardTypeTxtView.titleLabel.text = @"开户行";
    cardTypeTxtView.textField.placeholder = @"开户银行";
    [headerView addSubview:cardTypeTxtView];
    [cardTypeTxtView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(userTxtView);
        make.top.mas_equalTo(cardTxtView.mas_bottom);
        make.centerX.mas_equalTo(headerView);
    }];
    
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

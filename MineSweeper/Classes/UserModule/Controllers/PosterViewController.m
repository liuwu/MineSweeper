//
//  PosterViewController.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/15.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "PosterViewController.h"

#import "UserModelClient.h"
#import "IUserQrCodeModel.h"

@interface PosterViewController ()

@property (nonatomic, strong) QMUILabel *titleLabel;
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UIImageView *codeImageView;

@end

@implementation PosterViewController

- (NSString *)title {
    return @"推广海报";
}

- (void)initSubviews {
    [super initSubviews];
    
    [self addSubViews];
//    [self getUserVcode];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addSubViews {
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg"]];
    [self.view addSubview:bgImageView];
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    UIImageView *imgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img"]];
    [self.view addSubview:imgImageView];
    
    [imgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
        make.centerX.mas_equalTo(self.view);
    }];
    
    UIView *cotentView = [[UIView alloc] init];
    cotentView.backgroundColor = [UIColor whiteColor];
    [cotentView wl_setCornerRadius:15.f];
    [cotentView wl_setBorderWidth:1.f color:UIColorMake(254,72,30)];
    [self.view addSubview:cotentView];
    [cotentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(285.f);
        make.top.mas_equalTo(self.view).mas_offset([self qmui_navigationBarMaxYInViewCoordinator] + 97.f);
        make.centerX.mas_equalTo(self.view);
    }];
    
    UIView *shadowView = [[UIView alloc] init];
    shadowView.layer.shadowColor = UIColorMake(254,72,30).CGColor;
    shadowView.layer.shadowOffset = CGSizeMake(0, 0);
    shadowView.layer.shadowRadius = 10.f;
    shadowView.layer.shadowOpacity = .5f;
    shadowView.layer.shouldRasterize = YES;
    shadowView.clipsToBounds = NO;
    shadowView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    [self.view addSubview:shadowView];
    //    [shadowView wl_setDebug:YES];
    [shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(103.f);
        make.centerX.mas_equalTo(self.view);
        make.centerY.mas_equalTo(cotentView.mas_top);
    }];
    
    UIImageView *logoImageView = [[UIImageView alloc] init];
    if (_posterModel.app_logo.length > 0) {
        logoImageView.backgroundColor = [UIColor clearColor];
    } else {
        logoImageView.backgroundColor = UIColorMake(254,72,30);
    }
    logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    [shadowView addSubview:logoImageView];
    self.logoImageView = logoImageView;
    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(3.f, 3.f, 3.f, 3.f));
    }];
    
    QMUILabel *logoLabel = [[QMUILabel alloc] init];
    logoLabel.text = @"LOGO";
    logoLabel.font = UIFontMake(14);
    logoLabel.backgroundColor = [UIColor clearColor];//UIColorMake(254,72,30);
    logoLabel.textColor = [UIColor whiteColor];
    logoLabel.textAlignment = NSTextAlignmentCenter;
    [logoLabel wl_setBorderWidth:3.f color:[UIColor whiteColor]];
    [logoLabel wl_setCornerRadius:15.f];
    [shadowView addSubview:logoLabel];
//    [logoLabel wl_setDebug:YES];
    [logoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(3.f, 3.f, 3.f, 3.f));
//        make.width.height.mas_equalTo(100.f);
//        make.centerX.mas_equalTo(self.view);
//        make.centerY.mas_equalTo(cotentView.mas_top);
    }];
    
    WEAKSELF
    [logoImageView setImageWithURL:[NSURL URLWithString:_posterModel.app_logo]
                       placeholder:nil
                           options:YYWebImageOptionProgressive | YYWebImageOptionProgressiveBlur | YYWebImageOptionAvoidSetImage
                        completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                            if (image) {
                                weakSelf.logoImageView.image = image;
                            }else {
                                weakSelf.logoImageView.image = nil;
                            }
                        }];
    
    QMUILabel *titleLabel = [[QMUILabel alloc] init];
    titleLabel.text = _posterModel.app_name;//@"扫雷游戏APP";
    titleLabel.font = UIFontMake(18);
    titleLabel.textColor = WLColoerRGB(51.f);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    [titleLabel sizeToFit];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(logoLabel.mas_bottom).offset(10.f);
    }];
    
    UIView *codeBgView = [[UIView alloc] init];
    [self.view addSubview:codeBgView];
    [codeBgView wl_setCornerRadius:8.f];
    [codeBgView wl_setBorderWidth:1.f color:WLColoerRGB(153.f)];
    [codeBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(144.f);
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(cotentView.mas_bottom).offset(-37.f);
    }];
    
    UIImageView *codeImageView = [[UIImageView alloc] initWithImage:[UIImage wl_createQRImageFormString:configTool.userInfoModel.invite_code ? : @"" sizeSquareWidth:132.f]];
    codeImageView.contentMode = UIViewContentModeScaleAspectFit;
    [codeBgView addSubview:codeImageView];
    self.codeImageView = codeImageView;
    [codeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(3.f, 3.f, 3.f, 3.f));
    }];
    
    [codeImageView setImageWithURL:[NSURL URLWithString:_posterModel.app_qrcode]
                       placeholder:[UIImage wl_createQRImageFormString:configTool.userInfoModel.invite_code ? : @"" sizeSquareWidth:132.f]
                           options:YYWebImageOptionProgressive | YYWebImageOptionProgressiveBlur | YYWebImageOptionAvoidSetImage
                        completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                            if (image) {
                                weakSelf.codeImageView.image = image;
                            }else {
                                weakSelf.codeImageView.image = [UIImage wl_createQRImageFormString:configTool.userInfoModel.invite_code ? : @"" sizeSquareWidth:132.f];
                            }
                        }];
    
    QMUILabel *noteLabel = [[QMUILabel alloc] init];
    noteLabel.text = @"扫码关注我们";
    noteLabel.font = UIFontMake(14);
    noteLabel.textColor = WLColoerRGB(51.f);
    noteLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:noteLabel];
    [noteLabel sizeToFit];
    [noteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(codeBgView.mas_bottom).offset(5.f);
    }];
}

- (void)getUserVcode {
    [WLHUDView showHUDWithStr:@"" dim:YES];
    WEAKSELF
    [UserModelClient getPosterWithParams:nil Success:^(id resultInfo) {
        [WLHUDView hiddenHud];
        weakSelf.posterModel = [IPosterModel modelWithDictionary:resultInfo];
        [weakSelf updateUi];
    } Failed:^(NSError *error) {
        [WLHUDView hiddenHud];
    }];
}

- (void)updateUi {
    _titleLabel.text = _posterModel.app_name;
    [_logoImageView setImageWithURL:[NSURL URLWithString:_posterModel.app_logo] options:YYWebImageOptionProgressive | YYWebImageOptionProgressiveBlur | YYWebImageOptionAvoidSetImage];
    [_codeImageView setImageWithURL:[NSURL URLWithString:_posterModel.app_qrcode] options:YYWebImageOptionProgressive | YYWebImageOptionProgressiveBlur | YYWebImageOptionAvoidSetImage];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

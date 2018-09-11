//
//  WLHubProgressView.m
//  Welian
//
//  Created by weLian on 16/1/24.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import "WLHubProgressView.h"

#define kMarginLeft 35.f
#define kContenHeight 75.f// + 50.f)

@interface WLHubProgressView ()

@property (nonatomic, assign) UILabel *titleLabel;
@property (nonatomic, assign) UILabel *detailLabel;
@property (nonatomic, assign) UIProgressView *progressView;

@end

@implementation WLHubProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

#pragma mark - Private
- (void)setup
{
    self.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.5];
    
    UIView *contenView = [[UIView alloc] initWithFrame:CGRectMake(kMarginLeft, (self.height - kContenHeight) / 2.f - ViewCtrlTopBarHeight , self.width - kMarginLeft * 2.f, kContenHeight)];
    contenView.backgroundColor = [UIColor whiteColor];
    contenView.layer.cornerRadius = kWL_NormalMarginWidth_15;
    contenView.layer.masksToBounds = YES;
    [self addSubview:contenView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kWL_NormalMarginWidth_15, kWL_NormalMarginWidth_15, contenView.width - kWL_NormalMarginWidth_15 * 2.f, 20.f)];
    titleLabel.textColor = kWLNormalTextColor_153;
    titleLabel.font = kNormal14Font;
    titleLabel.text = @"0%";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [contenView addSubview:titleLabel];
    self.titleLabel = titleLabel;
//    [titleLabel setDebug:YES];
    
    UIProgressView *progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    progressView.frame = CGRectMake(kWL_NormalMarginWidth_15, titleLabel.bottom + 5.f, titleLabel.width, 5.f);
    progressView.progress = .0f;
    progressView.progressTintColor = [UIColor wl_hex0F6EF4];
    [contenView addSubview:progressView];
    self.progressView = progressView;
    
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(kWL_NormalMarginWidth_15, progressView.bottom + 5.f, contenView.width - kWL_NormalMarginWidth_15 * 2.f, 20.f)];
    detailLabel.textColor = kWLNormalTextColor_153;
    detailLabel.font = kNormal14Font;
    detailLabel.text = @"上传中，请稍后...";
    detailLabel.textAlignment = NSTextAlignmentCenter;
    [contenView addSubview:detailLabel];
    self.detailLabel = detailLabel;

//    UIButton *cancelBtn = [UIButton getBtnWithTitle:@"取消上传" image:nil];
//    cancelBtn.frame = CGRectMake(kMarginLeft, detailLabel.bottom + 10.f, detailLabel.width / 2.f - 10, 40.f);
//    [cancelBtn addTarget:self action:@selector(cancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [contenView addSubview:cancelBtn];
//    
//    UIButton *resumBtn = [UIButton getBtnWithTitle:@"继续上传" image:nil];
//    resumBtn.frame = CGRectMake(cancelBtn.right + 10.f, detailLabel.bottom + 10.f, cancelBtn.width, 40.f);
//    [resumBtn addTarget:self action:@selector(resumBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [contenView addSubview:resumBtn];
}

//- (void)cancelBtnClicked:(UIButton *)sender
//{
//    if (_cancelBlock) {
//        _cancelBlock();
//    }
//}
//
//- (void)resumBtnClicked:(UIButton *)sender
//{
//    if (_resumBlock) {
//        _resumBlock();
//    }
//}

/**
 *  初始化数据信息
 */
- (void)initUIDataShowWithDetailInfo:(NSString *)detailInfo
{
    _titleLabel.text = @"0%";
    _detailLabel.text = detailInfo;
    _progressView.progress = 0.f;
}

/**
 *  上传完成
 */
- (void)updateSueccess
{
    _titleLabel.text = @"100%";
    _detailLabel.text = @"上传完成";
    _progressView.progress = 1.f;
}

/**
 *  更新上传进度信息
 *
 *  @param progress 进度
 */
- (void)updateProgress:(CGFloat)progress
{
    _progressView.progress = progress;
    _titleLabel.text = [NSString stringWithFormat:@"%.0f%%",progress * 100];
}



@end

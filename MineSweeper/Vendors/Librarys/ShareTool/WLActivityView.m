//
//  WLActivityView.m
//  Welian
//
//  Created by dong on 15/3/4.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "WLActivityView.h"
#import "WLShareSheetCell.h"

@interface WLActivityView ()<UITableViewDelegate,UITableViewDataSource, UIGestureRecognizerDelegate>


@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIView *topBackground;
@property (nonatomic, strong) UIView *bottomBackground;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *tableHead;
@property (nonatomic, strong) UILabel *headTitle;

@end

@implementation WLActivityView

#pragma mark - Public method
- (id)initWithOneSectionArray:(NSArray *)oneArray andTwoArray:(NSArray *)twoArray {
    return [self initWithTitle:nil oneSectionArray:oneArray andTwoArray:twoArray];
}

- (id)initWithTitle:(NSAttributedString *)title oneSectionArray:(NSArray *)oneArray andTwoArray:(NSArray *)twoArray {
    self = [super init];
    if (self) {
        self.dataArray = [NSMutableArray arrayWithCapacity:2];
        if (oneArray.count) [self.dataArray addObject:oneArray];
        if (twoArray.count) [self.dataArray addObject:twoArray];
        //初始化背景视图，添加手势
        self.frame = CGRectMake(0, 0, SuperSize.width, SuperSize.height);
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
        self.topBackground = [[UIView alloc] initWithFrame:self.bounds];
        self.topBackground.backgroundColor = [UIColor clearColor];
        [self addSubview:self.topBackground];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel)];
        [tapGesture setDelegate:self];
        [self.topBackground addGestureRecognizer:tapGesture];
        
        CGFloat LXActivityHeight = (self.dataArray.count * ZY_ItemCellHeight) + self.tableView.tableFooterView.height;
        if (title) {
            CGFloat titleH = wl_textH(title.string, 16.f, ScreenWidth-2*16.f);
            self.headTitle.attributedText = title;
            UIView *headView = [[UIView alloc] init];
            [headView addSubview:self.headTitle];
            self.headTitle.frame = CGRectMake(16.f, 24.f, ScreenWidth-2*16.f, titleH);
            headView.height = 24.f+self.headTitle.height+10.f;
            self.tableView.tableHeaderView = headView;
            LXActivityHeight += headView.height;
        }
        
        self.bottomBackground = [[UIView alloc] initWithFrame:CGRectMake(0, SuperSize.height, SuperSize.width, LXActivityHeight)];
        self.bottomBackground.backgroundColor = [UIColor colorWithWhite:.3 alpha:0.2];
        [self addSubview:self.bottomBackground];
        [self addSubview:self.tableView];
        
        [UIView animateWithDuration:ANIMATE_DURATION animations:^{
            self.topBackground.backgroundColor = WINDOW_COLOR;
            [self.tableView setFrame:CGRectMake(0, SuperSize.height-LXActivityHeight, SuperSize.width, LXActivityHeight)];
            self.topBackground.bottom = self.tableView.top;
            self.bottomBackground.top = self.tableView.top;
        } completion:^(BOOL finished) {
        }];
    }
    return self;
}

- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tappedCancel) name:KWL_ZY_HideNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didClickOnImageIndex:(UIButton *)button {
    [self tappedCancel];
}

- (void)tappedCancel {
    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
        [self.tableView setFrame:CGRectMake(0, SuperSize.height, SuperSize.width, 0)];
        self.topBackground.backgroundColor = [UIColor clearColor];
        self.topBackground.bottom = self.tableView.top;
        self.bottomBackground.top = self.tableView.top;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ZY_ItemCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WLShareSheetCell *cell = [WLShareSheetCell cellWithTableView:tableView];
    cell.itemArray = self.dataArray[indexPath.row];
    return cell;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([[NSString stringWithFormat:@"%@",[touch.view class]] isEqualToString:@"UIScrollView"]) {
        return NO;
    }
    return YES;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SuperSize.height, SuperSize.width, 0) style:UITableViewStylePlain];
        _tableView.scrollEnabled = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        UIVibrancyEffect *vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:blurEffect];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        _tableView.backgroundView = effectView;
        _tableView.separatorEffect = vibrancyEffect;
        
        UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, ZY_CancelButtonHeight)];
        [cancelButton setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [cancelButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:0.8 alpha:0.5]] forState:UIControlStateHighlighted];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:WLRGB(116, 116, 116) forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(tappedCancel) forControlEvents:UIControlEventTouchUpInside];
        if (iPhoneX) {
            cancelButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, kWL_safeAreaHeight, 0);
            cancelButton.height += kWL_safeAreaHeight;
        }
        _tableView.tableFooterView = cancelButton;
    }
    return _tableView;
}

- (UILabel *)headTitle {
    if (!_headTitle) {
        _headTitle = [[UILabel alloc] init];
        _headTitle.textColor = UIColor.wl_Hex333333;
        _headTitle.font = WLFONT(16);
        _headTitle.textAlignment = NSTextAlignmentCenter;
        _headTitle.width = ScreenWidth-2*16.f;
    }
    return _headTitle;
}


@end

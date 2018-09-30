//
//  HomeViewController.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/11.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "HomeViewController.h"
#import "MessageNotifiListViewController.h"
#import "GameDetailListViewController.h"

//#import "DCCycleScrollView.h"
#import "RETableViewManager.h"
#import "QMUIMarqueeLabel.h"
#import "UILabel+QMUI.h"
#import "HomeTableViewCell.h"

#import "BannerImgModel.h"
#import "ImGroupModelClient.h"
#import "UserModelClient.h"
#import "INoticeModel.h"

#import "WLRongCloudDataSource.h"

#import <FSPagerView/FSPagerView-Swift.h>

#define kNoteHeight 30.f
#define kBannerHeight 186.f

@interface HomeViewController ()<FSPagerViewDataSource, FSPagerViewDelegate>

@property (nonatomic, strong) RETableViewManager *manager;
@property (nonatomic, strong) UIView *headerView;
//@property (nonatomic, strong) DCCycleScrollView *banner;
@property (nonatomic, strong) QMUIMarqueeLabel *noteLabel;
@property (nonatomic, strong) NSArray *noticeArray;

@property (nonatomic, strong) NSArray *bannerImageArray;
@property (nonatomic, strong) FSPagerView *pagerView;
@property (nonatomic, strong) FSPageControl *pageControl;

@end

@implementation HomeViewController

- (NSString *)title {
    return @"群组";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:WLColoerRGB(255.f)] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:WLColoerRGB(248.f)]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (void)initSubviews {
    [super initSubviews];
    
    [self addViews];
    
    [kNSNotification addObserver:self selector:@selector(reloadData) name:@"kLoginUserTokenRefresh" object:nil];
    [self reloadData];
}

- (void)reloadData {
    [self loadBannerData];
    [self loadNotice];
    
    [self getLoginUserInfo];
}

- (void)getLoginUserInfo {
    [UserModelClient getUserInfoWithParams:nil
                                   Success:^(id resultInfo) {
                                       IUserInfoModel *userInfoModel = [IUserInfoModel modelWithDictionary:resultInfo];
                                       configTool.userInfoModel = userInfoModel;
                                       [RCDDataSource refreshLogUserInfoCache:userInfoModel];
                                   } Failed:^(NSError *error) {
                                   }];
}

// 加载轮播图
- (void)loadBannerData {
    WEAKSELF
    [ImGroupModelClient getImBannerWithParams:nil Success:^(id resultInfo) {
        //        weakSelf.datasource = [NSArray modelArrayWithClass:[BannerImgModel class] json:resultInfo];
//        weakSelf.banner.imageDataArray = [NSArray modelArrayWithClass:[BannerImgModel class] json:resultInfo];
        weakSelf.bannerImageArray = [NSArray modelArrayWithClass:[BannerImgModel class] json:resultInfo];
        [weakSelf loadBanerUi];
    } Failed:^(NSError *error) {
        
    }];
}

- (void)loadBanerUi {
    _pageControl.numberOfPages = _bannerImageArray.count;
    [_pagerView reloadData];
}

// 加载系统公告
- (void)loadNotice {
    WEAKSELF
    [ImGroupModelClient getImSystemNoticeWithParams:nil Success:^(id resultInfo) {
        weakSelf.noticeArray = [NSArray modelArrayWithClass:[INoticeModel class] json:resultInfo];
        [weakSelf updateNoticeUI];
    } Failed:^(NSError *error) {
    }];
}

- (void)updateNoticeUI {
    if (_noticeArray.count > 0) {
        INoticeModel *model = _noticeArray[0];
        _noteLabel.text = [NSString stringWithFormat:@"%@                 ",model.title];
    }
}

- (void)addViews {
    UIBarButtonItem *leftBtnItem = [UIBarButtonItem qmui_itemWithButton:[[QMUINavigationButton alloc] initWithImage:[[UIImage imageNamed:@"home_notice_btn"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]] target:self action:@selector(leftBtnItemClicked)];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    
//    NSArray *imageArr = @[@"h1.jpg",
//                          @"h2.jpg",
//                          @"h3.jpg",
//                          @"h4.jpg",
//                          ];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, ScreenWidth, kNoteHeight + kBannerHeight)];
    headerView.backgroundColor = [UIColor whiteColor];
    self.headerView = headerView;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_scrollNotice_icon"]];
    [headerView addSubview:imageView];
    [imageView sizeToFit];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kWL_NormalMarginWidth_11);
        make.top.mas_equalTo(kWL_NormalMarginWidth_10);
    }];
    
    QMUIMarqueeLabel *noteLabel = [self generateLabelWithText:@"公告!"];
    noteLabel.shouldFadeAtEdge = NO;// 关闭渐隐遮罩
    noteLabel.speed = 1.5;// 调节滚动速度
    [headerView addSubview:noteLabel];
    self.noteLabel = noteLabel;
    [noteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imageView.right + kWL_NormalMarginWidth_11 * 2.f);
        make.centerY.mas_equalTo(imageView);
        make.width.mas_equalTo(headerView.width - imageView.right - kWL_NormalMarginWidth_11 * 3.f);
    }];
    
    // Create a pager view
    FSPagerView *pagerView = [[FSPagerView alloc] initWithFrame:CGRectMake(0, 30, DEVICE_WIDTH, kBannerHeight - 36.f)];
    pagerView.dataSource = self;
    pagerView.delegate = self;
    pagerView.interitemSpacing = 10;//设置图片间隔
    pagerView.automaticSlidingInterval = 10;//设置自动变动的时间
    pagerView.isInfinite = YES; // 设置无限循环
//    pagerView.decelerationDistance = 2;
//    CGAffineTransform transform = CGAffineTransformMakeScale(0.6, 0.75);
//    pagerView.itemSize = CGSizeApplyAffineTransform(CGSizeMake(ScreenWidth - 60.f, kBannerHeight - 36.f), transform);
//    pagerView.decelerationDistance = FSPagerViewAutomaticDistance;
    pagerView.itemSize = CGSizeMake(ScreenWidth - 60.f, kBannerHeight - 36.f);
    pagerView.transformer = [[FSPagerViewTransformer alloc] initWithType:FSPagerViewTransformerTypeLinear];
    [pagerView registerClass:FSPagerViewCell.class forCellWithReuseIdentifier:@"fspagercell"];
    pagerView.backgroundColor = WLColoerRGB(248.f);
    [headerView addSubview:pagerView];
    self.pagerView = pagerView;
   
    FSPageControl *pageControl = [[FSPageControl alloc] initWithFrame:CGRectMake(0.f, pagerView.bottom, DEVICE_WIDTH, 36.f)];
//    pageControl.numberOfPages = imageArr.count;
    // 边框颜色
    [pageControl setStrokeColor:WLColoerRGB(51.f) forState:UIControlStateNormal];
    [pageControl setStrokeColor:UIColorMake(254,72,30) forState:UIControlStateSelected];
    // 中心点颜色
    [pageControl setFillColor:WLColoerRGB(51.f) forState:UIControlStateNormal];
    [pageControl setFillColor:UIColorMake(254,72,30) forState:UIControlStateSelected];
//    _pageControl.currentPageIndicatorTintColor = UIColorMake(254,72,30);
//    _pageControl.pageIndicatorTintColor = WLColoerRGB(51.f)
    pageControl.backgroundColor = WLColoerRGB(248.f);
    [headerView addSubview:pageControl];
    self.pageControl = pageControl;
//    pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
//    headerView.addSubview(page
    // Create a page control
//    let pageControl = FSPageControl(frame: frame2)
//    self.view.addSubview(pageControl)
    
    //下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(beginPullDownRefreshingNew)];
    //上提加载更多
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(beginPullUpRefreshingNew)];
    self.tableView.mj_footer = footer;
    self.tableView.mj_footer.hidden = YES;
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //    self.tableView.allowsSelection = NO;// 去除默认选中效果
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//去除默认分割线
    self.tableView.tableHeaderView = headerView;
}

#pragma mark - FSPagerView Datasource & Delegate
- (NSInteger)numberOfItemsInPagerView:(FSPagerView *)pagerView {
    return _bannerImageArray.count;
}

- (FSPagerViewCell *)pagerView:(FSPagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    FSPagerViewCell * cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"fspagercell" atIndex:index];
    BannerImgModel *model = _bannerImageArray[index];
    cell.contentView.layer.shadowColor = [UIColor whiteColor].CGColor;
    NSURL *imageUrl = model.save_path.length > 0 ? [NSURL URLWithString:model.save_path] : [NSURL URLWithString:@"http://pic.nipic.com/2008-05-06/200856201542395_2.jpg"];
    [cell.imageView setImageWithURL:imageUrl//[NSURL URLWithString:model.save_path]
                        placeholder:nil//[UIImage imageNamed:@"game_friend_icon"]
                            options:YYWebImageOptionProgressive | YYWebImageOptionProgressiveBlur | YYWebImageOptionAvoidSetImage
                         completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                             cell.imageView.image = image;// [image qmui_imageWithClippedCornerRadius:10.f];
                         }];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
//    cell.imageView.clipsToBounds = YES;
    [cell.imageView wl_setCornerRadius:15.f];
    return cell;
}

- (void)pagerViewDidScroll:(FSPagerView *)pagerView {
    _pageControl.currentPage = pagerView.currentIndex;
}

- (void)pagerView:(FSPagerView *)pagerView didSelectItemAtIndex:(NSInteger)index {
    [pagerView deselectItemAtIndex:index animated:YES];
//    [pagerView scrollToItemAtIndex:index animated:YES];
}

- (void)pagerViewWillEndDragging:(FSPagerView *)pagerView targetIndex:(NSInteger)targetIndex {
    _pageControl.currentPage = index;
}


#pragma mark - UITableView Datasource & Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"home_cell"];
    if (!cell) {
        cell = [[HomeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"home_cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DLog(@"didSelectRowAtIndexPath------");
    GameDetailListViewController *gameListVc = [[GameDetailListViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:gameListVc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return kNoteHeight + kBannerHeight;
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 153.f;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private
- (QMUIMarqueeLabel *)generateLabelWithText:(NSString *)text {
    QMUIMarqueeLabel *label = [[QMUIMarqueeLabel alloc] qmui_initWithFont:UIFontMake(14) textColor:UIColorMake(254.f, 72.f, 30.f)];
    label.textAlignment = NSTextAlignmentCenter;// 跑马灯文字一般都是居中显示，所以 Demo 里默认使用 center
    [label qmui_calculateHeightAfterSetAppearance];
    label.text = text;
    return label;
}

- (void)leftBtnItemClicked{
    // 有使用配置表的时候，最简单的代码就只是控制显隐即可，没使用配置表的话，还需要设置其他的属性才能使红点样式正确，具体请看 UIBarButton+QMUIBadge.h 注释
    self.navigationItem.leftBarButtonItem.qmui_shouldShowUpdatesIndicator = NO;
    
    MessageNotifiListViewController *messageNotifiVc = [[MessageNotifiListViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:messageNotifiVc animated:YES];
}

- (void)beginPullDownRefreshingNew {
    [self reloadData];
     [self.tableView.mj_header endRefreshing];
     [self.tableView.mj_footer endRefreshing];
}

- (void)beginPullUpRefreshingNew {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

@end

//
//  HomeViewController.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/11.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "HomeViewController.h"
#import "DCCycleScrollView.h"
#import "RETableViewManager.h"
#import "QMUIMarqueeLabel.h"
#import "UILabel+QMUI.h"
#import "HomeTableViewCell.h"

#define kNoteHeight 30.f
#define kBannerHeight 186.f

@interface HomeViewController ()<DCCycleScrollViewDelegate>

@property (nonatomic, strong) RETableViewManager *manager;
@property (nonatomic, strong) UIView *headerView;

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
    
    NSArray *imageArr = @[@"h1.jpg",
                          @"h2.jpg",
                          @"h3.jpg",
                          @"h4.jpg",
                          ];
    
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
    
    QMUIMarqueeLabel *noteLabel = [self generateLabelWithText:@"通过 shouldFadeAtEdge = NO 可隐藏文字滚动时边缘的渐隐遮罩，通过 speed 属性可以调节滚动的速度"];
    noteLabel.shouldFadeAtEdge = NO;// 关闭渐隐遮罩
    noteLabel.speed = 1.5;// 调节滚动速度
    [headerView addSubview:noteLabel];
    [noteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imageView.right + kWL_NormalMarginWidth_11 * 2.f);
        make.centerY.mas_equalTo(imageView);
        make.width.mas_equalTo(headerView.width - imageView.right - kWL_NormalMarginWidth_11 * 3.f);
    }];
    
    DCCycleScrollView *banner = [DCCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 30, ScreenWidth, kBannerHeight) shouldInfiniteLoop:YES imageGroups:imageArr];
    //    banner.placeholderImage = [UIImage imageNamed:@"placeholderImage"];
    //        banner.cellPlaceholderImage = [UIImage imageNamed:@"placeholderImage"];
    banner.autoScrollTimeInterval = 5.f;
    banner.autoScroll = YES;
    banner.isZoom = YES;
    banner.itemSpace = -30.f;
    banner.imgCornerRadius = 10.f;
    banner.itemWidth = ScreenWidth - kWL_NormalMarginWidth_23 * 2.f;
    banner.delegate = self;
//    banner.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    banner.backgroundColor = WLColoerRGB(248.f);
    [headerView addSubview:banner];
    //    [banner wl_setDebug:YES];
    
    //下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(beginPullDownRefreshingNew)];
    //上提加载更多
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(beginPullUpRefreshingNew)];
    self.tableView.mj_footer = footer;
    self.tableView.mj_footer.hidden = YES;
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.allowsSelection = NO;// 去除默认选中效果
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//去除默认分割线
//    [self.tableView setSectionIndexColor:[UIColor wl_hex0F6EF4]];
//    [self.tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
    self.tableView.tableHeaderView = headerView;
    
//    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView];
//    _manager.tableView.backgroundColor = [UIColor whiteColor];
//    RETableViewSection *section = [RETableViewSection section];
//    section.headerHeight = kNoteHeight + kBannerHeight;
//    section.headerView = headerView;
//
//    RETableViewItem *commendItem = [RETableViewItem itemWithTitle:@"我的推荐" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
//
//    }];
//    [section addItem:commendItem];
//    RETableViewItem *promotionPosterItem = [RETableViewItem itemWithTitle:@"推广海报" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
//
//    }];
//    [section addItem:promotionPosterItem];
//    RETableViewItem *lotteryItem = [RETableViewItem itemWithTitle:@"抽奖" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
//
//    }];
//    [section addItem:lotteryItem];
//    RETableViewItem *customerServiceItem = [RETableViewItem itemWithTitle:@"客服" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
//    }];
//    [section addItem:customerServiceItem];
    
    
//    RETableViewCell *cell = [RETableViewCell heightWithItem:<#(RETableViewItem *)#> tableViewManager:<#(RETableViewManager *)#>]
    
//    [self.manager addSection:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"home_cell"];
    if (!cell) {
        cell = [[HomeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"home_cell"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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

- (QMUIMarqueeLabel *)generateLabelWithText:(NSString *)text {
    QMUIMarqueeLabel *label = [[QMUIMarqueeLabel alloc] qmui_initWithFont:UIFontMake(14) textColor:UIColorMake(254.f, 72.f, 30.f)];
    label.textAlignment = NSTextAlignmentCenter;// 跑马灯文字一般都是居中显示，所以 Demo 里默认使用 center
    [label qmui_calculateHeightAfterSetAppearance];
    label.text = text;
    return label;
}

//点击图片的代理
-(void)cycleScrollView:(DCCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    DLog(@"index = %ld",(long)index);
}

- (void)beginPullDownRefreshingNew {
     [self.tableView.mj_header endRefreshing];
     [self.tableView.mj_footer endRefreshing];
}

- (void)beginPullUpRefreshingNew {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

@end

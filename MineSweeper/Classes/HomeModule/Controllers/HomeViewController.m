//
//  HomeViewController.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/11.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "HomeViewController.h"
#import "DCCycleScrollView.h"

@interface HomeViewController ()<DCCycleScrollViewDelegate>

@end

@implementation HomeViewController

- (NSString *)title {
    return @"群组";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:WLColoerRGB(255.f)] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:WLColoerRGB(255.f)]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSArray *imageArr = @[@"h1.jpg",
                          @"h2.jpg",
                          @"h3.jpg",
                          @"h4.jpg",
                          ];
    DCCycleScrollView *banner = [DCCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 100, ScreenWidth, 135) shouldInfiniteLoop:YES imageGroups:imageArr];
    //    banner.placeholderImage = [UIImage imageNamed:@"placeholderImage"];
//        banner.cellPlaceholderImage = [UIImage imageNamed:@"placeholderImage"];
    banner.autoScrollTimeInterval = 5;
    banner.autoScroll = YES;
    banner.isZoom = YES;
    banner.itemSpace = 0;
    banner.imgCornerRadius = 10;
    banner.itemWidth = ScreenWidth - 100.f;
    banner.delegate = self;
    [self.view addSubview:banner];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//点击图片的代理
-(void)cycleScrollView:(DCCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    DLog(@"index = %ld",(long)index);
}

@end

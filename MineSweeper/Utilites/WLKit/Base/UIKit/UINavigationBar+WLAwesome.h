//
//  UINavigationBar+WLAwesome.h
//  Welian
//
//  Created by zp on 16/9/1.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//



@interface UINavigationBar (WLAwesome)

//- (void)setBottomBorderColor:(UIColor *)color height:(CGFloat)height;

- (void)wl_setBackgroundColor:(UIColor *)backgroundColor;
- (void)wl_reset;//重置


// 修改title颜色
- (void)wl_setTitleTextAttributesWithColor:(UIColor *)color;


/*
 navbar 位移效果
 - (void)scrollViewDidScroll:(UIScrollView *)scrollView
 {
 CGFloat offsetY = scrollView.contentOffset.y;
 if (offsetY > 0) {
 if (offsetY >= 44) {
 [self setNavigationBarTransformProgress:1];
 } else {
 [self setNavigationBarTransformProgress:(offsetY / 44)];
 }
 } else {
 [self setNavigationBarTransformProgress:0];
 self.navigationController.navigationBar.backIndicatorImage = [UIImage new];
 }
 }
 
 - (void)setNavigationBarTransformProgress:(CGFloat)progress
 {
 [self.navigationController.navigationBar lt_setTranslationY:(-44 * progress)];
 [self.navigationController.navigationBar lt_setElementsAlpha:(1-progress)];
 }
 
 - (void)viewWillDisappear:(BOOL)animated
 {
 [super viewWillDisappear:animated];
 [self.navigationController.navigationBar lt_reset];
 }

 */

/*
 navbar 渐变效果
 - (void)viewDidLoad {
 [super viewDidLoad];
 [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
 }
 
 - (void)scrollViewDidScroll:(UIScrollView *)scrollView
 {
 UIColor * color = [UIColor colorWithRed:0/255.0 green:175/255.0 blue:240/255.0 alpha:1];
 CGFloat offsetY = scrollView.contentOffset.y;
 if (offsetY > NAVBAR_CHANGE_POINT) {
 CGFloat alpha = MIN(1, 1 - ((NAVBAR_CHANGE_POINT + 64 - offsetY) / 64));
 [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
 } else {
 [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
 }
 }
 
 - (void)viewWillAppear:(BOOL)animated
 {
 [super viewWillAppear:YES];
 self.tableView.delegate = self;
 [self scrollViewDidScroll:self.tableView];
 [self.navigationController.navigationBar setShadowImage:[UIImage new]];
 }
 
 - (void)viewWillDisappear:(BOOL)animated
 {
 [super viewWillDisappear:animated];
 self.tableView.delegate = nil;
 [self.navigationController.navigationBar lt_reset];
 }

 */

@end

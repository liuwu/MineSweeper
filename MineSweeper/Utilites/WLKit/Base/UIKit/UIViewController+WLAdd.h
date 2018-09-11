//
//  UIViewController+WLAdd.h
//  Welian
//
//  Created by liuwu on 2016/11/21.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (WLAdd)

/// 统计 开始时间戳 （毫秒）
@property (nonatomic, strong) NSDate *wl_beginTime;

/// 统计 结束时间戳 （毫秒）
@property (nonatomic, strong) NSDate *wl_endTime;

// 获取当前处于activity状态的view controller
+ (UIViewController *)currentRootViewController;

//获取当前处于activity状态的view controller
+ (UIViewController *)getCurrentViewCtrl;

- (void)showViewControl:(UIViewController *)viewControl sender:(id)sender;
//leftItemt
- (UIBarButtonItem *)wl_setLeftItemWithTitle: (NSString *)title image: (UIImage *)image target:(id)target action:(SEL)action;
- (UIButton *)wl_setNavLeftButtonWithTitle:(NSString *)title image:(UIImage *)image target:(id)target action:(SEL)action;
//rightItemt
- (UIBarButtonItem *)wl_setRightItemWithTitle: (NSString *)title image: (UIImage *)image target:(id)target action:(SEL)action;
- (UIButton *)wl_setNavRightButtonWithTitle:(NSString *)title image:(UIImage *)image target:(id)target action:(SEL)action;

- (void)wl_dismissToRootViewControllerAnimated:(BOOL)animated completion:(void(^)(void))completion;

- (UIViewController *)wl_rootPresentingViewController;

@end

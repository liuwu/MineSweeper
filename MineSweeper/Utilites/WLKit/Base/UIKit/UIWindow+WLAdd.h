//
//  UIWindow+WLAdd.h
//  Welian
//
//  Created by weLian on 16/8/3.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 NS_ASSUME_NONNULL_BEGIN  NS_ASSUME_NONNULL_END
 在这两个宏之间的代码，所有简单指针对象都被假定为nonnull，因此我们只需要去指定那些nullable的指针。
 */
NS_ASSUME_NONNULL_BEGIN

/*
 UIWindow的扩展类
 */
@interface UIWindow (WLAdd)

/**
 *  @author liuwu     , 16-08-03
 *
 *  获取当前的UIWindow
 *  @return 屏幕当前的UIWindow
 */
+ (nullable UIWindow *)wl_currentWindow;

/**
 *  @author liuwu     , 16-08-03
 *
 *  返回当前Window最上层的UIViewController，可能是UINavigationController的VC组
 *  @return 当前最上层的UIViewController
 */
- (UIViewController *)wl_topMostController;

/**
 *  @author liuwu     , 16-08-03
 *
 *  获取在topMostController最上层的UIViewController，即：当前显示的UIViewController
 *  @return UIViewController
 */
- (UIViewController*)wl_currentViewController;

@end

NS_ASSUME_NONNULL_END

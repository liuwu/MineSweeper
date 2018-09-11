//
//  UIWindow+WLAdd.m
//  Welian
//
//  Created by weLian on 16/8/3.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import "UIWindow+WLAdd.h"

@implementation UIWindow (WLAdd)

/**
 *  @author liuwu     , 16-08-03
 *
 *  获取当前的UIWindow
 *  @return UIWindow
 */
+ (nullable UIWindow *)wl_currentWindow {
    UIApplication *application = [UIApplication wl_sharedExtensionApplication];
    if (application) {
        return application.keyWindow;
    }
    return nil;
}


/**
 *  @author liuwu     , 16-08-03
 *
 *  返回当前Window最上层的UIViewController，可能是UINavigationController的VC组
 *  @return 当前最上层的UIViewController
 */
- (UIViewController *)wl_topMostController {
    UIViewController *topController = [self rootViewController];
    
    //  Getting topMost ViewController
    while ([topController presentedViewController])	topController = [topController presentedViewController];
    
    //  Returning topMost ViewController
    return topController;
}


/**
 *  @author liuwu     , 16-08-03
 *
 *  获取在topMostController最上层的UIViewController，即：当前显示的UIViewController
 *  @return UIViewController
 */
- (UIViewController*)wl_currentViewController {
    UIViewController *currentViewController = [self wl_topMostController];
    
    while ([currentViewController isKindOfClass:[UINavigationController class]] && [(UINavigationController*)currentViewController topViewController])
        currentViewController = [(UINavigationController*)currentViewController topViewController];
    
    return currentViewController;
}

@end

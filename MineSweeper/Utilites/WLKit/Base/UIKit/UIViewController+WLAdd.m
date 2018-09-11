//
//  UIViewController+WLAdd.m
//  Welian
//
//  Created by liuwu on 2016/11/21.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import "UIViewController+WLAdd.h"
#import "UIViewController+WLNavigationControl.h"
#import "NavViewController.h"
#import "WLRuntimeClass.h"

@implementation UIViewController (WLAdd)

+ (void)load {
    [super load];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self adean_ViewControllerHook];
    });
}

+ (void)adean_ViewControllerHook {
    WLSwizzlingMethod([UIViewController class], @selector(viewDidAppear:), @selector(adean_viewDidAppear:));
    
    WLSwizzlingMethod([UIViewController class], @selector(viewDidDisappear:), @selector(adean_viewDidDisappear:));
    WLSwizzlingMethod([UIViewController class], @selector(viewDidLoad), @selector(adean_viewDidLoad));
}

- (void)adean_viewDidAppear:(BOOL)animated {
//    self.wl_beginTime = [NSDate date];
    [self adean_viewDidAppear:animated];
}

- (void)adean_viewDidDisappear:(BOOL)animated {
//    self.wl_endTime = [NSDate date];
//    if (self.wl_beginTime) {
//        [[WLUserBehaviorLog sharedWLUserBehaviorLog] pageBrowsesTimeController:self];
//    }
    [self adean_viewDidDisappear:animated];
}

- (void)adean_viewDidLoad {
    if (@available(iOS 11.0, *)) {
        self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
    }else {
        
    }
    [self adean_viewDidLoad];
}


- (NSDate *)wl_beginTime {
    return objc_getAssociatedObject(self, @selector(wl_beginTime));
}
- (void)setWl_beginTime:(NSDate *)wl_beginTime {
    objc_setAssociatedObject(self, @selector(wl_beginTime), wl_beginTime, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSDate *)wl_endTime {
    return objc_getAssociatedObject(self, @selector(wl_endTime));
}
- (void)setWl_endTime:(NSDate *)wl_endTime {
    objc_setAssociatedObject(self, @selector(wl_endTime), wl_endTime, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


// 获取当前处于activity状态的view controller
+ (UIViewController *)currentRootViewController
{
    UIViewController* activityViewController = nil;
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (kIOS7Later) {
        activityViewController = window.rootViewController;
    }else{
        if(window.windowLevel != UIWindowLevelNormal){
            NSArray *windows = [[UIApplication sharedApplication] windows];
            for(UIWindow *tmpWin in windows){
                if(tmpWin.windowLevel == UIWindowLevelNormal){
                    window = tmpWin;
                    break;
                }
            }
        }
        
        NSArray *viewsArray = [window subviews];
        if([viewsArray count] > 0)
        {
            UIView *frontView = [viewsArray objectAtIndex:0];
            id nextResponder = [frontView nextResponder];
            if([nextResponder isKindOfClass:[UIViewController class]]){
                activityViewController = nextResponder;
            }else{
                activityViewController = window.rootViewController;
            }
        }
    }
    return activityViewController;
}

+ (UIViewController *)getCurrentViewCtrl{
    UIViewController *result = nil;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [UIApplication sharedApplication].windows;
        for (UIWindow *tmWin in windows) {
            if (tmWin.windowLevel == UIWindowLevelNormal) {
                window = tmWin;
                break;
            }
        }
    }
    UIView *frontView = [[window subviews] firstObject];
    id nextResponder = [frontView nextResponder];
    id rootVC;
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        rootVC = nextResponder;
    }else{
        rootVC = window.rootViewController;
    }
    result = [self findTopViewController:rootVC];
    return result;
}

+ (id)findTopViewController:(id)inController{
    if ([inController isKindOfClass:[UITabBarController class]]) {
        return [self findTopViewController:[inController selectedViewController]];
    }else if ([inController isKindOfClass:[UINavigationController class]]) {
        return [self findTopViewController:[inController visibleViewController]];
    } else if ([inController isKindOfClass:[UIAlertController class]]) {
        return [inController presentingViewController];
    }
    else if ([inController isKindOfClass:[UIViewController class]]) {
        return inController;
    }else{
        return nil;
    }
}
//leftItem
- (UIBarButtonItem *)wl_setLeftItemWithTitle:(NSString *)title image:(UIImage *)image target:(id)target action:(SEL)action {
    SEL act = action ?: @selector(back);
    if (!image) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:target action:act];
    } else {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[image wl_alwaysOriginal] style:UIBarButtonItemStylePlain target:target action:act];
    }
    return self.navigationItem.leftBarButtonItem;
}
- (UIButton *)wl_setNavLeftButtonWithTitle:(NSString *)title image:(UIImage *)image target:(id)target action:(SEL)action {
    SEL act = action ?: @selector(back);
    UIButton *btn = [self wl_createCustomBtnWithImage:image title:title target:target action:act];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return btn;
}
//rightItem
- (UIBarButtonItem *)wl_setRightItemWithTitle:(NSString *)title image:(UIImage *)image target:(id)target action:(SEL)action {
    SEL act = action ?: @selector(back);
    if (!image) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:target action:act];
    } else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[image wl_alwaysOriginal] style:UIBarButtonItemStylePlain target:target action:act];
    }
    return self.navigationItem.rightBarButtonItem;
}
- (UIButton *)wl_setNavRightButtonWithTitle:(NSString *)title image:(UIImage *)image target:(id)target action:(SEL)action {
    SEL act = action ?: @selector(back);
    UIButton *btn = [self wl_createCustomBtnWithImage:image title:title target:target action:act];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return btn;
}

- (UIButton *)wl_createCustomBtnWithImage: (UIImage *)image title: (NSString *)title target:(nullable id)target action:(nullable SEL)action {
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    if (title && title.length >0) {
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor wl_Hex333333] forState:UIControlStateNormal];
        btn.titleLabel.font = WLFONT(16);
    }
    if (image) {
        [btn setImage:[image wl_alwaysOriginal] forState:UIControlStateNormal];
    }
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)showViewControl:(UIViewController *)viewControl sender:(id)sender{
    if (kIOS8Later) {
        UIViewController *v = viewControl;
        if (self.navigationController == nil) {
            viewControl.firstNavigationLeftItemShow = YES;
            NavViewController *nav = [[NavViewController alloc] initWithRootViewController:viewControl];
            v = nav;
        }
        [self showViewController:v sender:sender];
    } else{
        if (self.navigationController != nil) {
            // ios7 在连续pushViewController 多个viewControl的时候 当前个push动画没结束的时候 会出现NSInvalidArgumentException Can't add self as subview 错误
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController pushViewController:viewControl animated:YES];
            });
        }else{
            NavViewController *nav = [[NavViewController alloc] initWithRootViewController:viewControl];
            nav.firstNavigationLeftItemShow = YES;
            [self presentViewController:nav animated:YES completion:nil];
        }
    }
}

- (void)wl_dismissToRootViewControllerAnimated:(BOOL)animated completion:(void(^)(void))completion {
    UIViewController *vc = [self wl_rootPresentingViewController];
    if (vc != self) {
        [vc dismissViewControllerAnimated:animated completion:completion];
    } else {
        if (completion) {
            completion();
        }
    }
}
- (UIViewController *)wl_rootPresentingViewController {
    UIViewController *vc = self;
    while (vc.presentingViewController) {
        vc = vc.presentingViewController;
    }
    return vc;
}


@end

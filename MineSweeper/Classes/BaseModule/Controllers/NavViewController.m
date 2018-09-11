//
//  NavViewController.m
//  Welian
//
//  Created by dong on 14-9-10.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "NavViewController.h"
#import "UIViewController+WLNavigationControl.h"

@interface NavViewController ()<UIGestureRecognizerDelegate>

@end

@implementation NavViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.interactivePopGestureRecognizer.delegate = self;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
//      UIImage *backImage = [WLDicHQFontImage iconWithName:@"back" fontSize:WLNavImagePtSize color:UIColor.wl_Hex333333];
//    UIViewController *beforeViewController = [self.viewControllers lastObject];
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
//    beforeViewController.navigationItem.backBarButtonItem = backItem;
    //    [self.navigationBar setBackIndicatorImage:backImage];
    //    [self.navigationBar setBackIndicatorTransitionMaskImage:backImage];
    
    if (animated) {
        self.interactivePopGestureRecognizer.enabled = YES;
    }
    if (self.viewControllers.count) {
        [viewController setHidesBottomBarWhenPushed:YES];
        UIImage *backImage = [WLDicHQFontImage iconWithName:@"back" fontSize:WLNavImagePtSize color:UIColor.wl_Hex333333];
        [viewController wl_setLeftItemWithTitle:nil image:backImage target:self action:@selector(animatePopViewController)];
    }
    [super pushViewController:viewController animated:animated];
}

- (void)animatePopViewController {
    [self popViewControllerAnimated:true];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    [WLHUDView hiddenHud];
    return [super popViewControllerAnimated:animated];
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [WLHUDView hiddenHud];
    return [super popToViewController:viewController animated:animated];
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated
{
    [WLHUDView hiddenHud];
    if (animated)
    {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    return [super popToRootViewControllerAnimated:animated];
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ( gestureRecognizer == self.interactivePopGestureRecognizer )
    {
        UIViewController *controller = self.visibleViewController;
        if (controller.isUnallowedPop) {
            return NO;
        }
        if ( self.viewControllers.count < 2 || self.visibleViewController == [self.viewControllers objectAtIndex:0] )
        {
            return NO;
        }
    }
    return YES;
}

@end

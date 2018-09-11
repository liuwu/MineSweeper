//
//  UINavigationBar+WLAwesome.m
//  Welian
//
//  Created by zp on 16/9/1.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import "UINavigationBar+WLAwesome.h"
#import "WLRuntimeClass.h"

#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

@interface UINavigationBar ()

@property (nonatomic, strong) UIView *bottomBorder;

@end

@implementation UINavigationBar (WLAwesome)

static char overlayKey;

- (UIView *)overlay
{
    return objc_getAssociatedObject(self, &overlayKey);
}

- (void)setOverlay:(UIView *)overlay
{
    objc_setAssociatedObject(self, &overlayKey, overlay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)wl_setBackgroundColor:(UIColor *)backgroundColor
{
    if (!self.overlay) {
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        self.overlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) + 20)];
        self.overlay.userInteractionEnabled = NO;
        self.overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth;    // Should not set `UIViewAutoresizingFlexibleHeight`
        [[self.subviews firstObject] insertSubview:self.overlay atIndex:0];
    }
    self.overlay.backgroundColor = backgroundColor;
}
- (void)wl_reset
{
    [self setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.overlay removeFromSuperview];
    self.overlay = nil;
}

- (void)wl_setTitleTextAttributesWithColor:(UIColor *)color {
    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary:[[UINavigationBar appearance] titleTextAttributes]];
    [titleBarAttributes setValue:color forKey:NSForegroundColorAttributeName];
    [titleBarAttributes setValue:WLFONTBLOD(17) forKey:NSFontAttributeName];
    [self setTitleTextAttributes:titleBarAttributes];
}

//+ (void)load {
//    [super load];
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        WLSwizzlingMethod([UINavigationBar class], @selector(setShadowImage:), @selector(adean_setShadowImage:));
//    });
//}
//
//- (UIView *)bottomBorder {
//    return objc_getAssociatedObject(self, _cmd);
//}
//
//- (void)setBottomBorder:(UIView *)bottomBorder {
//    objc_setAssociatedObject(self, @selector(bottomBorder), bottomBorder, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}
//
//- (void)adean_setShadowImage:(UIImage *)shadowImage {
//    self.bottomBorder.hidden = (nil != shadowImage)?YES:NO;
//    [self adean_setShadowImage:shadowImage];
//}
//
//- (void)setBottomBorderColor:(UIColor *)color height:(CGFloat)height {
//    CGRect bottomBorderRect = CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), height);
//    self.bottomBorder = [[UIView alloc] initWithFrame:bottomBorderRect];
//    [self.bottomBorder setBackgroundColor:color];
//    self.bottomBorder.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
//    [self addSubview:self.bottomBorder];
//    self.bottomBorder.hidden = (nil != self.shadowImage)?YES:NO;
//}

@end

//
//  UIControl+WLAdd.m
//  Welian
//
//  Created by dong on 2018/7/19.
//  Copyright © 2018年 chuansongmen. All rights reserved.
//

#import "UIControl+WLAdd.h"
#import "UIView+Gradient.h"
#import "WLRuntimeClass.h"

@implementation UIControl (WLAdd)

ASSOCIATED(highligLayer, setHighligLayer, CALayer *, OBJC_ASSOCIATION_RETAIN_NONATOMIC)

+ (void)load {
    [super load];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self adean_UIControlHook];
    });
}

- (void)setGradientBackgroundWithColors:(NSArray<UIColor *> *)colors gradientType:(WLGradientType)gradientType {
    [super setGradientBackgroundWithColors:colors gradientType:gradientType];
    if (!self.highligLayer) {
        self.highligLayer = [[CALayer alloc] init];
    }
}

- (void)setGradientBackgroundWithColors:(NSArray<UIColor *> *)colors locations:(NSArray<NSNumber *> *)locations startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    [super setGradientBackgroundWithColors:colors locations:locations startPoint:startPoint endPoint:endPoint];
    if (!self.highligLayer) {
        self.highligLayer = [[CALayer alloc] init];
    }
}

+ (void)adean_UIControlHook {
    WLSwizzlingMethod([UIControl class], @selector(setHighlighted:), @selector(adean_setHighlighted:));
    WLSwizzlingMethod([UIControl class], @selector(setEnabled:), @selector(adean_setEnabled:));
}

- (void)adean_setEnabled:(BOOL)enabled {
    if (self.highligLayer){
        if (enabled) {
            self.alpha = 1.0;
        }else{
            self.alpha = 0.5;
        }
    }
    [self adean_setEnabled:enabled];
}

- (void)adean_setHighlighted:(BOOL)highlighted {
    if (self.highligLayer){
        if (highlighted) {
            self.highligLayer.frame = CGRectMake(0, 0, self.layer.bounds.size.width, self.layer.bounds.size.height);
            self.highligLayer.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2].CGColor;
            [self.layer addSublayer:self.highligLayer];
        }else{
            [self.highligLayer removeFromSuperlayer];
        }
    }
    [self adean_setHighlighted:highlighted];
}

@end

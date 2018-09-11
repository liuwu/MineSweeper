//
//  UIView+Gradient.m
//  AZCategory
//
//  Created by Alfred Zhang on 2017/6/29.
//  Copyright © 2017年 Alfred Zhang. All rights reserved.
//

#import "UIView+Gradient.h"
#import <objc/runtime.h>

@implementation UIView (Gradient)

+ (Class)layerClass {
    return [CAGradientLayer class];
}

+ (UIView *_Nullable)gradientViewWithColors:(NSArray<UIColor *> *_Nullable)colors gradientType:(WLGradientType)gradientType {
    CGPoint startPoint , endPoint;
    switch (gradientType) {
        case WLGradientFromTopToBottom:
            startPoint = CGPointMake(0.5, 0.0);
            endPoint = CGPointMake(0.5, 1.0);
            break;
        case WLGradientFromLeftToRight:
            startPoint = CGPointMake(0.0, 0.5);
            endPoint = CGPointMake(1.0, 0.5);
            break;
        case WLGradientFromLeftTopToRightBottom:
            startPoint = CGPointMake(0.0, 0.0);
            endPoint = CGPointMake(1.0, 1.0);
            break;
        case WLGradientFromLeftBottomToRightTop:
            startPoint = CGPointMake(0.0, 1.0);
            endPoint = CGPointMake(1.0, 0.0);
            break;
        default:
            break;
    }
    return [self gradientViewWithColors:colors locations:@[@(0.f), @(1.f)] startPoint:startPoint endPoint:endPoint];
}

- (void)setGradientBackgroundWithColors:(NSArray<UIColor *> *_Nullable)colors gradientType:(WLGradientType)gradientType{
    CGPoint startPoint , endPoint;
    switch (gradientType) {
        case WLGradientFromTopToBottom:
            startPoint = CGPointMake(0.5, 0.0);
            endPoint = CGPointMake(0.5, 1.0);
            break;
        case WLGradientFromLeftToRight:
            startPoint = CGPointMake(0.0, 0.5);
            endPoint = CGPointMake(1.0, 0.5);
            break;
        case WLGradientFromLeftTopToRightBottom:
            startPoint = CGPointMake(0.0, 0.0);
            endPoint = CGPointMake(1.0, 1.0);
            break;
        case WLGradientFromLeftBottomToRightTop:
            startPoint = CGPointMake(0.0, 1.0);
            endPoint = CGPointMake(1.0, 0.0);
            break;
        default:
            break;
    }
    [self setGradientBackgroundWithColors:colors locations:@[@(0.f), @(1.f)] startPoint:startPoint endPoint:endPoint];
}

+ (UIView *)gradientViewWithColors:(NSArray<UIColor *> *)colors locations:(NSArray<NSNumber *> *)locations startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    UIView *view = [[self alloc] init];
    [view setGradientBackgroundWithColors:colors locations:locations startPoint:startPoint endPoint:endPoint];
    return view;
}

- (void)setGradientBackgroundWithColors:(NSArray<UIColor *> *)colors locations:(NSArray<NSNumber *> *)locations startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    NSMutableArray *colorsM = [NSMutableArray array];
    for (UIColor *color in colors) {
        [colorsM addObject:(__bridge id)color.CGColor];
    }
    self.colors = [colorsM copy];
    self.locations = locations;
    self.startPoint = startPoint;
    self.endPoint = endPoint;
}

#pragma mark- Getter&Setter

- (NSArray *)colors {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setColors:(NSArray *)colors {
    objc_setAssociatedObject(self, @selector(colors), colors, OBJC_ASSOCIATION_COPY_NONATOMIC);
    if ([self.layer isKindOfClass:[CAGradientLayer class]]) {
        [((CAGradientLayer *)self.layer) setColors:self.colors];
    }
}

- (NSArray<NSNumber *> *)locations {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setLocations:(NSArray<NSNumber *> *)locations {
    objc_setAssociatedObject(self, @selector(locations), locations, OBJC_ASSOCIATION_COPY_NONATOMIC);
    if ([self.layer isKindOfClass:[CAGradientLayer class]]) {
        [((CAGradientLayer *)self.layer) setLocations:self.locations];
    }
}

- (CGPoint)startPoint {
    return [objc_getAssociatedObject(self, _cmd) CGPointValue];
}

- (void)setStartPoint:(CGPoint)startPoint {
    objc_setAssociatedObject(self, @selector(startPoint), [NSValue valueWithCGPoint:startPoint], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if ([self.layer isKindOfClass:[CAGradientLayer class]]) {
        [((CAGradientLayer *)self.layer) setStartPoint:self.startPoint];
    }
}

- (CGPoint)endPoint {
    return [objc_getAssociatedObject(self, _cmd) CGPointValue];
}

- (void)setEndPoint:(CGPoint)endPoint {
    objc_setAssociatedObject(self, @selector(endPoint), [NSValue valueWithCGPoint:endPoint], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if ([self.layer isKindOfClass:[CAGradientLayer class]]) {
        [((CAGradientLayer *)self.layer) setEndPoint:self.endPoint];
    }
}


@end



//
//  UIView+WLAdd.m
//  Welian
//
//  Created by weLian on 16/5/18.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import "UIView+WLAdd.h"
#import "WLCGUtilities.h"
#import "WLRuntimeClass.h"

WLSYNTH_DUMMY_CLASS(UIView_WLAdd)

@implementation UIView (WLAdd)

#pragma mark - Normal
///=============================================================================
/// @name 常用的属性
///=============================================================================
- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)width {
    return CGRectGetWidth(self.frame);
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return CGRectGetHeight(self.frame);
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGFloat)centerx {
    return self.width / 2;
}

- (void)setCenterx:(CGFloat)centerx {
    self.centerX  = self.superview.width / 2;
}

- (CGFloat)centery {
    return self.height / 2;
}

- (void)setCentery:(CGFloat)centery {
    self.centerY  = self.superview.height / 2;
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

///返回当前view所在的viewcontroller（可能为nil）
- (UIViewController *)wl_viewController {
    for (UIView *view = self; view; view = view.superview) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

///返回当前view的父viewcontroller（可能为nil）
- (UIViewController *)wl_superViewController {
    for (UIView *view = [self superview]; view; view = view.superview) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

//计算同等比例的宽度  在不同设备上的高度
+ (CGFloat)getHeightWithMaxWidth:(CGFloat)maxWidth In4ScreWidth:(CGFloat)in4ScreWith In4ScreeHeight:(CGFloat)in4ScreeHeight {
    CGFloat thisHeight = in4ScreeHeight;
    CGFloat withCale = maxWidth/in4ScreWith;
    thisHeight = withCale * in4ScreeHeight;
    return thisHeight;
}

/**
 *  @author liuwu     , 16-06-08
 *
 *  设置为调试状态
 *  @param val YES调试状态
 */
- (void)wl_setDebug:(BOOL)val {
    if (val) {
#ifdef DEBUG
        self.layer.borderColor = [[UIColor colorWithRed:(arc4random()%100)/100.0f green:(arc4random()%100)/100.0f blue:(arc4random()%100)/100.0f alpha:1.0f] CGColor];
        self.layer.borderWidth = 1.0f;
#endif
    }
}

/**
 *  @author liuwu     , 16-06-08
 *
 *  找到第一个处于活动中的view
 *  @return 活动中的View,如果找不到返回nil
 */
- (UIView *)wl_findFirstResponder {
    if ([self isFirstResponder]) {
        return self;
    }
    
    NSArray *subviews = [self subviews];
    for (UIView *subview in subviews) {
        UIView *firstResponder = [subview wl_findFirstResponder];
        
        if (firstResponder) {
            return firstResponder;
        }
    }
    return nil;
}

/**
 *  设置图层的圆角
 *
 *  @param cornerRadius 圆角弧度
 */
- (void)wl_setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
    self.clipsToBounds = YES;
}

/*
 *  设置一个圆角
 */
- (void)wl_setRoundedCorners:(UIRectCorner)corners
                      radius:(CGFloat)radius {
    CGRect rect = self.bounds;
    
    // Create the path
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect
                                                   byRoundingCorners:corners
                                                         cornerRadii:CGSizeMake(radius, radius)];
    // Create the shape layer and set its path
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = rect;
    maskLayer.path = maskPath.CGPath;
    
    // Set the newly created shape layer as the mask for the view's layer
    self.layer.mask = maskLayer;
}

/**
 *  设置layer边框
 *
 *  @param width 边框宽度
 *  @param color 边框颜色
 */
- (void)wl_setBorderWidth:(CGFloat)width color:(UIColor *)color {
    self.layer.borderWidth = width;
    self.layer.borderColor = [color CGColor];
}

/**
 设置view.layer的阴影
 
 @param color  阴影颜色
 @param offset 阴影offset
 @param radius 阴影radius
 */
- (void)wl_setLayerShadow:(nullable UIColor*)color
                   offset:(CGSize)offset
                   radius:(CGFloat)radius {
    [self setLayerShadow:color offset:offset radius:radius];
}

/**
 删除所有的子view
 
 @警告 不要在你的view的drawRect:方法中调用这个方法。
 */
- (void)wl_removeAllSubviews {
    [self removeAllSubviews];
}

#pragma mark - SnapShot
///=============================================================================
/// @name 快照、截图
///=============================================================================
/**
 *  整体截图
 *  @return 截取的图片
 */
- (UIImage *)wl_screenshot {
    return [self wl_screenshotWithRect:self.bounds];
}

/**
 *  截取view中的区域
 *
 *  @param rect 区域
 *  @return 截取的图片
 */
- (UIImage *)wl_screenshotWithRect:(CGRect)rect {
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (context == NULL) {
        return nil;
    }
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, -rect.origin.x, -rect.origin.y);
    
    if([self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]){
        [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
    }else{
        [self.layer renderInContext:context];
    }
    CGContextRestoreGState(context);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/**
 创建完整的视图层次的快照图片
 */
- (nullable UIImage *)wl_snapshotImage {
    return [self snapshotImage];
}

/**
 创建完整的视图层次的快照图片
 @讨论 它的速度比 "snapshotImage"快, 但可能会导致屏幕更新.
 查看 -[UIView drawViewHierarchyInRect:afterScreenUpdates:]更多信息.
 */
- (nullable UIImage *)wl_snapshotImageAfterScreenUpdates:(BOOL)afterUpdates {
    return [self snapshotImageAfterScreenUpdates:afterUpdates];
}

/**
 创建一个完整的视图层次的PDF快照。
 */
- (nullable NSData *)wl_snapshotPDF {
    return [self snapshotPDF];
}


- (CGPoint)wl_convertPoint:(CGPoint)point toViewOrWindow:(UIView *)view {
    return [self convertPoint:point toViewOrWindow:view];
}

- (CGPoint)wl_convertPoint:(CGPoint)point fromViewOrWindow:(UIView *)view {
    return [self convertPoint:point fromViewOrWindow:view];
}

- (CGRect)wl_convertRect:(CGRect)rect toViewOrWindow:(UIView *)view {
    return [self convertRect:rect toViewOrWindow:view];
}

- (CGRect)wl_convertRect:(CGRect)rect fromViewOrWindow:(UIView *)view {
    return [self convertRect:rect fromViewOrWindow:view];
}

/// 添加视觉差效果
- (void)addMotionEffectWithMax:(CGFloat)max Min:(CGFloat)min
{
    CGPoint maxMovement = CGPointMake(max, max);
    CGPoint minMovement = CGPointMake(min, min);
    
    UIInterpolatingMotionEffect *leftRightMotion = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    leftRightMotion.maximumRelativeValue = @(maxMovement.x);
    leftRightMotion.minimumRelativeValue = @(minMovement.x);
    
    UIInterpolatingMotionEffect *topDownMotion = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    topDownMotion.maximumRelativeValue = @(maxMovement.y);
    topDownMotion.minimumRelativeValue = @(minMovement.y);
    UIMotionEffectGroup *meGroup = [[UIMotionEffectGroup alloc] init];
    [meGroup setMotionEffects:@[leftRightMotion, topDownMotion]];
    [self addMotionEffect:meGroup];
}

@end


@implementation UIView (QMUI_Border)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        WLSwizzlingMethod([self class], @selector(initWithFrame:), @selector(qmui_initWithFrame:));
        WLSwizzlingMethod([self class], @selector(initWithCoder:), @selector(qmui_initWithCoder:));
        WLSwizzlingMethod([self class], @selector(layoutSublayersOfLayer:), @selector(qmui_layoutSublayersOfLayer:));
    });
}

- (instancetype)qmui_initWithFrame:(CGRect)frame {
    [self qmui_initWithFrame:frame];
    [self setDefaultStyle];
    return self;
}

- (instancetype)qmui_initWithCoder:(NSCoder *)aDecoder {
    [self qmui_initWithCoder:aDecoder];
    [self setDefaultStyle];
    return self;
}

- (void)qmui_layoutSublayersOfLayer:(CALayer *)layer {
    
    [self qmui_layoutSublayersOfLayer:layer];
    
    if ((!self.qmui_borderLayer && self.qmui_borderPosition == QMUIBorderViewPositionNone) || (!self.qmui_borderLayer && self.qmui_borderWidth == 0)) {
        return;
    }
    
    if (self.qmui_borderLayer && self.qmui_borderPosition == QMUIBorderViewPositionNone && !self.qmui_borderLayer.path) {
        return;
    }
    
    if (self.qmui_borderLayer && self.qmui_borderWidth == 0 && self.qmui_borderLayer.lineWidth == 0) {
        return;
    }
    
    if (!self.qmui_borderLayer) {
        self.qmui_borderLayer = [CAShapeLayer layer];
        [self.qmui_borderLayer wl_removePreviousFadeAnimation];
        [self.layer addSublayer:self.qmui_borderLayer];
    }
    self.qmui_borderLayer.frame = self.bounds;
    
    CGFloat borderWidth = self.qmui_borderWidth;
    self.qmui_borderLayer.lineWidth = borderWidth;
    self.qmui_borderLayer.strokeColor = self.qmui_borderColor.CGColor;
    self.qmui_borderLayer.lineDashPhase = self.qmui_dashPhase;
    if (self.qmui_dashPattern) {
        self.qmui_borderLayer.lineDashPattern = self.qmui_dashPattern;
    }
    
    UIBezierPath *path = nil;
    
    if (self.qmui_borderPosition != QMUIBorderViewPositionNone) {
        path = [UIBezierPath bezierPath];
    }
    
    if (self.qmui_borderPosition & QMUIBorderViewPositionTop) {
        [path moveToPoint:CGPointMake(0, borderWidth / 2)];
        [path addLineToPoint:CGPointMake(CGRectGetWidth(self.bounds), borderWidth / 2)];
    }
    
    if (self.qmui_borderPosition & QMUIBorderViewPositionLeft) {
        [path moveToPoint:CGPointMake(borderWidth / 2, 0)];
        [path addLineToPoint:CGPointMake(borderWidth / 2, CGRectGetHeight(self.bounds) - 0)];
    }
    
    if (self.qmui_borderPosition & QMUIBorderViewPositionBottom) {
        [path moveToPoint:CGPointMake(0, CGRectGetHeight(self.bounds) - borderWidth / 2)];
        [path addLineToPoint:CGPointMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - borderWidth / 2)];
    }
    
    if (self.qmui_borderPosition & QMUIBorderViewPositionRight) {
        [path moveToPoint:CGPointMake(CGRectGetWidth(self.bounds) - borderWidth / 2, 0)];
        [path addLineToPoint:CGPointMake(CGRectGetWidth(self.bounds) - borderWidth / 2, CGRectGetHeight(self.bounds))];
    }
    
    self.qmui_borderLayer.path = path.CGPath;
}

- (void)setDefaultStyle {
    self.qmui_borderWidth = WLCGFloatFromPixel(1);
    self.qmui_borderColor = [UIColor wl_HexE5E5E5];
}

static char kAssociatedObjectKey_borderPosition;
- (void)setQmui_borderPosition:(QMUIBorderViewPosition)qmui_borderPosition {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_borderPosition, @(qmui_borderPosition), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setNeedsLayout];
}

- (QMUIBorderViewPosition)qmui_borderPosition {
    return (QMUIBorderViewPosition)[objc_getAssociatedObject(self, &kAssociatedObjectKey_borderPosition) unsignedIntegerValue];
}

static char kAssociatedObjectKey_borderWidth;
- (void)setQmui_borderWidth:(CGFloat)qmui_borderWidth {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_borderWidth, @(qmui_borderWidth), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setNeedsLayout];
}

- (CGFloat)qmui_borderWidth {
    return (CGFloat)[objc_getAssociatedObject(self, &kAssociatedObjectKey_borderWidth) floatValue];
}

static char kAssociatedObjectKey_borderColor;
- (void)setQmui_borderColor:(UIColor *)qmui_borderColor {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_borderColor, qmui_borderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setNeedsLayout];
}

- (UIColor *)qmui_borderColor {
    return (UIColor *)objc_getAssociatedObject(self, &kAssociatedObjectKey_borderColor);
}

static char kAssociatedObjectKey_dashPhase;
- (void)setQmui_dashPhase:(CGFloat)qmui_dashPhase {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_dashPhase, @(qmui_dashPhase), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setNeedsLayout];
}

- (CGFloat)qmui_dashPhase {
    return (CGFloat)[objc_getAssociatedObject(self, &kAssociatedObjectKey_dashPhase) floatValue];
}

static char kAssociatedObjectKey_dashPattern;
- (void)setQmui_dashPattern:(NSArray<NSNumber *> *)qmui_dashPattern {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_dashPattern, qmui_dashPattern, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setNeedsLayout];
}

- (NSArray *)qmui_dashPattern {
    return (NSArray *)objc_getAssociatedObject(self, &kAssociatedObjectKey_dashPattern);
}

static char kAssociatedObjectKey_borderLayer;
- (void)setQmui_borderLayer:(CAShapeLayer *)qmui_borderLayer {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_borderLayer, qmui_borderLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CAShapeLayer *)qmui_borderLayer {
    return (CAShapeLayer *)objc_getAssociatedObject(self, &kAssociatedObjectKey_borderLayer);
}

- (void)setEmptyView:(WLEmptyView *)emptyView {
    objc_setAssociatedObject(self, @selector(emptyView), emptyView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (WLEmptyView *)emptyView {
    return objc_getAssociatedObject(self, _cmd);
}

@end

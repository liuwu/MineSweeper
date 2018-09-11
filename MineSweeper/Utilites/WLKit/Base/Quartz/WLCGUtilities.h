//
//  WLCGUtilities.h
//  Welian_Normal_Demo
//
//  Created by weLian on 16/6/8.
//  Copyright © 2016年 杭州传送门网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#if __has_include(<WLKit/WLKit.h>)
#import <WLKit/WLKitMacro.h>
#else
#import "WLKitMacro.h"
#endif

WL_EXTERN_C_BEGIN
NS_ASSUME_NONNULL_BEGIN

/**
 *  创建一个'ARGB'的bitmap context.如果发生错误，返回NULL.
 *
 *  @讨论 这个方法的功能和UIGraphicsBeginImageContextWithOptions()相同，
        但是它不会发送context给UIGraphic，所以你可以保留再利用的context.
 */
CGContextRef _Nullable WLCGContextCreateARGBBitmapContext(CGSize size, BOOL opaque, CGFloat scale);

///创建一个'DeviceGray'bitmap context。如果发生错误，返回NULL.
CGContextRef _Nullable WLCGContextCreateGrayBitmapContext(CGSize size, CGFloat scale);

/// 获取主屏幕的比例
CGFloat WLScreenScale();

/// 获取主屏幕的大小。高度总是大于宽度。
CGSize WLScreenSize();

/// 度数转换为弧度。
static inline CGFloat WLDegreesToRadians(CGFloat degrees) {
    return degrees * M_PI / 180;
}

/// 弧度转换为度数。
static inline CGFloat WLRadiansToDegrees(CGFloat radians) {
    return radians * 180 / M_PI;
}

/// 获取旋转的弧度.
/// @return 旋转的弧度[-PI,PI] ([-180°,180°])
static inline CGFloat WLCGAffineTransformGetRotation(CGAffineTransform transform) {
    return atan2(transform.b, transform.a);
}

/// 获取变换的X轴比例
static inline CGFloat WLCGAffineTransformGetScaleX(CGAffineTransform transform) {
    return  sqrt(transform.a * transform.a + transform.c * transform.c);
}

/// Get the transform's scale.y
/// 获取变换的y轴的比例
static inline CGFloat WLCGAffineTransformGetScaleY(CGAffineTransform transform) {
    return sqrt(transform.b * transform.b + transform.d * transform.d);
}

/// Get the transform's translate.x
/// 获取改变是的转换的x
static inline CGFloat WLCGAffineTransformGetTranslateX(CGAffineTransform transform) {
    return transform.tx;
}

/// Get the transform's translate.y
/// 获取改变时的转变的y
static inline CGFloat WLCGAffineTransformGetTranslateY(CGAffineTransform transform) {
    return transform.ty;
}

/**
 如果你有通过一个相同的CGAffineTransform的3对点的转换：
 p1 (转换为->) q1
 p2 (转换为->) q2
 p3 (转换为->) q3
 此方法返回从这3个点的原始变换模型。
This method returns the original transform matrix from these 3 pair of points.
 
 @see http://stackoverflow.com/questions/13291796/calculate-values-for-a-cgaffinetransform-from-three-points-in-each-of-two-uiview
 */
CGAffineTransform WLCGAffineTransformGetFromPoints(CGPoint before[3], CGPoint after[3]);

/// Get the transform which can converts a point from the coordinate system of a given view to another.
/// 得到一个可以将某个视图的坐标系统转换为另一个点的 transform。
CGAffineTransform WLCGAffineTransformGetFromViews(UIView *from, UIView *to);

/// Create a skew transform.
/// 创建一个倾斜的transform。
static inline CGAffineTransform WLCGAffineTransformMakeSkew(CGFloat x, CGFloat y){
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform.c = -x;
    transform.b = y;
    return transform;
}

/// Negates/inverts a UIEdgeInsets.
/// 反转UIEdgeInsets
static inline UIEdgeInsets WLUIEdgeInsetsInvert(UIEdgeInsets insets) {
    return UIEdgeInsetsMake(-insets.top, -insets.left, -insets.bottom, -insets.right);
}

/// Convert CALayer's gravity string to UIViewContentMode.
/// 转换CALayer的引力字符串为UIViewContentMode
UIViewContentMode WLCAGravityToUIViewContentMode(NSString *gravity);

/// Convert UIViewContentMode to CALayer's gravity string.
/// 转换UIViewContentMode为CALayer的引力字符串
NSString *WLUIViewContentModeToCAGravity(UIViewContentMode contentMode);



/**
 Returns a rectangle to fit the @param rect with specified content mode.
 返回一个CGRect用来适合@param rect和给定的content mode.
 
 @param rect The constrant rect
 @param size The content size
 @param mode The content mode
 @return A rectangle for the given content mode.
 @讨论 UIViewContentModeRedraw is same as UIViewContentModeScaleToFill.
 */
CGRect WLCGRectFitWithContentMode(CGRect rect, CGSize size, UIViewContentMode mode);

/// Returns the center for the rectangle.
/// 返回Rect的中心点
static inline CGPoint WLCGRectGetCenter(CGRect rect) {
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

/// Returns the area of the rectangle.
/// 返回rect区域的面积。
static inline CGFloat WLCGRectGetArea(CGRect rect) {
    if (CGRectIsNull(rect)) return 0;
    rect = CGRectStandardize(rect);
    return rect.size.width * rect.size.height;
}

/// Returns the distance between two points.
/// 返回两点间的距离
static inline CGFloat WLCGPointGetDistanceToPoint(CGPoint p1, CGPoint p2) {
    return sqrt((p1.x - p2.x) * (p1.x - p2.x) + (p1.y - p2.y) * (p1.y - p2.y));
}

/// Returns the minmium distance between a point to a rectangle.
/// 返回一个点到一个矩形之间的最近距离。
static inline CGFloat WLCGPointGetDistanceToRect(CGPoint p, CGRect r) {
    r = CGRectStandardize(r);
    if (CGRectContainsPoint(r, p)) return 0;
    CGFloat distV, distH;
    if (CGRectGetMinY(r) <= p.y && p.y <= CGRectGetMaxY(r)) {
        distV = 0;
    } else {
        distV = p.y < CGRectGetMinY(r) ? CGRectGetMinY(r) - p.y : p.y - CGRectGetMaxY(r);
    }
    if (CGRectGetMinX(r) <= p.x && p.x <= CGRectGetMaxX(r)) {
        distH = 0;
    } else {
        distH = p.x < CGRectGetMinX(r) ? CGRectGetMinX(r) - p.x : p.x - CGRectGetMaxX(r);
    }
    return MAX(distV, distH);
}



/// Convert point to pixel.
/// 转换float为像素
static inline CGFloat WLCGFloatToPixel(CGFloat value) {
    return value * WLScreenScale();
}

/// Convert pixel to point.
/// 转换像素点
static inline CGFloat WLCGFloatFromPixel(CGFloat value) {
    return value / WLScreenScale();
}


/// floor point value for pixel-aligned
static inline CGFloat WLCGFloatPixelFloor(CGFloat value) {
    CGFloat scale = WLScreenScale();
    return floor(value * scale) / scale;
}

/// round point value for pixel-aligned
static inline CGFloat WLCGFloatPixelRound(CGFloat value) {
    CGFloat scale = WLScreenScale();
    return round(value * scale) / scale;
}

/// ceil point value for pixel-aligned
static inline CGFloat WLCGFloatPixelCeil(CGFloat value) {
    CGFloat scale = WLScreenScale();
    return ceil(value * scale) / scale;
}

/// round point value to .5 pixel for path stroke (odd pixel line width pixel-aligned)
static inline CGFloat WLCGFloatPixelHalf(CGFloat value) {
    CGFloat scale = WLScreenScale();
    return (floor(value * scale) + 0.5) / scale;
}



/// floor point value for pixel-aligned
static inline CGPoint WLCGPointPixelFloor(CGPoint point) {
    CGFloat scale = WLScreenScale();
    return CGPointMake(floor(point.x * scale) / scale,
                       floor(point.y * scale) / scale);
}

/// round point value for pixel-aligned
static inline CGPoint WLCGPointPixelRound(CGPoint point) {
    CGFloat scale = WLScreenScale();
    return CGPointMake(round(point.x * scale) / scale,
                       round(point.y * scale) / scale);
}

/// ceil point value for pixel-aligned
static inline CGPoint WLCGPointPixelCeil(CGPoint point) {
    CGFloat scale = WLScreenScale();
    return CGPointMake(ceil(point.x * scale) / scale,
                       ceil(point.y * scale) / scale);
}

/// round point value to .5 pixel for path stroke (odd pixel line width pixel-aligned)
static inline CGPoint WLCGPointPixelHalf(CGPoint point) {
    CGFloat scale = WLScreenScale();
    return CGPointMake((floor(point.x * scale) + 0.5) / scale,
                       (floor(point.y * scale) + 0.5) / scale);
}



/// floor point value for pixel-aligned
static inline CGSize WLCGSizePixelFloor(CGSize size) {
    CGFloat scale = WLScreenScale();
    return CGSizeMake(floor(size.width * scale) / scale,
                      floor(size.height * scale) / scale);
}

/// round point value for pixel-aligned
static inline CGSize WLCGSizePixelRound(CGSize size) {
    CGFloat scale = WLScreenScale();
    return CGSizeMake(round(size.width * scale) / scale,
                      round(size.height * scale) / scale);
}

/// ceil point value for pixel-aligned
static inline CGSize WLCGSizePixelCeil(CGSize size) {
    CGFloat scale = WLScreenScale();
    return CGSizeMake(ceil(size.width * scale) / scale,
                      ceil(size.height * scale) / scale);
}

/// round point value to .5 pixel for path stroke (odd pixel line width pixel-aligned)
static inline CGSize WLCGSizePixelHalf(CGSize size) {
    CGFloat scale = WLScreenScale();
    return CGSizeMake((floor(size.width * scale) + 0.5) / scale,
                      (floor(size.height * scale) + 0.5) / scale);
}



/// floor point value for pixel-aligned
static inline CGRect WLCGRectPixelFloor(CGRect rect) {
    CGPoint origin = WLCGPointPixelCeil(rect.origin);
    CGPoint corner = WLCGPointPixelFloor(CGPointMake(rect.origin.x + rect.size.width,
                                                   rect.origin.y + rect.size.height));
    CGRect ret = CGRectMake(origin.x, origin.y, corner.x - origin.x, corner.y - origin.y);
    if (ret.size.width < 0) ret.size.width = 0;
    if (ret.size.height < 0) ret.size.height = 0;
    return ret;
}

/// round point value for pixel-aligned
static inline CGRect WLCGRectPixelRound(CGRect rect) {
    CGPoint origin = WLCGPointPixelRound(rect.origin);
    CGPoint corner = WLCGPointPixelRound(CGPointMake(rect.origin.x + rect.size.width,
                                                   rect.origin.y + rect.size.height));
    return CGRectMake(origin.x, origin.y, corner.x - origin.x, corner.y - origin.y);
}

/// ceil point value for pixel-aligned
static inline CGRect WLCGRectPixelCeil(CGRect rect) {
    CGPoint origin = WLCGPointPixelFloor(rect.origin);
    CGPoint corner = WLCGPointPixelCeil(CGPointMake(rect.origin.x + rect.size.width,
                                                  rect.origin.y + rect.size.height));
    return CGRectMake(origin.x, origin.y, corner.x - origin.x, corner.y - origin.y);
}

/// round point value to .5 pixel for path stroke (odd pixel line width pixel-aligned)
static inline CGRect WLCGRectPixelHalf(CGRect rect) {
    CGPoint origin = WLCGPointPixelHalf(rect.origin);
    CGPoint corner = WLCGPointPixelHalf(CGPointMake(rect.origin.x + rect.size.width,
                                                  rect.origin.y + rect.size.height));
    return CGRectMake(origin.x, origin.y, corner.x - origin.x, corner.y - origin.y);
}



/// floor UIEdgeInset for pixel-aligned
static inline UIEdgeInsets WLUIEdgeInsetPixelFloor(UIEdgeInsets insets) {
    insets.top = WLCGFloatPixelFloor(insets.top);
    insets.left = WLCGFloatPixelFloor(insets.left);
    insets.bottom = WLCGFloatPixelFloor(insets.bottom);
    insets.right = WLCGFloatPixelFloor(insets.right);
    return insets;
}

/// ceil UIEdgeInset for pixel-aligned
static inline UIEdgeInsets WLUIEdgeInsetPixelCeil(UIEdgeInsets insets) {
    insets.top = WLCGFloatPixelCeil(insets.top);
    insets.left = WLCGFloatPixelCeil(insets.left);
    insets.bottom = WLCGFloatPixelCeil(insets.bottom);
    insets.right = WLCGFloatPixelCeil(insets.right);
    return insets;
}


// 主屏幕的缩放率
#ifndef kScreenScale
#define kScreenScale WLScreenScale()
#endif

// 主屏幕的大小 (portrait)
#ifndef kScreenSize
#define kScreenSize WLScreenSize()
#endif

// 主屏幕的宽度 (portrait)
#ifndef kScreenWidth
#define kScreenWidth WLScreenSize().width
#endif

// 主屏幕的高度 (portrait)
#ifndef kScreenHeight
#define kScreenHeight WLScreenSize().height
#endif

NS_ASSUME_NONNULL_END
WL_EXTERN_C_END

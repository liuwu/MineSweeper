//
//  UIView+WLAdd.h
//  Welian
//
//  Created by weLian on 16/5/18.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 NS_ASSUME_NONNULL_BEGIN  NS_ASSUME_NONNULL_END
 在这两个宏之间的代码，所有简单指针对象都被假定为nonnull，因此我们只需要去指定那些nullable的指针。
 */
NS_ASSUME_NONNULL_BEGIN

@class WLEmptyView;

@interface UIView (WLAdd)

#pragma mark - Normal
///=============================================================================
/// @name 常用的属性
///=============================================================================

///左边在坐标的位置。frame.origin.x的缩写.
@property (nonatomic) CGFloat left;
///顶部在坐标的位置。frame.origin.y缩写
@property (nonatomic) CGFloat top;
///右边在坐标的位置。frame.origin.x + frame.size.width的缩写
@property (nonatomic) CGFloat right;
///底部在坐标的位置。frame.origin.y + frame.size.height的缩写
@property (nonatomic) CGFloat bottom;
///view的宽度。frame.size.width的缩写
@property (nonatomic) CGFloat width;
///view的高度。rame.size.height的缩写
@property (nonatomic) CGFloat height;
///view的宽度中间点在X轴的位置。center.x的缩写，外部中心
@property (nonatomic) CGFloat centerX;
///View的高度中间点在Y轴的位置。viewcenter.y的缩写
@property (nonatomic) CGFloat centerY;
//内部中心。frame.size.width / 2的缩写
@property (nonatomic) CGFloat centerx;
//    frame.size.height / 2的缩写
@property (nonatomic) CGFloat centery;
///frame.origin的缩写
@property (nonatomic) CGPoint origin;
///frame.size的缩写
@property (nonatomic) CGSize  size;
///返回当前view所在的viewcontroller（可能为nil）
@property (nullable, nonatomic, readonly) UIViewController *wl_viewController;
///返回当前view的父viewcontroller（可能为nil）。比如给的是[self.view wl_superViewController]返回的不是当前VC，而是当前VC的上一级VC
@property (nullable, nonatomic, readonly) UIViewController *wl_superViewController;

//计算同等比例的宽度  在不同设备上的高度
+ (CGFloat)getHeightWithMaxWidth:(CGFloat)maxWidth In4ScreWidth:(CGFloat)in4ScreWith In4ScreeHeight:(CGFloat)in4ScreeHeight;

/**
 *  @author liuwu     , 16-06-08
 *
 *  设置为调试状态
 *  @param val YES调试状态
 */
- (void)wl_setDebug:(BOOL)val;

/**
 *  @author liuwu     , 16-06-08
 *
 *  找到第一响应者
 *  @return 活动中的View,如果找不到返回nil
 */
- (UIView *)wl_findFirstResponder;

/**
 *  设置图层的圆角
 *
 *  @param cornerRadius 圆角弧度
 */
- (void)wl_setCornerRadius:(CGFloat)cornerRadius;

/*
 *  设置一个圆角
 */
- (void)wl_setRoundedCorners:(UIRectCorner)corners
                      radius:(CGFloat)radius;

/**
 *  设置layer边框
 *
 *  @param width 边框宽度
 *  @param color 边框颜色
 */
- (void)wl_setBorderWidth:(CGFloat)width color:(UIColor *)color;

/**
 设置view.layer的阴影
 
 @param color  阴影颜色
 @param offset 阴影offset
 @param radius 阴影radius
 */
- (void)wl_setLayerShadow:(nullable UIColor*)color
                   offset:(CGSize)offset
                   radius:(CGFloat)radius;

/**
 删除所有的子view
 
 @警告 不要在你的view的drawRect:方法中调用这个方法。
 */
- (void)wl_removeAllSubviews;


#pragma mark - SnapShot
///=============================================================================
/// @name 快照、截图
///=============================================================================
/**
 *  整体截图
 *  @return 截取的图片
 */
- (UIImage *)wl_screenshot;

/**
 *  截取view中的区域
 *
 *  @param rect 区域
 *  @return 截取的图片
 */
- (UIImage *)wl_screenshotWithRect:(CGRect)rect;

/**
 创建完整的视图层次的快照图片
 */
- (nullable UIImage *)wl_snapshotImage;

/**
  创建完整的视图层次的快照图片
 @讨论 它的速度比 "snapshotImage"快, 但可能会导致屏幕更新.
 查看 -[UIView drawViewHierarchyInRect:afterScreenUpdates:]更多信息.
 */
- (nullable UIImage *)wl_snapshotImageAfterScreenUpdates:(BOOL)afterUpdates;

/**
 创建一个完整的视图层次的PDF快照。
 */
- (nullable NSData *)wl_snapshotPDF;


/**
 将接收的点转换为在指定的视图或窗口中的坐标系
 
 @param point 接收的指定的坐标点.
 @param view  要转换坐标的视图或窗口。如果视图为nil，则次方法转换为窗口基础坐标.
 @return 转换为点在视图中的坐标系统.
 */
- (CGPoint)wl_convertPoint:(CGPoint)point toViewOrWindow:(nullable UIView *)view;

/**
 Converts a point from the coordinate system of a given view or window to that of the receiver.
 
 @param point A point specified in the local coordinate system (bounds) of view.
 @param view  The view or window with point in its coordinate system.
 If view is nil, this method instead converts from window base coordinates.
 @return The point converted to the local coordinate system (bounds) of the receiver.
 */
- (CGPoint)wl_convertPoint:(CGPoint)point fromViewOrWindow:(nullable UIView *)view;

/**
 Converts a rectangle from the receiver's coordinate system to that of another view or window.
 
 @param rect A rectangle specified in the local coordinate system (bounds) of the receiver.
 @param view The view or window that is the target of the conversion operation. If view is nil, this method instead converts to window base coordinates.
 @return The converted rectangle.
 */
- (CGRect)wl_convertRect:(CGRect)rect toViewOrWindow:(nullable UIView *)view;

/**
 Converts a rectangle from the coordinate system of another view or window to that of the receiver.
 
 @param rect A rectangle specified in the local coordinate system (bounds) of view.
 @param view The view or window with rect in its coordinate system.
 If view is nil, this method instead converts from window base coordinates.
 @return The converted rectangle.
 */
- (CGRect)wl_convertRect:(CGRect)rect fromViewOrWindow:(nullable UIView *)view;

/// 添加视觉差效果
- (void)addMotionEffectWithMax:(CGFloat)max Min:(CGFloat)min;

@end

typedef NS_OPTIONS(NSUInteger, QMUIBorderViewPosition) {
    QMUIBorderViewPositionNone      = 0,
    QMUIBorderViewPositionTop       = 1 << 0,
    QMUIBorderViewPositionLeft      = 1 << 1,
    QMUIBorderViewPositionBottom    = 1 << 2,
    QMUIBorderViewPositionRight     = 1 << 3
};

/**
 *  UIView (QMUI_Border) 为 UIView 方便地显示某几个方向上的边框。
 *
 *  系统的默认实现里，要为 UIView 加边框一般是通过 view.layer 来实现，view.layer 会给四条边都加上边框，如果你只想为其中某几条加上边框就很麻烦，于是 UIView (QMUI_Border) 提供了 qmui_borderPosition 来解决这个问题。
 *  @warning 注意如果你需要为 UIView 四条边都加上边框，请使用系统默认的 view.layer 来实现，而不要用 UIView (QMUI_Border)，会浪费资源，这也是为什么 QMUIBorderViewPosition 不提供一个 QMUIBorderViewPositionAll 枚举值的原因。
 */
@interface UIView (QMUI_Border)

/// 设置边框类型，支持组合，例如：`borderType = QMUIBorderViewTypeTop|QMUIBorderViewTypeBottom`
@property(nonatomic, assign) QMUIBorderViewPosition qmui_borderPosition;

/// 边框的大小，默认为PixelOne
@property(nonatomic, assign) IBInspectable CGFloat qmui_borderWidth;

/// 边框的颜色，默认为UIColorSeparator
@property(nonatomic, strong) IBInspectable UIColor *qmui_borderColor;

/// 虚线 : dashPhase默认是0，且当dashPattern设置了才有效
@property(nonatomic, assign) CGFloat qmui_dashPhase;
@property(nonatomic, copy) NSArray <NSNumber *> *qmui_dashPattern;

/// border的layer
@property(nonatomic, strong, readonly) CAShapeLayer *qmui_borderLayer;

@property (nonatomic, weak) WLEmptyView *emptyView;

@end

NS_ASSUME_NONNULL_END





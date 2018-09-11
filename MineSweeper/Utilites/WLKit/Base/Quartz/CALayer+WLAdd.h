//
//  CALayer+WLAdd.h
//  Welian
//
//  Created by weLian on 16/5/18.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

/*
 NS_ASSUME_NONNULL_BEGIN  NS_ASSUME_NONNULL_END
 在这两个宏之间的代码，所有简单指针对象都被假定为nonnull，因此我们只需要去指定那些nullable的指针。
 */
NS_ASSUME_NONNULL_BEGIN

/**
 CALayer的扩展
 */
@interface CALayer (WLAdd)

///< frame.origin.x 的快捷方式
@property (nonatomic) CGFloat left;
///< frame.origin.y 的快捷方式
@property (nonatomic) CGFloat top;
///< frame.origin.x + frame.size.width 的快捷方式
@property (nonatomic) CGFloat right;
///< frame.origin.y + frame.size.height 的快捷方式
@property (nonatomic) CGFloat bottom;
///< frame.size.width 的快捷方式
@property (nonatomic) CGFloat width;
///< frame.size.height 的快捷方式
@property (nonatomic) CGFloat height;
///< center 的快捷方式
@property (nonatomic) CGPoint center;
///< center.x 的快捷方式
@property (nonatomic) CGFloat centerX;
///< center.y 的快捷方式
@property (nonatomic) CGFloat centerY;
///< frame.origin 的快捷方式
@property (nonatomic) CGPoint origin;
 ///< frame.size 的快捷方式
@property (nonatomic, getter=frameSize, setter=setFrameSize:) CGSize  size;

/**
 不需要改变的快照，图像的大小等于bounds.
 */
- (UIImage *)wl_snapshotImage;

/**
 不需要改变的快照，PDF的页面大小等于bounds。
 */
- (NSData *)wl_snapshotPDF;

/**
 设置图层阴影的快捷方式。
 
 @param color  Shadow Color
 @param offset Shadow offset
 @param radius Shadow radius
 */
- (void)wl_setLayerShadow:(UIColor*)color offset:(CGSize)offset radius:(CGFloat)radius;

/**
 删除所有的自层。
 */
- (void)wl_removeAllSublayers;
/**
 删除指定类型的Layer。
 */

- (void)wl_removeSublayerWithType:(Class)classObj;


/**
 当内容改变时，在图层的内容中添加一个渐变的动画。
 
 @param duration Animation duration
 @param curve    Animation curve.
 */
- (void)wl_addFadeAnimationWithDuration:(NSTimeInterval)duration curve:(UIViewAnimationCurve)curve;

/**
 取消通过"-addFadeAnimationWithDuration:curve:"添加的渐变动画
 */
- (void)wl_removePreviousFadeAnimation;

@end

NS_ASSUME_NONNULL_END

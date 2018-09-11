//
//  UIScreen+WLAdd.h
//  Welian
//
//  Created by weLian on 16/5/19.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 NS_ASSUME_NONNULL_BEGIN  NS_ASSUME_NONNULL_END
 在这两个宏之间的代码，所有简单指针对象都被假定为nonnull，因此我们只需要去指定那些nullable的指针。
 */
NS_ASSUME_NONNULL_BEGIN


#ifndef MainScreen
#define MainScreen   [UIScreen mainScreen]
#endif

/*
 UIScreen的扩展类
 */
@interface UIScreen (WLAdd)

///UIScreen的大小
+ (CGSize)wl_size;
///UIScreen的宽度
+ (CGFloat)wl_width;
///UIScreen的高度
+ (CGFloat)wl_height;

///UIScreen的纵向的大小
+ (CGSize)wl_orientationSize;
///UIScreen的纵向的宽度
+ (CGFloat)wl_orientationWidth;
///UIScreen的纵向的高度
+ (CGFloat)wl_orientationHeight;
///UIScreen的分辨率下的大小
+ (CGSize)wl_DPISize;

/**
 MainScreen的scale
 */
+ (CGFloat)wl_screenScale;

/**
 当前设置方向的屏幕边界
 @查看    boundsForOrientation:
 */
- (CGRect)wl_currentBounds NS_EXTENSION_UNAVAILABLE_IOS("");

/**
 给定的设备方向的屏幕的边界。UIScreen的bounds方法总是返回纵向方向的画面边界。
 @查看  currentBounds
 */
- (CGRect)wl_boundsForOrientation:(UIInterfaceOrientation)orientation;

/**
 屏幕的实际大小（宽度总是小于高度）。
 这个值在位置的设备或模拟器中可能不是很准确。
 例： (768,1024)
 */
@property (nonatomic, readonly) CGSize wl_sizeInPixel;

/**
 屏幕的PPI.
 这个值在位置的设备或模拟器中可能不是很准确。
 默认值是 96.
 */
@property (nonatomic, readonly) CGFloat wl_pixelsPerInch;

@end

NS_ASSUME_NONNULL_END


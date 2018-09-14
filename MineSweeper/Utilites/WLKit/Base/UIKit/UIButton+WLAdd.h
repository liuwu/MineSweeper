//
//  UIButton+WLAdd.h
//  Welian_Normal_Demo
//
//  Created by weLian on 16/6/8.
//  Copyright © 2016年 杭州传送门网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 NS_ASSUME_NONNULL_BEGIN  NS_ASSUME_NONNULL_END
 在这两个宏之间的代码，所有简单指针对象都被假定为nonnull，因此我们只需要去指定那些nullable的指针。
 */
NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSUInteger, WLImagePosition) {
    WLImagePositionLeft = 0,        //图片在左，文字在右，默认
    WLImagePositionRight = 1,       //图片在右，文字在左
    WLImagePositionTop = 2,         //图片在上，文字在下
    WLImagePositionBottom = 3       //图片在下，文字在上
};

/*
 UIButton的扩展类
 */
@interface UIButton (WLAdd)

/**
 *  利用UIButton的titleEdgeInsets和imageEdgeInsets来实现文字和图片的自由排列
 *  注意：这个方法需要在设置图片和文字之后才可以调用，且button的大小要大于 图片大小+文字大小+spacing
 *
 *  @param spacing 图片和文字的间隔
 */
- (void)wl_setImagePosition:(WLImagePosition)postion
                    spacing:(CGFloat)spacing;

/**
 *  使用颜色设置按钮背景
 *
 *  @param backgroundColor 背景颜色
 *  @param state           按钮状态
 */
- (void)wl_setBackgroundColor:(UIColor *)backgroundColor
                     forState:(UIControlState)state;

/**
 扩大UIButton点击区域
 */
- (void)wl_setEnlargeEdgeWithTop:(CGFloat)top
                           right:(CGFloat)right
                          bottom:(CGFloat)bottom
                            left:(CGFloat)left;


//获取按钮对象
+ (UIButton *)wl_getBtnWithTitle:(nullable NSString *)title
                           image:(nullable UIImage *)image;


@end

NS_ASSUME_NONNULL_END


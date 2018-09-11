//
//  UIScrollView+WLAdd.h
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

/*
 UIScrollView的扩展类
 */
@interface UIScrollView (WLAdd)

/**
 创建完整的ScrollView截屏层次的快照图片
 */
- (nullable UIImage *)wl_snapshotImage;


/**
 滚动内容到顶部带动画
 */
- (void)wl_scrollToTop;

/**
 滚动内容到底部带动画
 */
- (void)wl_scrollToBottom;

/**
 滚动内容到最左边带动画
 */
- (void)wl_scrollToLeft;

/**
 滚动内容到最右边带动画
 */
- (void)wl_scrollToRight;

/**
 滚动内容到顶部。
 
 @param animated  是否使用动画.
 */
- (void)wl_scrollToTopAnimated:(BOOL)animated;

/**
 滚动内容到底部
 
 @param animated  是否使用动画.
 */
- (void)wl_scrollToBottomAnimated:(BOOL)animated;

/**
 滚动内容到左边
 
 @param animated  是否使用动画.
 */
- (void)wl_scrollToLeftAnimated:(BOOL)animated;

/**
 滚动内容到右边
 
 @param animated  是否使用动画.
 */
- (void)wl_scrollToRightAnimated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END


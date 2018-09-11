//
//  UIScrollView+WLAdd.m
//  Welian_Normal_Demo
//
//  Created by weLian on 16/6/8.
//  Copyright © 2016年 杭州传送门网络科技有限公司. All rights reserved.
//

#import "UIScrollView+WLAdd.h"
#import "WLCGUtilities.h"

WLSYNTH_DUMMY_CLASS(UIScrollView_WLAdd)

@implementation UIScrollView (WLAdd)

/**
 创建完整的ScrollView截屏层次的快照图片
 */
- (nullable UIImage *)wl_snapshotImage {
    UIImage* image = nil;
    //保存
    CGPoint savedContentOffset = self.contentOffset;
    CGRect savedFrame = self.frame;
    self.contentOffset = CGPointZero;
    CGFloat w = MAX(self.width, self.contentSize.width);
    CGFloat h = MAX(self.height , self.contentSize.height);
    self.frame = CGRectMake(0, 0, w, h);
    image = [self snapshotImageAfterScreenUpdates:YES];
    //还原数据
    self.contentOffset = savedContentOffset;
    self.frame = savedFrame;
    return image;
}

/**
 滚动内容到顶部带动画
 */
- (void)wl_scrollToTop {
    [self scrollToTop];
}

/**
 滚动内容到底部带动画
 */
- (void)wl_scrollToBottom {
    [self wl_scrollToBottomAnimated:YES];
}

/**
 滚动内容到最左边带动画
 */
- (void)wl_scrollToLeft {
    [self scrollToLeft];
}

/**
 滚动内容到最右边带动画
 */
- (void)wl_scrollToRight {
    [self scrollToRight];
}

/**
 滚动内容到顶部。
 
 @param animated  是否使用动画.
 */
- (void)wl_scrollToTopAnimated:(BOOL)animated {
    [self scrollToTopAnimated:animated];
}

/**
 滚动内容到底部
 
 @param animated  是否使用动画.
 */
- (void)wl_scrollToBottomAnimated:(BOOL)animated {
    CGPoint off = self.contentOffset;
    CGFloat contentInsetBottom = self.contentInset.bottom;
    if (@available(iOS 11.0, *)) {
        contentInsetBottom =  self.adjustedContentInset.bottom;
    }
    if (self.contentSize.height - self.bounds.size.height + contentInsetBottom < 0) {
        return;
    }
    off.y = self.contentSize.height - self.bounds.size.height + contentInsetBottom;
    [self setContentOffset:off animated:animated];
}

/**
 滚动内容到左边
 
 @param animated  是否使用动画.
 */
- (void)wl_scrollToLeftAnimated:(BOOL)animated {
    [self scrollToLeftAnimated:animated];
}

/**
 滚动内容到右边
 
 @param animated  是否使用动画.
 */
- (void)wl_scrollToRightAnimated:(BOOL)animated {
    [self scrollToRightAnimated:animated];
}

@end

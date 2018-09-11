//
//  CALayer+WLAdd.m
//  Welian
//
//  Created by weLian on 16/5/18.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import "CALayer+WLAdd.h"
#import "WLCGUtilities.h"

WLSYNTH_DUMMY_CLASS(CALayer_WLAdd)

@implementation CALayer (WLAdd)

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
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGPoint)center {
    return CGPointMake(self.frame.origin.x + self.frame.size.width * 0.5,
                       self.frame.origin.y + self.frame.size.height * 0.5);
}

- (void)setCenter:(CGPoint)center {
    CGRect frame = self.frame;
    frame.origin.x = center.x - frame.size.width * 0.5;
    frame.origin.y = center.y - frame.size.height * 0.5;
    self.frame = frame;
}

- (CGFloat)centerX {
    return self.frame.origin.x + self.frame.size.width * 0.5;
}

- (void)setCenterX:(CGFloat)centerX {
    CGRect frame = self.frame;
    frame.origin.x = centerX - frame.size.width * 0.5;
    self.frame = frame;
}

- (CGFloat)centerY {
    return self.frame.origin.y + self.frame.size.height * 0.5;
}

- (void)setCenterY:(CGFloat)centerY {
    CGRect frame = self.frame;
    frame.origin.y = centerY - frame.size.height * 0.5;
    self.frame = frame;
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)frameSize {
    return self.frame.size;
}

- (void)setFrameSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

/**
 不需要改变的快照，图像的大小等于bounds.
 */
- (UIImage *)wl_snapshotImage {
    return [self snapshotImage];
}

/**
 不需要改变的快照，PDF的页面大小等于bounds。
 */
- (NSData *)wl_snapshotPDF {
    return [self snapshotPDF];
}

/**
 设置图层阴影的快捷方式。
 
 @param color  Shadow Color
 @param offset Shadow offset
 @param radius Shadow radius
 */
- (void)wl_setLayerShadow:(UIColor*)color offset:(CGSize)offset radius:(CGFloat)radius {
    [self setLayerShadow:color offset:offset radius:radius];
}

/**
 删除所有的自层。
 */
- (void)wl_removeAllSublayers {
    [self removeAllSublayers];
}
/**
 删除指定类型的Layer。
 */
- (void)wl_removeSublayerWithType:(Class)classObj {
    for (CALayer *layer in self.sublayers) {
        if ([layer isKindOfClass:classObj]) {
            [layer removeFromSuperlayer];
            return ;
        }
    }
}


/**
 当内容改变时，在图层的内容中添加一个渐变的动画。
 
 @param duration Animation duration
 @param curve    Animation curve.
 */
- (void)wl_addFadeAnimationWithDuration:(NSTimeInterval)duration curve:(UIViewAnimationCurve)curve {
    [self addFadeAnimationWithDuration:duration curve:curve];
}

/**
 取消通过"-addFadeAnimationWithDuration:curve:"添加的渐变动画
 */
- (void)wl_removePreviousFadeAnimation {
    [self removePreviousFadeAnimation];
}

@end

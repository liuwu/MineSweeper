//
//  UIView+WLRoundedCorner.m
//  Welian
//
//  Created by zp on 16/8/29.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import "UIView+WLRoundedCorner.h"
#import <objc/runtime.h>

static NSOperationQueue *wl_operationQueue;
static char wl_operationKey;

@implementation UIView (WLRoundedCorner)

+ (void)load {
    wl_operationQueue = [[NSOperationQueue alloc] init];
}

- (NSOperation *)wl_getOperation {
    id operation = objc_getAssociatedObject(self, &wl_operationKey);
    return operation;
}

- (void)wl_setOperation:(NSOperation *)operation {
    objc_setAssociatedObject(self, &wl_operationKey, operation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)wl_cancelOperation {
    NSOperation *operation = [self wl_getOperation];
    [operation cancel];
    [self wl_setOperation:nil];
}


- (void)wl_setCornerRadius:(CGFloat)radius withBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth {
     [self wl_setCornerRadius:radius withBorderColor:borderColor borderWidth:borderWidth backgroundColor:nil backgroundImage:nil contentMode:UIViewContentModeScaleAspectFill];
}


- (void)wl_setWLRadius:(WLRadius)radius withBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth {
    [self wl_setWLRadius:radius withBorderColor:borderColor borderWidth:borderWidth backgroundColor:nil backgroundImage:nil contentMode:UIViewContentModeScaleAspectFill];
}


- (void)wl_setCornerRadius:(CGFloat)radius withBackgroundColor:(UIColor *)backgroundColor {
    [self wl_setCornerRadius:radius withBorderColor:nil borderWidth:0 backgroundColor:backgroundColor backgroundImage:nil contentMode:UIViewContentModeScaleAspectFill];
}


- (void)wl_setWLRadius:(WLRadius)radius withBackgroundColor:(UIColor *)backgroundColor {
    [self wl_setWLRadius:radius withBorderColor:nil borderWidth:0 backgroundColor:backgroundColor backgroundImage:nil contentMode:UIViewContentModeScaleAspectFill];

}


- (void)wl_setCornerRadius:(CGFloat)radius withImage:(UIImage *)image {
     [self wl_setCornerRadius:radius withBorderColor:nil borderWidth:0 backgroundColor:nil backgroundImage:image contentMode:UIViewContentModeScaleAspectFill];
}


- (void)wl_setWLRadius:(WLRadius)radius withImage:(UIImage *)image {
    [self wl_setWLRadius:radius withBorderColor:nil borderWidth:0 backgroundColor:nil backgroundImage:image contentMode:UIViewContentModeScaleAspectFill];
}


- (void)wl_setCornerRadius:(CGFloat)radius withImage:(UIImage *)image contentMode:(UIViewContentMode)contentMode {
    [self wl_setCornerRadius:radius withBorderColor:nil borderWidth:0 backgroundColor:nil backgroundImage:image contentMode:contentMode];

}


- (void)wl_setWLRadius:(WLRadius)radius withImage:(UIImage *)image contentMode:(UIViewContentMode)contentMode {
   [self wl_setWLRadius:radius withBorderColor:nil borderWidth:0 backgroundColor:nil backgroundImage:image contentMode:contentMode];
}


- (void)wl_setCornerRadius:(CGFloat)radius withBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth backgroundColor:(UIColor *)backgroundColor backgroundImage:(UIImage *)backgroundImage contentMode:(UIViewContentMode)contentMode {
    [self wl_setWLRadius:WLRadiusMake(radius, radius, radius, radius) withBorderColor:borderColor borderWidth:borderWidth backgroundColor:backgroundColor backgroundImage:backgroundImage contentMode:contentMode];
}


- (void)wl_setWLRadius:(WLRadius)radius withBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth backgroundColor:(UIColor *)backgroundColor backgroundImage:(UIImage *)backgroundImage contentMode:(UIViewContentMode)contentMode {
    [self wl_cancelOperation];
    
    [self wl_setWLRadius:radius withBorderColor:borderColor borderWidth:borderWidth backgroundColor:backgroundColor backgroundImage:backgroundImage contentMode:contentMode size:CGSizeZero];
}


- (void)wl_setWLRadius:(WLRadius)radius withBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth backgroundColor:(UIColor *)backgroundColor backgroundImage:(UIImage *)backgroundImage contentMode:(UIViewContentMode)contentMode size:(CGSize)size {
    __block CGSize _size = size;
    
    __weak typeof(self) wself = self;
    NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
        
        if ([[wself wl_getOperation] isCancelled]) return;
        
        if (CGSizeEqualToSize(_size, CGSizeZero)) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                _size = wself.bounds.size;
            });
        }
        
        CGSize size2 = CGSizeMake(pixel(_size.width), pixel(_size.height));
        
        UIImage *image = [UIImage wl_imageWithRoundedCornersAndSize:size2 wlRadius:radius borderColor:borderColor borderWidth:borderWidth backgroundColor:backgroundColor backgroundImage:backgroundImage withContentMode:contentMode];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            __strong typeof(wself) self = wself;
            if ([[self wl_getOperation] isCancelled]) return;
            
            self.frame = CGRectMake(pixel(self.frame.origin.x), pixel(self.frame.origin.y), size2.width, size2.height);
            if ([self isKindOfClass:[UIImageView class]]) {
                ((UIImageView *)self).image = image;
            } else if ([self isKindOfClass:[UIButton class]] && backgroundImage) {
                [((UIButton *)self) setBackgroundImage:image forState:UIControlStateNormal];
            } else if ([self isKindOfClass:[UILabel class]]) {
                self.layer.backgroundColor = [UIColor colorWithPatternImage:image].CGColor;
            } else {
                self.layer.contents = (__bridge id _Nullable)(image.CGImage);
            }
        }];
    }];
    
    [self wl_setOperation:blockOperation];
    [wl_operationQueue addOperation:blockOperation];

}

static inline float pixel(float num) {
    float unit = 1.0 / [UIScreen mainScreen].scale;
    double remain = fmod(num, unit);
    return num - remain + (remain >= unit / 2.0? unit: 0);
}

@end

//
//  UINavigationController+WLAdd.m
//  Welian
//
//  Created by 丁彦鹏 on 2018/5/7.
//  Copyright © 2018年 chuansongmen. All rights reserved.
//

#import "UINavigationController+WLAdd.h"

@implementation UINavigationController (WLAdd)
- (void)wl_removeSubviewControllerWithIndex:(NSInteger)index {
    NSUInteger vcCount = self.viewControllers.count;
    if (index >= 0 && index < vcCount) {
        NSMutableArray *arr = [NSMutableArray arrayWithArray:self.viewControllers];
        [arr removeObjectAtIndex:index];
        self.viewControllers = arr;
    }
}

- (void)wl_removeSubviewControllerWithRange:(NSRange)range {
    NSUInteger vcCount = self.viewControllers.count;
    if (range.location < vcCount && (range.location + range.length) <= vcCount) {
        [self removeSubVCWithRange:range];
    }
}
- (void)wl_removeLastSecondSubviewControoler {
    [self wl_removeSubviewControllerWithIndex:self.viewControllers.count -2];
}
//如果范围不在第一个和最后一个之间，就不会顺利移除
- (void)wl_removeSubviewControllerMiddleWithRange:(NSRange)range {
    NSUInteger vcCount = self.viewControllers.count;
    //第一个和最后一个不会被在移除范围内
    if (range.location > 0 && range.location < vcCount -1 && (range.location + range.length) <= vcCount - 1) {
        [self removeSubVCWithRange:range];
    }
}
//移除navgationController中间的子控制器，第一个和最后一个不移除
- (void)wl_removeSubviewControllerMiddle {
    NSUInteger vcCount = self.viewControllers.count;
    if (vcCount > 2) {
        [self removeSubVCWithRange:NSMakeRange(1, vcCount-2)];
    }
}


- (void)removeSubVCWithRange:(NSRange)range {
    NSMutableArray *arr = [NSMutableArray arrayWithArray:self.viewControllers];
    [arr removeObjectsInRange:range];
    self.viewControllers = arr;
}

@end

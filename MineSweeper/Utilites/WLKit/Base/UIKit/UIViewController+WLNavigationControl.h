//
//  UIViewController+WLNavigationControl.h
//  Welian
//
//  Created by liuwu on 2016/11/21.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (WLNavigationControl)

- (void)dismissViewControl:(id)sender;
/**
 *  是否 显示 第一个 navigation left Item，默认 是 NO
 */
@property (nonatomic, assign) BOOL firstNavigationLeftItemShow;

///* 不允许左滑手势返回 （默认NO允许  YES为不允许）
@property (nonatomic, assign, getter=isUnallowedPop) BOOL unallowedPop;

@end

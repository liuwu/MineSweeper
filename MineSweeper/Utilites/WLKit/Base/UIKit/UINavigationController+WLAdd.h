//
//  UINavigationController+WLAdd.h
//  Welian
//
//  Created by 丁彦鹏 on 2018/5/7.
//  Copyright © 2018年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (WLAdd)
- (void)wl_removeSubviewControllerWithIndex:(NSInteger)index;
- (void)wl_removeSubviewControllerWithRange:(NSRange)range;
- (void)wl_removeLastSecondSubviewControoler;
///如果范围不在第一个和最后一个之间，就不会顺利移除
- (void)wl_removeSubviewControllerMiddleWithRange:(NSRange)range;
- (void)wl_removeSubviewControllerMiddle;
@end

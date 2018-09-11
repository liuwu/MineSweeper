//
//  WLPackAlertController.h
//  ddssds
//
//  Created by 丁彦鹏 on 2018/1/29.
//  Copyright © 2018年 丁彦鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^WLAlertActionHandler)(UIAlertAction *action);
@interface WLPackAlertController : UIAlertController


/**
 一个按钮,默认颜色
 */
+ (instancetype)alertWithTitle: (NSString *)title message: (NSString *)message alertStyle: (UIAlertControllerStyle)alertStyle actionStyle:(UIAlertActionStyle)actionStyle text1:(NSString *)text1  handler1:(WLAlertActionHandler)handler1;
/**
 一个取消按钮，一个普通按钮,可设置颜色
 */
+ (instancetype)alertWithTitle: (NSString *)title message: (NSString *)message alertStyle: (UIAlertControllerStyle)alertStyle cancelColor: (UIColor *)cancelColor color1: (UIColor *)color1 cancelText: (NSString *)cancelText text1:(NSString *)text1 cancelHandler: (WLAlertActionHandler)cancelHandler handler1:(WLAlertActionHandler)handler1;
/**
 一个取消按钮，一个普通按钮,不能设置字体颜色
 */
+ (instancetype)alertWithTitle: (NSString *)title message: (NSString *)message alertStyle: (UIAlertControllerStyle)alertStyle cancelText: (NSString *)cancelText text1:(NSString *)text1 cancelHandler: (WLAlertActionHandler)cancelHandler handler1:(WLAlertActionHandler)handler1;
/**
 两个普通按钮，可设置字体颜色
 */
+ (instancetype)alertWithTitle: (NSString *)title message: (NSString *)message alertStyle: (UIAlertControllerStyle)alertStyle color1: (UIColor *)color1 color2: (UIColor *)color2 text1: (NSString *)text1 text2:(NSString *)text2 handler1: (WLAlertActionHandler)handler1 handler2:(WLAlertActionHandler)handler2;
/**
 两个普通按钮，不能设置字体颜色
 */
+ (instancetype)alertWithTitle: (NSString *)title message: (NSString *)message alertStyle: (UIAlertControllerStyle)alertStyle text1: (NSString *)text1 text2:(NSString *)text2 handler1: (WLAlertActionHandler)handler1 handler2:(WLAlertActionHandler)handler2;
/**
 三个普通按钮，不能设置字体颜色
 */
+ (instancetype)alertWithTitle: (NSString *)title message: (NSString *)message alertStyle: (UIAlertControllerStyle)alertStyle text1: (NSString *)text1 text2:(NSString *)text2 text3:(NSString *)text3 handler1: (WLAlertActionHandler)handler1 handler2:(WLAlertActionHandler)handler2 handler3:(WLAlertActionHandler)handler3;



/**
 一个取消按钮，一个destructiveBtn，可设置取消的字体颜色
 */
+ (instancetype)alertWithTitle: (NSString *)title message: (NSString *)message alertStyle: (UIAlertControllerStyle)alertStyle cancelColor: (UIColor *)cancelColor cancelText: (NSString *)cancelText destructiveText:(NSString *)destructiveText cancelHandler: (WLAlertActionHandler)cancelHandler destructiveHandler:(WLAlertActionHandler)destructiveHandler;

- (void)show;
- (void)showWithPresentingViewController:(UIViewController *)presentingVC;
@end

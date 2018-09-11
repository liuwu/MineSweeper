//
//  WLPackAlertController.m
//  ddssds
//
//  Created by 丁彦鹏 on 2018/1/29.
//  Copyright © 2018年 丁彦鹏. All rights reserved.
//

#import "WLPackAlertController.h"
@interface WLPackAlertController ()

@end

@implementation WLPackAlertController

/**
 一个按钮,默认颜色
 */
+ (instancetype)alertWithTitle: (NSString *)title message: (NSString *)message alertStyle: (UIAlertControllerStyle)alertStyle actionStyle:(UIAlertActionStyle)actionStyle text1:(NSString *)text1  handler1:(WLAlertActionHandler)handler1 {
    WLPackAlertController *alertVC = [WLPackAlertController alertControllerWithTitle:title message:message preferredStyle:alertStyle];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:text1 style:actionStyle handler:handler1];
    [alertVC addAction:action1];
    return alertVC;
}
/**
 一个取消按钮，一个普通按钮,可设置颜色
 */
+ (instancetype)alertWithTitle: (NSString *)title message: (NSString *)message alertStyle: (UIAlertControllerStyle)alertStyle cancelColor: (UIColor *)cancelColor color1: (UIColor *)color1 cancelText: (NSString *)cancelText text1:(NSString *)text1 cancelHandler: (WLAlertActionHandler)cancelHandler handler1:(WLAlertActionHandler)handler1 {
    WLPackAlertController *alertVC = [WLPackAlertController alertWithTitle:title message:message alertStyle:alertStyle cancelText:cancelText text1:text1 cancelHandler:cancelHandler handler1:handler1];
    if (cancelColor) {
        [alertVC.actions.firstObject setValue:cancelColor forKey:@"titleTextColor"];
    }
    if (color1) {
        [alertVC.actions[1] setValue:color1 forKey:@"titleTextColor"];
    }

    return alertVC;
}
/**
 一个取消按钮，一个普通按钮,默认颜色
 */
+ (instancetype)alertWithTitle: (NSString *)title message: (NSString *)message alertStyle: (UIAlertControllerStyle)alertStyle cancelText: (NSString *)cancelText text1:(NSString *)text1 cancelHandler: (WLAlertActionHandler)cancelHandler handler1:(WLAlertActionHandler)handler1 {
    WLPackAlertController *alertVC = [WLPackAlertController alertControllerWithTitle:title message:message preferredStyle:alertStyle];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelText style:UIAlertActionStyleCancel handler:cancelHandler];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:text1 style:UIAlertActionStyleDefault handler:handler1];
    [alertVC addAction:cancelAction];
    [alertVC addAction:action1];
    return alertVC;
}
/**
   两个普通按钮,可以设置字体颜色
 */
+ (instancetype)alertWithTitle: (NSString *)title message: (NSString *)message alertStyle: (UIAlertControllerStyle)alertStyle color1: (UIColor *)color1 color2: (UIColor *)color2 text1: (NSString *)text1 text2:(NSString *)text2 handler1: (WLAlertActionHandler)handler1 handler2:(WLAlertActionHandler)handler2 {
    WLPackAlertController *alertVC = [WLPackAlertController alertControllerWithTitle:title message:message preferredStyle:alertStyle];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:text1 style:UIAlertActionStyleCancel handler:handler1];
    if (color1) {
        [action1 setValue:color1 forKey:@"titleTextColor"];
    }
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:text2 style:UIAlertActionStyleDefault handler:handler2];
    if (color2) {
        [action2 setValue:color2 forKey:@"titleTextColor"];
    }
    [alertVC addAction:action1];
    [alertVC addAction:action2];
    return alertVC;
}
/**
 两个普通按钮，不能设置字体颜色
 */
+ (instancetype)alertWithTitle: (NSString *)title message: (NSString *)message alertStyle: (UIAlertControllerStyle)alertStyle text1: (NSString *)text1 text2:(NSString *)text2 handler1: (WLAlertActionHandler)handler1 handler2:(WLAlertActionHandler)handler2 {
    WLPackAlertController *alertVC = [WLPackAlertController alertControllerWithTitle:title message:message preferredStyle:alertStyle];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:text1 style:UIAlertActionStyleDefault handler:handler1];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:text2 style:UIAlertActionStyleDefault handler:handler2];
    [alertVC addAction:action1];
    [alertVC addAction:action2];
    return alertVC;
}
/**
 三个普通按钮，不能设置字体颜色
 */
+ (instancetype)alertWithTitle: (NSString *)title message: (NSString *)message alertStyle: (UIAlertControllerStyle)alertStyle text1: (NSString *)text1 text2:(NSString *)text2 text3:(NSString *)text3 handler1: (WLAlertActionHandler)handler1 handler2:(WLAlertActionHandler)handler2 handler3:(WLAlertActionHandler)handler3 {
    WLPackAlertController *alertVC = [WLPackAlertController alertControllerWithTitle:title message:message preferredStyle:alertStyle];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:text1 style:UIAlertActionStyleDefault handler:handler1];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:text2 style:UIAlertActionStyleDefault handler:handler2];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:text3 style:UIAlertActionStyleDefault handler:handler3];
    for (UIAlertAction *action in @[action1,action2,action3]) {
        [action setValue:[UIColor wl_hex0F6EF4] forKey:@"titleTextColor"];
    }
    [alertVC addAction:action1];
    [alertVC addAction:action2];
    [alertVC addAction:action3];
    return alertVC;
}

/**
   一个取消按钮，一个destructiveBtn
 */
+ (instancetype)alertWithTitle: (NSString *)title message: (NSString *)message alertStyle: (UIAlertControllerStyle)alertStyle cancelColor: (UIColor *)cancelColor cancelText: (NSString *)cancelText destructiveText:(NSString *)destructiveText cancelHandler: (WLAlertActionHandler)cancelHandler destructiveHandler:(WLAlertActionHandler)destructiveHandler {
    WLPackAlertController *alertVC = [WLPackAlertController alertControllerWithTitle:title message:message preferredStyle:alertStyle];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelText style:UIAlertActionStyleCancel handler:cancelHandler];
    if (cancelColor) {
        [cancelAction setValue:cancelColor forKey:@"titleTextColor"];
    }
    UIAlertAction *destructiveAction = [UIAlertAction actionWithTitle:destructiveText style:UIAlertActionStyleDestructive handler:destructiveHandler];
    [alertVC addAction:cancelAction];
    [alertVC addAction:destructiveAction];
    return alertVC;
}

- (void)show {
    [[UIViewController getCurrentViewCtrl] presentViewController:self animated:true completion:nil];
}

- (void)showWithPresentingViewController:(UIViewController *)presentingVC {
    [presentingVC presentViewController:self animated:true completion:nil];
}
@end

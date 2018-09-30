//
//  WLHUDView.h
//  Welian
//
//  Created by dong on 14-9-22.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>

static const CGFloat MBDuration = 1;

@class MBProgressHUD;

@interface WLHUDView : NSObject

+(UIView *)window;
// 只有文字
+ (void)showOnlyTextHUD:(NSString *)labelText;
// 成功
+ (void)showSuccessHUD:(NSString *)labeltext;

+ (void)showErrorHUD:(NSString *)labeltext Duration:(CGFloat)duration;
// 失败
+ (void)showErrorHUD:(NSString *)labeltext;
// 网络请求失败
+ (void)showNetWorkError;

// 警告
+ (void)showAttentionHUD:(NSString *)labelText;

+ (void)showCustomHUD:(NSString *)labeltext imageview:(NSString *)imageName;

+ (MBProgressHUD*)showHUDWithStr:(NSString*)title dim:(BOOL)dim;
// 
+ (void)hiddenHud;
@end

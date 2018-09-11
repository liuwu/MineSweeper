//
//  WLHUDView.m
//  Welian
//
//  Created by dong on 14-9-22.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "WLHUDView.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"

#define Kerror     @"hud_error"
#define Ksuccess   @"hud_success"
#define KAttention @"hud_attention"

@interface WLHUDView ()
@end

@implementation WLHUDView

+ (UIView *)window {
    return [AppDelegate sharedAppDelegate].window;
}

MBProgressHUD *HUD;

// 只有文字
+ (void)showOnlyTextHUD:(NSString *)labelText {
    [self showCustomHUD:labelText imageview:nil];
}

+ (void)showAttentionHUD:(NSString *)labelText
{
    [self showCustomHUD:labelText imageview:KAttention];
}

+ (void)showSuccessHUD:(NSString *)labeltext
{
    [self showCustomHUD:labeltext imageview:Ksuccess];
}

+ (void)showErrorHUD:(NSString *)labeltext
{
    [self showCustomHUD:labeltext imageview:Kerror];
}

+ (void)showNetWorkError{
    [self showErrorHUD:@"网络请求失败"];
}

+ (void)showErrorHUD:(NSString *)labeltext Duration:(CGFloat)Duration
{
    [self showCustomHUD:labeltext imageview:Kerror time:Duration];
}

+ (void)showCustomHUD:(NSString *)labeltext imageview:(NSString *)imageName
{
    [self showCustomHUD:labeltext imageview:imageName time:MBDuration];
}

+ (void)showCustomHUD:(NSString *)labeltext imageview:(NSString *)imageName time:(CGFloat)time
{
    [self showHUDWithStr:labeltext dim:NO];
    if (imageName) {
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        HUD.mode = MBProgressHUDModeCustomView;
    }else{
        HUD.mode = MBProgressHUDModeText;
    }
    [HUD hide:YES afterDelay:time];
}


+ (MBProgressHUD*)showHUDWithStr:(NSString*)title dim:(BOOL)dim
{
    [self hiddenHud];
    HUD = [MBProgressHUD showHUDAddedTo:[self window] animated:YES];
    [HUD setUserInteractionEnabled:dim];
    if (title.length > 15) {
        [HUD setDetailsLabelFont:WLFONT(14)];
        [HUD setDetailsLabelText:title];
    }else{
        [HUD setLabelText:title];
    }
//    [HUD hide:YES afterDelay:25.f];
    return HUD;
}

+ (void)hiddenHud
{
    [MBProgressHUD hideHUDForView:[self window] animated:NO];
}

@end

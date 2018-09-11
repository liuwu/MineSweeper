//
//  WLNormalInputAlertView.h
//  Welian
//
//  Created by weLian on 15/10/30.
//  Copyright © 2015年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^cancelBtnClickedBlock)(void);
typedef void(^OkBtnClickedBlock)(NSString *inputText);

@interface WLNormalInputAlertView : UIView

@property (strong, nonatomic) cancelBtnClickedBlock cancelBtnClickedBlock;
@property (strong, nonatomic) OkBtnClickedBlock okBtnClickedBlock;
//输入框高度，默认35.f
@property (assign, nonatomic) CGFloat InputViewHeight;
//输入框限制数据的字数，默认不限制
@property (assign, nonatomic) CGFloat maxInputLimit;

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)msg
               placeHolderStr:(NSString *)placeHolderStr
            cancelButtonTitle:(NSString *)cancelButtonTitle
             otherButtonTitle:(NSString *)otherButtonTitle;

//显示
- (void)show;

@end

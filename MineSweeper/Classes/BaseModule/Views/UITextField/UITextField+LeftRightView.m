//
//  UITextField+LeftRightView.m
//  Welian
//
//  Created by dong on 15/4/23.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "UITextField+LeftRightView.h"
//#import "WLCustomTextField.h"

@implementation UITextField (LeftRightView)

//+ (UITextField *)textFieldWitFrame:(CGRect)frame
//                       placeholder:(NSString *)placeholder
//                 leftViewImageName:(NSString *)leftImage
//{
//    return [self textFieldWitFrame:frame placeholder:placeholder placeholderColor:nil leftViewImageName:leftImage lineColor:nil];
//}
//
//
//+ (UITextField *)textFieldWitFrame:(CGRect)frame
//                       placeholder:(NSString *)placeholder
//                  placeholderColor:(UIColor *)placeholderColor
//                 leftViewImageName:(NSString *)leftImage
//                         lineColor:(UIColor *)lineColor
//{
//    return [self textFieldWitFrame:frame placeholder:placeholder placeholderColor:placeholderColor leftViewImageName:leftImage lineColor:lineColor andRightViewImageName:nil isNeedSecureText:NO];
//}

//+ (UITextField *)textFieldWitFrame:(CGRect)frame
//                       placeholder:(NSString *)placeholder
//                  placeholderColor:(UIColor *)placeholderColor
//                 leftViewImageName:(NSString *)leftImage
//                         lineColor:(UIColor *)lineColor
//             andRightViewImageName:(NSString *)rightImage
//                  isNeedSecureText:(BOOL)isNeedSecureText;
//
//{
//    WLCustomTextField *textf = [[WLCustomTextField alloc] initWithFrame:frame isNeedSecureText:isNeedSecureText];
//    textf.backgroundColor = [UIColor clearColor];
//    UIColor *_placeholderColor = [UIColor wl_HexBDBDBD];
//    if (placeholderColor) {
//        _placeholderColor = placeholderColor;
//    }
//    if (isNeedSecureText) {
//        textf.secureTextEntry = YES;
//    }
//    textf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSFontAttributeName:WLFONT(16),NSForegroundColorAttributeName:_placeholderColor}];
//    if (leftImage) {
//        [textf setLeftViewMode:UITextFieldViewModeAlways];
//        UIImageView *nameleftV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:leftImage]];
//        [textf setLeftView:nameleftV];
//    }
//    if (rightImage) {
//        UIView *view = [[UIView alloc]init];
//        [textf setRightViewMode:UITextFieldViewModeAlways];
//        UIImage *openImage = [UIImage imageNamed:rightImage];
//        UIImage *closeImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_close",rightImage]];
//        UIImageView *rightView = [[UIImageView alloc] initWithImage:closeImage];
//        if (closeImage == nil) {
//            rightView.image = openImage;
//        }
//        if (isNeedSecureText) {
//            [rightView setUserInteractionEnabled:YES];
//            [rightView bk_whenTapped:^{
//                if (textf.secureTextEntry) {
//                    rightView.image = openImage;
//                }else{
//                    rightView.image = closeImage;
//                }
//                [textf setSecureTextEntry:!textf.secureTextEntry];
//            }];
//        }
//
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        [button setImage:[UIImage imageNamed:@"textField_clear_but"] forState:UIControlStateNormal];
//        [button setFrame:CGRectMake(0.0f, 0.0f, 22.0f, frame.size.height)];
//        button.hidden = YES;
//        [view addSubview:button];
//        [view addSubview:rightView];
//
//        [rightView sizeToFit];
//        rightView.left = button.right + 5.f;
//        rightView.centerY = button.centerY;
//        view.frame = CGRectMake(0.0f, 0.0f, 22.0f + rightView.width + 5.f, frame.size.height);
//        [textf setRightView:view];
//
//        [button bk_addEventHandler:^(id sender) {
//            textf.text = @"";
//            button.hidden = YES;
//            [textf sendActionsForControlEvents:UIControlEventEditingChanged];
//        } forControlEvents:UIControlEventTouchUpInside];
//
//        [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidChangeNotification object:textf queue:nil usingBlock:^(NSNotification *note) {
//            if (textf.text.length > 0) {
//                button.hidden = NO;
//            }else {
//                button.hidden = YES;
//            }
//        }];
//
//        [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidEndEditingNotification object:textf queue:nil usingBlock:^(NSNotification *note) {
//            button.hidden = YES;
//        }];
//
//    }
//
//    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-1, frame.size.width, 1)];
//    UIColor *_lineColor = [UIColor whiteColor];
//    if (lineColor) {
//        _lineColor = lineColor;
//    }
//    lineView.backgroundColor = _lineColor;
//    [textf addSubview:lineView];
//    return textf;
//}

@end

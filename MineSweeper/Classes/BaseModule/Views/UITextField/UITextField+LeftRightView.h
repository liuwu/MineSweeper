//
//  UITextField+LeftRightView.h
//  Welian
//
//  Created by dong on 15/4/23.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (LeftRightView)

+ (UITextField *)textFieldWitFrame:(CGRect)frame
                       placeholder:(NSString *)placeholder
                 leftViewImageName:(NSString *)leftImage;


+ (UITextField *)textFieldWitFrame:(CGRect)frame
                       placeholder:(NSString *)placeholder
                  placeholderColor:(UIColor *)placeholderColor
                 leftViewImageName:(NSString *)leftImage
                         lineColor:(UIColor *)lineColor;

+ (UITextField *)textFieldWitFrame:(CGRect)frame
                       placeholder:(NSString *)placeholder
                  placeholderColor:(UIColor *)placeholderColor
                 leftViewImageName:(NSString *)leftImage
                         lineColor:(UIColor *)lineColor
             andRightViewImageName:(NSString *)rightImage
                  isNeedSecureText:(BOOL)isNeedSecureText;
@end

//
//  UILabel+WLAdd.m
//  weLianAppDis
//
//  Created by 丁彦鹏 on 2018/3/15.
//  Copyright © 2018年 chuansongmen. All rights reserved.
//

#import "UILabel+WLAdd.h"

@implementation UILabel (WLAdd)
+ (UILabel *)createWithFrame:(CGRect)frame fontSize:(CGFloat)fontSize textClor:(UIColor *)textColor text:(NSString *)text {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = WLFONT(fontSize);
    label.textColor = textColor;
    label.text = text;
    return label;
}

@end

//
//  UILabel+WLAdd.h
//  weLianAppDis
//
//  Created by 丁彦鹏 on 2018/3/15.
//  Copyright © 2018年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (WLAdd)
+ (UILabel *)createWithFrame:(CGRect)frame fontSize:(CGFloat)fontSize textClor:(UIColor *)textColor text:(NSString *)text;
@end

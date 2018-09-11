//
//  UISearchBar+WLAdd.h
//  Welian
//
//  Created by dong on 16/9/14.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UISearchBar (WLAdd)

// 设置背景图（色）
- (void)wl_setBackgroundImage;

// 为搜索框添加边线
- (void)wl_setBorder;

- (void)wl_setTextFieldBackgroundColor:(UIColor *)color;

@property (nonatomic, strong,readonly) UITextField *searchTF;

@end

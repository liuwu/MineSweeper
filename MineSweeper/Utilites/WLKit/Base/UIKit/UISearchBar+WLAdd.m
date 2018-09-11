//
//  UISearchBar+WLAdd.m
//  Welian
//
//  Created by dong on 16/9/14.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import "UISearchBar+WLAdd.h"

@implementation UISearchBar (WLAdd)

// 设置背景图（色）
- (void)wl_setBackgroundImage {
    [self setBackgroundImage:[UIImage wl_resizedImage:@"searchbar_bg"]];
}

// 为搜索框添加边线
- (void)wl_setBorder {
    UITextField *searchField = [self valueForKey:@"_searchField"];
    [searchField wl_setCornerRadius:6.f];
    [searchField wl_setBorderWidth:0.4 color:kWLNormalGrayColor_204];
}

- (void)wl_setTextFieldBackgroundColor:(UIColor *)color {
    UITextField *searchField = [self valueForKey:@"_searchField"];
    searchField.backgroundColor = color;
}
//需要在searchBar设置好placeholder等后才能获取到
- (UITextField *)searchTF {
    for (UIView *subView in self.subviews) {
        if (subView.subviews.count < 2) {
            return nil;
        }
        if ([subView.subviews[1] isKindOfClass:[UITextField class]]) {
            return subView.subviews[1];
        }
    }
    return nil;
}

@end

//
//  UITextField+WLAdd.m
//  Welian_Normal_Demo
//
//  Created by weLian on 16/6/8.
//  Copyright © 2016年 杭州传送门网络科技有限公司. All rights reserved.
//

#import "UITextField+WLAdd.h"
#import "WLCGUtilities.h"

WLSYNTH_DUMMY_CLASS(UITextField_WLAdd)

@implementation UITextField (WLAdd)

/**
 当前选中的字符串范围
 */
- (NSRange)wl_selectedRange {
    UITextPosition* beginning = self.beginningOfDocument;
    
    UITextRange* selectedRange = self.selectedTextRange;
    UITextPosition* selectionStart = selectedRange.start;
    UITextPosition* selectionEnd = selectedRange.end;
    
    NSInteger location = [self offsetFromPosition:beginning toPosition:selectionStart];
    NSInteger length = [self offsetFromPosition:selectionStart toPosition:selectionEnd];
    
    return NSMakeRange(location, length);
}

/**
 设置选中所有的文字
 */
- (void)wl_selectAllText {
    [self selectAllText];
}

/**
 设置选定范围内的文本
 
 @param range  文档中选定文本的范围.
 */
- (void)wl_setSelectedRange:(NSRange)range {
    [self setSelectedRange:range];
}


- (BOOL)wl_isDisableOperate {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setWl_isDisableOperate:(BOOL)isDisableOperate {
    objc_setAssociatedObject(self, @selector(wl_isDisableOperate), @(isDisableOperate), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (self.wl_isDisableOperate) {
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        if (menuController) {
            [UIMenuController sharedMenuController].menuVisible = NO;
        }
        return NO;
    }else{
        return [super canPerformAction:action withSender:sender];
    }
}


@end

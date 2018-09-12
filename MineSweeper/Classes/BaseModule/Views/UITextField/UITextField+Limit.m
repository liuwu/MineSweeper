//
//  UITextField+Limit.m
//  WLTextField
//
//  Created by dong on 16/5/19.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import "UITextField+Limit.h"
#import <objc/runtime.h>

static char *klimitCountKey = "limitCountKey";

@implementation UITextField (Limit)

- (void)setLimitMaxCount:(NSInteger)limitMaxCount {
    objc_setAssociatedObject(self, klimitCountKey, @(limitMaxCount), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self removeTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    [self removeTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingDidEnd];
    
    [self addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    [self addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingDidEnd];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    
    return [super canPerformAction:action withSender:sender];
}

- (NSInteger)limitMaxCount {

    return [objc_getAssociatedObject(self, klimitCountKey) integerValue];
}

- (void)textFieldEditChanged:(UITextField *)textField {
    
    NSString *toBeString = textField.text;
    
    //获取高亮部分
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position)
    {
        if (toBeString.length > self.limitMaxCount)
        {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:self.limitMaxCount];
            if (rangeIndex.length == 1) {
                textField.text = [toBeString substringToIndex:self.limitMaxCount];
            }else {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, self.limitMaxCount)];
                textField.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
}


@end

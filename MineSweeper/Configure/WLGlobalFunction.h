//
//  WLGlobalFunction.h
//  Welian
//
//  Created by 丁彦鹏 on 2018/3/16.
//  Copyright © 2018年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>

//根据文字计算高度
inline static CGFloat wl_textH(NSString *text, CGFloat font, CGFloat width) {
    CGRect bounds = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:WLFONT(font)} context:nil];
    return bounds.size.height + 0.1;
}
inline static CGFloat wl_attrTextH(NSString *text, NSDictionary *attr, CGFloat width) {
    CGRect bounds = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil];
    return bounds.size.height + 0.1;
}
//根据字体大小，计算单行文字的高度
inline static CGFloat wl_singleLineH(CGFloat font) {
    return wl_textH(@"单行文字", font, ScreenWidth) + 0.1;
}
//根据行数，计算高度
inline static CGFloat wl_textHWithLines(NSInteger lines, CGFloat font) {
    return wl_singleLineH(font) * lines;
}
//不超过限制的最大行数的高度
inline static CGFloat wl_noMoreMaxLinesTextH(NSString *text,NSInteger maxLine, CGFloat font, CGFloat width) {
    CGFloat allTextH = wl_textH(text, font, width);
    //最大高度是: maxLine行的高度
    CGFloat maxH = wl_textHWithLines(font,maxLine);
    CGFloat finalH = allTextH > maxH ? maxH : allTextH;
    return finalH;
}
//计算行数
inline static NSInteger wl_textLines(NSString *text, CGFloat font, CGFloat width) {
    CGFloat allH = wl_textH(text, font, width);
    CGFloat result = allH / wl_singleLineH(font);
    NSInteger tempLines = (NSInteger)result;
    NSInteger lines = result > tempLines ? tempLines + 1 : tempLines;
    return lines;
}
//根据文字计算宽度
inline static CGFloat wl_textW(NSString *text, CGFloat font) {
    CGRect bounds = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, 17) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:WLFONT(font)} context:nil];
    return bounds.size.width;
}
//行间距
inline static NSMutableParagraphStyle* wl_createParagraphStyle(CGFloat lineSpacing) {
    NSMutableParagraphStyle *pagrStyle = [[NSMutableParagraphStyle alloc] init];
    pagrStyle.lineSpacing = lineSpacing;
    pagrStyle.alignment = NSTextAlignmentCenter;
    return pagrStyle;
}

inline static UIView * createShadowBottomView() {
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 60)];
    bottomView.backgroundColor = [UIColor whiteColor];
//    [bottomView setLayerShadow:[UIColor colorWithWhite:0 alpha:0.1]
//                        offset:CGSizeMake(0, 1) radius:5];
    return bottomView;
}

inline static UIView * wl_keyboard() {
    UIWindow *keyboardWindow = nil;
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        if([[window class] isEqual:NSClassFromString(@"UITextEffectsWindow")]) {
            keyboardWindow = window;
            break;
        }
    }
    for (UIView *inputContainerView in [keyboardWindow subviews]) {
        NSLog(@"keyboard:%@",inputContainerView.subviews.firstObject);
        return inputContainerView.subviews.firstObject;
        
    }
    return nil;
}

inline static CGFloat wl_keyboardH() {
    UIView *keyborad = wl_keyboard();
    if (keyborad) {
        return keyborad.height;
    }
    return 0;
}


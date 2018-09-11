//
//  NSString+WLAddForSize.m
//  Welian
//
//  Created by weLian on 16/5/9.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import "NSString+WLAddForSize.h"
#import "WLCGUtilities.h"

WLSYNTH_DUMMY_CLASS(NSString_WLAddForSize)

@implementation NSString (WLAddForSize)

/// 计算文字的高度
- (CGFloat)wl_heightWithFont:(UIFont *)font
          constrainedToWidth:(CGFloat)width {
    return [self wl_heightWithFont:font
                constrainedToWidth:width
                       lineSpacing:0.0];
}

/// 计算文字的高度
- (CGFloat)wl_heightWithFont:(UIFont *)font
          constrainedToWidth:(CGFloat)width
                 lineSpacing:(CGFloat)lineSpacing {
    CGSize textSize = [self wl_sizeWithFont:font
                         constrainedToWidth:width
                                lineSpacing:lineSpacing];
    return textSize.height;
}

/// 计算文字的宽度
- (CGFloat)wl_widthWithFont:(UIFont *)font
        constrainedToHeight:(CGFloat)height {
    return [self wl_widthWithFont:font
              constrainedToHeight:height
                      lineSpacing:0.0f];
}

/// 计算文字的宽度
- (CGFloat)wl_widthWithFont:(UIFont *)font
        constrainedToHeight:(CGFloat)height
                lineSpacing:(CGFloat)lineSpacing {
    CGSize textSize = [self wl_sizeWithFont:font
                        constrainedToHeight:height
                                lineSpacing:lineSpacing];
    return textSize.width;
}

/// 计算文字的size
- (CGSize)wl_sizeWithFont:(UIFont *)font
       constrainedToWidth:(CGFloat)width {
    return [self wl_sizeWithFont:font
              constrainedToWidth:width
                     lineSpacing:0.0f];
}

/// 计算文字的size
- (CGSize)wl_sizeWithFont:(UIFont *)font
       constrainedToWidth:(CGFloat)width
              lineSpacing:(CGFloat)lineSpacing {
    UIFont *textFont = font ? font : [UIFont systemFontOfSize:[UIFont systemFontSize]];
    CGSize textSize;
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 70000
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName: textFont,
                                     NSParagraphStyleAttributeName: paragraph};
        textSize = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                      options:(NSStringDrawingUsesLineFragmentOrigin |
                                               NSStringDrawingTruncatesLastVisibleLine)
                                   attributes:attributes
                                      context:nil].size;
    } else {
        textSize = [self sizeWithFont:textFont
                    constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)
                        lineBreakMode:NSLineBreakByWordWrapping];
    }
#else
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    if (lineSpacing) {
        paragraph.lineSpacing = lineSpacing;
    }
    NSDictionary *attributes = @{NSFontAttributeName: textFont,
                                 NSParagraphStyleAttributeName: paragraph};
    textSize = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                  options:(NSStringDrawingUsesLineFragmentOrigin |
                                           NSStringDrawingTruncatesLastVisibleLine)
                               attributes:attributes
                                  context:nil].size;
#endif
    
    return CGSizeMake(ceil(textSize.width), ceil(textSize.height));
}


/**
 *  @brief 计算文字的大小
 *
 *  @param font   字体(默认为系统字体)
 *  @param height 约束高度
 */
- (CGSize)wl_sizeWithFont:(UIFont *)font
      constrainedToHeight:(CGFloat)height {
    return [self wl_sizeWithFont:font
             constrainedToHeight:height
                     lineSpacing:0.0f];
}

/// 计算文字的size
- (CGSize)wl_sizeWithFont:(UIFont *)font
      constrainedToHeight:(CGFloat)height
              lineSpacing:(CGFloat)lineSpacing {
    UIFont *textFont = font ? font : [UIFont systemFontOfSize:[UIFont systemFontSize]];
    
    CGSize textSize;
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 70000
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName: textFont,
                                     NSParagraphStyleAttributeName: paragraph};
        textSize = [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height)
                                      options:(NSStringDrawingUsesLineFragmentOrigin |
                                               NSStringDrawingTruncatesLastVisibleLine)
                                   attributes:attributes
                                      context:nil].size;
    } else {
        textSize = [self sizeWithFont:textFont
                    constrainedToSize:CGSizeMake(CGFLOAT_MAX, height)
                        lineBreakMode:NSLineBreakByWordWrapping];
    }
#else
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    if (lineSpacing) {
        paragraph.lineSpacing = lineSpacing;
    }
    NSDictionary *attributes = @{NSFontAttributeName: textFont,
                                 NSParagraphStyleAttributeName: paragraph};
    textSize = [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height)
                                  options:(NSStringDrawingUsesLineFragmentOrigin |
                                           NSStringDrawingTruncatesLastVisibleLine)
                               attributes:attributes
                                  context:nil].size;
#endif
    
    return CGSizeMake(ceil(textSize.width), ceil(textSize.height));
}

// 计算单行宽高
- (CGSize)wl_sizeWithCustomFont:(UIFont*)font {
    NSDictionary *attribute = @{NSFontAttributeName:(font ? : [UIFont systemFontOfSize:16.f])};
    CGSize textSize = [self sizeWithAttributes:attribute];
    return CGSizeMake(ceil(textSize.width), ceil(textSize.height));
}

/**
 *  @author dong, 16-03-09 15:03:28
 *
 *  翻转字符串 ABC ---> CBA
 *  @param strSrc strSrc description
 *
 *  @return return value description
 */
+ (NSString *)wl_reverseString:(NSString *)strSrc {
    NSMutableString* reverseString = [[NSMutableString alloc] init];
    NSInteger charIndex = [strSrc length];
    while (charIndex > 0) {
        charIndex --;
        NSRange subStrRange = NSMakeRange(charIndex, 1);
        [reverseString appendString:[strSrc substringWithRange:subStrRange]];
    }
    return reverseString;
}

@end

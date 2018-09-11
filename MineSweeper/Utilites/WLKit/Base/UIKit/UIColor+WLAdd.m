//
//  UIColor+WLAdd.m
//  Welian
//
//  Created by weLian on 16/5/13.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import "UIColor+WLAdd.h"
#import "NSString+WLAdd.h"
#import "WLCGUtilities.h"

WLSYNTH_DUMMY_CLASS(UIColor_WLAdd)

#define CLAMP_COLOR_VALUE(v) (v) = (v) < 0 ? 0 : (v) > 1 ? 1 : (v)

#undef CLAMP_COLOR_VALUE

@implementation UIColor (WLAdd)

/** 蓝色 */
+ (UIColor *)wl_hex0F6EF4 {return WLRGB(15, 110, 244);}

+ (UIColor *)wl_Hex305AFA {return WLRGB(48, 90, 250);}
+ (UIColor *)wl_Hex5AA0FF {return WLRGB(90, 160, 255);}


+ (UIColor *)wl_Hex4093C9 {return WLRGB(64, 147, 201);}
+ (UIColor *)wl_Hex48C4F7 {return WLRGB(72, 196, 247);}
+ (UIColor *)wl_HexCCEDFC {return WLRGB(204, 237, 252);}
+ (UIColor *)wl_HexF6FBFF {return WLRGB(246, 251, 255);}
+ (UIColor *)wl_HexECF7FE {return WLRGB(236, 247, 254);}
+ (UIColor *)wl_HexF9FAFC {return WLRGB(249, 250, 252);}

/** 黑灰 */
+ (UIColor *)wl_Hex333333 {return WLColoerRGB(51);}
+ (UIColor *)wl_Hex666666 {return WLColoerRGB(102);}
+ (UIColor *)wl_Hex555555 {return WLColoerRGB(85);}
+ (UIColor *)wl_Hex999999 {return WLColoerRGB(153);}
+ (UIColor *)wl_HexADADAD {return WLColoerRGB(173);}
+ (UIColor *)wl_HexCCCCCC {return WLColoerRGB(204);}
+ (UIColor *)wl_HexE5E5E5 {return WLColoerRGB(229);}
+ (UIColor *)wl_HexEFEFEF {return WLColoerRGB(239);}
+ (UIColor *)wl_HexF2F2F2 {return WLColoerRGB(242);}
+ (UIColor *)wl_HexF5F5F5 {return WLColoerRGB(245);}
+ (UIColor *)wl_HexFAFAFA {return WLColoerRGB(250);}
+ (UIColor *)wl_HexBDBDBD {return WLRGB(189, 189, 189);}

/** 红色 */
+ (UIColor *)wl_HexFF5336 {return WLRGB(255, 83, 54);}
// 系统角标和删除色
+ (UIColor *)wl_HexFF3B30 {return WLRGB(255, 59, 48);}

/** 彩色 */
+ (UIColor *)wl_HexFF9729 {return WLRGB(255, 151, 41);}
+ (UIColor *)wl_HexFBB217 {return WLRGB(251, 178, 23);}
+ (UIColor *)wl_HexFF5B36 {return WLRGB(255, 91, 54);}
+ (UIColor *)wl_HexFFC355 {return WLRGB(255, 195, 85);}
+ (UIColor *)wl_HexFFC55C {return WLRGB(255, 197, 92);}
+ (UIColor *)wl_Hex00C2D0 {return WLRGB(0, 194, 208);}
+ (UIColor *)wl_HexFEA66A {return WLRGB(254, 166, 106);}
+ (UIColor *)wl_Hex7D7D7D {return WLRGB(125, 125, 125);}
+ (UIColor *)wl_HexC7C7CD {return WLRGB(199, 199, 205);}
+ (UIColor *)wl_HexFFF8EF {return WLRGB(255, 248, 239);}
+ (UIColor *)wl_HexFFAB1F {return WLRGB(255, 171, 31);}
+ (UIColor *)wl_HexFFF5E4 {return WLRGB(255, 245, 228);}
+ (UIColor *)wl_HexC59F68 {return WLRGB(197, 159, 104);}
+ (UIColor *)wl_HexF3CF87 {return WLRGB(243, 207, 135);}
+ (UIColor *)wl_HexCBA161 {return WLRGB(203, 161, 97);}
+ (UIColor *)wl_HexA09CAE {return WLRGB(160, 156, 174);}
+ (UIColor *)wl_Hex9793A6 {return WLRGB(151, 147, 166);}
+ (UIColor *)wl_HexC7C4D1 {return WLRGB(199, 196, 209);}


#pragma mark - Normal
///=============================================================================
/// @name 常用的UIColor操作
///=============================================================================

///获取随机颜色
+ (UIColor *)wl_randomColor {
    NSInteger aRedValue = arc4random() % 255;
    NSInteger aGreenValue = arc4random() % 255;
    NSInteger aBlueValue = arc4random() % 255;
    UIColor *randColor = [UIColor colorWithRed:aRedValue / 255.0f green:aGreenValue / 255.0f blue:aBlueValue / 255.0f alpha:1.0f];
    return randColor;
}


#pragma mark - Create a UIColor Object
///=============================================================================
/// @name 创建一个UIColor对象
///=============================================================================

///根据给定的rgba值，返回颜色对象
+ (UIColor *)wl_red:(CGFloat)red
              green:(CGFloat)green
               blue:(CGFloat)blue
              alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:red/255.f
                           green:green/255.f
                            blue:blue/255.f
                           alpha:alpha];
}

///根据给定的rgb值，返回颜色对象
+ (UIColor *)wl_red:(CGFloat)red
              green:(CGFloat)green
               blue:(CGFloat)blue {
    return [self wl_red:red green:green blue:blue alpha:1.0];
}

static inline NSUInteger hexStrToInt(NSString *str) {
    uint32_t result = 0;
    sscanf([str UTF8String], "%X", &result);
    return result;
}

static BOOL hexStrToRGBA(NSString *str,
                         CGFloat *r, CGFloat *g, CGFloat *b, CGFloat *a) {
    str = [[str wl_trimWhitespaceAndNewlines] uppercaseString];
    if ([str hasPrefix:@"#"]) {
        str = [str substringFromIndex:1];
    } else if ([str hasPrefix:@"0X"]) {
        str = [str substringFromIndex:2];
    }
    
    NSUInteger length = [str length];
    //         RGB            RGBA          RRGGBB        RRGGBBAA
    if (length != 3 && length != 4 && length != 6 && length != 8) {
        return NO;
    }
    
    //RGB,RGBA,RRGGBB,RRGGBBAA
    if (length < 5) {
        *r = hexStrToInt([str substringWithRange:NSMakeRange(0, 1)]) / 255.0f;
        *g = hexStrToInt([str substringWithRange:NSMakeRange(1, 1)]) / 255.0f;
        *b = hexStrToInt([str substringWithRange:NSMakeRange(2, 1)]) / 255.0f;
        if (length == 4)  *a = hexStrToInt([str substringWithRange:NSMakeRange(3, 1)]) / 255.0f;
        else *a = 1;
    } else {
        *r = hexStrToInt([str substringWithRange:NSMakeRange(0, 2)]) / 255.0f;
        *g = hexStrToInt([str substringWithRange:NSMakeRange(2, 2)]) / 255.0f;
        *b = hexStrToInt([str substringWithRange:NSMakeRange(4, 2)]) / 255.0f;
        if (length == 8) *a = hexStrToInt([str substringWithRange:NSMakeRange(6, 2)]) / 255.0f;
        else *a = 1;
    }
    return YES;
}

/**
 使用指定十六进制字符串中创建并返回的颜色对象。
 
 @讨论:
 有效格式: #RGB #RGBA #RRGGBB #RRGGBBAA 0xRGB ...
 '#'和'0x'标志是不需要的。
 如果透明度设置为1.0将没有透明度。如果解析中发送错误返回nil.
 
 例如: @"0xF0F", @"66ccff", @"#66CCFF88"
 
 @param hexStr  十六进制字符串值.
 
 @return        UIColor对象, 如果出错返回nil.
 */
+ (nullable UIColor *)wl_hexString:(NSString *)hexStr {
    CGFloat r, g, b, a;
    if (hexStrToRGBA(hexStr, &r, &g, &b, &a)) {
        return [UIColor colorWithRed:r green:g blue:b alpha:a];
    }
    return nil;
}


#pragma mark - Get color's description
///=============================================================================
/// @name Get 颜色的描述
///=============================================================================

/**
 返回十六进制的RGB值
 @return 十六进制RGB值,如： 0x66ccff.
 */
- (uint32_t)wl_rgbValue {
    return [self rgbValue];
}

/**
 返回十六进制的RGBA值.
 
 @return 十六进制RGBA值，如：0x66ccffff.
 */
- (uint32_t)wl_rgbaValue {
    return [self rgbaValue];
}

/**
 返回十六进制RGB值的字符串（小写），如：@"0066cc".
 如果色值不是RGB返回nil.
 @return 颜色的十六进制字符串.
 */
- (nullable NSString *)wl_hexString {
    return [self hexString];
}

/**
 返回十六进制RGBA值字符串(小写).如：@"0066ccff".
 如果色值不是RGBA值返回nil.
 @return 颜色的十六进制字符串.
 */
- (nullable NSString *)wl_hexStringWithAlpha {
    return [self wl_hexStringWithAlpha:YES];
}

- (NSString *)wl_hexStringWithAlpha:(BOOL)withAlpha {
    CGColorRef color = self.CGColor;
    size_t count = CGColorGetNumberOfComponents(color);
    const CGFloat *components = CGColorGetComponents(color);
    static NSString *stringFormat = @"%02x%02x%02x";
    NSString *hex = nil;
    if (count == 2) {
        NSUInteger white = (NSUInteger)(components[0] * 255.0f);
        hex = [NSString stringWithFormat:stringFormat, white, white, white];
    } else if (count == 4) {
        hex = [NSString stringWithFormat:stringFormat,
               (NSUInteger)(components[0] * 255.0f),
               (NSUInteger)(components[1] * 255.0f),
               (NSUInteger)(components[2] * 255.0f)];
    }
    
    if (hex && withAlpha) {
        hex = [hex stringByAppendingFormat:@"%02lx",
               (unsigned long)(self.wl_alpha * 255.0 + 0.5)];
    }
    return hex;
}


#pragma mark - Retrieving Color Information
///=============================================================================
/// @name 获取颜色信息
///=============================================================================
/**
 在RGB颜色空间的红色色值。
 此属性的值范围是：0.0到1.0。
 */
- (CGFloat)wl_red {
    return [self red];
}

/**
 在RGB颜色空间的绿色色值。
 此属性的值范围是：0.0到1.0。
 */
- (CGFloat)wl_green {
    return [self green];
}

/**
 在RGB颜色空间的蓝色色值。
 此属性的值范围是：0.0到1.0。
 */
- (CGFloat)wl_blue {
    return [self blue];
}

/**
 在HSB颜色空间的色调值。
 此属性的值范围是：0.0到1.0。
 */
- (CGFloat)wl_hue {
    return [self hue];
}

/**
 在HSB颜色空间的饱和度值。
 此属性的值范围是：0.0到1.0。
 */
- (CGFloat)wl_saturation {
    return [self saturation];
}

/**
 在HSB颜色空间的亮度值。
 此属性的值范围是：0.0到1.0。
 */
- (CGFloat)wl_brightness {
    return [self brightness];
}

/**
 颜色的透明度值。
 此属性的值范围是：0.0到1.0。
 */
- (CGFloat)wl_alpha {
    return [self alpha];
}

/**
 颜色的颜色空间模型
 */
- (CGColorSpaceModel)wl_colorSpaceModel {
    return [self colorSpaceModel];
}

/**
 颜色控件字符串
 */
- (NSString *)wl_colorSpaceString {
    return [self colorSpaceString];
}


+ (CAGradientLayer *)gradualChangingColorWithSize:(CGSize)size colors:(NSArray<UIColor *> *)colors {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, size.width, size.height);
    //  创建渐变色数组，需要转换为CGColor颜色
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:colors.count];
    for (UIColor *color in colors) {
        [arr appendObject:(__bridge id)color.CGColor];
    }
    gradientLayer.colors = arr;
    //(0,0)(1.0,0)代表水平方向渐变,(0,0)(0,1.0)代表竖直方向渐变
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    //  设置颜色变化点，取值范围 0.0~1.0
    gradientLayer.locations = @[@0,@1];
    return gradientLayer;
}

@end

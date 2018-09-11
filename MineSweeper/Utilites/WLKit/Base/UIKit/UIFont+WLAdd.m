//
//  UIFont+WLAdd.m
//  Welian_Normal_Demo
//
//  Created by weLian on 16/6/8.
//  Copyright © 2016年 杭州传送门网络科技有限公司. All rights reserved.
//

#import "UIFont+WLAdd.h"
#import "WLCGUtilities.h"

WLSYNTH_DUMMY_CLASS(UIFont_WLAdd)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wprotocol"
// Apple has implemented UIFont<NSCoding>, but did not make it public.

@implementation UIFont (WLAdd)

#pragma mark - Font Traits
///=============================================================================
/// @name Font 特性
///=============================================================================

///< 字体是否为黑体. 自IOS7.0开始支持
- (BOOL)wl_isBold {
    return [self isBold];
}

///< 字体是否为斜体
- (BOOL)wl_isItalic {
    return [self isItalic];
}

///< 字体是否为单空间.
- (BOOL)wl_isMonoSpace {
    return [self isMonoSpace];
}

///< 字体是否为颜色符号(如 Emoji).
- (BOOL)wl_isColorGlyphs {
    return [self isColorGlyphs];
}

///< 字体重量从-1.0 到 1.0. 规定的权重为0.0.
- (CGFloat)wl_fontWeight {
    return [self fontWeight];
}

/**
 创建一个黑体字体，如果出错返回nil.
 */
- (UIFont *)wl_fontWithBold {
    return [self fontWithBold];
}

/**
 创建一个斜体字体，如果出错返回nil.
 */
- (UIFont *)wl_fontWithItalic {
    return [self fontWithItalic];
}

/**
 创建一个斜体和黑体的字体，如果出错返回nil.
 */
- (UIFont *)wl_fontWithBoldItalic {
    return [self fontWithBoldItalic];
}

/**
 创建一个正常的字体。(no bold/italic/...)。如果出错返回nil.
 */
- (UIFont *)wl_fontWithNormal {
    return [self fontWithNormal];
}

#pragma mark - Create font
///=============================================================================
/// @name 创建字体
///=============================================================================

/**
 通过指定的CTFontRef创建字体对象。
 
 @param CTFont  CoreText字体.
 */
+ (nullable UIFont *)wl_fontWithCTFont:(CTFontRef)CTFont {
    return [self fontWithCTFont:CTFont];
}

/**
 通过指定的CGFontRef和大小创建字体对象。
 
 @param CGFont  CoreGraphic字体.
 @param size    Font大小.
 */
+ (nullable UIFont *)wl_fontWithCGFont:(CGFontRef)CGFont size:(CGFloat)size {
    return [self fontWithCGFont:CGFont size:size];
}

/**
 创建和返回CTFontRef对象。（使用后需要调用CFRelease()）
 */
- (nullable CTFontRef)CTFontRef CF_RETURNS_RETAINED {
    CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)self.fontName, self.pointSize, NULL);
    return font;
}

/**
 创建和返回CGFontRef对象。（使用后需要调用CFRelease()）
 */
- (nullable CGFontRef)CGFontRef CF_RETURNS_RETAINED {
    CGFontRef font = CGFontCreateWithFontName((__bridge CFStringRef)self.fontName);
    return font;
}


#pragma mark - Load and unload font
///=============================================================================
/// @name 加载和卸载字体
///=============================================================================

/**
 从文件路径加载字体。支持格式：TTF，OTF。
 如果返回YES，字体可以通过它的附带名字加载使用：[UIFont fontWithName:...]
 
 @param path    字体文件的完整路径
 */
+ (BOOL)wl_loadFontFromPath:(NSString *)path {
    return [self loadFontFromPath:path];
}

/**
 从文件路径卸载字体。
 @param path    字体文件的完整路径
 */
+ (void)wl_unloadFontFromPath:(NSString *)path {
    return [self unloadFontFromPath:path];
}

/**
 从data中加载字体。支持格式：TTF，OTF。
 
 @param data  字体数据.
 @return 如果加载成功返回UIFont，否则为nil.
 */
+ (nullable UIFont *)wl_loadFontFromData:(NSData *)data {
    return [self loadFontFromData:data];
}

/**
 卸载通过loadFontFromData:方法加载的字体。
 
 @param font 通过loadFontFromData:方法加载的字体。
 @return 成功返回YES, 否则NO.
 */
+ (BOOL)wl_unloadFontFromData:(UIFont *)font {
    return [self unloadFontFromData:font];
}


#pragma mark - Dump font data
///=============================================================================
/// @name 字体数据转换
///=============================================================================

/**
 序列化并返回字体数据。
 
 @param font 字体.
 @return TTF中的数据, 如果出错为nil.
 */
+ (nullable NSData *)wl_dataFromFont:(UIFont *)font {
    return [self dataFromFont:font];
}

/**
 序列化并返回字体数据。
 
 @param cgFont 字体对象.
 @return TTF中的数据, 如果出错返回nil.
 */
//Reference:
//https://github.com/google/skia/blob/master/src%2Fports%2FSkFontHost_mac.cpp
+ (nullable NSData *)wl_dataFromCGFont:(CGFontRef)cgFont {
    return [self dataFromCGFont:cgFont];
}

@end


#pragma clang diagnostic pop




//
//  UIFont+WLAdd.h
//  Welian_Normal_Demo
//
//  Created by weLian on 16/6/8.
//  Copyright © 2016年 杭州传送门网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreText/CoreText.h>

/*
 NS_ASSUME_NONNULL_BEGIN  NS_ASSUME_NONNULL_END
 在这两个宏之间的代码，所有简单指针对象都被假定为nonnull，因此我们只需要去指定那些nullable的指针。
 */
NS_ASSUME_NONNULL_BEGIN

/*
 UIFont的扩展类
 */
@interface UIFont (WLAdd)

#pragma mark - Font Traits
///=============================================================================
/// @name Font 特性
///=============================================================================

///< 字体是否为黑体. 自IOS7.0开始支持
@property (nonatomic, readonly) BOOL wl_isBold NS_AVAILABLE_IOS(7_0);
///< 字体是否为斜体
@property (nonatomic, readonly) BOOL wl_isItalic NS_AVAILABLE_IOS(7_0);
///< 字体是否为单空间.
@property (nonatomic, readonly) BOOL wl_isMonoSpace NS_AVAILABLE_IOS(7_0);
///< 字体是否为颜色符号(如 Emoji).
@property (nonatomic, readonly) BOOL wl_isColorGlyphs NS_AVAILABLE_IOS(7_0);
///< 字体重量从-1.0 到 1.0. 规定的权重为0.0.
@property (nonatomic, readonly) CGFloat wl_fontWeight NS_AVAILABLE_IOS(7_0);

/**
 创建一个黑体字体，如果出错返回nil.
 */
- (nullable UIFont *)wl_fontWithBold NS_AVAILABLE_IOS(7_0);

/**
 创建一个斜体字体，如果出错返回nil.
 */
- (nullable UIFont *)wl_fontWithItalic NS_AVAILABLE_IOS(7_0);

/**
 创建一个斜体和黑体的字体，如果出错返回nil.
 */
- (nullable UIFont *)wl_fontWithBoldItalic NS_AVAILABLE_IOS(7_0);

/**
 创建一个正常的字体。(no bold/italic/...)。如果出错返回nil.
 */
- (nullable UIFont *)wl_fontWithNormal NS_AVAILABLE_IOS(7_0);

#pragma mark - Create font
///=============================================================================
/// @name 创建字体
///=============================================================================

/**
 通过指定的CTFontRef创建字体对象。
 
 @param CTFont  CoreText字体.
 */
+ (nullable UIFont *)wl_fontWithCTFont:(CTFontRef)CTFont;

/**
 通过指定的CGFontRef和大小创建字体对象。
 
 @param CGFont  CoreGraphic字体.
 @param size    Font大小.
 */
+ (nullable UIFont *)wl_fontWithCGFont:(CGFontRef)CGFont size:(CGFloat)size;

/**
 创建和返回CTFontRef对象。（使用后需要调用CFRelease()）
 */
- (nullable CTFontRef)CTFontRef CF_RETURNS_RETAINED;

/**
 创建和返回CGFontRef对象。（使用后需要调用CFRelease()）
 */
- (nullable CGFontRef)CGFontRef CF_RETURNS_RETAINED;


#pragma mark - Load and unload font
///=============================================================================
/// @name 加载和卸载字体
///=============================================================================

/**
 从文件路径加载字体。支持格式：TTF，OTF。
 如果返回YES，字体可以通过它的附带名字加载使用：[UIFont fontWithName:...]
 
 @param path    字体文件的完整路径
 */
+ (BOOL)wl_loadFontFromPath:(NSString *)path;

/**
 从文件路径卸载字体。
 @param path    字体文件的完整路径
 */
+ (void)wl_unloadFontFromPath:(NSString *)path;

/**
 从data中加载字体。支持格式：TTF，OTF。
 
 @param data  字体数据.
 @return 如果加载成功返回UIFont，否则为nil.
 */
+ (nullable UIFont *)wl_loadFontFromData:(NSData *)data;

/**
 卸载通过loadFontFromData:方法加载的字体。
 
 @param font 通过loadFontFromData:方法加载的字体。
 @return 成功返回YES, 否则NO.
 */
+ (BOOL)wl_unloadFontFromData:(UIFont *)font;


#pragma mark - Dump font data
///=============================================================================
/// @name 字体数据转换
///=============================================================================

/**
 序列化并返回字体数据。
 
 @param font 字体.
 @return TTF中的数据, 如果出错为nil.
 */
+ (nullable NSData *)wl_dataFromFont:(UIFont *)font;

/**
 序列化并返回字体数据。
 
 @param cgFont 字体对象.
 @return TTF中的数据, 如果出错返回nil.
 */
+ (nullable NSData *)wl_dataFromCGFont:(CGFontRef)cgFont;

@end

NS_ASSUME_NONNULL_END


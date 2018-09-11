//
//  UIColor+WLAdd.h
//  Welian
//
//  Created by weLian on 16/5/13.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 NS_ASSUME_NONNULL_BEGIN  NS_ASSUME_NONNULL_END
 在这两个宏之间的代码，所有简单指针对象都被假定为nonnull，因此我们只需要去指定那些nullable的指针。
 */
NS_ASSUME_NONNULL_BEGIN

/**
 *  系统颜色
 *
 *  @param r
 *  @param g
 *  @param b
 *
 *  @return
 */
#define WLRGBA(r, g, b, a)      [UIColor wl_red:r green:g blue:b alpha:a]
#define WLRGB(r, g, b)          [UIColor wl_red:r green:g blue:b]
#define WLColoerRGB(rgb)        WLRGB(rgb, rgb, rgb)

// 3.全局背景色
#define kWLNormalBgColor_242        WLRGB(242, 242, 242)
#define kWLNormalBgColor_239        WLRGB(239, 239, 239)
#define kWLNormalNavBgColor_249     WLRGB(249.f, 249.f, 249.f)
#define kWLNormalBgColor_245        WLRGB(240, 240, 240)

//常用系统颜色
#define kWLNormalTextColor_173      WLRGB(173.f, 173.f, 173.f)
#define kWLNormalTextColor_51       WLRGB(51.f, 51.f, 51.f)

#define kWLNormalTextColor_85       WLRGB(85.f, 85.f, 85.f)
#define kWLNormalTextColor_125      WLRGB(125.f, 125.f, 125.f)
#define kWLNormalTextColor_153      WLRGB(153.f, 153.f, 153.f)
#define kWLNormalTextColor_155      WLRGB(155.f, 155.f, 155.f)
#define kWLNormalTextColor_197      WLRGB(197.f, 197.f, 197.f)
#define kWLNormalTextColor_231      WLRGB(231.f, 231.f, 231.f)
#define kWLNormalTextColor_239      WLRGB(239.f, 239.f, 239.f)
#define kWLNormalTextColor_247      WLRGB(247.f, 247.f, 247.f)
#define kWLNormalTextColor_242      WLRGB(242.f, 242.f, 242.f)

#define kWLNormalCommentColor       WLRGB(117.f, 191.f, 222.f)

#define kWLNormalYellowTextColor    WLRGB(251.f,178.f,23.f)
#define kWLNormalYellowBgColor      WLRGB(255.f, 249.f, 235.f)
#define kWLNormalGrayTextColor      WLRGB(135.f, 135.f, 136.f)
#define kWLNormalRedTextColor       WLRGB(233.f, 83.f, 70.f)

#define kWLNormalBtnJieShouColor    WLRGB(79.f, 191.f, 232.f)

#define kWLRetweetHighlightColor_242        WLRGB(242.f, 242.f, 242.f)
#define kWLRetweetBackgroundColor_252     WLRGB(252.f, 252.f, 252.f)

// 线条浅灰颜色
#define kWLNormalLineColor          WLRGB(232.f, 234.f, 239.f)
#define kWLNormalColor_229          WLRGB(229.f, 229.f, 229.f)
#define kWLNormalGrayColor_204      WLRGB(204.f, 204.f, 204.f)

//背景灰色
#define kWLNormalLightGrayColor     WLRGB(236.f, 238.f, 241.f)
#define kWLNormalBgGrayColor        WLRGB(212.f, 214.f, 216.f)
#define kWLNormalBgGrayTextColor    WLRGB(163.f, 163.f, 169.f)

/**
 UIColor提供的一些在RGB,HSB,HSL,CMYK和Hex颜色之间的转换方法
 
 | 颜色区域 | 表示意义                                     |
 |-------------|----------------------------------------|
 | RGB *       | 红, 绿, 蓝                              |
 | HSB(HSV) *  | 色相, 饱和度, 亮度 (值)                   |
 | HSL         | 色相, 饱和度, 亮度                        |
 | CMYK        | 青色, 洋红, 黄色, 黑色                    |
 
 苹果使用默认的RGB和HSB.
 这一类所有的值的取值范围在0.0到1.0。 值低于0.0被解析为0，值大于1被解析为1。
 如果你想要更多的色彩空间之间的转换颜色(CIEXYZ,Lab,YUV...),
 查看 https://github.com/ibireme/yy_color_convertor
 */
@interface UIColor (WLAdd)

#pragma mark - 微链在用颜色
/** 蓝色 */
+ (UIColor *)wl_Hex305AFA;
+ (UIColor *)wl_Hex5AA0FF;

+ (UIColor *)wl_hex0F6EF4;

+ (UIColor *)wl_Hex48C4F7;
+ (UIColor *)wl_HexCCEDFC;
+ (UIColor *)wl_HexF6FBFF;
+ (UIColor *)wl_HexECF7FE;
+ (UIColor *)wl_HexF9FAFC;

/** 黑灰 */
+ (UIColor *)wl_Hex333333;
+ (UIColor *)wl_Hex666666;
+ (UIColor *)wl_Hex555555;
+ (UIColor *)wl_Hex999999;
+ (UIColor *)wl_HexADADAD;
+ (UIColor *)wl_HexCCCCCC;
+ (UIColor *)wl_HexE5E5E5;
+ (UIColor *)wl_HexEFEFEF;
+ (UIColor *)wl_HexF2F2F2;
+ (UIColor *)wl_HexF5F5F5;
+ (UIColor *)wl_HexFAFAFA;
+ (UIColor *)wl_HexBDBDBD;

/** 红色 */
+ (UIColor *)wl_HexFF5336;
// 系统角标和删除色
+ (UIColor *)wl_HexFF3B30;

/** 彩色 */
+ (UIColor *)wl_HexFF9729;

+ (UIColor *)wl_HexFBB217;
+ (UIColor *)wl_HexFF5B36;
+ (UIColor *)wl_HexFFC355;
+ (UIColor *)wl_HexFFC55C;
+ (UIColor *)wl_Hex00C2D0;
+ (UIColor *)wl_HexFEA66A;
+ (UIColor *)wl_Hex7D7D7D;
+ (UIColor *)wl_HexFFF8EF;
+ (UIColor *)wl_HexC7C7CD;
+ (UIColor *)wl_HexFFAB1F;
+ (UIColor *)wl_HexFFF5E4;
+ (UIColor *)wl_HexC59F68;
+ (UIColor *)wl_HexF3CF87;
+ (UIColor *)wl_HexCBA161;
+ (UIColor *)wl_HexA09CAE;
+ (UIColor *)wl_Hex9793A6;
+ (UIColor *)wl_HexC7C4D1;

#pragma mark - Normal
///=============================================================================
/// @name 常用的UIColor操作
///=============================================================================

/**
*  @author liuwu     , 16-05-19
*
*  获取随机颜色
*  @return 颜色
*  @since V2.7.9
*/
+ (UIColor *)wl_randomColor;


#pragma mark - Create a UIColor Object
///=============================================================================
/// @name 创建一个UIColor对象
///=============================================================================

///根据给定的rgba值，返回颜色对象
+ (UIColor *)wl_red:(CGFloat)red
              green:(CGFloat)green
               blue:(CGFloat)blue
              alpha:(CGFloat)alpha;

///根据给定的rgb值，返回颜色对象
+ (UIColor *)wl_red:(CGFloat)red
              green:(CGFloat)green
               blue:(CGFloat)blue;

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
+ (nullable UIColor *)wl_hexString:(NSString *)hexStr;


#pragma mark - Get color's description
///=============================================================================
/// @name Get 颜色的描述
///=============================================================================

/**
 返回十六进制的RGB值
 @return 十六进制RGB值,如： 0x66ccff.
 */
- (uint32_t)wl_rgbValue;

/**
 返回十六进制的RGBA值.
 
 @return 十六进制RGBA值，如：0x66ccffff.
 */
- (uint32_t)wl_rgbaValue;

/**
 返回十六进制RGB值的字符串（小写），如：@"0066cc".
 如果色值不是RGB返回nil.
 @return 颜色的十六进制字符串.
 */
- (nullable NSString *)wl_hexString;

/**
 返回十六进制RGBA值字符串(小写).如：@"0066ccff".
 如果色值不是RGBA值返回nil.
 @return 颜色的十六进制字符串.
 */
- (nullable NSString *)wl_hexStringWithAlpha;


#pragma mark - Retrieving Color Information
///=============================================================================
/// @name 获取颜色信息
///=============================================================================
/**
 在RGB颜色空间的红色色值。
 此属性的值范围是：0.0到1.0。
 */
@property (nonatomic, readonly) CGFloat wl_red;

/**
 在RGB颜色空间的绿色色值。
 此属性的值范围是：0.0到1.0。
 */
@property (nonatomic, readonly) CGFloat wl_green;

/**
 在RGB颜色空间的蓝色色值。
 此属性的值范围是：0.0到1.0。
 */
@property (nonatomic, readonly) CGFloat wl_blue;

/**
 在HSB颜色空间的色调值。
 此属性的值范围是：0.0到1.0。
 */
@property (nonatomic, readonly) CGFloat wl_hue;

/**
 在HSB颜色空间的饱和度值。
 此属性的值范围是：0.0到1.0。
 */
@property (nonatomic, readonly) CGFloat wl_saturation;

/**
 在HSB颜色空间的亮度值。
 此属性的值范围是：0.0到1.0。
 */
@property (nonatomic, readonly) CGFloat wl_brightness;

/**
 颜色的透明度值。
 此属性的值范围是：0.0到1.0。
 */
@property (nonatomic, readonly) CGFloat wl_alpha;

/**
 颜色的颜色空间模型
 */
@property (nonatomic, readonly) CGColorSpaceModel wl_colorSpaceModel;

/**
 颜色控件字符串
 */
@property (nullable, nonatomic, readonly) NSString *wl_colorSpaceString;

//颜色渐变
+ (CAGradientLayer *)gradualChangingColorWithSize:(CGSize)size colors:(NSArray<UIColor *> *)colors;

@end

NS_ASSUME_NONNULL_END

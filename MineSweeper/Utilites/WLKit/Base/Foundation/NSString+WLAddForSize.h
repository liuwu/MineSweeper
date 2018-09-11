//
//  NSString+WLAddForSize.h
//  Welian
//
//  Created by weLian on 16/5/9.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 NS_ASSUME_NONNULL_BEGIN  NS_ASSUME_NONNULL_END
 在这两个宏之间的代码，所有简单指针对象都被假定为nonnull，因此我们只需要去指定那些nullable的指针。
 */
NS_ASSUME_NONNULL_BEGIN

/**
 *  @author liuwu     , 16-05-09
 *
 *  字符串的大小计算
 *  @since V2.7.9.1
 */
@interface NSString (WLAddForSize)

/**
 *  @author dong, 16-03-09 15:03:08
 *
 *  计算字符串高度（height）
 *
 *  @param font  字体
 *  @param width 给定宽度
 *
 *  @return 返回高度（height）
 */
- (CGFloat)wl_heightWithFont:(UIFont *)font
          constrainedToWidth:(CGFloat)width;

/**
 *  @author dong, 16-03-09 15:03:08
 *
 *  计算字符串高度 （height）
 *
 *  @param font  字体
 *  @param width 给定宽度
 *  @param lineSpacing 字符串 行间隔
 *
 *  @return 返回高度 （height）
 */
- (CGFloat)wl_heightWithFont:(UIFont *)font
          constrainedToWidth:(CGFloat)width
                 lineSpacing:(CGFloat)lineSpacing;

/**
 *  @author dong, 16-03-09 15:03:08
 *
 *  计算字符串宽度
 *
 *  @param font  字体
 *  @param height 给定高度
 *
 *  @return 返回宽度
 */
- (CGFloat)wl_widthWithFont:(UIFont *)font
        constrainedToHeight:(CGFloat)height;

/**
 *  @author dong, 16-03-09 15:03:08
 *
 *  计算字符串宽度
 *
 *  @param font  字体
 *  @param height 给定高度
 *  @param lineSpacing 字符串 行间隔
 *
 *  @return 返回宽度
 */
- (CGFloat)wl_widthWithFont:(UIFont *)font
        constrainedToHeight:(CGFloat)height
                lineSpacing:(CGFloat)lineSpacing;

/**
 *  @author dong, 16-03-09 15:03:08
 *
 *  计算字符串size
 *
 *  @param font  字体
 *  @param width 给定宽度
 *
 *  @return 返回size
 */
- (CGSize)wl_sizeWithFont:(UIFont *)font
       constrainedToWidth:(CGFloat)width;

/**
 *  @author dong, 16-03-09 15:03:08
 *
 *  计算字符串高度
 *
 *  @param font  字体
 *  @param width 给定宽度
 *  @param lineSpacing 字符串 行间隔
 *
 *  @return 返回高度
 */
- (CGSize)wl_sizeWithFont:(UIFont *)font
       constrainedToWidth:(CGFloat)width
              lineSpacing:(CGFloat)lineSpacing;

/**
 *  @author dong, 16-03-09 15:03:08
 *
 *  计算字符串高度
 *
 *  @param font  字体
 *  @param width 给定宽度
 *
 *  @return 返回高度
 */
- (CGSize)wl_sizeWithFont:(UIFont *)font
      constrainedToHeight:(CGFloat)height;

/**
 *  @author dong, 16-03-09 15:03:08
 *
 *  计算字符串size
 *
 *  @param font  字体
 *  @param height 给定高度
 *  @param lineSpacing 字符串 行间隔
 *
 *  @return 返回size
 */
- (CGSize)wl_sizeWithFont:(UIFont *)font
      constrainedToHeight:(CGFloat)height
              lineSpacing:(CGFloat)lineSpacing;

/**
 *  @author dong, 16-03-09 16:03:10
 *
 *  计算单行宽高
 *  @param font 字体
 *  @return return value description
 */
- (CGSize)wl_sizeWithCustomFont:(UIFont*)font;

/**
 *  @author dong, 16-03-09 15:03:28
 *
 *  翻转字符串 ABC ---> CBA
 *  @param strSrc strSrc description
 *
 *  @return return value description
 */
+ (NSString *)wl_reverseString:(NSString *)strSrc;

@end

NS_ASSUME_NONNULL_END

//
//  NSString+WLAddForPinyin.h
//  Welian
//
//  Created by weLian on 16/5/12.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 NS_ASSUME_NONNULL_BEGIN  NS_ASSUME_NONNULL_END
 在这两个宏之间的代码，所有简单指针对象都被假定为nonnull，因此我们只需要去指定那些nullable的指针。
 */
NS_ASSUME_NONNULL_BEGIN

@interface NSString (WLAddForPinyin)

/**
 *  @author liuwu     , 16-05-12
 *
 *  汉子的首字母拼音
 *  @return 首字母字符串
 *  @since V2.7.9
 */
- (NSString *)wl_hanziFirstPinyin;

/**
 *  @author liuwu     , 16-05-12
 *
 *  转化为带音标的拼音
 *  @return 转化后的拼音字符串
 *  @since V2.7.9
 */
- (NSString *)wl_pinyinWithPhoneticSymbol;

/**
 *  @author liuwu     , 16-05-12
 *
 *  汉子转化为拼音，不带音标
 *  @return 转化后的拼音字符串
 *  @since V2.7.9
 */
- (NSString *)wl_pinyin;

/**
 *  @author liuwu     , 16-05-12
 *
 *  汉子转化为拼音数组
 *  @return 拼音数组
 *  @since V2.7.9
 */
- (NSArray *)wl_pinyinArray;

/**
 *  @author liuwu     , 16-05-12
 *
 *  汉子转化为拼音不带空格
 *  @return 拼音字符串
 *  @since V2.7.9
 */
- (NSString *)wl_pinyinWithoutBlank;

/**
 *  @author liuwu     , 16-05-12
 *
 *  汉子拼音的首字母数组
 *  @return 首字母数组
 *  @since V2.7.9
 */
- (NSArray *)wl_pinyinInitialsArray;

/**
 *  @author liuwu     , 16-05-12
 *
 *  汉子首字母的拼音字符串
 *  @return 首字母字符串
 *  @since V2.7.9
 */
- (NSString *)wl_pinyinInitialsString;

@end

NS_ASSUME_NONNULL_END

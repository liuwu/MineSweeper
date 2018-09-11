//
//  NSString+WLAddForPinyin.m
//  Welian
//
//  Created by weLian on 16/5/12.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import "NSString+WLAddForPinyin.h"
#import "WLCGUtilities.h"

WLSYNTH_DUMMY_CLASS(NSString_WLAddForPinyin)

//#import "PinYin4Objc.h"

@implementation NSString (WLAddForPinyin)

/**
 *  @author liuwu     , 16-05-12
 *
 *  汉子的首字母拼音
 *  @return 首字母字符串
 *  @since V2.7.9
 */
- (NSString *)wl_hanziFirstPinyin {
    if (self.length == 0) return @"";
    NSString *firstHanzi = [self substringToIndex:1];
    NSString *pinyin = [[[firstHanzi wl_pinyin] substringToIndex:1] uppercaseString];
    return pinyin;
    /*
     第三方的获取方法
     //格式类型
     HanyuPinyinOutputFormat *outputFormat=[[HanyuPinyinOutputFormat alloc] init];
     [outputFormat setToneType:ToneTypeWithoutTone];
     [outputFormat setVCharType:VCharTypeWithV];
     [outputFormat setCaseType:CaseTypeLowercase];
     
     NSString *outputPinyin=[PinyinHelper toHanyuPinyinStringWithNSString:[self substringToIndex:1] withHanyuPinyinOutputFormat:outputFormat withNSString:@" "];
     return [[NSString stringWithFormat:@"%c",[outputPinyin characterAtIndex:0]] uppercaseString];
     */
}

/**
 *  @author liuwu     , 16-05-12
 *
 *  汉子转化为带音标的拼音
 *  @return 转化后的拼音字符串
 *  @since V2.7.9
 */
- (NSString *)wl_pinyinWithPhoneticSymbol {
    NSMutableString *pinyin = [NSMutableString stringWithString:self];
    CFStringTransform((__bridge CFMutableStringRef)(pinyin), NULL, kCFStringTransformMandarinLatin, NO);
    return pinyin;
}

/**
 *  @author liuwu     , 16-05-12
 *
 *  汉子转化为拼音，不带音标
 *  @return 转化后的拼音字符串
 *  @since V2.7.9
 */
- (NSString *)wl_pinyin {
    NSMutableString *pinyin = [NSMutableString stringWithString:[self wl_pinyinWithPhoneticSymbol]];
    CFStringTransform((__bridge CFMutableStringRef)(pinyin), NULL, kCFStringTransformStripCombiningMarks, NO);
    return pinyin;
}

/**
 *  @author liuwu     , 16-05-12
 *
 *  汉子转化为拼音数组
 *  @return 拼音数组
 *  @since V2.7.9
 */
- (NSArray *)wl_pinyinArray {
    NSArray *array = [[self wl_pinyin] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return array;
}

/**
 *  @author liuwu     , 16-05-12
 *
 *  汉子转化为拼音不带空格
 *  @return 拼音字符串
 *  @since V2.7.9
 */
- (NSString *)wl_pinyinWithoutBlank {
    NSMutableString *string = [NSMutableString stringWithString:@""];
    for (NSString *str in [self wl_pinyinArray]) {
        [string appendString:str];
    }
    return string;
}

/**
 *  @author liuwu     , 16-05-12
 *
 *  汉子拼音的首字母数组
 *  @return 首字母数组
 *  @since V2.7.9
 */
- (NSArray *)wl_pinyinInitialsArray {
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *str in [self wl_pinyinArray]) {
        if ([str length] > 0) {
            [array addObject:[str substringToIndex:1]];
        }
    }
    return array;
}

/**
 *  @author liuwu     , 16-05-12
 *
 *  汉子首字母的拼音字符串
 *  @return 首字母字符串
 *  @since V2.7.9
 */
- (NSString *)wl_pinyinInitialsString {
    NSMutableString *pinyin = [NSMutableString stringWithString:@""];
    for (NSString *str in [self wl_pinyinArray]) {
        if ([str length] > 0) {
            [pinyin appendString:[str substringToIndex:1]];
        }
    }
    return pinyin;
}

@end

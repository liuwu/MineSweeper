//
//  NSString+WLAddForRegex.h
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
 *  字符串的相关正则验证
 *  @since V2.7.9
 */
@interface NSString (WLAddForRegex)

/**
*  @author liuwu     , 16-05-09
*
*  手机号码的有效性:分电信、联通、移动和小灵通 ,是否是中国的手机号码
*  @return 手机号码是否有效
*  @since V2.7.9.1
*/
- (BOOL)wl_isMobileNumberClassification;

/**
 *  @author liuwu     , 16-05-09
 *
 *  手机号有效性验证
 *  @return 手机号是否有效
 *  @since V2.7.9
 */
- (BOOL)wl_isMobileNumber;

/**
 *  @author liuwu     , 16-05-09
 *
 *  手机号是否有效
 *  @return YES or NO
 *  @since V2.7.9
 */
- (BOOL)wl_isValidPhoneNumber;

/**
 *  @author liuwu     , 16-05-09
 *
 *  密码是否有效
 *  @return YES or NO
 *  @since V2.7.9
 */
- (BOOL)wl_isValidPassword;

/**
 *  @author liuwu     , 16-05-09
 *
 *  邮箱的有效性验证
 *  @return 是否邮箱
 *  @since V2.7.9
 */
- (BOOL)wl_isEmailAddress;

/**
 *  @author liuwu     , 16-05-09
 *
 *  网页地址的有效性
 *  @return 是否网页地址
 *  @since V2.7.9
 */
- (BOOL)wl_isValidUrl;

/**
 *  @author liuwu     , 16-05-09
 *
 *  车牌号的有效性验证
 *  @return 是否车牌号
 *  @since V2.7.9
 */
- (BOOL)wl_isCarNumber;

/**
 *  @author liuwu     , 16-05-09
 *
 *  IP地址有效性
 *  @return YES or NO
 *  @since V2.7.9
 */
- (BOOL)wl_isIPAddress;

/**
 *  @author liuwu     , 16-05-09
 *
 *  Mac地址有效性
 *  @return YES or NO
 *  @since V2.7.9
 */
- (BOOL)wl_isMacAddress;

/**
 *  @author liuwu     , 16-05-09
 *
 *  是否纯汉字
 *  @return YES or NO
 *  @since V2.7.9
 */
- (BOOL)wl_isValidChinese;

/**
 *  @author liuwu     , 16-05-09
 *
 *  是否邮政编码
 *  @return YES or NO
 *  @since V2.7.9
 */
- (BOOL)wl_isValidPostalcode;

/**
 *  @author liuwu     , 16-05-09
 *
 *  是否工商税号
 *  @return YES or NO
 *  @since V2.7.9
 */
- (BOOL)wl_isValidTaxNo;

/**
 @brief     是否符合最小长度、最长长度，是否包含中文,首字母是否可以为数字
 @param     minLenth 账号最小长度
 @param     maxLenth 账号最长长度
 @param     containChinese 是否包含中文
 @param     firstCannotBeDigtal 首字母不能为数字
 @return    正则验证成功返回YES, 否则返回NO
 */
- (BOOL)wl_isValidWithMinLenth:(NSInteger)minLenth
                      maxLenth:(NSInteger)maxLenth
                containChinese:(BOOL)containChinese
           firstCannotBeDigtal:(BOOL)firstCannotBeDigtal;

/**
 @brief     是否符合最小长度、最长长度，是否包含中文,数字，字母，其他字符，首字母是否可以为数字
 @param     minLenth 账号最小长度
 @param     maxLenth 账号最长长度
 @param     containChinese 是否包含中文
 @param     containDigtal   包含数字
 @param     containLetter   包含字母
 @param     containOtherCharacter   其他字符
 @param     firstCannotBeDigtal 首字母不能为数字
 @return    正则验证成功返回YES, 否则返回NO
 */
- (BOOL)wl_isValidWithMinLenth:(NSInteger)minLenth
                      maxLenth:(NSInteger)maxLenth
                containChinese:(BOOL)containChinese
                 containDigtal:(BOOL)containDigtal
                 containLetter:(BOOL)containLetter
         containOtherCharacter:(NSString *)containOtherCharacter
           firstCannotBeDigtal:(BOOL)firstCannotBeDigtal;

/**
 *  @author liuwu     , 16-05-09
 *
 *  简单的身份证有效性
 *  @return 身份证是否有效
 *  @since V2.7.9
 */
- (BOOL)wl_simpleVerifyIdentityCardNum;

/**
 *  精确的身份证号码有效性检测
 *
 *  @param value 身份证号
 */
+ (BOOL)wl_accurateVerifyIDCardNumber:(NSString *)value;

/**
 *  银行卡的有效性
 */
- (BOOL)wl_bankCardluhmCheck;


/**
 是否能够匹配正则表达式
 
 @param regex  正则表达式
 @param options     普配方式.
 @return YES：如果可以匹配正则表达式; 否则,NO.
 */
- (BOOL)wl_matchesRegex:(NSString *)regex options:(NSRegularExpressionOptions)options;

/**
 匹配正则表达式，并使用匹配的每个对象执行给定的块。
 
 @param regex    正则表达式
 @param options  上报的匹配选项.
 @param block    应用于在数组元素中匹配的块.
 该块需要四个参数:
 match: 匹配的子串.
 matchRange: 匹配选项.
 stop: 一个布尔值的引用。块可以设置YES来停止处理阵列。stop参数是一个唯一的输出。你应该给块设置YES。
 */
- (void)wl_enumerateRegexMatches:(NSString *)regex
                         options:(NSRegularExpressionOptions)options
                      usingBlock:(void (^)(NSString *match, NSRange matchRange, BOOL *stop))block;

/**
 返回一个包含匹配正则表达式的新字符串替换为模版字符串。
 
 @param regex       正则表达式
 @param options     上报的匹配选项.
 @param replacement 用来替换匹配到的内容.
 
 @return 返回一个用指定字符串替换匹配字符串后的字符串.
 */
- (NSString *)wl_stringByReplacingRegex:(NSString *)regex
                                options:(NSRegularExpressionOptions)options
                             withString:(NSString *)replacement;

@end

NS_ASSUME_NONNULL_END

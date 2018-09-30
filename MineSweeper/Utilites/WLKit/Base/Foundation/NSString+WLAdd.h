//
//  NSString+WLAdd.h
//  Welian
//
//  Created by weLian on 16/5/9.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, WLDownloadImageScene) {
    WLDownloadImageSceneThumbnail = 0,  // 缩略图
    WLDownloadImageSceneTailor,         // 裁剪图
    WLDownloadImageSceneBig,             // 大图
    WLDownloadImageSceneAvatar,          // 头像
    WLDownloadImageSceneRound            // 内切圆
};

/*
 NS_ASSUME_NONNULL_BEGIN  NS_ASSUME_NONNULL_END
 在这两个宏之间的代码，所有简单指针对象都被假定为nonnull，因此我们只需要去指定那些nullable的指针。
 */
NS_ASSUME_NONNULL_BEGIN

/**
 *  @author liuwu     , 16-05-09
 *
 *  NSString的常见任务
 */
@interface NSString (WLAdd)

/**
 *  @author dong, 16-03-07 10:03:34
 *
 *  下载头像大图 URL地址处理
 *  宽高 按默认 200 处理
 *  @return return value description
 */
- (NSString *)wl_imageUrlDownloadImageSceneAvatar;

/**
 *  转换字符串为阿里云对应的图片压缩格式，方便下载
 */
- (NSString *)wl_imageUrlManageScene:(WLDownloadImageScene)imageScene condenseSize:(CGSize)condenseSize;

//设置特殊颜色
// 数组
+ (NSMutableAttributedString *)wl_getAttributedInfoString:(NSString *)str
                                           searchAllArray:(NSArray *)searchArray
                                                    color:(UIColor *)sColor
                                                     font:(UIFont *)sFont;
// 单个
+ (NSMutableAttributedString *)wl_getAttributedInfoString:(NSString *)str
                                                searchStr:(NSString *)searchStr
                                                    color:(UIColor *)sColor
                                                     font:(UIFont *)sFont;
/**
 *  @author liuwu     , 16-03-28
 *
 *  给Label设置行间距
 *  @return 设计后的内容
 *  @since V2.7.7.1
 */
+ (NSMutableAttributedString *)wl_getAttributedInfoString:(NSString *)str
                                              lineSpacing:(CGFloat)lineSpacing;


#pragma mark - Utilities
///=============================================================================
/// @name 常用方法
///=============================================================================

// 倒计时 还剩xx天xx小时xx分xx秒  单位秒
+ (NSString *)countdownTimeInterval:(NSTimeInterval)countdown;

// 把时长转换为 时：分：秒
+ (NSString *)durationTimeInterval:(NSTimeInterval)duration;

///把接收的时间毫秒，转换为时间
+ (NSString *)wl_formatterTimeText:(NSTimeInterval)secs;

/**
*  解析时间字符串转换成过去的时间
*/
- (NSString *)wl_createdTimeSineNow;

/**
*  随机获取英文字母
*
*  @param count 字符个数
*
*  @return 随机获取英文字母
*/
+ (NSString *)wl_randomString:(NSInteger)count;

/**
*  @author liuwu     , 16-05-12
*
*  获取当前时间戳，精确到毫秒
*  @return 时间戳字符串
*  @since V2.7.9
*/
+ (NSString *)wl_timeStamp;

/**
*  @author liuwu     , 16-05-09
*
*  获取随机UUID，例如： "E621E1F8-C36C-495A-93FC-0C247A3E6E5F"
*  @return 一个新的UUID字符串
*  @since V2.7.9.1
*/
+ (NSString *)wl_stringWithUUID;

/**
 是否包含给定的字符串

 @param string 给定的字符串.
 
 @讨论 评估已经在iOS8实现containsString:这个方法.
 */
- (BOOL)wl_containsString:(NSString *)string;

/**
 字符串统一转换小写字母后，判断是否包含给定的字符串
 
 @param string 给定的字符串.
 */
- (BOOL)wl_containsLowercaseString:(NSString *)string;

/**
 如果目标字符集内包含当前字符串返回YES
 @param set  一个字符集用来测试接收器
 */
- (BOOL)wl_containsCharacterSet:(NSCharacterSet *)set;

/**
 尝试解析这个字符串并返回一个NSNumber.
 @return 如果解析成功返回一个NSNumber, 如果出错返回nil.
 */
- (nullable NSNumber *)wl_numberValue;

/**
 使用UTF-8编码一个NSData
 */
- (nullable NSData *)wl_dataValue;

/**
 返回NSMakeRange(0, self.length).
 */
- (NSRange)wl_rangeOfAll;

/**
 解码字符串为NSDictionfary或NSArray.如果发生错误返回nil.
 例如：NSString: @"{"name":"a","count":2}"  => NSDictionary: @[@"name":@"a",@"count":@2]
 */
- (nullable id)wl_jsonValueDecoded;

// 判断 是否为 nil 如果为nil 返回 @"",否则返回 原值
+ (NSString *)wl_stringObject:(NSString *)string;

#pragma mark - 检查是否数字
/**
 *  @author liuwu     , 16-02-29
 *
 *  判断是否为整形
 *  @return YES：是Int类型  NO:不是
 *  @since V2.7.3
 */
- (BOOL)wl_isPureInt;

/**
 *  @author liuwu     , 16-02-29
 *
 *  判断是否为整形
 *  @return YES：是NSInteger类型  NO:不是
 *  @since V2.7.3
 */
- (BOOL)wl_isPureInteger;

/**
 *  @author liuwu     , 16-02-29
 *
 *  判断是否为浮点形
 *  @return YES：是float类型  NO:不是
 *  @since V2.7.3
 */
- (BOOL)wl_isPureFloat;

/**
 *  @author liuwu     , 16-02-29
 *
 *  使用NSString的trimming方法，判断是否都是数字
 *  @return YES:都是数字 or NO：存在字符串
 *  @since V2.7.3
 */
- (BOOL)wl_isPureNumandCharacters;


#pragma mark - Encode and decode
///=============================================================================
/// @name 编码 and 解码
///=============================================================================

/**
 字符串进行base64编码
 */
- (nullable NSString *)wl_base64EncodedString;

/**
 base64编码给定的字符串
 @param base64Encoding base64位编码的字符串.
 */
+ (nullable NSString *)wl_stringWithBase64EncodedString:(NSString *)base64EncodedString;

/**
 URL编码utf-8字符串.
 @return 编码的字符串.
 */
- (NSString *)wl_stringByURLEncode;

/**
 URL解码utf-8字符串.
 @return 解码后的字符串.
 */
- (NSString *)wl_stringByURLDecode;

/**
 转换普通HTML实体。
 例子: "a<b" 转变为 "a&lt;b".
 */
- (NSString *)wl_stringByEscapingHTML;


#pragma mark - Date Formart
///=============================================================================
/// @name 日期格式化
///=============================================================================

+ (NSString *)dateTimeStampFormatTodateStr:(long)timeStamp;

+ (NSDate *)dateTimeStampFormatTodate:(long)timeStamp;

/**
 *  @author liuwu     , 16-05-10
 *
 *  最常用的日期格式化转换： “yyyy-MM-dd HH:mm:ss"
 *  @return 格式化后的日期
 *  @since V2.7.9
 */
- (NSDate *)wl_dateFormartNormalString;

//
/**
 *  @author liuwu     , 16-05-10
 *
 *  最常用的日期不带秒的时间格式化转换： “yyyy-MM-dd HH:mm"
 *  @return 格式化后的日期
 *  @since V2.7.9
 */
- (NSDate *)wl_dateFormartNormalStringNoss;

/**
 *  @author liuwu     , 16-05-10
 *
 *  短日期格式转换： "yyyy-MM-dd"
 *  @return 转化后的日期
 *  @since V2.7.9
 */
- (NSDate *)wl_dateFormartShortString;

/**
 *  @author liuwu     , 16-05-10
 *
 *  短日期格式转换： "yyyy-MM-dd'T'HH:mm:ss.SSS"
 *  @return 转化后的日期
 *  @since V2.7.9
 */
- (NSDate *)wl_dateFormartISOString;

/**
 *  @author liuwu     , 16-05-10
 *
 *  只有年月的日期格式转换： "yyyy年MM月"
 *  @return 转化后的日期
 *  @since V2.7.9
 */
- (NSDate *)wl_dateFormartYearAndMonthString;

//只有年月 yyyy年MM月  对月进行计算，小于10补零
/**
 *  @author liuwu     , 16-05-10
 *
 *  只有年月的日期格式转换,对月进行计算，小于10补零： "yyyy年MM月"
 *  @return 转化后的日期字符串
 *  @since V2.7.9
 */
- (NSString *)wl_dateFormartYearAndMonthAddZoreString;


#pragma mark - Trims
///=============================================================================
/// @name Trims
///=============================================================================

/**
 *  @author liuwu     , 16-05-12
 *
 *  对电话号码格式化去掉 -( ) 等格式
 *  @return 去掉-（ ）等的电话号码字符串
 *  @since V2.7.9
 */
- (NSString *)wl_telephoneWithReformat;

/**
 *  @author liuwu     , 16-05-10
 *
 *  去除字符串头部和尾部的空格符
 *  @return 去除头部和尾部的空格符的字符串
 *  @since V2.7.9
 */
- (NSString *)wl_trimWhitespace;

/**
 *  @author liuwu     , 16-05-10
 *
 *  去除字符串头部和尾部的换行符
 *  @return 去除头部和尾部的换行符的字符串
 *  @since V2.7.9
 */
- (NSString *)wl_trimNewlines;

/**
 *  @author liuwu     , 16-05-10
 *
 *  去除字符串头部和尾部的空格与换行符
 *  @return 去除空格与换行的字符串
 *  @since V2.7.9
 */
- (NSString *)wl_trimWhitespaceAndNewlines;

/**
 *  @author liuwu     , 16-05-10
 *
 *  清除html标签
 *  @return 清除后的结果
 *  @since V2.7.9
 */
- (NSString *)wl_stringByStrippingHTML;

/**
 *  @author liuwu     , 16-05-10
 *
 *  清除js脚本
 *  @return 清除js后的字符串
 *  @since V2.7.9
 */
- (NSString *)wl_stringByRemovingScriptsAndStrippingHTML;


/**
 添加用来修改文件名的比例 (没有路径扩展名),
 从 @"name" to @"name@2x".
 
 例如：
 <table>
 <tr><th>Before     </th><th>After(scale:2)</th></tr>
 <tr><td>"icon"     </td><td>"icon@2x"     </td></tr>
 <tr><td>"icon "    </td><td>"icon @2x"    </td></tr>
 <tr><td>"icon.top" </td><td>"icon.top@2x" </td></tr>
 <tr><td>"/p/name"  </td><td>"/p/name@2x"  </td></tr>
 <tr><td>"/path/"   </td><td>"/path/"      </td></tr>
 </table>
 
 @param scale 资源比例.
 @return 添加比例修改后的字符串，如果它没有结束文件名直接返回.
 */
- (NSString *)wl_stringByAppendingNameScale:(CGFloat)scale;

/**
 向文件路径添加修改比例 (路径扩展名),
 从 @"name.png" to @"name@2x.png".
 
 例如
 <table>
 <tr><th>Before     </th><th>After(scale:2)</th></tr>
 <tr><td>"icon.png" </td><td>"icon@2x.png" </td></tr>
 <tr><td>"icon..png"</td><td>"icon.@2x.png"</td></tr>
 <tr><td>"icon"     </td><td>"icon@2x"     </td></tr>
 <tr><td>"icon "    </td><td>"icon @2x"    </td></tr>
 <tr><td>"icon."    </td><td>"icon.@2x"    </td></tr>
 <tr><td>"/p/name"  </td><td>"/p/name@2x"  </td></tr>
 <tr><td>"/path/"   </td><td>"/path/"      </td></tr>
 </table>
 
 @param scale 资源比例.
 @return 添加比例修改后的字符串，如果它没有结束文件名直接返回
 */
- (NSString *)wl_stringByAppendingPathScale:(CGFloat)scale;

/**
 返回路径的比例。
 
 例如.
 <table>
 <tr><th>Path            </th><th>Scale </th></tr>
 <tr><td>"icon.png"      </td><td>1     </td></tr>
 <tr><td>"icon@2x.png"   </td><td>2     </td></tr>
 <tr><td>"icon@2.5x.png" </td><td>2.5   </td></tr>
 <tr><td>"icon@2x"       </td><td>1     </td></tr>
 <tr><td>"icon@2x..png"  </td><td>1     </td></tr>
 <tr><td>"icon@2x.png/"  </td><td>1     </td></tr>
 </table>
 */
- (CGFloat)wl_pathScale;


/**
 13312345678 转换为133****5678

 @return <#return value description#>
 */
- (NSString *)wl_telephoneBySecurity;


// 字节转换string
+ (NSString *)wl_convertFileSize:(int64_t)size;

//匹配身份证号
- (BOOL)wl_matcheIdentityCardNumber;

//判断是否是纯汉字
- (BOOL)wl_isChinese;
//判断是否含有汉字
- (BOOL)wl_includeChinese;
//判断是否只含有数字和X/x
- (BOOL)wl_isNumberOrX;

///  Document
- (NSString *)appendDocumentPath;
/// Libray
- (NSString *)appendLibraryPath;
/// Libray/Cache
- (NSString *)appendCachePath;
/// Temp
- (NSString *)appendTempPath;

@end

NS_ASSUME_NONNULL_END

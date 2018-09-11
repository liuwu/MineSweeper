//
//  NSString+WLAdd.m
//  Welian
//
//  Created by weLian on 16/5/9.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import "NSString+WLAdd.h"
#import "NSDate+WLAdd.h"
#import "NSData+WLAdd.h"
#import "NSNumber+WLAdd.h"
#import "NSString+WLAddForRegex.h"
#import "WLCGUtilities.h"

WLSYNTH_DUMMY_CLASS(NSString_WLAdd)

@implementation NSString (WLAdd)

/**
 *  根据图片使用场景生成新的URL地址
 *
 *  @param imageScene 使用场景
 *
 *  @return 新的地址
 */
- (NSString *)wl_imageUrlDownloadImageSceneAvatar
{
    return [self wl_imageUrlManageScene:WLDownloadImageSceneAvatar condenseSize:CGSizeZero];
}

///转换字符串为阿里云对应的图片压缩格式，方便下载
- (NSString *)wl_imageUrlManageScene:(WLDownloadImageScene)imageScene condenseSize:(CGSize)condenseSize
{
    if (![self containsString:@"welian"]) return self;
    
    NSString *deleExestr = [self stringByDeletingPathExtension];
    if ([deleExestr hasSuffix:@"_x"]) return self;
    NSArray *array = [deleExestr componentsSeparatedByString:@"_"];
    if (array.count<3) {
        return self;
    }
    CGFloat originalWidth = [array[1] floatValue];
    CGFloat originalHeight = [array[2] floatValue];
    long long bytesStr = [[array lastObject] longLongValue];
    CGFloat max = MAX(originalWidth, originalHeight);
    if (max<300) return self;
    
    NSString *thumbType = @"w";
    if (originalWidth > originalHeight) {
        thumbType = @"h";
    }
    // 图片格式，转小写
    NSString *suffixStr = [[self pathExtension] lowercaseStringWithLocale:[NSLocale currentLocale]];
    if (!([suffixStr isEqualToString:@"png"] || [suffixStr isEqualToString:@"jpg"])) {
        suffixStr = @"jpg";
    }
    
    int multiple = 2;
    if (iPhone6plusAnd6splus) {
        multiple = 3;
    }
    
    switch (imageScene) {
        case WLDownloadImageSceneAvatar:
            return [self stringByAppendingFormat:@"@200w_1o.%@",suffixStr];
            break;
        case WLDownloadImageSceneThumbnail:
        {
            //缩略图
            //change by liuwu | 2016.2.29 | 添加传入尺寸为0的默认值处理
            if (condenseSize.width == 0 || condenseSize.height == 0) {
                condenseSize = CGSizeMake(150.f, 150.f);
            }
            NSString *widthStr = [NSString stringWithFormat:@"%.0f",((originalWidth > originalHeight)?condenseSize.height : condenseSize.width)*multiple];
            return [self stringByAppendingFormat:@"@80Q_%@%@_1o.%@",widthStr, thumbType, suffixStr];
        }
            break;
        case WLDownloadImageSceneTailor:
        {
            //裁剪图
            //change by liuwu | 2016.2.29 | 添加传入尺寸为0的默认值处理
            if (condenseSize.width == 0 || condenseSize.height == 0) {
                condenseSize = CGSizeMake(150.f, 150.f);
            }
            NSString *widthStr = [NSString stringWithFormat:@"%.0f",condenseSize.width*multiple];
            NSString *heightStr = [NSString stringWithFormat:@"%.0f",condenseSize.height*multiple];
            return [self stringByAppendingFormat:@"@%@x%@-5rc_2o.%@",widthStr, heightStr, suffixStr];
        }
            break;
        case WLDownloadImageSceneBig:
        {
            CGFloat byteM = bytesStr/1024.00f;
            CGFloat min = MIN(originalHeight, originalWidth);
            if (min<1000) {
                CGFloat maxPixel = 20.0;
                if (byteM<=1.0) {
                    return self;
                }else if (byteM>1&&byteM<=8){
                    maxPixel = (10-byteM)*10;
                }
                return [self stringByAppendingFormat:@"@%.fQ_1o.%@",maxPixel, suffixStr];
            }
            
            NSString *oreStr = @"";
            if (originalHeight > 3000 || originalWidth > 3000) {
                if ([thumbType isEqualToString:@"w"]) {
                    oreStr = @"_3000h";
                }else{
                    oreStr = @"_3000w";
                }
            }
            return [self stringByAppendingFormat:@"@%@_1o.%@",oreStr, suffixStr];
        }
            break;
            
        case WLDownloadImageSceneRound:
        {
//            100w_100h_1e_1c_50-2ci.png
            NSString *widthStr = [NSString stringWithFormat:@"%.0f",condenseSize.width*multiple];
            NSString *heightStr = [NSString stringWithFormat:@"%.0f",condenseSize.height*multiple];
            return [self stringByAppendingFormat:@"@%@w_%@h_1e_1c_%@-2ci.png",widthStr,heightStr,[NSString stringWithFormat:@"%@",heightStr]];
        }
            break;
        default:
            break;
    }
    return self;
}

+ (NSMutableAttributedString *)wl_getAttributedInfoString:(NSString *)str searchAllArray:(NSArray *)searchArray color:(UIColor *)sColor font:(UIFont *)sFont {
    NSUInteger beginLacation = 0;
    NSDictionary *attrsDic = @{NSForegroundColorAttributeName:sColor,NSFontAttributeName:sFont};
    NSMutableAttributedString *attrstr = [[NSMutableAttributedString alloc] initWithString:str];
    if (searchArray.count) {
        for (NSString *searchStr in searchArray) {
            NSRange searchRange = [[str substringFromIndex:beginLacation] rangeOfString:searchStr options:NSCaseInsensitiveSearch];
            if (searchRange.location != NSNotFound) {
                NSRange r = NSMakeRange(searchRange.location+beginLacation, searchRange.length);
                [attrstr addAttributes:attrsDic range:r];
                beginLacation = NSMaxRange(r);
            }
        }
    }
    return attrstr;
}


//设置特殊颜色
+ (NSMutableAttributedString *)wl_getAttributedInfoString:(NSString *)str searchStr:(NSString *)searchStr color:(UIColor *)sColor font:(UIFont *)sFont {
    if(str == nil){
        str = @"";
    }
    NSDictionary *attrsDic = @{NSForegroundColorAttributeName:sColor,NSFontAttributeName:sFont};
    NSMutableAttributedString *attrstr = [[NSMutableAttributedString alloc] initWithString:str];
    if (searchStr) {
        NSRange searchRange = [str rangeOfString:searchStr options:NSCaseInsensitiveSearch];
        [attrstr addAttributes:attrsDic range:searchRange];
    }
    return attrstr;
}

/**
 *  @author liuwu     , 16-03-28
 *
 *  给Label设置行间距
 *  @return 设计后的内容
 *  @since V2.7.7.1
 */
+ (NSMutableAttributedString *)wl_getAttributedInfoString:(NSString *)str
                                              lineSpacing:(CGFloat)lineSpacing {
    // 调整行间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpacing;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, str.length)];
    return attributedString;
}

#pragma mark - Utilities
///=============================================================================
/// @name 常用方法
///=============================================================================

// 倒计时 还剩xx天xx小时xx分xx秒  单位秒
+ (NSString *)countdownTimeInterval:(NSTimeInterval)countdown {
    if (countdown <= 0) return @"";
    NSInteger days = countdown/60/60/24;
    NSInteger hours = (NSInteger)countdown/60/60%24;//小时
    NSInteger minute = (NSInteger)countdown/60%60;//分钟;
    NSInteger second = (NSInteger)countdown%60;//秒
    if (days > 0) {
        return [NSString stringWithFormat:@"还剩%ld天%ld小时", days, hours];
    }else if(hours > 0){
        return [NSString stringWithFormat:@"还剩%02ld:%02ld:%02ld", hours, minute, second];
    }else{
        return [NSString stringWithFormat:@"还剩%02ld:%02ld", minute, second];
    }
}

// 把时长转换为 时：分：秒
+ (NSString *)durationTimeInterval:(NSTimeInterval)duration {
    NSInteger seconds = duration;
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%ld",seconds/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    return format_time;
}

///把接收的时间毫秒，转换为时间
+ (NSString *)wl_formatterTimeText:(NSTimeInterval)secs {
    if (secs<=0) return @"";
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSDate *send = [NSDate dateWithTimeIntervalSince1970:secs/1000];
    NSString *sendStr = [fmt stringFromDate:send];
    NSDate *now = [NSDate date];
    NSString *nowStr = [fmt stringFromDate:now];
    
    NSDate *yesterday = [[NSDate alloc] initWithTimeIntervalSinceNow:-(24 * 60 * 60)];
    NSString *strYesterday = [fmt stringFromDate:yesterday];
    
    if ([sendStr isEqualToString:nowStr]) {
        fmt.dateFormat = @"HH:mm";
        return [fmt stringFromDate:send];
    }else if([strYesterday isEqualToString:sendStr]){
        fmt.dateFormat = @"HH:mm";
        return [NSString stringWithFormat:@"昨天 %@",[fmt stringFromDate:send]];
    }else{
        return sendStr;
    }
}

/**
 *  解析时间字符串转换成过去的时间
 */
- (NSString *)wl_createdTimeSineNow {
    return [[self wl_dateFormartNormalString] wl_timeAgoSimple];
}

/**
 *  随机获取英文字母
 *
 *  @param count 字符个数
 *
 *  @return 随机获取英文字母
 */
+ (NSString *)wl_randomString:(NSInteger)count {
    char data[count];
    for (int x=0;x<count;data[x++] = (char)('a' + (arc4random_uniform(26))));
    NSString *randomStr = [[NSString alloc] initWithBytes:data length:count encoding:NSUTF8StringEncoding];
    return randomStr;
}

/**
 *  @author liuwu     , 16-05-12
 *
 *  获取当前时间戳，精确到毫秒
 *  @return 时间戳字符串
 *  @since V2.7.9
 */
+ (NSString *)wl_timeStamp {
    return [[NSNumber numberWithLongLong:[[NSDate date] timeIntervalSince1970]*1000] stringValue];
}

/**
 *  @author liuwu     , 16-05-09
 *
 *  获取随机UUID，例如： "E621E1F8-C36C-495A-93FC-0C247A3E6E5F"
 *  @return 一个新的UUID字符串
 *  @since V2.7.9.1
 */
+ (NSString *)wl_stringWithUUID{
    return [self stringWithUUID];
}

/**
 是否包含给定的字符串
 
 @param string 给定的字符串.
 
 @讨论 评估已经在iOS8实现这个方法.
 */
- (BOOL)wl_containsString:(NSString *)string {
    return [self containsString:string];
}

/**
 字符串统一转换小写字母后，判断是否包含给定的字符串
 
 @param string 给定的字符串.
 */
- (BOOL)wl_containsLowercaseString:(NSString *)string {
    if (string == nil) return NO;
    NSRange range = [[self lowercaseString] rangeOfString:[string lowercaseString]];
    return range.location != NSNotFound;
}

/**
 如果目标字符集内包含当前字符串返回YES
 @param set  一个字符集用来测试接收器
 */
- (BOOL)wl_containsCharacterSet:(NSCharacterSet *)set {
    return [self containsCharacterSet:set];
}

/**
 尝试解析这个字符串并返回一个NSNumber.
 @return 如果解析成功返回一个NSNumber, 如果出错返回nil.
 */
- (nullable NSNumber *)wl_numberValue {
    return [self numberValue];
}

/**
 使用UTF-8编码一个NSData
 */
- (nullable NSData *)wl_dataValue {
    return [self dataValue];
}

/**
 返回NSMakeRange(0, self.length).
 */
- (NSRange)wl_rangeOfAll {
    return [self rangeOfAll];
}

/**
 解码字符串为NSDictionfary或NSArray.如果发生错误返回nil.
 例如：NSString: @"{"name":"a","count":2}"  => NSDictionary: @[@"name":@"a",@"count":@2]
 */
- (nullable id)wl_jsonValueDecoded {
    return [self jsonValueDecoded];
}

+ (NSString *)wl_stringObject:(NSString *)string{
    if (string == nil || [string isKindOfClass:[NSNull class]]) {
        return @"";
    }
    else{
        return string;
    }
}

#pragma mark - 检查是否数字
/**
 *  @author liuwu     , 16-02-29
 *
 *  判断是否为整形
 *  @return YES：是Int类型  NO:不是
 *  @since V2.7.3
 */
- (BOOL)wl_isPureInt {
    NSScanner* scan = [NSScanner scannerWithString:self];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

/**
 *  @author liuwu     , 16-02-29
 *
 *  判断是否为整形
 *  @return YES：是NSInteger类型  NO:不是
 *  @since V2.7.3
 */
- (BOOL)wl_isPureInteger {
    NSScanner* scan = [NSScanner scannerWithString:self];
    NSInteger val;
    return [scan scanInteger:&val] && [scan isAtEnd];
}

/**
 *  @author liuwu     , 16-02-29
 *
 *  判断是否为浮点形
 *  @return YES：是float类型  NO:不是
 *  @since V2.7.3
 */
- (BOOL)wl_isPureFloat {
    NSScanner* scan = [NSScanner scannerWithString:self];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}

/**
 *  @author liuwu     , 16-02-29
 *
 *  使用NSString的trimming方法，判断是否都是数字
 *  @return YES:都是数字 or NO：存在字符串
 *  @since V2.7.3
 */
- (BOOL)wl_isPureNumandCharacters {
    if (self.length == 0) {
        return NO;
    }
    NSString *searchStr = [self stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(searchStr.length > 0){
        //包换字符串
        return NO;
    }
    return YES;
}


#pragma mark - Encode and decode
///=============================================================================
/// @name 编码 and 解码
///=============================================================================

/**
 字符串进行base64编码
 */
- (nullable NSString *)wl_base64EncodedString {
    return [self base64EncodedString];
}

/**
 base64编码给定的字符串
 @param base64Encoding base64位编码的字符串.
 */
+ (nullable NSString *)wl_stringWithBase64EncodedString:(NSString *)base64EncodedString {
    return [self stringWithBase64EncodedString:base64EncodedString];
}

/**
 URL编码utf-8字符串.
 @return 编码的字符串.
 */
- (NSString *)wl_stringByURLEncode {
    return [self stringByURLEncode];
}

/**
 URL解码utf-8字符串.
 @return 解码后的字符串.
 */
- (NSString *)wl_stringByURLDecode {
    return [self stringByURLDecode];
}

/**
 转换普通HTML实体。
 例子: "a<b" 转变为 "a&lt;b".
 */
- (NSString *)wl_stringByEscapingHTML {
    return [self stringByEscapingHTML];
}



#pragma mark - Date Formart
///=============================================================================
/// @name 日期格式化
///=============================================================================

/**
 *  @author liuwu     , 16-05-10
 *
 *  最常用的日期格式化转换： “yyyy-MM-dd HH:mm:ss"
 *  @return 格式化后的日期
 *  @since V2.7.9
 */
- (NSDate *)wl_dateFormartNormalString {
    return [NSDate wl_dateWithString:self format:@"yyyy-MM-dd HH:mm:ss"];
}

//
/**
 *  @author liuwu     , 16-05-10
 *
 *  最常用的日期不带秒的时间格式化转换： “yyyy-MM-dd HH:mm"
 *  @return 格式化后的日期
 *  @since V2.7.9
 */
- (NSDate *)wl_dateFormartNormalStringNoss {
    return [NSDate wl_dateWithString:self format:@"yyyy-MM-dd HH:mm"];
}

/**
 *  @author liuwu     , 16-05-10
 *
 *  短日期格式转换： "yyyy-MM-dd"
 *  @return 转化后的日期
 *  @since V2.7.9
 */
- (NSDate *)wl_dateFormartShortString {
    return [NSDate wl_dateWithString:self format:@"yyyy-MM-dd"];
}

/**
 *  @author liuwu     , 16-05-10
 *
 *  短日期格式转换： "yyyy-MM-dd'T'HH:mm:ss.SSS"
 *  @return 转化后的日期
 *  @since V2.7.9
 */
- (NSDate *)wl_dateFormartISOString {
    return [NSDate wl_dateWithString:self format:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
}

/**
 *  @author liuwu     , 16-05-10
 *
 *  只有年月的日期格式转换： "yyyy年MM月"
 *  @return 转化后的日期
 *  @since V2.7.9
 */
- (NSDate *)wl_dateFormartYearAndMonthString {
    return [NSDate wl_dateWithString:self format:@"yyyy年MM月"];
}

//只有年月 yyyy年MM月  对月进行计算，小于10补零
/**
 *  @author liuwu     , 16-05-10
 *
 *  只有年月的日期格式转换,对月进行计算，小于10补零： "yyyy年MM月"
 *  @return 转化后的日期字符串
 *  @since V2.7.9
 */
- (NSString *)wl_dateFormartYearAndMonthAddZoreString {
    NSDate *date = [self wl_dateFormartYearAndMonthString];
    NSInteger month = date.wl_month;
    NSString *dateStr = @"";
    if (month < 10) {
        //小于10，前面补零
        NSString *monthStr = [NSString stringWithFormat:@"0%ld",(long)month];
        dateStr = [NSString stringWithFormat:@"%ld年%@月",(long)date.wl_year,monthStr];
    }else{
        dateStr = [date wl_stringWithFormat:@"yyyy年MM月"];
    }
    return dateStr;
}

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
- (NSString *)wl_telephoneWithReformat {
    NSString *telepStr = [self stringByReplacingOccurrencesOfString:@"-" withString:@""];
    telepStr = [telepStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    telepStr = [telepStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    telepStr = [telepStr stringByReplacingOccurrencesOfString:@"(" withString:@""];
    telepStr = [telepStr stringByReplacingOccurrencesOfString:@")" withString:@""];
    return telepStr;
}

/**
 *  @author liuwu     , 16-05-10
 *
 *  去除字符串头部和尾部的空格符
 *  @return 去除头部和尾部的空格符的字符串
 *  @since V2.7.9
 */
- (NSString *)wl_trimWhitespace {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

/**
 *  @author liuwu     , 16-05-10
 *
 *  去除字符串头部和尾部的换行符
 *  @return 去除头部和尾部的换行符的字符串
 *  @since V2.7.9
 */
- (NSString *)wl_trimNewlines {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
}

/**
 *  @author liuwu     , 16-05-10
 *
 *  去除字符串头部和尾部的空格与换行符
 *  @return 去除空格与换行的字符串
 *  @since V2.7.9
 */
- (NSString *)wl_trimWhitespaceAndNewlines {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

/**
 *  @author liuwu     , 16-05-10
 *
 *  清除html标签
 *  @return 清除后的结果
 *  @since V2.7.9
 */
- (NSString *)wl_stringByStrippingHTML {
    return [self stringByReplacingOccurrencesOfString:@"<[^>]+>" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, self.length)];
}

/**
 *  @author liuwu     , 16-05-10
 *
 *  清除js脚本
 *  @return 清除js后的字符串
 *  @since V2.7.9
 */
- (NSString *)wl_stringByRemovingScriptsAndStrippingHTML {
    NSMutableString *mString = [self mutableCopy];
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<script[^>]*>[\\w\\W]*</script>" options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *matches = [regex matchesInString:mString options:NSMatchingReportProgress range:NSMakeRange(0, [mString length])];
    for (NSTextCheckingResult *match in [matches reverseObjectEnumerator]) {
        [mString replaceCharactersInRange:match.range withString:@""];
    }
    return [mString wl_stringByStrippingHTML];
}

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
- (NSString *)wl_stringByAppendingNameScale:(CGFloat)scale {
    return [self stringByAppendingNameScale:scale];
}

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
- (NSString *)wl_stringByAppendingPathScale:(CGFloat)scale {
    return [self stringByAppendingPathScale:scale];
}

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
- (CGFloat)wl_pathScale {
    return [self pathScale];
}

- (NSString *)wl_telephoneBySecurity{
    if (self.length == 11) {
        return [self stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    }
    return self;
}

// 字节转换string
+ (NSString *)wl_convertFileSize:(int64_t)size {
    long kb = 1024;
    long mb = kb * 1024;
    long gb = mb * 1024;
    
    if (size >= gb) {
        return [NSString stringWithFormat:@"%.1fGB", (float) size / gb];
    } else if (size >= mb) {
        float f = (float) size / mb;
        if (f > 100) {
            return [NSString stringWithFormat:@"%.0fM", f];
        }else{
            return [NSString stringWithFormat:@"%.1fM", f];
        }
    } else if (size >= kb) {
        float f = (float) size / kb;
        if (f > 100) {
            return [NSString stringWithFormat:@"%.0fKB", f];
        }else{
            return [NSString stringWithFormat:@"%.1fKB", f];
        }
    } else
        return [NSString stringWithFormat:@"%lldB", size];
}

//匹配身份证号
- (BOOL)wl_matcheIdentityCardNumber {
    //长度不为18的都排除掉
    if (self.length != 18) {
        return NO;
    }
    //校验格式
    NSString *regex2 = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    BOOL flag = [identityCardPredicate evaluateWithObject:self];
    if (!flag) {
        return flag;    //格式错误
    }else {
        //格式正确在判断是否合法
        //将前17位加权因子保存在数组里
        NSArray * idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
        
        //这是除以11后，可能产生的11位余数、验证码，也保存成数组
        NSArray * idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
        
        //用来保存前17位各自乖以加权因子后的总和
        NSInteger idCardWiSum = 0;
        for (int i = 0;i < 17;i++) {
            NSInteger subStrIndex = [[self substringWithRange:NSMakeRange(i, 1)] integerValue];
            NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
            
            idCardWiSum+= subStrIndex * idCardWiIndex;
        }
        //计算出校验码所在数组的位置
        NSInteger idCardMod=idCardWiSum%11;
        //得到最后一位身份证号码
        NSString * idCardLast= [self substringWithRange:NSMakeRange(17, 1)];
        
        //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
        if(idCardMod==2) {
            return ([idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"]);
        } else {
            //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
            return [idCardLast isEqualToString: [idCardYArray objectAtIndex:idCardMod]];
        }
    }
}

//判断是否是纯汉字
- (BOOL)wl_isChinese
{
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
}
//判断是否含有汉字
- (BOOL)wl_includeChinese
{
    for(int i=0; i< [self length];i++)
    {
        int a =[self characterAtIndex:i];
        if( a >=0x4e00&& a <=0x9fff){
            return YES;
        }
    }
    return NO;
}

- (BOOL)wl_isNumberOrX {
    NSArray *arr = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"X",@"x"];
    for (int i = 0; i < self.length; ++i) {
        NSString *one = [self substringWithRange:NSMakeRange(i, 1)];
        if (![arr containsObject:one]) {
            return false;
        }
    }
    return true;
}

- (NSString *)appendDocumentPath {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:self.lastPathComponent];
}

- (NSString *)appendLibraryPath {
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:self.lastPathComponent];
}

- (NSString *)appendCachePath {
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:self.lastPathComponent];
}

- (NSString *)appendTempPath {
    return [NSTemporaryDirectory() stringByAppendingPathComponent:self.lastPathComponent];
}


@end

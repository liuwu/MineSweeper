//
//  NSDictionary+WLAdd.m
//  Welian
//
//  Created by weLian on 16/5/11.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import "NSDictionary+WLAdd.h"
#import "NSData+WLAdd.h"
#import "NSString+WLAdd.h"
#import "WLCGUtilities.h"

WLSYNTH_DUMMY_CLASS(NSDictionary_WLAdd)

@implementation NSDictionary (WLAdd)

#pragma mark - Dictionary Convertor
///=============================================================================
/// @name 字典转换
///=============================================================================

/**
 把属性列表数据转换为字典。
 
 @param plist   根对象为字典的属性列表数据.
 @return 一个从plist数据中解析的字典, 如果出错返回nil.
 */
+ (nullable NSDictionary *)wl_dictionaryWithPlistData:(NSData *)plist {
    return [self dictionaryWithPlistData:plist];
}

/**
 把xml的属性列表字符串转换为字典。
 
 @param plist   根对象为字典的xml属性列表字符串.
 @return 一个从plist字符串中解析的字典, 如果出错返回nil.
 
 @讨论 苹果已经实现了这个方法，但并没有公开它.
 */
+ (nullable NSDictionary *)wl_dictionaryWithPlistString:(NSString *)plist {
    return [self dictionaryWithPlistString:plist];
}

/**
 把字典转换为属性列表数据。
 
 @return 一个plist数据, 如果出错返回nil.
 
 @讨论 苹果已经实现了这个方法，但并没有公开它.
 */
- (nullable NSData *)wl_plistData {
    return [self plistData];
}

/**
 把字典对象转换为一个xml属性列表字符串。
 
 @return 一个xml的属性列表字符串, 如果出错返回nil.
 */
- (nullable NSString *)wl_plistString {
    return [self plistString];
}

/**
 返回一个字典的键排序后的数组。这些键必须是NSString类型，它们将按升序排列。
 
 @return 一个包含字典键的新数组,如果字典没有数据返回空数组。
 */
- (NSArray *)wl_allKeysSorted {
    return [self allKeysSorted];
}

/**
 返回一个该字典值按照键排序后的新数组。
 
 数组中的值的顺序是由键定义的。
 键必须是NSString类型，他们将升序排列。
 
 @return 一个按照字典中的键排序后的值的数组,如果字典没有数据返回空数组。
 */
- (NSArray *)wl_allValuesSortedByKeys {
    return [self allValuesSortedByKeys];
}

/**
 返回字典中是否有给定key的对象。
 @param key 键.
 */
- (BOOL)wl_containsObjectForKey:(id)key {
    return [self containsObjectForKey:key];
}

/**
 返回一个包含键数组的新字典.如果键数组是空的或nil，将返回一个空的字典。
 
 @param keys 键数组.
 @return 包含键的字典对象.
 */
- (NSDictionary *)wl_entriesForKeys:(NSArray *)keys {
    return [self entriesForKeys:keys];
}

/**
 把字典转换为json字符串。如果出错返回nil
 */
- (nullable NSString *)wl_jsonStringEncoded {
    return [self jsonStringEncoded];
}

/**
 把字典转换为格式化的json字符串，如果出错返回nil
 */
- (nullable NSString *)wl_jsonPrettyStringEncoded {
    return [self jsonPrettyStringEncoded];
}

/**
 试着解析一个XML并把它转换成一个字典。 如果你只想从一个小的XML中获取一些值，试试这个方法。
 
 例 XML："<config><a href="test.com">link</a></config>"
 例 Return:  @{@"_name":@"config", @"a":{@"_text":@"link",@"href":@"test.com"}}
 
 @param xmlDataOrString XML是NSData或NSString格式.
 @return 一个新的字典, 如果出错返回nil.
 */
+ (nullable NSDictionary *)wl_dictionaryWithXML:(id)xmlDataOrString {
    return [self dictionaryWithXML:xmlDataOrString];
}

#pragma mark - Dictionary Value Getter
///=============================================================================
/// @name Dictionary Value Getter
///=============================================================================

/// Get a number value from 'id'.
static NSNumber *NSNumberFromID(id value) {
    static NSCharacterSet *dot;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dot = [NSCharacterSet characterSetWithRange:NSMakeRange('.', 1)];
    });
    if (!value || value == [NSNull null]) return nil;
    if ([value isKindOfClass:[NSNumber class]]) return value;
    if ([value isKindOfClass:[NSString class]]) {
        NSString *lower = ((NSString *)value).lowercaseString;
        if ([lower isEqualToString:@"true"] || [lower isEqualToString:@"yes"]) return @(YES);
        if ([lower isEqualToString:@"false"] || [lower isEqualToString:@"no"]) return @(NO);
        if ([lower isEqualToString:@"nil"] || [lower isEqualToString:@"null"]) return nil;
        if ([(NSString *)value rangeOfCharacterFromSet:dot].location != NSNotFound) {
            return @(((NSString *)value).doubleValue);
        } else {
            return @(((NSString *)value).longLongValue);
        }
    }
    return nil;
}

#define RETURN_VALUE(_type_)                                                     \
if (!key) return def;                                                            \
id value = self[key];                                                            \
if (!value || value == [NSNull null]) return def;                                \
if ([value isKindOfClass:[NSNumber class]]) return ((NSNumber *)value)._type_;   \
if ([value isKindOfClass:[NSString class]]) return NSNumberFromID(value)._type_; \
return def;

- (BOOL)wl_boolValueForKey:(NSString *)key default:(BOOL)def {
    RETURN_VALUE(boolValue);
}

- (char)wl_charValueForKey:(NSString *)key default:(char)def {
    RETURN_VALUE(charValue);
}

- (unsigned char)wl_unsignedCharValueForKey:(NSString *)key default:(unsigned char)def {
    RETURN_VALUE(unsignedCharValue);
}

- (short)wl_shortValueForKey:(NSString *)key default:(short)def {
    RETURN_VALUE(shortValue);
}

- (unsigned short)wl_unsignedShortValueForKey:(NSString *)key default:(unsigned short)def {
    RETURN_VALUE(unsignedShortValue);
}

- (int)wl_intValueForKey:(NSString *)key default:(int)def {
    RETURN_VALUE(intValue);
}

- (unsigned int)wl_unsignedIntValueForKey:(NSString *)key default:(unsigned int)def {
    RETURN_VALUE(unsignedIntValue);
}

- (long)wl_longValueForKey:(NSString *)key default:(long)def {
    RETURN_VALUE(longValue);
}

- (unsigned long)wl_unsignedLongValueForKey:(NSString *)key default:(unsigned long)def {
    RETURN_VALUE(unsignedLongValue);
}

- (long long)wl_longLongValueForKey:(NSString *)key default:(long long)def {
    RETURN_VALUE(longLongValue);
}

- (unsigned long long)wl_unsignedLongLongValueForKey:(NSString *)key default:(unsigned long long)def {
    RETURN_VALUE(unsignedLongLongValue);
}

- (float)wl_floatValueForKey:(NSString *)key default:(float)def {
    RETURN_VALUE(floatValue);
}

- (double)wl_doubleValueForKey:(NSString *)key default:(double)def {
    RETURN_VALUE(doubleValue);
}

- (NSInteger)wl_integerValueForKey:(NSString *)key default:(NSInteger)def {
    RETURN_VALUE(integerValue);
}

- (NSUInteger)wl_unsignedIntegerValueForKey:(NSString *)key default:(NSUInteger)def {
    RETURN_VALUE(unsignedIntegerValue);
}

- (NSNumber *)wl_numverValueForKey:(NSString *)key default:(NSNumber *)def {
    if (!key) return def;
    id value = self[key];
    if (!value || value == [NSNull null]) return def;
    if ([value isKindOfClass:[NSNumber class]]) return value;
    if ([value isKindOfClass:[NSString class]]) return NSNumberFromID(value);
    return def;
}

- (NSString *)wl_stringValueForKey:(NSString *)key default:(NSString *)def {
    if (!key) return def;
    id value = self[key];
    if (!value || value == [NSNull null]) return def;
    if ([value isKindOfClass:[NSString class]]) return value;
    if ([value isKindOfClass:[NSNumber class]]) return ((NSNumber *)value).description;
    return def;
}

@end


@implementation NSMutableDictionary (WLAdd)

/**
 把属性列表数据转换为字典。
 
 @param plist   根对象为字典的属性列表数据.
 @return 一个从plist数据中解析的字典, 如果出错返回nil.
 @讨论 苹果已经实现了这个方法，但并没有公开它.
 */
+ (NSMutableDictionary *)wl_dictionaryWithPlistData:(NSData *)plist {
    return [self dictionaryWithPlistData:plist];
}

/**
 把xml的属性列表字符串转换为字典。
 
 @param plist   根对象为字典的xml属性列表字符串.
 @return 一个从plist字符串中解析的字典, 如果出错返回nil.
 */
+ (NSMutableDictionary *)wl_dictionaryWithPlistString:(NSString *)plist {
    return [self dictionaryWithPlistString:plist];
}

/**
 移除并返回给定的key关联的值。
 
 @param aKey 返回和删除相应关联值的key.
 @return akey相关联的值, 如果没有与akey相关联的值或者没有值返回nil.
 */
- (id)wl_popObjectForKey:(id)aKey {
    return [self popObjectForKey:aKey];
}

/**
 返回一个包含给定key数组的新的字典，并删除这些接收的实体.如果keys是空的或者nil，它只返回一个空的字典。
 
 @param keys key数组.
 @return keys数组相对于的实体字典.
 */
- (NSDictionary *)wl_popEntriesForKeys:(NSArray *)keys {
    return [self popEntriesForKeys:keys];
}


@end

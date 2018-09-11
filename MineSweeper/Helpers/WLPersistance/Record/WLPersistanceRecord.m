//
//  WLPersistanceRecord.m
//  Welian
//
//  Created by weLian on 16/9/8.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import "WLPersistanceRecord.h"
#import "NSString+WLSQL.h"

@implementation WLPersistanceRecord

#pragma mark - CTPersistanceRecordProtocol
/// 把数据对象转换为存储到数据库的数据
- (NSDictionary *)dictionaryRepresentationWithTable:(WLPersistanceTable<WLPersistanceTableProtocol> *)table {
    NSMutableArray *classArray = [NSMutableArray array];
    classArray = [self getClassArray];
    
    NSMutableDictionary *propertyList = [[NSMutableDictionary alloc] init];
    [classArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        unsigned int count = 0;
        objc_property_t *properties = class_copyPropertyList([obj class], &count);
        while (count --> 0) {
            objc_property_t property = properties[count];
            NSString *key = [NSString stringWithUTF8String:property_getName(property)];
            id value = [self valueForKey:key];
            if (value == nil) {
                propertyList[key] = [NSNull null];
            }else {
                if ([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSDictionary class]]) {
                    propertyList[key] = [value modelToJSONString];
                }else if ([value isKindOfClass:[NSDate class]]){
                    propertyList[key] = [value formattedDateWithFormat:@"yyyy-MM-dd HH:mm:ss"];
                }else{
                    // 其他类型
                    propertyList[key] = value;
                }
            }
        }
        free(properties);
    }];
    
    NSMutableDictionary *dictionaryRepresentation = [[NSMutableDictionary alloc] init];
    [table.columnInfo enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull columnName, NSString * _Nonnull columnDescription, BOOL * _Nonnull stop) {
        if (propertyList[columnName]) {
            dictionaryRepresentation[columnName] = propertyList[columnName];
        }
    }];
    
    return dictionaryRepresentation;
}

/// 解析数据库查询出来的数据
- (void)objectRepresentationWithDictionary:(NSDictionary *)dictionary {
    NSMutableArray *classArray = [NSMutableArray array];
    classArray = [self getClassArray];
    //获取对象参数类型
    NSDictionary *propertyTypeList = [self getClassPropertyTypeInfo];
    [dictionary enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull value, BOOL * _Nonnull stop) {
        [self setPersistanceValue:value forKey:key propertyTypeDict:propertyTypeList];
    }];
}

- (BOOL)setPersistanceValue:(id)value forKey:(NSString *)key {
    BOOL result = YES;
    NSString *setter = [NSString stringWithFormat:@"set%@%@:", [[key substringToIndex:1] capitalizedString], [key substringFromIndex:1]];
    if ([self respondsToSelector:NSSelectorFromString(setter)]) {
        if ([value isKindOfClass:[NSString class]]) {
            [self setValue:[value safeSQLDecode] forKey:key];
        } else if ([value isKindOfClass:[NSNull class]]) {
            [self setValue:nil forKey:key];
        } else {
            [self setValue:value forKey:key];
        }
    } else {
        result = NO;
    }
    
    return result;
}

- (NSObject<WLPersistanceRecordProtocol> *)mergeRecord:(NSObject<WLPersistanceRecordProtocol> *)record shouldOverride:(BOOL)shouldOverride {
    if ([self respondsToSelector:@selector(availableKeyList)]) {
        NSArray *availableKeyList = [self availableKeyList];
        [availableKeyList enumerateObjectsUsingBlock:^(NSString * _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([record respondsToSelector:NSSelectorFromString(key)]) {
                id recordValue = [record valueForKey:key];
                if (shouldOverride) {
                    [self setPersistanceValue:recordValue forKey:key];
                } else {
                    id selfValue = [self valueForKey:key];
                    if (selfValue == nil) {
                        [self setPersistanceValue:recordValue forKey:key];
                    }
                }
            }
        }];
    }
    return self;
}

#pragma mark - Private
// 获取所有对象及父类对象
- (NSMutableArray *)getClassArray {
    NSMutableArray *classArray = [NSMutableArray array];
    Class myClass = [self class];
    [classArray addObject:myClass];
    // 最上层的父类
    while (![[[myClass superclass] className] isEqualToString:@"WLPersistanceRecord"]) {
        [classArray addObject:[myClass superclass]];
        myClass = [myClass superclass];
    }
    return classArray;
}

/*
 c char
 i int
 l long
 s short
 d double
 f float
 @ id //指针 对象
 ...  BOOL 获取到的表示 方式是 char
 .... ^i 表示  int*  一般都不会用到
 */
/// 获取对象属性的类型
- (NSDictionary *)getClassPropertyTypeInfo {
    NSMutableArray *classArray = [NSMutableArray array];
    classArray = [self getClassArray];
    
    NSMutableDictionary *propertyTypeList = [[NSMutableDictionary alloc] init];
    [classArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        unsigned int count = 0;
        //        objc_property_t *properties = class_copyPropertyList([self class], &count);
        objc_property_t *properties = class_copyPropertyList([obj class], &count);
        while (count --> 0) {
            objc_property_t property = properties[count];
            NSString *key = [NSString stringWithUTF8String:property_getName(property)];
            NSString *propertyType = [NSString stringWithUTF8String:property_getAttributes(property)];
            // 获取参数属性
            NSString* propertyClassName = [self getPropertyClassNameWithType:propertyType];
            // 保存属性参数字符串
            propertyTypeList[key] = propertyClassName;
        }
        free(properties);
    }];
    return propertyTypeList;
}

// 获取属性对应的objc
- (NSString *)getPropertyClassNameWithType:(NSString *)propertyType {
    NSString* propertyClassName = nil;
    if ([propertyType hasPrefix:@"T@"]) {
        
        NSRange range = [propertyType rangeOfString:@","];
        if (range.location > 4 && range.location <= propertyType.length) {
            range = NSMakeRange(3, range.location - 4);
            propertyClassName = [propertyType substringWithRange:range];
            if ([propertyClassName hasSuffix:@">"]) {
                NSRange categoryRange = [propertyClassName rangeOfString:@"<"];
                if (categoryRange.length > 0) {
                    propertyClassName = [propertyClassName substringToIndex:categoryRange.location];
                }
            }
        }
    }else if ([propertyType hasPrefix:@"T{"]) {
        NSRange range = [propertyType rangeOfString:@"="];
        if (range.location > 2 && range.location <= propertyType.length) {
            range = NSMakeRange(2, range.location - 2);
            propertyClassName = [propertyType substringWithRange:range];
        }
    }else {
        propertyType = [propertyType lowercaseString];
        if ([propertyType hasPrefix:@"ti"] || [propertyType hasPrefix:@"tb"]) {
            propertyClassName = @"int";
        }
        else if ([propertyType hasPrefix:@"tf"]) {
            propertyClassName = @"float";
        }
        else if ([propertyType hasPrefix:@"td"]) {
            propertyClassName = @"double";
        }
        else if ([propertyType hasPrefix:@"tl"] || [propertyType hasPrefix:@"tq"]) {
            propertyClassName = @"long";
        }
        else if ([propertyType hasPrefix:@"tc"]) {
            propertyClassName = @"char";
        }
        else if ([propertyType hasPrefix:@"ts"]) {
            propertyClassName = @"short";
        }
    }
    return propertyClassName;
}

- (BOOL)setPersistanceValue:(id)value forKey:(NSString *)key propertyTypeDict:(NSDictionary *)propertyTypeDict {
    BOOL result = YES;
    NSString *setter = [NSString stringWithFormat:@"set%@%@:", [[key substringToIndex:1] capitalizedString], [key substringFromIndex:1]];
    if ([self respondsToSelector:NSSelectorFromString(setter)]) {
        ///参试获取属性的Class
        Class columnClass = NSClassFromString(propertyTypeDict[key]);
        if ([value isKindOfClass:[NSString class]]) {
            if ([columnClass isSubclassOfClass:[NSString class]]) {
                [self setValue:[value safeSQLDecode] forKey:key];
            }else if ([columnClass isSubclassOfClass:[NSNull class]]){
                [self setValue:nil forKey:key];
            }else if ([columnClass isSubclassOfClass:[NSDate class]]){
                [self setValue:[NSDate dateWithString:value format:@"yyyy-MM-dd HH:mm:ss"] forKey:key];
            }else if ([columnClass isSubclassOfClass:[NSNumber class]]){
                [self setValue:[NSNumber numberWithString:value] forKey:key];
            }else if ([columnClass isSubclassOfClass:[NSArray class]] || [value isSubclassOfClass:[NSDictionary class]]){
                [self setValue:[value jsonValueDecoded] forKey:key];
            }else{
                // 其他类型
                [self setValue:value forKey:key];
            }
        }else if ([value isKindOfClass:[NSNull class]]){
            [self setValue:nil forKey:key];
        }else{
            // 其他类型
            [self setValue:value forKey:key];
        }
    } else {
        result = NO;
    }
    return result;
}

@end

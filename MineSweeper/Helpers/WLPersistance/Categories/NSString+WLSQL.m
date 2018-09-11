//
//  NSString+WLSQL.m
//  Welian
//
//  Created by weLian on 16/9/9.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import "NSString+WLSQL.h"

@implementation NSString (WLSQL)

- (NSString *)safeSQLEncode {
    NSString *safeSQL = [self copy];
    safeSQL = [safeSQL stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    safeSQL = [safeSQL stringByReplacingOccurrencesOfString:@";" withString:@""];
    return safeSQL;
}

- (NSString *)safeSQLDecode {
    // do nothing
    return self;
}

- (NSString *)safeSQLMetaString {
    NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:@"'`"];
    return [[self componentsSeparatedByCharactersInSet:charSet] componentsJoinedByString:@""];
}

- (NSString *)stringWithSQLParams:(NSDictionary *)params {
    /*
     self 
     字符串内容：uid = :primaryKeyValue
     
     params:
     {
        primaryKeyValue = 11078;
     }
     */
    NSMutableArray *keyList = [[NSMutableArray alloc] init];
    
    // 匹配字符串中的 :后面的内容
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:@":[\\w]*" options:0 error:NULL];
    NSArray *list = [expression matchesInString:self options:0 range:NSMakeRange(0, self.length)];
    
    [list enumerateObjectsUsingBlock:^(NSTextCheckingResult * _Nonnull checkResult, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *subString = [self substringWithRange:checkResult.range];
        [keyList addObject:[subString substringWithRange:NSMakeRange(1, subString.length-1)]];
    }];
    
    // 根据字符串中的参数key，从params中获取数据
    NSMutableString *resultString = [self mutableCopy];
    [keyList enumerateObjectsUsingBlock:^(NSString * _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
        if (params[key]) {
            NSRegularExpression *expressionForReplace = [NSRegularExpression regularExpressionWithPattern:[NSString stringWithFormat:@":%@\\b", key] options:0 error:NULL];
            NSString *value = [NSString stringWithFormat:@"%@", params[key]];
            if ([params[key] isKindOfClass:[NSString class]] && [keyList containsObject:params[key]] == NO && [key isEqualToString:@"primaryKeyValueListString"] == NO) {
                value = [NSString stringWithFormat:@"'%@'", params[key]];
            }
            [expressionForReplace replaceMatchesInString:resultString options:0 range:NSMakeRange(0, resultString.length) withTemplate:value];
        }
    }];
    
    return resultString;
}


@end

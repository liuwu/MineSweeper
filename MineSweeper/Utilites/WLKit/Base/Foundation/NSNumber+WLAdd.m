//
//  NSNumber+WLAdd.m
//  Welian
//
//  Created by weLian on 16/5/13.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import "NSNumber+WLAdd.h"
#import "NSString+WLAdd.h"
#import "WLCGUtilities.h"

WLSYNTH_DUMMY_CLASS(NSNumber_WLAdd)

@implementation NSNumber (WLAdd)

/**
 创建并返回一个字符串解析成的NSNumber对象.
 有效的格式: @"12", @"12.345", @" -0xFF", @" .23e99 "...
 
 @param string  一个数字字符串.
 
 @return 一个解析成功的NSNumber, 如果出错返回nil.
 */
+ (nullable NSNumber *)wl_numberWithString:(NSString *)string {
    return [self numberWithString:string];
}

///如果不为整形保留小数点后两位
- (NSString *)wl_keepTwoDecimalPlaces {
    NSString *string = self.stringValue;
    if ([string wl_isPureInt] == NO) {
        string = [NSString stringWithFormat:@"%0.2f",self.doubleValue];
    }
    return string;
}

@end

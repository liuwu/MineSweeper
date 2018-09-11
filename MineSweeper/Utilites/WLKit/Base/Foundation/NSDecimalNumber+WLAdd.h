//
//  NSDecimalNumber+WLAdd.h
//  Welian
//
//  Created by dong on 2018/2/5.
//  Copyright © 2018年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDecimalNumber (WLAdd)

/**
 格式化金额

 @param power 除以10 金额单位决定
 @param fractionDigits 小数点后几位
 @return return value description
 */
- (NSString *)stringFormatterDecimalNumberMultiplyingByPowerOf10:(short)power fractionDigits:(NSUInteger)fractionDigits;

- (NSString *)stringFormatterDecimalNumberMultiplyingByPowerOf10:(short)power;
// 默认为单位分 （power = -2）
- (NSString *)stringFormatterDecimalNumber;

//
- (NSString *)stringIntegerFormmatter;

@end

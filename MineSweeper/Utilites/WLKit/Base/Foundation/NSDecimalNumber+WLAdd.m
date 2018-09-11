//
//  NSDecimalNumber+WLAdd.m
//  Welian
//
//  Created by dong on 2018/2/5.
//  Copyright © 2018年 chuansongmen. All rights reserved.
//

#import "NSDecimalNumber+WLAdd.h"

@implementation NSDecimalNumber (WLAdd)

///
- (NSDecimalNumber *)roundToScale:(short)scale mode:(NSRoundingMode)roundingMode {
    NSDecimalNumberHandler *handler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:roundingMode scale:scale raiseOnExactness:NO raiseOnOverflow:YES raiseOnUnderflow:YES raiseOnDivideByZero:YES];
    return [self decimalNumberByRoundingAccordingToBehavior:handler];
}


- (NSString *)stringIntegerFormmatter {
    NSString *price = [self stringFormatterDecimalNumber];
    price = [price substringToIndex:[price rangeOfString:@"."].location];
    return price;
}

- (NSString *)stringFormatterDecimalNumber {
    return [self stringFormatterDecimalNumberMultiplyingByPowerOf10:-2];
}

- (NSString *)stringFormatterDecimalNumberMultiplyingByPowerOf10:(short)power {
    return [self stringFormatterDecimalNumberMultiplyingByPowerOf10:power fractionDigits:2];
}

- (NSString *)stringFormatterDecimalNumberMultiplyingByPowerOf10:(short)power fractionDigits:(NSUInteger)fractionDigits {
    if (!self) return @"";
    static NSNumberFormatter *_numberFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _numberFormatter = [[NSNumberFormatter alloc] init];
        _numberFormatter.minimumIntegerDigits = 1;
        [_numberFormatter setRoundingMode:NSNumberFormatterRoundDown];
        _numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    });
    _numberFormatter.maximumFractionDigits = fractionDigits;// 最多2位小数.
    _numberFormatter.minimumFractionDigits = fractionDigits;
    NSString *string = [_numberFormatter stringFromNumber:[self decimalNumberByMultiplyingByPowerOf10:power]];
    return string;
}

@end

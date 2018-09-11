//
//  NSNumber+WLAdd.h
//  Welian
//
//  Created by weLian on 16/5/13.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>


/*
 NS_ASSUME_NONNULL_BEGIN  NS_ASSUME_NONNULL_END
 在这两个宏之间的代码，所有简单指针对象都被假定为nonnull，因此我们只需要去指定那些nullable的指针。
 */
NS_ASSUME_NONNULL_BEGIN

/**
 NSNumber的一些常用操作.
 */
@interface NSNumber (WLAdd)


/**
 创建并返回一个字符串解析成的NSNumber对象.
 有效的格式: @"12", @"12.345", @" -0xFF", @" .23e99 "...
 
 @param string  一个数字字符串.
 
 @return 一个解析成功的NSNumber, 如果出错返回nil.
 */
+ (nullable NSNumber *)wl_numberWithString:(NSString *)string;

///如果不为整形保留小数点后两位
- (NSString *)wl_keepTwoDecimalPlaces;

@end

NS_ASSUME_NONNULL_END

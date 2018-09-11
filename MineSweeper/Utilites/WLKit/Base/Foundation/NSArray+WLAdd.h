//
//  NSArray+WLAdd.h
//  Welian
//
//  Created by weLian on 16/5/11.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 NS_ASSUME_NONNULL_BEGIN  NS_ASSUME_NONNULL_END
 在这两个宏之间的代码，所有简单指针对象都被假定为nonnull，因此我们只需要去指定那些nullable的指针。
 */
NS_ASSUME_NONNULL_BEGIN

/**
 *  @author liuwu     , 16-05-11
 *
 *  NSArray一些常用方法
 *  @since V2.7.9
 */
@interface NSArray (WLAdd)

/**
 将属性列表数据转换为 NSArray 返回。
 
 @param plist   根对象为数组的属性列表数据.
 @return 一个从plist数据中解析的数组, 如果出错返回nil.
 */
+ (nullable NSArray *)wl_arrayWithPlistData:(NSData *)plist;

/**
 将xml格式的属性列表字符串转换为 NSArray 返回。
 
 @param plist   跟对象为数组的xml属性列表字符串.
 @return 一个从plist字符串中解析的数组, 如果出错返回nil.
 */
+ (nullable NSArray *)wl_arrayWithPlistString:(NSString *)plist;

/**
 把数组转换为属性列表
 
 @return 一个plist数据, 如果出错返回nil.
 */
- (nullable NSData *)wl_plistData;

/**
 把数组转换为xml属性列表字符串
 
 @return 一个xml属性列表字符串, 如果出错返回nil.
 */
- (nullable NSString *)wl_plistString;

/**
 返回数组中随机对象的索引。
 
 @return  在数组的对象中返回一个随机的索引值.如果数组为空，返回nil.
 */
- (nullable id)wl_randomObject;

/**
 返回索引处的对象，或超出边界时返回nil。 它类似与'objectAtIndex:',但它不会抛出异常。
 
 @param index 对象的索引值.
 */
- (nullable id)wl_objectOrNilAtIndex:(NSUInteger)index;

/**
 把数组转换为json字符串。 如果出错返回nil.
 NSString/NSNumber/NSDictionary/NSArray
 */
- (nullable NSString *)wl_jsonStringEncoded;

/**
 把数组转换为格式化的json字符串。如果出错返回Nil.
 */
- (nullable NSString *)wl_jsonPrettyStringEncoded;

@end


/**
 NSMutableArray的一些常用方法.
 */
@interface NSMutableArray (WLAdd)

/**
 把指定的属性列表数据转换为数组
 
 @param plist   根对象为数组的属性列表数据.
 @return 一个从plist数据中解析的数组, 如果出错返回nil.
 */
+ (nullable NSMutableArray *)wl_arrayWithPlistData:(NSData *)plist;

/**
 把xml的属性列表字符串转换为数组
 
 @param plist   跟对象为数组的xml属性列表字符串.
 @return 一个从plist字符串中解析的数组, 如果出错返回nil.
 */
+ (nullable NSMutableArray *)wl_arrayWithPlistString:(NSString *)plist;

/**
 移除数组中的第一个索引的对象。如果数组是空的，该方法没有效果。
 
 @讨论 苹果已经实现了该方法，但是并没有公开. 重写覆盖使用它安全。
 Override for safe.
 */
- (void)wl_removeFirstObject;

/**
 移除数组中最后一个索引的对象。如果数组是空的，该方法没有效果。
 
 @讨论 苹果的实现表示如果数组是空的，它将报出一个NSRangeException的错误，但事实上没有什么会发生。重写覆盖使用它安全.
 */
- (void)wl_removeLastObject;

/**
 删除并返回数组中的最小值索引的对象。如果数组是空，它只返回nil.
 
 @return 第一个对象或nil.
 */
- (nullable id)wl_popFirstObject;

/**
 删除并返回数组中的最大索引的对象。如果数组是空，它只返回nil.
 
 @return 最后一个对象或nil.
 */
- (nullable id)wl_popLastObject;

/**
 在数组的末端插入一个给定的对象。
 
 @param anObject 添加到数组中的对象。
 这个值不能为nil。如果对象是nil报出一个NSInvalidArgumentException错误
 */
- (void)wl_appendObject:(id)anObject;

/**
 在数组的开头加入一个给定的对象。
 
 @param anObject 添加到数组中的对象.
 这个值不能为nil.如果对象是nil报出一个NSInvalidArgumentException错误
 */
- (void)wl_prependObject:(id)anObject;

/**
  将给定数组中包含的对象添加到当前的数组中。
 
 @param objects 添加到接收数组最后面的对象属性. 如果对象是空或nil,此方法没有效果.
 */
- (void)wl_appendObjects:(NSArray *)objects;

/**
 将给定数组中包含的对象添加到接收数组的开始位置。
 
 @param objects 添加到接收数组的开始位置的对象数组。如果对象是空或nil,此方法没有效果。
 */
- (void)wl_prependObjects:(NSArray *)objects;

/**
 将给定数组中的包含对象添加到接收数组的给定索引位置
 
 @param objects 添加到接收数组中的对象数组. 如果对象是空或nil,此方法没有效果。
 
 @param index  插入对象在当前数组的索引. 该值必须小于数组中元素的计数。如果索引大于数组中元素的个数报出NSRangeException的错误
 */
- (void)wl_insertObjects:(NSArray *)objects atIndex:(NSUInteger)index;

/**
 反转对象在数组中的索引位置。
 例如: Before @[ @1, @2, @3 ], After @[ @3, @2, @1 ].
 */
- (void)wl_reverse;

/**
 随机排序该数组的对象
 */
- (void)wl_shuffle;

@end

NS_ASSUME_NONNULL_END

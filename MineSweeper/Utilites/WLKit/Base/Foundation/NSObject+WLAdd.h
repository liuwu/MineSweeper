//
//  NSObject+WLAdd.h
//  Welian
//
//  Created by weLian on 16/5/9.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 NS_ASSUME_NONNULL_BEGIN  NS_ASSUME_NONNULL_END
 在这两个宏之间的代码，所有简单指针对象都被假定为nonnull，因此我们只需要去指定那些nullable的指针。
 */
NS_ASSUME_NONNULL_BEGIN

/**
 *  @author liuwu     , 16-05-09
 *
 *  NSObject的常见任务
 */
@interface NSObject (WLAdd)

#pragma mark - Custom
/**
 *  @author liuwu     , 16-08-01
 *
 *  自动生成属性申明Code
 *  @param dict 传入的字典
 */
- (void)wl_propertyCodeWithDictionary;

#pragma mark - Normal
/**
*  @author liuwu     , 16-05-10
*
*  返回NSString格式的类的名字。
*  @return 类名
*  @since V2.7.9
*/
+ (NSString *)wl_className;

/**
 返回NSString格式的对象的类的名字。
 
 @讨论 苹果已经在NSObject(NSLayoutConstraintCallsThis)实现了该方法，但没有公开它。
*/
- (NSString *)wl_className;

/**
 深度拷贝，NSKeyedArchiver和NSKeyedUnarchiver将对象编码再解码，达到深度拷贝的效果。
 */
- (nullable id)wl_deepCopy;

/**
 深度拷贝，使用archiver类和unarchiver类将对象编码再解码，达到深度拷贝的效果。
 
 @param archiver   NSKeyedArchiver类或者其他类继承.
 @param unarchiver NSKeyedUnarchiver类或者其他类继承.
 */
- (nullable id)wl_deepCopyWithArchiver:(Class)archiver unarchiver:(Class)unarchiver;

#pragma mark - Swap method (Swizzling)
//[Objective-C的hook方案（一）: Method Swizzling](http://blog.csdn.net/yiyaaixuexi/article/details/9374411)
/**
 在一个类中交换两个实例方法的实现。危险，小心使用！
 
 @param originalSel   实例方法 1.
 @param newSel        实例方法 2.
 @return              YES ：交换成功; 否则, NO.
 */
+ (BOOL)wl_swizzleInstanceMethod:(SEL)originalSel with:(SEL)newSel;

/**
 在一个类中交换两个类方法的实现。危险，小心使用！
 
 @param originalSel   类方法 1.
 @param newSel        类方法 2.
 @return              YES ：交换成功; 否则, NO.
 */
+ (BOOL)wl_swizzleClassMethod:(SEL)originalSel with:(SEL)newSel;

#pragma mark - Associate value
///=============================================================================
/// @name 附加值
///=============================================================================
///[[Objective-C]关联(objc_setAssociatedObject、objc_getAssociatedObject、objc_removeAssociatedObjects）](http://blog.csdn.net/onlyou930/article/details/9299169)

/**
 将对象和内存管理语义为strong的value关联。标识为key。
 
 @param value   被附加的对象
 @param key     被附加对象的key.
 */
- (void)wl_setAssociateValue:(nullable id)value withKey:(void *)key;

/**
 将对象和内存管理语义为weak的的value关联。标识为key。
 
 @param value   被附加的对象
 @param key     被附加对象的key.
 */
- (void)wl_setAssociateWeakValue:(nullable id)value withKey:(void *)key;

/**
 获取对象的关联对象。标识为key
 
 @param key 附加对象的key.
 */
- (nullable id)wl_getAssociatedValueForKey:(void *)key;

/**
 移除对象的所有关联对象。
 */
- (void)wl_removeAssociatedValues;


@end

NS_ASSUME_NONNULL_END

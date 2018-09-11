//
//  NSObject+WLAdd.m
//  Welian
//
//  Created by weLian on 16/5/9.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import "NSObject+WLAdd.h"
#import <objc/runtime.h>
#import "WLCGUtilities.h"

WLSYNTH_DUMMY_CLASS(NSObject_WLAdd)

@implementation NSObject (WLAdd)

#pragma mark - Custom
///自动生成属性申明Code
- (void)wl_propertyCodeWithDictionary {
    if (![self isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSMutableString *strM = [NSMutableString string];
    NSDictionary *dict = (NSDictionary *)self;
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        NSString *str;
        
        //        NSLog(@"obj class-------> %@",[obj class]);
        if ([obj isKindOfClass:NSClassFromString(@"__NSCFString")] || [obj isKindOfClass:NSClassFromString(@"NSTaggedPointerString")] || [obj isKindOfClass:NSClassFromString(@"__NSCFConstantString")]) {
            str = [NSString stringWithFormat:@"@property (nonatomic, copy) NSString *%@;",key];
        }
        if ([obj isKindOfClass:NSClassFromString(@"__NSCFNumber")]) {
            str = [NSString stringWithFormat:@"@property (nonatomic, strong) NSNumber *%@;",key];
        }
        if ([obj isKindOfClass:NSClassFromString(@"__NSCFArray")]) {
            str = [NSString stringWithFormat:@"@property (nonatomic, copy) NSArray *%@;",key];
        }
        if ([obj isKindOfClass:NSClassFromString(@"__NSCFDictionary")]) {
            str = [NSString stringWithFormat:@"@property (nonatomic, copy) NSDictionary *%@;",key];
        }
        if ([obj isKindOfClass:NSClassFromString(@"__NSCFBoolean")]) {
            str = [NSString stringWithFormat:@"@property (nonatomic, assign) BOOL %@;",key];
        }
        
        [strM appendFormat:@"\n%@\n",str];
    }];
    
    DLog(@"dict propertyCode ------> :%@",strM);
}

#pragma mark - Normal
/**
 *  @author liuwu     , 16-05-10
 *
 *  返回NSString格式的类的名字。
 *  @return 类名
 *  @since V2.7.9
 */
+ (NSString *)wl_className {
    return [self className];
}

/**
 返回NSString格式的对象的类的名字。
 
 @讨论 苹果已经在NSObject(NSLayoutConstraintCallsThis)实现了该方法，但没有公开它。
 */
- (NSString *)wl_className {
    return [self className];
}

/**
 深度拷贝，NSKeyedArchiver和NSKeyedUnarchiver将对象编码再解码，达到深度拷贝的效果。
 */
- (nullable id)wl_deepCopy {
    return [self deepCopy];
}

/**
 深度拷贝，使用archiver类和unarchiver类将对象编码再解码，达到深度拷贝的效果。
 
 @param archiver   NSKeyedArchiver类或者其他类继承.
 @param unarchiver NSKeyedUnarchiver类或者其他类继承.
 */
- (nullable id)wl_deepCopyWithArchiver:(Class)archiver unarchiver:(Class)unarchiver {
    return [self deepCopyWithArchiver:archiver unarchiver:unarchiver];
}

#pragma mark - Swap method (Swizzling)
/**
 在一个类中交换两个实例方法的实现。危险，小心使用！
 
 @param originalSel   实例方法 1.
 @param newSel        实例方法 2.
 @return              YES ：交换成功; 否则, NO.
 */
+ (BOOL)wl_swizzleInstanceMethod:(SEL)originalSel with:(SEL)newSel {
    return [self swizzleInstanceMethod:originalSel with:newSel];
}

/**
 在一个类中交换两个类方法的实现。危险，小心使用！
 
 @param originalSel   类方法 1.
 @param newSel        类方法 2.
 @return              YES ：交换成功; 否则, NO.
 */
+ (BOOL)wl_swizzleClassMethod:(SEL)originalSel with:(SEL)newSel {
    return [self swizzleClassMethod:originalSel with:newSel];
}


#pragma mark - Associate value
///=============================================================================
/// @name 附加值
///=============================================================================

/**
 将对象和内存管理语义为strong的value关联。标识为key。
 
 @param value   被附加的对象
 @param key     被附加对象的key.
 */
- (void)wl_setAssociateValue:(nullable id)value withKey:(void *)key {
    [self setAssociateValue:value withKey:key];
}

/**
 将对象和内存管理语义为weak的的value关联。标识为key。
 
 @param value   被附加的对象
 @param key     被附加对象的key.
 */
- (void)wl_setAssociateWeakValue:(nullable id)value withKey:(void *)key {
    [self setAssociateWeakValue:value withKey:key];
}

/**
 获取对象的关联对象。标识为key
 
 @param key 附加对象的key.
 */
- (nullable id)wl_getAssociatedValueForKey:(void *)key {
    return [self getAssociatedValueForKey:key];
}

/**
 移除对象的所有关联对象。
 */
- (void)wl_removeAssociatedValues {
    [self removeAssociatedValues];
}

@end

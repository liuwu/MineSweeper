//
//  WLRuntimeClass.h
//  Welian
//
//  Created by dong on 16/3/10.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

// 添加id类型属性
#define ASSOCIATED(propertyName, setter, type, objc_AssociationPolicy)\
- (type)propertyName {\
return objc_getAssociatedObject(self, _cmd);\
}\
\
- (void)setter:(type)object\
{\
objc_setAssociatedObject(self, @selector(propertyName), object, objc_AssociationPolicy);\
}

// 添加BOOL类型属性
#define ASSOCIATED_BOOL(propertyName, setter)\
- (BOOL)propertyName {\
NSNumber *value = objc_getAssociatedObject(self, _cmd); return value.boolValue;\
}\
\
- (void)setter:(BOOL)object\
{\
objc_setAssociatedObject(self, @selector(propertyName), @(object), OBJC_ASSOCIATION_RETAIN_NONATOMIC);\
}

// 添加NSInteger类型属性
#define ASSOCIATED_NSInteger(propertyName, setter)\
- (NSInteger)propertyName {\
NSNumber *value = objc_getAssociatedObject(self, _cmd); return value.integerValue;\
}\
\
- (void)setter:(NSInteger)object\
{\
objc_setAssociatedObject(self, @selector(propertyName), @(object), OBJC_ASSOCIATION_RETAIN_NONATOMIC);\
}

// 添加float类型属性
#define ASSOCIATED_float(propertyName, setter)\
- (float)propertyName {\
NSNumber *value = objc_getAssociatedObject(self, _cmd); return value.floatValue;\
}\
\
- (void)setter:(float)object\
{\
objc_setAssociatedObject(self, @selector(propertyName), @(object), OBJC_ASSOCIATION_RETAIN_NONATOMIC);\
}

// 添加double类型属性
#define ASSOCIATED_double(propertyName, setter)\
- (double)propertyName {\
NSNumber *value = objc_getAssociatedObject(self, _cmd); return value.doubleValue;\
}\
\
- (void)setter:(double)object\
{\
objc_setAssociatedObject(self, @selector(propertyName), @(object), OBJC_ASSOCIATION_RETAIN_NONATOMIC);\
}

// 添加long long类型属性
#define ASSOCIATED_longlong(propertyName, setter)\
- (long long)propertyName {\
NSNumber *value = objc_getAssociatedObject(self, _cmd); return value.longLongValue;\
}\
\
- (void)setter:(long long)object\
{\
objc_setAssociatedObject(self, @selector(propertyName), @(object), OBJC_ASSOCIATION_RETAIN_NONATOMIC);\
}


void WLSwizzlingMethod(Class c, SEL origSEL, SEL newSEL);

//
//  WLKitMacro.h
//  Welian_Normal_Demo
//
//  Created by weLian on 16/6/15.
//  Copyright © 2016年 杭州传送门网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sys/time.h>
#import <pthread.h>

#ifndef WLKitMacro_h
#define WLKitMacro_h


#ifdef __cplusplus
#define WL_EXTERN_C_BEGIN  extern "C" {
#define WL_EXTERN_C_END  }
#else
#define WL_EXTERN_C_BEGIN
#define WL_EXTERN_C_END
#endif


WL_EXTERN_C_BEGIN

///返回三个数的中值
#ifndef WL_CLAMP
#define WL_CLAMP(_x_, _low_, _high_)  (((_x_) > (_high_)) ? (_high_) : (((_x_) < (_low_)) ? (_low_) : (_x_)))
#endif

///交换两个数
#ifndef WL_SWAP
#define WL_SWAP(_a_, _b_)  do { __typeof__(_a_) _tmp_ = (_a_); (_a_) = (_b_); (_b_) = _tmp_; } while (0)
#endif

///[iOS - 断言处理与调试](http://www.jianshu.com/p/7cea580441d3)
///当条件condition不满足时，抛出异常，并打印(description, …)。这个宏被展开之后持有了self，那么有可能就会出现引用不释放的问题。
#define WLAssertNil(condition, description, ...) NSAssert(!(condition), (description), ##__VA_ARGS__)
//同上，但WLCAssertNil展开之后并没有持有self，不会出现引用不释放的问题。
#define WLCAssertNil(condition, description, ...) NSCAssert(!(condition), (description), ##__VA_ARGS__)

///当条件condition满足时，抛出异常，并打印(description, …)。这个宏被展开之后持有了self，那么有可能就会出现引用不释放的问题。
#define WLAssertNotNil(condition, description, ...) NSAssert((condition), (description), ##__VA_ARGS__)
///同上，但WLCAssertNotNil展开之后并没有持有self，不会出现引用不释放的问题。
#define WLCAssertNotNil(condition, description, ...) NSCAssert((condition), (description), ##__VA_ARGS__)

///判断此方法有没有在主线程调用，没有的话抛出异常，打印@“This method must be called on the main thread"
#define WLAssertMainThread() NSAssert([NSThread isMainThread], @"This method must be called on the main thread")
///同上，WLCAssertMainThread展开之后并没有持有self，不会出现引用不释放的问题。
#define WLCAssertMainThread() NSCAssert([NSThread isMainThread], @"This method must be called on the main thread")


/**
 在每个类实现前添加此宏，所以，我们不必使用-all_load 或 -force_load 从静态库文件中加载对象文件。
 更多信息: http://developer.apple.com/library/mac/#qa/qa2006/qa1490.html .
 
 解决使用静态库的一些问题，
 [使用静态库的一些问题 -all_load](http://www.cnblogs.com/ygm900/archive/2013/07/15/3191003.html)
 *******************************************************************************
 Example:
 WLSYNTH_DUMMY_CLASS(NSString_WLAdd)
 */
#ifndef WLSYNTH_DUMMY_CLASS
#define WLSYNTH_DUMMY_CLASS(_name_) \
@interface WLSYNTH_DUMMY_CLASS_ ## _name_ : NSObject @end \
@implementation WLSYNTH_DUMMY_CLASS_ ## _name_ @end
#endif


/**
 在类别里添加自定义对象属性时候使用，给属性绑getter和setter方法。
 _association_是属性的内存管理语义，_type_是属性的类型。
 
 @param association  ASSIGN / RETAIN / COPY / RETAIN_NONATOMIC / COPY_NONATOMIC
 @警告 #import <objc/runtime.h>
 *******************************************************************************
 Example:
 @interface NSObject (MyAdd)
 @property (nonatomic, retain) UIColor *myColor;
 @end
 
 #import <objc/runtime.h>
 @implementation NSObject (MyAdd)
 WLSYNTH_DYNAMIC_PROPERTY_OBJECT(myColor, setMyColor, RETAIN, UIColor *)
 @end
 */
#ifndef WLSYNTH_DYNAMIC_PROPERTY_OBJECT
#define WLSYNTH_DYNAMIC_PROPERTY_OBJECT(_getter_, _setter_, _association_, _type_) \
- (void)_setter_ : (_type_)object { \
    [self willChangeValueForKey:@#_getter_]; \
    objc_setAssociatedObject(self, _cmd, object, OBJC_ASSOCIATION_ ## _association_); \
    [self didChangeValueForKey:@#_getter_]; \
} \
- (_type_)_getter_ { \
    return objc_getAssociatedObject(self, @selector(_setter_:)); \
}
#endif

/**
 在类别里添加自定义C类型属性时候使用，给属性绑getter和setter方法。
 _association_是属性的内存管理语义，_type_是属性的类型。
 
 Synthsize a dynamic c type property in @implementation scope.
 It allows us to add custom properties to existing classes in categories.
 
 @警告 #import <objc/runtime.h>
 *******************************************************************************
 Example:
 @interface NSObject (MyAdd)
 @property (nonatomic, retain) CGPoint myPoint;
 @end
 
 #import <objc/runtime.h>
 @implementation NSObject (MyAdd)
 WLSYNTH_DYNAMIC_PROPERTY_CTYPE(myPoint, setMyPoint, CGPoint)
 @end
 */
#ifndef WLSYNTH_DYNAMIC_PROPERTY_CTYPE
#define WLSYNTH_DYNAMIC_PROPERTY_CTYPE(_getter_, _setter_, _type_) \
- (void)_setter_ : (_type_)object { \
    [self willChangeValueForKey:@#_getter_]; \
    NSValue *value = [NSValue value:&object withObjCType:@encode(_type_)]; \
    objc_setAssociatedObject(self, _cmd, value, OBJC_ASSOCIATION_RETAIN); \
    [self didChangeValueForKey:@#_getter_]; \
} \
- (_type_)_getter_ { \
    _type_ cValue = { 0 }; \
    NSValue *value = objc_getAssociatedObject(self, @selector(_setter_:)); \
    [value getValue:&cValue]; \
    return cValue; \
}
#endif

///避免Block拥有self而造成循环引用
#ifndef weakify
    #if DEBUG
        #if __has_feature(objc_arc)
        #define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
        #else
        #define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
        #endif
    #else
        #if __has_feature(objc_arc)
        #define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
        #else
        #define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
        #endif
    #endif
#endif

///给Block里的self加上强引用，避免Block里的self提前释放掉了。
#ifndef strongify
    #if DEBUG
        #if __has_feature(objc_arc)
        #define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
        #else
        #define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
        #endif
    #else
        #if __has_feature(objc_arc)
        #define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
        #else
        #define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
        #endif
    #endif
#endif


/**
 将CFRange转换为NSRange
 @param range CFRange 
 @return NSRange
 */
static inline NSRange WLNSRangeFromCFRange(CFRange range) {
    return NSMakeRange(range.location, range.length);
}

/**
 将NSRange转换为CFRange
 @param range NSRange 
 @return CFRange
 */
static inline CFRange WLCFRangeFromNSRange(NSRange range) {
    return CFRangeMake(range.location, range.length);
}

/**
 //支持iOS6的CFAutorelease方法
 @param arg CFObject 
 @return same as input
 */
static inline CFTypeRef WLCFAutorelease(CFTypeRef CF_RELEASES_ARGUMENT arg) {
    if (((long)CFAutorelease + 1) != 1) {
        return CFAutorelease(arg);
    } else {
        id __autoreleasing obj = CFBridgingRelease(arg);
        return (__bridge CFTypeRef)obj;
    }
}

/**
 执行block所消耗的时间，单位毫秒
 @param ^block     code to benchmark
 @param ^complete  code time cost (millisecond)
 
 用法:
 WLBenchmark(^{
 // code
 }, ^(double ms) {
 NSLog(@"time cost: %.2f ms",ms);
 });
 
 */
static inline void WLBenchmark(void (^block)(void), void (^complete)(double ms)) {
    // <QuartzCore/QuartzCore.h> version
    /*
     extern double CACurrentMediaTime (void);
     double begin, end, ms;
     begin = CACurrentMediaTime();
     block();
     end = CACurrentMediaTime();
     ms = (end - begin) * 1000.0;
     complete(ms);
     */
    
    // <sys/time.h> version
    struct timeval t0, t1;
    gettimeofday(&t0, NULL);
    block();
    gettimeofday(&t1, NULL);
    double ms = (double)(t1.tv_sec - t0.tv_sec) * 1e3 + (double)(t1.tv_usec - t0.tv_usec) * 1e-3;
    complete(ms);
}

//获取这行代码的编译时间（非执行时间）。
static inline NSDate *_WLCompileTime(const char *data, const char *time) {
    NSString *timeStr = [NSString stringWithFormat:@"%s %s",data,time];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM dd yyyy HH:mm:ss"];
    [formatter setLocale:locale];
    return [formatter dateFromString:timeStr];
}

/**
 获取这行代码的编译时间（非执行时间）。
 Get compile timestamp.
 @return A new date object set to the compile date and time.
 */
#ifndef WLCompileTime
// use macro to avoid compile warning when use pch file
#define WLCompileTime() _WLCompileTime(__DATE__, __TIME__)
#endif

/**
 在现在多少秒后的时间
 Returns a dispatch_time delay from now.
 */
static inline dispatch_time_t wl_dispatch_time_delay(NSTimeInterval second) {
    return dispatch_time(DISPATCH_TIME_NOW, (int64_t)(second * NSEC_PER_SEC));
}

/**
 Returns a dispatch_wall_time delay from now.
 */
static inline dispatch_time_t wl_dispatch_walltime_delay(NSTimeInterval second) {
    return dispatch_walltime(DISPATCH_TIME_NOW, (int64_t)(second * NSEC_PER_SEC));
}

/**
 Returns a dispatch_wall_time from NSDate.
 //同上，但当你的设备进入睡眠状态dispatch_time停止运行。dispatch_walltime继续运行
 */
static inline dispatch_time_t wl_dispatch_walltime_date(NSDate *date) {
    NSTimeInterval interval;
    double second, subsecond;
    struct timespec time;
    dispatch_time_t milestone;
    
    interval = [date timeIntervalSince1970];
    subsecond = modf(interval, &second);
    time.tv_sec = second;
    time.tv_nsec = subsecond * NSEC_PER_SEC;
    milestone = dispatch_walltime(&time, 0);
    return milestone;
}

/**
 是否是在主线程
 */
static inline bool wl_dispatch_is_main_queue() {
    return pthread_main_np() != 0;
}

/**
 在主队列中提交一个异步执行的block，并立即返回。
 */
static inline void wl_dispatch_async_on_main_queue(void (^block)()) {
    if (pthread_main_np()) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

/**
 在一个主队列中提交一个block并等待完成
 */
static inline void wl_dispatch_sync_on_main_queue(void (^block)()) {
    if (pthread_main_np()) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

/**
 Initialize a pthread mutex.
 初始化一个互斥锁，pthread_mutex_lock声明开始用互斥锁上锁，此后的代码直至调用pthread_mutex_unlock为止，均被上锁，即同一时间只能被一个线程调用执行。
 [多线程编程-互斥锁](http://blog.chinaunix.net/uid-21411227-id-1826888.html)
 */
static inline void wl_pthread_mutex_init_recursive(pthread_mutex_t *mutex, bool recursive) {
#define WLMUTEX_ASSERT_ON_ERROR(x_) do { \
__unused volatile int res = (x_); \
assert(res == 0); \
} while (0)
    assert(mutex != NULL);
    if (!recursive) {
        WLMUTEX_ASSERT_ON_ERROR(pthread_mutex_init(mutex, NULL));
    } else {
        pthread_mutexattr_t attr;
        WLMUTEX_ASSERT_ON_ERROR(pthread_mutexattr_init (&attr));
        WLMUTEX_ASSERT_ON_ERROR(pthread_mutexattr_settype (&attr, PTHREAD_MUTEX_RECURSIVE));
        WLMUTEX_ASSERT_ON_ERROR(pthread_mutex_init (mutex, &attr));
        WLMUTEX_ASSERT_ON_ERROR(pthread_mutexattr_destroy (&attr));
    }
#undef WLMUTEX_ASSERT_ON_ERROR
}

WL_EXTERN_C_END

#endif /* WLKitMacro_h */

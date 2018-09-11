//
//  NSNotificationCenter+WLAdd.h
//  Welian
//
//  Created by weLian on 16/5/16.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>

// 配置文件
#ifndef kNSNotification
#define kNSNotification   [NSNotificationCenter defaultCenter]
#endif

/*
 NS_ASSUME_NONNULL_BEGIN  NS_ASSUME_NONNULL_END
 在这两个宏之间的代码，所有简单指针对象都被假定为nonnull，因此我们只需要去指定那些nullable的指针。
 */
NS_ASSUME_NONNULL_BEGIN


/**
 NSNotificationCenter在不同的线程进行通知的一些方法。
 */
@interface NSNotificationCenter (WLAdd)

/**
 在主线程发通知。（如果现在不在主线程，则异步发送通知）
 
 @param notification  发送的通知.
 如果通知是nil会引发异常.
 */
- (void)wl_postNotificationOnMainThread:(NSNotification *)notification;

/**
 在主线程发通知。（如果现在不在主线程，wait 为 YES 则阻塞主线程发送通知）
 
 @param notification 发送的通知.如果通知是nil会引发异常.
 @param wait   一个布尔值用来指定是否阻塞线程直到通知在主线程上发送给接收者.
 指定YES阻止当前线程; 否则, 指定NO此方法立即返回。
 */
- (void)wl_postNotificationOnMainThread:(NSNotification *)notification
                          waitUntilDone:(BOOL)wait;

/**
 在主线程创建一个通知发送。（如果现在不在主线程，则异步创建发送通知）
 
 @param name    通知的名称.
 @param object  发送通知的对象.
 */
- (void)wl_postNotificationOnMainThreadWithName:(NSString *)name
                                         object:(nullable id)object;

/**
 在主线程创建一个通知发送。（如果现在不在主线程，wait 为 YES 则阻塞主线程去发通知）
 在主线程发送一个用给定的名称创建的通知给接收者. 如果当前线程是主线程，则同步通知；否则，异步通知.
 
 @param name    通知的名称.
 @param object  发送通知的对象.
 @param userInfo  有关通知的信息. 可能是nil.
 */
- (void)wl_postNotificationOnMainThreadWithName:(NSString *)name
                                         object:(nullable id)object
                                       userInfo:(nullable NSDictionary *)userInfo;

/**
 在主线程发送一个用给定的名称创建的通知给接收者.
 
 @param name    通知的名称.
 @param object  发送通知的对象.
 @param userInfo  有关通知的信息. 可能是nil.
 @param wait    一个布尔值用来指定是否阻塞线程直到通知在主线程上发送给接收者.
 指定YES阻止当前线程; 否则, 指定NO此方法立即返回。
 */
- (void)wl_postNotificationOnMainThreadWithName:(NSString *)name
                                         object:(nullable id)object
                                       userInfo:(nullable NSDictionary *)userInfo
                                  waitUntilDone:(BOOL)wait;

@end

NS_ASSUME_NONNULL_END


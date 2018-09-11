//
//  NSObject+WLAddForKVO.h
//  Welian
//
//  Created by weLian on 16/5/16.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 NS_ASSUME_NONNULL_BEGIN  NS_ASSUME_NONNULL_END
 在这两个宏之间的代码，所有简单指针对象都被假定为nonnull，因此我们只需要去指定那些nullable的指针。
 */
NS_ASSUME_NONNULL_BEGIN


/**
 观察模块（KVO）
 */
@interface NSObject (WLAddForKVO)
///[IOS SDK详解之KVO]（http://www.2cto.com/kf/201502/378470.html）

/**
 通过指定的keyPath注册一个接收KVO通知的接收器。
 
 @讨论 被保留的块和块捕获的对象. 调用 `removeObserverBlocksForKeyPath:` 或 `removeObserverBlocks` 释放.
 
 @param keyPath 关键路径, 相当于接收器的观察属性.这个值不能为nil.
 @param block   注册KVO通知的块.
 */
- (void)wl_addObserverBlockForKeyPath:(NSString*)keyPath block:(void (^)(id _Nonnull obj, _Nullable id oldVal, _Nullable id newVal))block;

/**
 停止所有的 (通过`addObserverBlockForKeyPath:block:`进行关联) 从给定的keyPath接收属性来接收更改的通知的块，并释放这些块。
 
 @param keyPath 关键路径, 相对于接收器用来注册KVO改变通知的块。
 */
- (void)wl_removeObserverBlocksForKeyPath:(NSString*)keyPath;

/**
 停止所有从接收改变通知的块(关联使用 `addObserverBlockForKeyPath:block:`),并释放这些块.
 */
- (void)wl_removeObserverBlocks;

@end

NS_ASSUME_NONNULL_END

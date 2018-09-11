//
//  NSObject+WLAddForKVO.m
//  Welian
//
//  Created by weLian on 16/5/16.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import "NSObject+WLAddForKVO.h"
#import <objc/runtime.h>
#import "WLCGUtilities.h"

WLSYNTH_DUMMY_CLASS(NSObject_WLAddForKVO)

static const int block_key;

@interface WL_WLNSObjectKVOBlockTarget : NSObject

@property (nonatomic, copy) void (^block)(__weak id obj, id oldVal, id newVal);

- (id)initWithBlock:(void (^)(__weak id obj, id oldVal, id newVal))block;

@end

@implementation WL_WLNSObjectKVOBlockTarget

- (id)initWithBlock:(void (^)(__weak id obj, id oldVal, id newVal))block {
    self = [super init];
    if (self) {
        self.block = block;
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (!self.block) return;
    
    BOOL isPrior = [[change objectForKey:NSKeyValueChangeNotificationIsPriorKey] boolValue];
    if (isPrior) return;
    
    NSKeyValueChange changeKind = [[change objectForKey:NSKeyValueChangeKindKey] integerValue];
    if (changeKind != NSKeyValueChangeSetting) return;
    
    id oldVal = [change objectForKey:NSKeyValueChangeOldKey];
    if (oldVal == [NSNull null]) oldVal = nil;
    
    id newVal = [change objectForKey:NSKeyValueChangeNewKey];
    if (newVal == [NSNull null]) newVal = nil;
    
    self.block(object, oldVal, newVal);
}

@end

@implementation NSObject (WLAddForKVO)

/**
 通过指定的keyPath注册一个接收KVO通知的接收器。
 
 @讨论 被保留的块和块捕获的对象. 调用 `removeObserverBlocksForKeyPath:` 或 `removeObserverBlocks` 释放.
 
 @param keyPath 关键路径, 相当于接收器的观察属性.这个值不能为nil.
 @param block   注册KVO通知的块.
 */
- (void)wl_addObserverBlockForKeyPath:(NSString*)keyPath block:(void (^)(id _Nonnull obj, _Nullable id oldVal, _Nullable id newVal))block {
    if (!keyPath || !block) return;
    WL_WLNSObjectKVOBlockTarget *target = [[WL_WLNSObjectKVOBlockTarget alloc] initWithBlock:block];
    NSMutableDictionary *dic = [self wl_allNSObjectObserverBlocks];
    NSMutableArray *arr = dic[keyPath];
    if (!arr) {
        arr = [NSMutableArray new];
        dic[keyPath] = arr;
    }
    [arr addObject:target];
    [self addObserver:target forKeyPath:keyPath options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
}

/**
 停止所有的 (通过`addObserverBlockForKeyPath:block:`进行关联) 从给定的keyPath接收属性来接收更改的通知的块，并释放这些块。
 
 @param keyPath 关键路径, 相对于接收器用来注册KVO改变通知的块。
 */
- (void)wl_removeObserverBlocksForKeyPath:(NSString*)keyPath {
    if (!keyPath) return;
    NSMutableDictionary *dic = [self wl_allNSObjectObserverBlocks];
    NSMutableArray *arr = dic[keyPath];
    [arr enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        [self removeObserver:obj forKeyPath:keyPath];
    }];
    
    [dic removeObjectForKey:keyPath];
}

/**
 停止所有从接收改变通知的块(关联使用 `addObserverBlockForKeyPath:block:`),并释放这些块.
 */
- (void)wl_removeObserverBlocks {
    NSMutableDictionary *dic = [self wl_allNSObjectObserverBlocks];
    [dic enumerateKeysAndObjectsUsingBlock: ^(NSString *key, NSArray *arr, BOOL *stop) {
        [arr enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
            [self removeObserver:obj forKeyPath:key];
        }];
    }];
    
    [dic removeAllObjects];
}

- (NSMutableDictionary *)wl_allNSObjectObserverBlocks {
    NSMutableDictionary *targets = objc_getAssociatedObject(self, &block_key);
    if (!targets) {
        targets = [NSMutableDictionary new];
        objc_setAssociatedObject(self, &block_key, targets, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return targets;
}

@end

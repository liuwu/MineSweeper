//
//  WLPersistanceAsyncExecutor.m
//  Welian
//
//  Created by weLian on 16/9/9.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import "WLPersistanceAsyncExecutor.h"

@interface WLPersistanceAsyncExecutor ()

@property (nonatomic, strong) NSOperationQueue *operationQueue;

@end

@implementation WLPersistanceAsyncExecutor

#pragma mark - public methods
+ (instancetype)sharedInstance {
    static WLPersistanceAsyncExecutor *executor = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        executor = [[WLPersistanceAsyncExecutor alloc] init];
    });
    return executor;
}

- (void)performAsyncAction:(void (^)(void))action shouldWaitUntilDone:(BOOL)shouldWaitUntilDone {
    __block volatile BOOL shouldWait = shouldWaitUntilDone;
    
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        action();
        shouldWait = NO;
    }];
    
    [self.operationQueue addOperation:operation];
    
    while (shouldWait) {
    }
}

#pragma mark - getters and setters
- (NSOperationQueue *)operationQueue {
    if (_operationQueue == nil) {
        _operationQueue = [[NSOperationQueue alloc] init];
        _operationQueue.maxConcurrentOperationCount = 1;
    }
    return _operationQueue;
}

@end

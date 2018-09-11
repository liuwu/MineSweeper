//
//  WLPersistanceAsyncExecutor.h
//  Welian
//
//  Created by weLian on 16/9/9.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 异步线程执行
 */
@interface WLPersistanceAsyncExecutor : NSObject


+ (instancetype)sharedInstance;

/**
 *  执行异步方法.
 *
 *  you must always create WLPersistanceTable in action block, do not use outside table instance in this block.
 *
 *  @param action              the action block to be performed
 *  @param shouldWaitUntilDone if YES, this method will not end until action block has finished.
 */
- (void)performAsyncAction:(void (^)(void))action shouldWaitUntilDone:(BOOL)shouldWaitUntilDone;

@end

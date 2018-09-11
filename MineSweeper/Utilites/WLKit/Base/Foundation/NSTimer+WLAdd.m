//
//  NSTimer+WLAdd.m
//  Welian
//
//  Created by weLian on 16/5/13.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import "NSTimer+WLAdd.h"
#import "WLCGUtilities.h"

WLSYNTH_DUMMY_CLASS(NSTimer_WLAdd)

@implementation NSTimer (WLAdd)

/**
 *  @author liuwu     , 16-05-13
 *
 *  暂停NSTimer
 *  @since V2.7.9
 */
- (void)wl_pauseTimer {
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate distantFuture]];
}

/**
 *  @author liuwu     , 16-05-13
 *
 *  开始NSTimer
 *  @since V2.7.9
 */
- (void)wl_resumeTimer {
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate date]];
}

/**
 *  @author liuwu     , 16-05-13
 *
 *  延迟开始NSTimer
 *  @param interval 时间
 *  @since V2.7.9
 */
- (void)wl_resumeTimerAfterTimeInterval:(NSTimeInterval)interval {
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:interval]];
}

+ (void)WL_ExecBlock:(NSTimer *)timer {
    if ([timer userInfo]) {
        void (^block)(NSTimer *timer) = (void (^)(NSTimer *timer))[timer userInfo];
        block(timer);
    }
}

+ (NSTimer *)wl_scheduledTimerWithTimeInterval:(NSTimeInterval)seconds block:(void (^)(NSTimer *timer))block repeats:(BOOL)repeats {
    return [NSTimer scheduledTimerWithTimeInterval:seconds target:self selector:@selector(WL_ExecBlock:) userInfo:[block copy] repeats:repeats];
}

+ (NSTimer *)wl_timerWithTimeInterval:(NSTimeInterval)seconds block:(void (^)(NSTimer *timer))block repeats:(BOOL)repeats {
    return [NSTimer timerWithTimeInterval:seconds target:self selector:@selector(WL_ExecBlock:) userInfo:[block copy] repeats:repeats];
}

@end

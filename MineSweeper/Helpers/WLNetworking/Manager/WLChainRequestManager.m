//
//  WLChainRequestManager.m
//  Welian_Network_Demo
//
//  Created by weLian on 16/7/4.
//  Copyright © 2016年 杭州传送门网络科技有限公司. All rights reserved.
//

#import "WLChainRequestManager.h"

@interface WLChainRequestManager ()

@property (strong, nonatomic) NSMutableArray *requestArray;

@end

@implementation WLChainRequestManager

+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[WLChainRequestManager alloc] init];
    });
    return sharedInstance;
}

///添加一组队列请求
- (void)addChainRequest:(WLChainRequest *)request {
    @synchronized(self) {
        [self.requestArray addObject:request];
    }
}

///移除一组队列请求
- (void)removeChainRequest:(WLChainRequest *)request {
    @synchronized(self) {
        [self.requestArray removeObject:request];
    }
}

#pragma mark - Getter&settter
- (NSMutableArray *)requestArray {
    if (_requestArray == nil) {
        _requestArray = [NSMutableArray array];
    }
    return _requestArray;
}

@end

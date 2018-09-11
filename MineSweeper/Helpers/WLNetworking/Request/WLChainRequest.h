//
//  WLChainRequest.h
//  Welian_MVP
//
//  Created by weLian on 16/7/2.
//  Copyright © 2016年 杭州传送门网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WLRequest.h"

@class WLChainRequest;
@protocol WLChainRequestDelegate <NSObject>

@optional
/// 请求完成
- (void)chainRequestFinished:(WLChainRequest *)chainRequest;
/// 请求失败
- (void)chainRequestFailed:(WLChainRequest *)chainRequest
         failedBaseRequest:(WLRequest *)request;
@end

typedef void (^WLChainCallback)(WLChainRequest *chainRequest, WLRequest *request);

/**
 *  完成一组存在依赖关系的请求，所有请求完成，请求成功
 */
@interface WLChainRequest : NSObject

/// 请求的代理
@property (weak, nonatomic) id<WLChainRequestDelegate> delegate;
//@property (nonatomic, strong) NSMutableArray *requestAccessories;

/// 获取请求接口的数组
- (NSArray *)requestArray;

/// 开始请求
- (void)start;

/// 关闭请求
- (void)stop;

/// 添加请求
- (void)addRequest:(WLRequest *)request callback:(WLChainCallback)callback;

@end

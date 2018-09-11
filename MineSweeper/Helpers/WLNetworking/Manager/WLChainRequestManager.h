//
//  WLChainRequestManager.h
//  Welian_Network_Demo
//
//  Created by weLian on 16/7/4.
//  Copyright © 2016年 杭州传送门网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WLChainRequest.h"

/**
 *  用来管理WLChainRequest的请求信息
 */
@interface WLChainRequestManager : NSObject

+ (instancetype)sharedInstance;

/// 添加一组队列请求
- (void)addChainRequest:(WLChainRequest *)request;

/// 移除一组队列请求
- (void)removeChainRequest:(WLChainRequest *)request;

@end

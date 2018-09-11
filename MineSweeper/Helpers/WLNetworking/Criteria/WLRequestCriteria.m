//
//  WLRequestCriteria.m
//  Welian
//
//  Created by weLian on 16/9/12.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import "WLRequestCriteria.h"

@interface WLRequestCriteria ()

@end

@implementation WLRequestCriteria

- (instancetype)init {
    self = [super init];
    if (self) {
        self.cacheTimeInSeconds = -1;
        self.requestTimeoutInterval = kWLNetworkingTimeoutSeconds;
        self.requestMethodType = WLRequestMethodTypePost;
        self.requestSerializerType = WLRequestSerializerTypeJSON;
        self.reponseSerializerType = WLResponseSerializerTypeHTTP;
        self.removesKeysWithNullValues = YES;
        self.requestCoverType = WLRequestCoverTypeNormal;
        self.ignoreDecryptAES256Value = NO;
        self.ignoreHttpHeader = NO;
    }
    return self;
}

@end

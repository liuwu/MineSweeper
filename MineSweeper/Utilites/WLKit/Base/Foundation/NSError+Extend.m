//
//  NSError+Extend.m
//  The Dragon
//
//  Created by yangxh on 12-7-16.
//  Copyright (c) 2012年 杭州引力网络技术有限公司. All rights reserved.
//

#import "NSError+Extend.h"

@implementation NSError (Extend)

+ (NSError *)errorWithMsg:(NSString *)msg{
    return [self errorWithMsg:msg code:-1000];
}

+ (NSError *)errorWithMsg:(NSString *)msg code:(NSInteger)code {
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:msg? : @"连接错误，请稍后再试", NSLocalizedDescriptionKey, nil];
    return [NSError errorWithDomain:msg?:@"ERROR DOMAIN" code:code userInfo:userInfo];
}

@end

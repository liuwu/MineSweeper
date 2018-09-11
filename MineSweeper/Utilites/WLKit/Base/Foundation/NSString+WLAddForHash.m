//
//  NSString+WLAddForHash.m
//  Welian
//
//  Created by weLian on 16/5/9.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import "NSString+WLAddForHash.h"
#import "NSData+WLAddForHash.h"
#import "WLCGUtilities.h"

WLSYNTH_DUMMY_CLASS(NSString_WLAddForHash)

@implementation NSString (WLAddForHash)

/**
 返回一个MD2加密的小写NSString字符串
 */
- (nullable NSString *)wl_md2String {
    return [self md2String];
}

/**
 返回一个MD4加密的小写NSString字符串
 */
- (nullable NSString *)wl_md4String {
    return [self md4String];
}

/**
 返回一个MD5加密的小写NSString字符串
 */
- (nullable NSString *)wl_md5String {
    return [self md5String];
}

/**
 返回一个sha1加密的小写NSString字符串
 */
- (nullable NSString *)wl_sha1String {
    return [self sha1String];
}

/**
 返回一个sha224加密的小写NSString字符串
 */
- (nullable NSString *)wl_sha224String {
    return [self sha224String];
}

/**
 返回一个sha256加密的小写NSString字符串
 */
- (nullable NSString *)wl_sha256String {
    return [self sha256String];
}

/**
 返回一个sha384加密的小写NSString字符串
 */
- (nullable NSString *)wl_sha384String {
    return [self sha384String];
}

/**
 返回一个sha512加密的小写NSString字符串
 */
- (nullable NSString *)wl_sha512String {
    return [self sha512String];
}

/**
 Returns a lowercase NSString for hmac using algorithm md5 with key.
 返回一个hmac的小写NSString字符串，使用md5加密的key的计算方式
 @param key hmac的密钥
 */
- (nullable NSString *)wl_hmacMD5StringWithKey:(NSString *)key {
    return [self hmacMD5StringWithKey:key];
}

/**
 Returns a lowercase NSString for hmac using algorithm sha1 with key.
 返回一个hmac的小写NSString字符串，使用SHA1加密的key的计算方式
 @param key hmac的密钥
 */
- (nullable NSString *)wl_hmacSHA1StringWithKey:(NSString *)key {
    return [self hmacSHA1StringWithKey:key];
}

/**
 Returns a lowercase NSString for hmac using algorithm sha224 with key.
 返回一个hmac的小写NSString字符串，使用SHA224加密的key的计算方式
 @param key hmac的密钥
 */
- (nullable NSString *)wl_hmacSHA224StringWithKey:(NSString *)key {
    return [self hmacSHA224StringWithKey:key];
}

/**
 Returns a lowercase NSString for hmac using algorithm sha256 with key.
 返回一个hmac的小写NSString字符串，使用SHA256加密的key的计算方式
 @param key hmac的密钥
 */
- (nullable NSString *)wl_hmacSHA256StringWithKey:(NSString *)key {
    return [self hmacSHA256StringWithKey:key];
}

/**
 Returns a lowercase NSString for hmac using algorithm sha384 with key.
 返回一个hmac的小写NSString字符串，使用SHA1384加密的key的计算方式
 @param key hmac的密钥
 */
- (nullable NSString *)wl_hmacSHA384StringWithKey:(NSString *)key {
    return [self hmacSHA384StringWithKey:key];
}

/**
 Returns a lowercase NSString for hmac using algorithm sha512 with key.
 返回一个hmac的小写NSString字符串，使用SHA512加密的key的计算方式
 @param key hmac的密钥
 */
- (nullable NSString *)wl_hmacSHA512StringWithKey:(NSString *)key {
    return [self hmacSHA512StringWithKey:key];
}

/**
 Returns a lowercase NSString for crc32 hash.
 返回一个src32加密的小写NSString字符串
 */
- (nullable NSString *)wl_crc32String {
    return [self crc32String];
}

@end

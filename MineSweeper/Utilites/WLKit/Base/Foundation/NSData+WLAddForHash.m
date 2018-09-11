//
//  NSData+WLAddForHash.m
//  Welian
//
//  Created by weLian on 16/5/9.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import "NSData+WLAddForHash.h"
#include <CommonCrypto/CommonCrypto.h>
#include <zlib.h>
#import "WLCGUtilities.h"

WLSYNTH_DUMMY_CLASS(NSData_WLAddForHash)

@implementation NSData (WLAddForHash)

/**
 返回一个MD2加密的小写NSString字符串
 */
- (NSString *)wl_md2String {
    return [self md2String];
}

/**
 返回一个MD2加密的NSData数据
 */
- (NSData *)wl_md2Data {
    return [self md2Data];
}

/**
 返回一个MD4加密的小写NSString字符串
 */
- (NSString *)wl_md4String {
    return [self md4String];
}

/**
 返回一个MD4加密的NSData数据
 */
- (NSData *)wl_md4Data {
    return [self md4Data];
}

/**
 返回一个MD5加密的小写NSString字符串
 */
- (NSString *)wl_md5String {
    return [self md5String];
}

/**
 返回一个MD5加密的NSData数据
 */
- (NSData *)wl_md5Data {
    return [self md5Data];
}

/*
 返回一个SHA1加密的小写NSString字符串
 */
- (NSString *)wl_sha1String {
    return [self sha1String];
}

/**
 返回一个SHA1加密的NSData数据
 */
- (NSData *)wl_sha1Data {
    return [self sha1Data];
}

/**
 返回一个SHA224加密的小写NSString字符串
 */
- (NSString *)wl_sha224String {
    return [self sha224String];
}

/*
 返回一个SHA224加密的NSData数据
 */
- (NSData *)wl_sha224Data {
    return [self sha224Data];
}

/**
 返回一个SHA256加密的小写NSString字符串
 */
- (NSString *)wl_sha256String {
    return [self sha256String];
}

/**
 返回一个SHA256加密的NSData数据
 */
- (NSData *)wl_sha256Data {
    return [self sha256Data];
}

/*
 返回一个SHA384加密的小写NSString字符串
 */
- (NSString *)wl_sha384String {
    return [self sha384String];
}

/**
 返回一个SHA384加密的NSData数据
 */
- (NSData *)wl_sha384Data {
    return [self sha384Data];
}

/**
 返回一个SHA512加密的小写NSString字符串
 */
- (NSString *)wl_sha512String {
    return [self sha512String];
}

/**
 返回一个SHA512加密的NSData数据
 */
- (NSData *)wl_sha512Data {
    return [self sha512Data];
}

/**
 返回一个hmac的小写NSString字符串，使用md5加密的key的计算方式
 @param key  hmac的密钥
 */
- (NSString *)wl_hmacMD5StringWithKey:(NSString *)key {
    return [self hmacMD5StringWithKey:key];
}

/**
 返回一个hmac的NSData数据，使用md5加密的key的计算方式
 @param key  hmac的密钥
 */
- (NSData *)wl_hmacMD5DataWithKey:(NSData *)key {
    return [self hmacMD5DataWithKey:key];
}

/**
 Returns a lowercase NSString for hmac using algorithm sha1 with key.
 返回一个hmac的小写NSString字符串，使用SHA1加密的key的计算方式
 @param key  hmac的密钥
 */
- (NSString *)wl_hmacSHA1StringWithKey:(NSString *)key {
    return [self hmacSHA1StringWithKey:key];
}

/**
 Returns an NSData for hmac using algorithm sha1 with key.
 返回一个hmac的NSData数据，使用SHA1加密的key的计算方式
 @param key  hmac的密钥
 */
- (NSData *)wl_hmacSHA1DataWithKey:(NSData *)key {
    return [self hmacSHA1DataWithKey:key];
}

/**
 Returns a lowercase NSString for hmac using algorithm sha224 with key.
 返回一个hmac的小写NSString字符串，使用SHA224加密的key的计算方式
 @param key  hmac的密钥
 */
- (NSString *)wl_hmacSHA224StringWithKey:(NSString *)key {
    return [self hmacSHA224StringWithKey:key];
}

/**
 Returns an NSData for hmac using algorithm sha224 with key.
 返回一个hmac的NSData数据，使用SHA224加密的key的计算方式
 @param key  hmac的密钥
 */
- (NSData *)wl_hmacSHA224DataWithKey:(NSData *)key {
    return [self hmacSHA224DataWithKey:key];
}

/**
 Returns a lowercase NSString for hmac using algorithm sha256 with key.
 返回一个hmac的小写NSString字符串，使用SHA256加密的key的计算方式
 @param key  hmac的密钥
 */
- (NSString *)wl_hmacSHA256StringWithKey:(NSString *)key {
    return [self hmacSHA256StringWithKey:key];
}

/**
 Returns an NSData for hmac using algorithm sha256 with key.
 返回一个hmac的NSData数据，使用SHA256加密的key的计算方式
 @param key  hmac的密钥
 */
- (NSData *)wl_hmacSHA256DataWithKey:(NSData *)key {
    return [self hmacSHA256DataWithKey:key];
}

/**
 Returns a lowercase NSString for hmac using algorithm sha384 with key.
 返回一个hmac的小写NSString字符串，使用SHA384加密的key的计算方式
 @param key  hmac的密钥
 */
- (NSString *)wl_hmacSHA384StringWithKey:(NSString *)key {
    return [self hmacSHA384StringWithKey:key];
}

/**
 Returns an NSData for hmac using algorithm sha384 with key.
 返回一个hmac的NSData数据，使用SHA384加密的key的计算方式
 @param key  hmac的密钥
 */
- (NSData *)wl_hmacSHA384DataWithKey:(NSData *)key {
    return [self hmacSHA384DataWithKey:key];
}

/**
 Returns a lowercase NSString for hmac using algorithm sha512 with key.
 返回一个hmac的小写NSString字符串，使用SHA512加密的key的计算方式
 @param key  hmac的密钥
 */
- (NSString *)wl_hmacSHA512StringWithKey:(NSString *)key {
    return [self hmacSHA512StringWithKey:key];
}

/**
 Returns an NSData for hmac using algorithm sha512 with key.
 返回一个hmac的NSData数据，使用SHA512加密的key的计算方式
 @param key  hmac的密钥
 */
- (NSData *)wl_hmacSHA512DataWithKey:(NSData *)key {
    return [self hmacSHA512DataWithKey:key];
}

/**
 返回一个src32加密的小写NSString字符串
 */
- (NSString *)wl_crc32String {
    return [self crc32String];
}

/**
 返回src32加密的数据
 */
- (uint32_t)wl_crc32 {
    return [self crc32];
}

@end

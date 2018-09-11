//
//  NSString+WLAddForHash.h
//  Welian
//
//  Created by weLian on 16/5/9.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 NS_ASSUME_NONNULL_BEGIN  NS_ASSUME_NONNULL_END
 在这两个宏之间的代码，所有简单指针对象都被假定为nonnull，因此我们只需要去指定那些nullable的指针。
 */
NS_ASSUME_NONNULL_BEGIN

/**
 *  @author liuwu     , 16-05-09
 *
 *  NSString的加密处理
 */
@interface NSString (WLAddForHash)

/**
 返回一个MD2加密的小写NSString字符串
 */
- (nullable NSString *)wl_md2String;

/**
 返回一个MD4加密的小写NSString字符串
 */
- (nullable NSString *)wl_md4String;

/**
 返回一个MD5加密的小写NSString字符串
 */
- (nullable NSString *)wl_md5String;

/**
 返回一个sha1加密的小写NSString字符串
 */
- (nullable NSString *)wl_sha1String;

/**
  返回一个sha224加密的小写NSString字符串
 */
- (nullable NSString *)wl_sha224String;

/**
  返回一个sha256加密的小写NSString字符串
 */
- (nullable NSString *)wl_sha256String;

/**
  返回一个sha384加密的小写NSString字符串
 */
- (nullable NSString *)wl_sha384String;

/**
  返回一个sha512加密的小写NSString字符串
 */
- (nullable NSString *)wl_sha512String;

/**
 Returns a lowercase NSString for hmac using algorithm md5 with key.
 返回一个hmac的小写NSString字符串，使用md5加密的key的计算方式
 @param key hmac的密钥
 */
- (nullable NSString *)wl_hmacMD5StringWithKey:(NSString *)key;

/**
 Returns a lowercase NSString for hmac using algorithm sha1 with key.
 返回一个hmac的小写NSString字符串，使用SHA1加密的key的计算方式
 @param key hmac的密钥
 */
- (nullable NSString *)wl_hmacSHA1StringWithKey:(NSString *)key;

/**
 Returns a lowercase NSString for hmac using algorithm sha224 with key.
 返回一个hmac的小写NSString字符串，使用SHA224加密的key的计算方式
 @param key hmac的密钥
 */
- (nullable NSString *)wl_hmacSHA224StringWithKey:(NSString *)key;

/**
 Returns a lowercase NSString for hmac using algorithm sha256 with key.
 返回一个hmac的小写NSString字符串，使用SHA256加密的key的计算方式
 @param key hmac的密钥
 */
- (nullable NSString *)wl_hmacSHA256StringWithKey:(NSString *)key;

/**
 Returns a lowercase NSString for hmac using algorithm sha384 with key.
 返回一个hmac的小写NSString字符串，使用SHA1384加密的key的计算方式
 @param key hmac的密钥
 */
- (nullable NSString *)wl_hmacSHA384StringWithKey:(NSString *)key;

/**
 Returns a lowercase NSString for hmac using algorithm sha512 with key.
 返回一个hmac的小写NSString字符串，使用SHA512加密的key的计算方式
 @param key hmac的密钥
 */
- (nullable NSString *)wl_hmacSHA512StringWithKey:(NSString *)key;

/**
 Returns a lowercase NSString for crc32 hash.
 返回一个src32加密的小写NSString字符串
 */
- (nullable NSString *)wl_crc32String;

@end

NS_ASSUME_NONNULL_END

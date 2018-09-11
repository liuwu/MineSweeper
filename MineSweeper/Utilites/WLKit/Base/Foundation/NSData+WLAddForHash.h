//
//  NSData+WLAddForHash.h
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
 *  @author liuwu     , 16-05-10
 *
 *  提供NSData的加密操作
 *  @since V2.7.9
 */
@interface NSData (WLAddForHash)

/**
 返回一个MD2加密的小写NSString字符串
 */
- (NSString *)wl_md2String;

/**
 返回一个MD2加密的NSData数据
 */
- (NSData *)wl_md2Data;

/**
 返回一个MD4加密的小写NSString字符串
 */
- (NSString *)wl_md4String;

/**
 返回一个MD4加密的NSData数据
 */
- (NSData *)wl_md4Data;

/**
 返回一个MD5加密的小写NSString字符串
 */
- (NSString *)wl_md5String;

/**
 返回一个MD5加密的NSData数据
 */
- (NSData *)wl_md5Data;

/*
 返回一个SHA1加密的小写NSString字符串
 */
- (NSString *)wl_sha1String;

/**
 返回一个SHA1加密的NSData数据
 */
- (NSData *)wl_sha1Data;

/**
 返回一个SHA224加密的小写NSString字符串
 */
- (NSString *)wl_sha224String;

/*
 返回一个SHA224加密的NSData数据
 */
- (NSData *)wl_sha224Data;

/**
 返回一个SHA256加密的小写NSString字符串
 */
- (NSString *)wl_sha256String;

/**
 返回一个SHA256加密的NSData数据
 */
- (NSData *)wl_sha256Data;

/*
 返回一个SHA384加密的小写NSString字符串
 */
- (NSString *)wl_sha384String;

/**
 返回一个SHA384加密的NSData数据
 */
- (NSData *)wl_sha384Data;

/**
 返回一个SHA512加密的小写NSString字符串
 */
- (NSString *)wl_sha512String;

/**
 返回一个SHA512加密的NSData数据
 */
- (NSData *)wl_sha512Data;

/**
 返回一个hmac的小写NSString字符串，使用md5加密的key的计算方式
 @param key  hmac的密钥
 */
- (NSString *)wl_hmacMD5StringWithKey:(NSString *)key;

/**
 返回一个hmac的NSData数据，使用md5加密的key的计算方式
 @param key  hmac的密钥
 */
- (NSData *)wl_hmacMD5DataWithKey:(NSData *)key;

/**
 Returns a lowercase NSString for hmac using algorithm sha1 with key.
 返回一个hmac的小写NSString字符串，使用SHA1加密的key的计算方式
 @param key  hmac的密钥
 */
- (NSString *)wl_hmacSHA1StringWithKey:(NSString *)key;

/**
 Returns an NSData for hmac using algorithm sha1 with key.
 返回一个hmac的NSData数据，使用SHA1加密的key的计算方式
 @param key  hmac的密钥
 */
- (NSData *)wl_hmacSHA1DataWithKey:(NSData *)key;

/**
 Returns a lowercase NSString for hmac using algorithm sha224 with key.
 返回一个hmac的小写NSString字符串，使用SHA224加密的key的计算方式
 @param key  hmac的密钥
 */
- (NSString *)wl_hmacSHA224StringWithKey:(NSString *)key;

/**
 Returns an NSData for hmac using algorithm sha224 with key.
 返回一个hmac的NSData数据，使用SHA224加密的key的计算方式
 @param key  hmac的密钥
 */
- (NSData *)wl_hmacSHA224DataWithKey:(NSData *)key;

/**
 Returns a lowercase NSString for hmac using algorithm sha256 with key.
 返回一个hmac的小写NSString字符串，使用SHA256加密的key的计算方式
 @param key  hmac的密钥
 */
- (NSString *)wl_hmacSHA256StringWithKey:(NSString *)key;

/**
 Returns an NSData for hmac using algorithm sha256 with key.
 返回一个hmac的NSData数据，使用SHA256加密的key的计算方式
 @param key  hmac的密钥
 */
- (NSData *)wl_hmacSHA256DataWithKey:(NSData *)key;

/**
 Returns a lowercase NSString for hmac using algorithm sha384 with key.
 返回一个hmac的小写NSString字符串，使用SHA384加密的key的计算方式
 @param key  hmac的密钥
 */
- (NSString *)wl_hmacSHA384StringWithKey:(NSString *)key;

/**
 Returns an NSData for hmac using algorithm sha384 with key.
 返回一个hmac的NSData数据，使用SHA384加密的key的计算方式
 @param key  hmac的密钥
 */
- (NSData *)wl_hmacSHA384DataWithKey:(NSData *)key;

/**
 Returns a lowercase NSString for hmac using algorithm sha512 with key.
 返回一个hmac的小写NSString字符串，使用SHA512加密的key的计算方式
 @param key  hmac的密钥
 */
- (NSString *)wl_hmacSHA512StringWithKey:(NSString *)key;

/**
 Returns an NSData for hmac using algorithm sha512 with key.
 返回一个hmac的NSData数据，使用SHA512加密的key的计算方式
 @param key  hmac的密钥
 */
- (NSData *)wl_hmacSHA512DataWithKey:(NSData *)key;

/**
 返回一个src32加密的小写NSString字符串
 */
- (NSString *)wl_crc32String;

/**
 返回src32加密的数据
 */
- (uint32_t)wl_crc32;

@end

NS_ASSUME_NONNULL_END
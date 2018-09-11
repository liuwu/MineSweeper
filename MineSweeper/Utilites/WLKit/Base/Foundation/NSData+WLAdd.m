//
//  NSData+WLAdd.m
//  Welian
//
//  Created by weLian on 16/5/11.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import "NSData+WLAdd.h"
#include <CommonCrypto/CommonCrypto.h>
#import "WLCGUtilities.h"
#include <zlib.h>

WLSYNTH_DUMMY_CLASS(NSData_WLAdd)

// DES加解密key
#define KDESkey @"weLian&188"

@implementation NSData (WLAdd)

#pragma mark - Encrypt and Decrypt
///=============================================================================
/// @name 加密 and 解密
///=============================================================================

/**
 *  @author liuwu     , 16-05-11
 *
 *  使用AES256解密数据
 *  @return 解密后的数据字符串
 *  @since V2.7.9
 */
- (NSString *)wl_decryptAES256Value {
    NSData *data = [[NSData alloc] initWithBase64EncodedData:self
                                                     options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [[data wl_decryptAES256Withkey:KDESkey] wl_utf8String];
}

/**
 *  @author liuwu     , 16-05-11
 *
 *  利用AES加密数据
 *  @param key 加密的key.
 *  @return 一个加密后的NSData,或nil如果出现错误。
 *  @since V2.7.9
 */
- (nullable NSData *)wl_encryptAESWithkey:(NSString *)key{
    char keyPtr[kCCKeySizeAES256 + 1]; // room for terminator (unused)
    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
    
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [self length];
    
    size_t bufferSize           = dataLength + kCCBlockSizeAES128;
    void* buffer                = malloc(bufferSize);
    
    size_t numBytesEncrypted    = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          keyPtr,
                                          kCCKeySizeAES256,
                                          NULL /* initialization vector (optional) */,
                                          [self bytes],
                                          dataLength, /* input */
                                          buffer,
                                          bufferSize, /* output */
                                          &numBytesEncrypted);
    
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    
    free(buffer);
    return nil;
}

/**
 *  @author liuwu     , 16-05-11
 *
 *  使用AES256解密数据
 *  @param key 解密的key.
 *  @return 一个解密后的NSData,或nil如果出现错误。
 *  @since V2.7.9
 */
- (nullable NSData *)wl_decryptAES256Withkey:(NSString *)key {
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [self length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr,
                                          kCCBlockSizeDES,
                                          NULL,
                                          [self bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesDecrypted);
    
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    
    free(buffer);
    return nil;
}

#pragma mark - Encode and decode
///=============================================================================
/// @name 编码 and 解码
///=============================================================================

/**
 *  @author liuwu     , 16-05-11
 *
 *  base64数据解码为字符串
 *  @return 解码后的字符串
 *  @since V2.7.9
 */
- (nullable NSString *)wl_base64DcodedString {
    if (self.length == 0) {
        return @"";
    }
    NSData *data = [[NSData alloc] initWithBase64EncodedData:self
                                                     options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [data wl_utf8String];
}

/**
 返回UTF8解码的字符串
 */
- (nullable NSString *)wl_utf8String {
    return [self utf8String];
}

/**
 返回一个hex编码的字符串
 */
- (nullable NSString *)wl_hexString {
    return [self hexString];
}

/**
 返回一个使用hex字符串编码的NSData
 
 @param hexString   不区分大小写的hex字符串.
 
 @return 一个新的NSData,或nil如果出现错误。
 */
+ (nullable NSData *)wl_dataWithHexString:(NSString *)hexString {
    return [self dataWithHexString:hexString];
}

/**
 返回一个base64编码的字符串
 */
- (nullable NSString *)wl_base64EncodedString {
    return [self base64EncodedString];
}

/**
 Returns an NSData from base64 encoded string.
 从base64编码的字符串数据中返回一个NSData
 
 @警告 这个方法已经在iOS7中实现.
 
 @param base64EncodedString  编码的字符串.
 */
+ (nullable NSData *)wl_dataWithBase64EncodedString:(NSString *)base64EncodedString {
    return [self dataWithBase64EncodedString:base64EncodedString];
}

/**
 *  @author liuwu     , 16-05-11
 *
 *  系统自带的字符串base64后转data
 *  @param string 编码的字符串
 *  @return 传入字符串base64后的data
 *  @since V2.7.9
 */
+ (nullable NSData *)wl_systemdataWithBase64EncodedString:(NSString *)string {
    if (![string length]) return nil;
    NSData *decoded = nil;
#if __MAC_OS_X_VERSION_MIN_REQUIRED < __MAC_10_9 || __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    if (![NSData instancesRespondToSelector:@selector(initWithBase64EncodedString:options:)])
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        decoded = [[self alloc] initWithBase64Encoding:[string stringByReplacingOccurrencesOfString:@"[^A-Za-z0-9+/=]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [string length])]];
#pragma clang diagnostic pop
    }
    else
#endif
    {
        decoded = [[self alloc] initWithBase64EncodedString:string options:NSDataBase64DecodingIgnoreUnknownCharacters];
    }
    return [decoded length]? decoded: nil;
}

/**
 返回一个解码的NSDictionary或NSArray. 如果发送错误，返回nil.
 */
- (nullable id)wl_jsonValueDecoded {
    return [self jsonValueDecoded];
}

#pragma mark - Inflate and deflate
///=============================================================================
/// @name 压缩 and 解压
///=============================================================================

/**
 对使用 gzip 压缩后的数据进行解压
 @return Inflated data.
 */
- (nullable NSData *)wl_gzipInflate {
    return [self gzipInflate];
}

/**
 使用 gzip 默认 compresssion 级别对 NSData 进行压缩。
 [gzip](https://zh.wikipedia.org/wiki/Gzip)
 @return Deflated data.
 */
- (nullable NSData *)wl_gzipDeflate {
    return [self gzipDeflate];
}

/**
 对使用 zlib 压缩后的数据进行解压
 @return Inflated data.
 */
- (nullable NSData *)wl_zlibInflate {
    return [self zlibInflate];
}

/**
 使用 zlib 默认 compresssion 级别对 NSData 进行压缩。
 [zlib](https://zh.wikipedia.org/wiki/Zlib)
 @return Deflated data.
 */
- (nullable NSData *)wl_zlibDeflate {
    return [self zlibDeflate];
}


#pragma mark - Others
///=============================================================================
/// @name Others
///=============================================================================

/**
 从main bundle中获取 name 文件里的内容，返回 NSData。类似[UIImage imageNamed:]。
 
 @param name The file name (in main bundle).
 @return A new data create from the file.
 */
+ (nullable NSData *)wl_dataNamed:(NSString *)name {
    return [self dataNamed:name];
}


@end

//
//  WLAsset.h
//  Welian
//
//  Created by dong on 2017/3/31.
//  Copyright © 2017年 chuansongmen. All rights reserved.
//

#import <Photos/PHImageManager.h>
#import "WLPhotoConst.h"

@class PHAsset;

@interface WLAsset : NSObject

@property(nonatomic, assign, readonly) WLAssetType assetType;

@property (nonatomic, strong, readonly) PHAsset *phAsset;

- (instancetype)initWithPHAsset:(PHAsset *)phAsset;

@property(nonatomic, assign, readonly) WLAssetDownloadStatus downloadStatus; // 从 iCloud 下载资源大图的状态
@property(nonatomic, assign) double downloadProgress; // 从 iCloud 下载资源大图的进度
@property(nonatomic, assign) NSInteger requestID; // 从 iCloud 请求获得资源的大图的请求 ID

/// Asset 的原图（包含系统相册“编辑”功能处理后的效果）
- (UIImage *)originImage;

/**
 *  Asset 的缩略图
 *
 *  @param size 指定返回的缩略图的大小
 *
 *  @return Asset 的缩略图
 */
- (UIImage *)thumbnailWithSize:(CGSize)size;

/**
 *  Asset 的预览图
 *
 *  @warning 仿照 ALAssetsLibrary 的做法输出与当前设备屏幕大小相同尺寸的图片，如果图片原图小于当前设备屏幕的尺寸，则只输出原图大小的图片
 *  @return Asset 的全屏图
 */
- (UIImage *)previewImage;

/**
 *  异步请求 Asset 的原图，包含了系统照片“编辑”功能处理后的效果（剪裁，旋转和滤镜等），可能会有网络请求
 *
 *  @param completion        完成请求后调用的 block，参数中包含了请求的原图以及图片信息，在 iOS 8.0 或以上版本中，
 *                           这个 block 会被多次调用，其中第一次调用获取到的尺寸很小的低清图，然后不断调用，直到获取到高清图。
 *  @param phProgressHandler 处理请求进度的 handler，不在主线程上执行，在 block 中修改 UI 时注意需要手工放到主线程处理。
 *
 *  @wraning iOS 8.0 以下中并没有异步请求预览图的接口，因此实际上为同步请求，这时 block 中的第二个参数（图片信息）返回的为 nil。
 *
 *  @return 返回请求图片的请求 id
 */
- (PHImageRequestID)requestOriginImageWithCompletion:(void (^)(UIImage *image, NSDictionary *info))completion withProgressHandler:(PHAssetImageProgressHandler)phProgressHandler;

/**
 *  异步请求 Asset 的缩略图，不会产生网络请求
 *
 *  @param size       指定返回的缩略图的大小，仅在 iOS 8.0 及以上的版本有效
 *  @param completion 完成请求后调用的 block，参数中包含了请求的缩略图以及图片信息，在 iOS 8.0 或以上版本中，这个 block 会被多次调用，
 *                    其中第一次调用获取到的尺寸很小的低清图，然后不断调用，直到获取到高清图，这时 block 中的第二个参数（图片信息）返回的为 nil。
 *
 *  @return 返回请求图片的请求 id
 */
- (PHImageRequestID)requestThumbnailImageWithSize:(CGSize)size completion:(void (^)(UIImage *image, NSDictionary *info))completion;


- (PHImageRequestID)requestImageDataWithCompletion:(void(^)(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info))completion withProgressHandler:(PHAssetImageProgressHandler)phProgressHandler;

/**
 *  异步请求 Asset 的预览图，可能会有网络请求
 *
 *  @param completion        完成请求后调用的 block，参数中包含了请求的预览图以及图片信息，在 iOS 8.0 或以上版本中，
 *                           这个 block 会被多次调用，其中第一次调用获取到的尺寸很小的低清图，然后不断调用，直到获取到高清图。
 *  @param phProgressHandler 处理请求进度的 handler，不在主线程上执行，在 block 中修改 UI 时注意需要手工放到主线程处理。
 *
 *  @wraning iOS 8.0 以下中并没有异步请求预览图的接口，因此实际上为同步请求，这时 block 中的第二个参数（图片信息）返回的为 nil。
 *
 *  @return 返回请求图片的请求 id
 */
- (PHImageRequestID)requestPreviewImageWithCompletion:(void (^)(UIImage *image, NSDictionary *info))completion withProgressHandler:(PHAssetImageProgressHandler)phProgressHandler;

/**
 *  异步请求 Live Photo，可能会有网络请求，仅当 assetType 为 QMUIAssetTypeLivePhoto 时有返回值，否则返回 nil
 *
 *  @param completion        完成请求后调用的 block，参数中包含了请求的 Live Photo 以及相关信息
 *  @param phProgressHandler 处理请求进度的 handler，不在主线程上执行，在 block 中修改 UI 时注意需要手工放到主线程处理。
 *
 *  @wraning iOS 9.1 以下中并没有 Live Photo，因此返回 nil。
 *
 *  @return 返回请求图片的请求 id
 */
- (PHImageRequestID)requestLivePhotoWithCompletion:(void (^)(PHLivePhoto *livePhoto, NSDictionary *info))completion withProgressHandler:(PHAssetImageProgressHandler)phProgressHandler NS_AVAILABLE_IOS(9_1);

- (UIImageOrientation)imageOrientation;

/**
 *  Asset 的标识，每个 WLAsset 的标识值不相同，该标识值经过 md5 处理，避免了特殊字符
 *
 *  @return Asset 的标识字符串
 */
- (NSString *)assetIdentity;

/// 更新下载资源的结果
- (void)updateDownloadStatusWithDownloadResult:(BOOL)succeed;

/**
 * 获取 Asset 的体积（数据大小）
 */
- (long long)assetSize;

@end

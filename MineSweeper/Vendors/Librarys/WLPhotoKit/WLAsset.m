//
//  WLAsset.m
//  Welian
//
//  Created by dong on 2017/3/31.
//  Copyright © 2017年 chuansongmen. All rights reserved.
//

#import "WLAsset.h"
#import "WLAssetsManager.h"
#import <Photos/Photos.h>

@interface WLAsset ()

@property (nonatomic, assign, readwrite) WLAssetType assetType;
@property (nonatomic, strong, readwrite) PHAsset *phAsset;

@end

@implementation WLAsset {
    
    NSDictionary *_phAssetInfo;
    float imageSize;
    
    NSString *_assetIdentityHash;
}

- (instancetype)initWithPHAsset:(PHAsset *)phAsset {
    if (self = [super init]) {
        _phAsset = phAsset;
        switch (phAsset.mediaType) {
            case PHAssetMediaTypeImage:
                if (phAsset.mediaSubtypes & PHAssetMediaSubtypePhotoLive) {
                    self.assetType = WLAssetTypeLivePhoto;
                } else {
                    self.assetType = WLAssetTypeImage;
                }
                break;
            case PHAssetMediaTypeVideo:
                self.assetType = WLAssetTypeVideo;
                break;
            case PHAssetMediaTypeAudio:
                self.assetType = WLAssetTypeAudio;
                break;
            default:
                self.assetType = WLAssetTypeUnknow;
                break;
        }
    }
    return self;
}

- (UIImage *)originImage {
    __block UIImage *resultImage = nil;
    PHImageRequestOptions *phImageRequestOptions = [[PHImageRequestOptions alloc] init];
    phImageRequestOptions.synchronous = YES;
    phImageRequestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    [[[WLAssetsManager sharedInstance] phCachingImageManager] requestImageForAsset:_phAsset
                                                                          targetSize:PHImageManagerMaximumSize
                                                                         contentMode:PHImageContentModeDefault
                                                                             options:phImageRequestOptions
                                                                       resultHandler:^(UIImage *result, NSDictionary *info) {
                                                                           resultImage = result;
                                                                       }];
    return resultImage;
}

- (UIImage *)thumbnailWithSize:(CGSize)size {
    __block UIImage *resultImage;
    PHImageRequestOptions *phImageRequestOptions = [[PHImageRequestOptions alloc] init];
    phImageRequestOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
    
    // 在 PHImageManager 中，targetSize 等 size 都是使用 px 作为单位，因此需要对targetSize 中对传入的 Size 进行处理，宽高各自乘以 ScreenScale，从而得到正确的图片
    [[[WLAssetsManager sharedInstance] phCachingImageManager] requestImageForAsset:_phAsset
                                                                          targetSize:CGSizeMake(size.width * [UIScreen screenScale], size.height * [UIScreen screenScale])
                                                                         contentMode:PHImageContentModeAspectFill options:phImageRequestOptions
                                                                       resultHandler:^(UIImage *result, NSDictionary *info) {
                                                                           resultImage = result;
                                                                       }];
    return resultImage;
}

- (UIImage *)previewImage {
    __block UIImage *resultImage = nil;
    PHImageRequestOptions *imageRequestOptions = [[PHImageRequestOptions alloc] init];
    imageRequestOptions.synchronous = YES;
    imageRequestOptions.resizeMode = PHImageRequestOptionsResizeModeFast;
    [[[WLAssetsManager sharedInstance] phCachingImageManager] requestImageForAsset:_phAsset
                                                                          targetSize:CGSizeMake(ScreenWidth*[UIScreen screenScale], ScreenHeight*[UIScreen screenScale])
                                                                         contentMode:PHImageContentModeAspectFill
                                                                             options:imageRequestOptions
                                                                       resultHandler:^(UIImage *result, NSDictionary *info) {
                                                                           resultImage = result;
                                                                       }];
    return resultImage;
}

- (PHImageRequestID)requestThumbnailImageWithSize:(CGSize)size completion:(void (^)(UIImage *image, NSDictionary *info))completion {
    PHImageRequestOptions *imageRequestOptions = [[PHImageRequestOptions alloc] init];
    imageRequestOptions.resizeMode = PHImageRequestOptionsResizeModeFast;
    // 在 PHImageManager 中，targetSize 等 size 都是使用 px 作为单位，因此需要对targetSize 中对传入的 Size 进行处理，宽高各自乘以 ScreenScale，从而得到正确的图片
    return [[[WLAssetsManager sharedInstance] phCachingImageManager] requestImageForAsset:_phAsset targetSize:CGSizeMake(size.width * [UIScreen screenScale], size.height * [UIScreen screenScale]) contentMode:PHImageContentModeAspectFill options:imageRequestOptions resultHandler:^(UIImage *result, NSDictionary *info) {
        if (completion) {
            completion(result, info);
        }
    }];
}

- (PHImageRequestID)requestPreviewImageWithCompletion:(void (^)(UIImage *image, NSDictionary *info))completion withProgressHandler:(PHAssetImageProgressHandler)phProgressHandler {
    PHImageRequestOptions *imageRequestOptions = [[PHImageRequestOptions alloc] init];
    imageRequestOptions.networkAccessAllowed = YES; // 允许访问网络
    imageRequestOptions.resizeMode = PHImageRequestOptionsResizeModeFast;
    imageRequestOptions.progressHandler = phProgressHandler;
    return [[[WLAssetsManager sharedInstance] phCachingImageManager] requestImageForAsset:_phAsset targetSize:CGSizeMake(ScreenWidth*[UIScreen screenScale], ScreenHeight*[UIScreen screenScale]) contentMode:PHImageContentModeAspectFill options:imageRequestOptions resultHandler:^(UIImage *result, NSDictionary *info) {
        if (completion) {
            completion(result, info);
        }
    }];
}

- (PHImageRequestID)requestOriginImageWithCompletion:(void (^)(UIImage *image, NSDictionary *info))completion withProgressHandler:(PHAssetImageProgressHandler)phProgressHandler {
    PHImageRequestOptions *imageRequestOptions = [[PHImageRequestOptions alloc] init];
    imageRequestOptions.networkAccessAllowed = YES; // 允许访问网络
    imageRequestOptions.progressHandler = phProgressHandler;
    return [[[WLAssetsManager sharedInstance] phCachingImageManager] requestImageForAsset:_phAsset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:imageRequestOptions resultHandler:^(UIImage *result, NSDictionary *info) {
        if (completion) {
            completion(result, info);
        }
    }];
}

- (PHImageRequestID)requestLivePhotoWithCompletion:(void (^)(PHLivePhoto *livePhoto, NSDictionary *info))completion withProgressHandler:(PHAssetImageProgressHandler)phProgressHandler {
    if ([[PHCachingImageManager class] instancesRespondToSelector:@selector(requestLivePhotoForAsset:targetSize:contentMode:options:resultHandler:)]) {
        PHLivePhotoRequestOptions *livePhotoRequestOptions = [[PHLivePhotoRequestOptions alloc] init];
        livePhotoRequestOptions.networkAccessAllowed = YES; // 允许访问网络
        livePhotoRequestOptions.progressHandler = phProgressHandler;
        return [[[WLAssetsManager sharedInstance] phCachingImageManager] requestLivePhotoForAsset:_phAsset targetSize:CGSizeMake(ScreenWidth*[UIScreen screenScale], ScreenHeight*[UIScreen screenScale]) contentMode:PHImageContentModeDefault options:livePhotoRequestOptions resultHandler:^(PHLivePhoto * _Nullable livePhoto, NSDictionary * _Nullable info) {
            if (completion) {
                completion(livePhoto, info);
            }
        }];
    } else {
        return 0;
    }
}

- (UIImageOrientation)imageOrientation {
    UIImageOrientation orientation;
    if (!_phAssetInfo) {
        // PHAsset 的 UIImageOrientation 需要调用过 requestImageDataForAsset 才能获取
        [self requestPhAssetInfo];
    }
    // 从 PhAssetInfo 中获取 UIImageOrientation 对应的字段
    orientation = (UIImageOrientation)[_phAssetInfo[@"orientation"] integerValue];
    return orientation;
}

- (NSString *)assetIdentity {
    if (_assetIdentityHash) {
        return _assetIdentityHash;
    }
    NSString *identity = _phAsset.localIdentifier;
    // 系统输出的 identity 可能包含特殊字符，为了避免引起问题，统一使用 md5 转换
    _assetIdentityHash = [identity md5String];
    return _assetIdentityHash;
}

- (void)requestPhAssetInfo {
    if (_phAssetInfo || !_phAsset) {
        return;
    }
    PHImageRequestOptions *imageRequestOptions = [[PHImageRequestOptions alloc] init];
    imageRequestOptions.synchronous = YES;
    [[[WLAssetsManager sharedInstance] phCachingImageManager] requestImageDataForAsset:_phAsset options:imageRequestOptions resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
        if (info) {
            NSMutableDictionary *tempInfo = [[NSMutableDictionary alloc] init];
            if (info) {
                [tempInfo addEntriesFromDictionary:info];
            }
            if (dataUTI) {
                [tempInfo setObject:dataUTI forKey:@"dataUTI"];
            }
            [tempInfo setObject:@(orientation) forKey:@"orientation"];
            [tempInfo setObject:@(imageData.length) forKey:@"imageSize"];
            _phAssetInfo = tempInfo;
        }
    }];
}

- (PHImageRequestID)requestImageDataWithCompletion:(void(^)(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info))completion withProgressHandler:(PHAssetImageProgressHandler)phProgressHandler {
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc]init];
    option.progressHandler = phProgressHandler;
    option.networkAccessAllowed = YES;
    return [[[WLAssetsManager sharedInstance] phCachingImageManager] requestImageDataForAsset:_phAsset options:option resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
        if (downloadFinined && imageData) {
            if (completion) completion(imageData,dataUTI,orientation,info);
            
            NSMutableDictionary *tempInfo = [[NSMutableDictionary alloc] init];
            if (info) {
                [tempInfo addEntriesFromDictionary:info];
            }
            if (dataUTI) {
                [tempInfo setObject:dataUTI forKey:@"dataUTI"];
            }
            [tempInfo setObject:@(orientation) forKey:@"orientation"];
            [tempInfo setObject:@(imageData.length) forKey:@"imageSize"];
            _phAssetInfo = tempInfo;
        }
    }];
}

- (void)setDownloadProgress:(double)downloadProgress {
    _downloadProgress = downloadProgress;
    _downloadStatus = WLAssetDownloadStatusDownloading;
}

- (void)updateDownloadStatusWithDownloadResult:(BOOL)succeed {
    _downloadStatus = succeed ? WLAssetDownloadStatusSucceed : WLAssetDownloadStatusFailed;
}

- (long long)assetSize {
    long long size;
    if (!_phAssetInfo) {
        // PHAsset 的 UIImageOrientation 需要调用过 requestImageDataForAsset 才能获取
        [self requestPhAssetInfo];
    }
    // 从 PhAssetInfo 中获取 UIImageOrientation 对应的字段
    size = [_phAssetInfo[@"imageSize"] longLongValue];
    return size;
}

@end

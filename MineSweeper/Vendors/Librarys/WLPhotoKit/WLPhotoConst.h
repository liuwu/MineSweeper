//
//  WLPhotoConst.h
//  Welian
//
//  Created by dong on 2017/4/13.
//  Copyright © 2017年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>

/// Asset授权的状态
typedef NS_ENUM(NSInteger, WLAssetAuthorizationStatus)
{
    WLAssetAuthorizationStatusNotUsingPhotoKit,   // 对于iOS7及以下不支持PhotoKit的系统，没有所谓的“授权状态”，所以定义一个特定的status用于表示这种情况
    WLAssetAuthorizationStatusNotDetermined,      // 还不确定有没有授权
    WLAssetAuthorizationStatusAuthorized,         // 已经授权
    WLAssetAuthorizationStatusNotAuthorized       // 手动禁止了授权
};

// 相册展示内容的类型
typedef NS_ENUM(NSInteger, WLAlbumContentType)
{
    WLAlbumContentTypeAll,                                  // 展示所有资源（照片和视频）
    WLAlbumContentTypeOnlyPhoto,                            // 只展示照片
    WLAlbumContentTypeOnlyVideo,                            // 只展示视频
    WLAlbumContentTypeOnlyAudio  NS_ENUM_AVAILABLE_IOS(8_0) // 只展示音频
};

// 相册展示内容按日期排序的方式
typedef NS_ENUM(NSInteger, WLAlbumSortType)
{
    WLAlbumSortTypePositive,  // 日期最新的内容排在后面
    WLAlbumSortTypeReverse  // 日期最新的内容排在前面
};

typedef NS_ENUM(NSInteger, WLAssetType) {
    WLAssetTypeUnknow,                              // 未知类型的 Asset
    WLAssetTypeImage,                               // 图片类型的 Asset
    WLAssetTypeVideo,                               // 视频类型的 Asset
    WLAssetTypeAudio NS_ENUM_AVAILABLE_IOS(8_0),    // 音频类型的 Asset，仅被 PhotoKit 支持，因此只适用于 iOS 8.0
    WLAssetTypeLivePhoto NS_ENUM_AVAILABLE_IOS(9_1) // Live Photo 类型的 Asset，仅被 PhotoKit 支持，因此只适用于 iOS 9.1
};

typedef NS_ENUM(NSInteger, WLAssetDownloadStatus) {
    WLAssetDownloadStatusSucceed,     // 下载成功或资源本来已经在本地
    WLAssetDownloadStatusDownloading, // 下载中
    WLAssetDownloadStatusCanceled,    // 取消下载
    WLAssetDownloadStatusFailed,      // 下载失败
}; // 从 iCloud 请求 Asset 大图的状态

UIKIT_EXTERN const CGFloat WLPhotoImageSpacing;
UIKIT_EXTERN const CGFloat WLPhotoBottomViewHeigh;
UIKIT_EXTERN const CGFloat WLPhotoAlbumTableViewCellHeight;
UIKIT_EXTERN const CGFloat WLPhotoImageMaximumZoomScale;
UIKIT_EXTERN const CGFloat WLPhotoImageCropMaximumZoomScale;


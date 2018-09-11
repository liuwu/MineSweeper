//
//  WLAssetsGroup.h
//  Welian
//
//  Created by dong on 2017/3/31.
//  Copyright © 2017年 chuansongmen. All rights reserved.
//

#import <Photos/PHAsset.h>
#import <Photos/PHFetchOptions.h>
#import <Photos/PHCollection.h>
#import <Photos/PHFetchResult.h>
#import <Photos/PHImageManager.h>
#import "WLPhotoConst.h"

@class WLAsset;

@interface WLAssetsGroup : NSObject

- (instancetype)initWithPHCollection:(PHAssetCollection *)phAssetCollection;

- (instancetype)initWithPHCollection:(PHAssetCollection *)phAssetCollection fetchAssetsOptions:(PHFetchOptions *)pHFetchOptions;

/// 仅能通过 initWithPHCollection 和 initWithPHCollection:fetchAssetsOption 方法修改 phAssetCollection 的值
@property(nonatomic, strong, readonly) PHAssetCollection *phAssetCollection;

@property (nonatomic, strong, readonly) PHFetchOptions *pHFetchOptions;

/// 仅能通过 initWithPHCollection 和 initWithPHCollection:fetchAssetsOption 方法修改 phAssetCollection 后，产生一个对应的 PHAssetsFetchResults 保存到 phFetchResult 中
@property(nonatomic, strong, readonly) PHFetchResult *phFetchResult;

// 刷新一下
- (WLAssetsGroup *)refreshData;

/// 相册的名称
- (NSString *)name;

/// 相册内的资源数量，包括视频、图片、音频（如果支持）这些类型的所有资源
- (NSInteger)numberOfAllAssets;

- (NSInteger)countOfAssetsWithMediaType:(PHAssetMediaType)mediaType;

/**
 *  相册的缩略图，即系统接口中的相册海报（Poster Image）
 *
 *  @param size 缩略图的 size，仅在 iOS 8.0 及以上的版本有效，其他版本则调用 ALAsset 的接口由系统返回一个固定大小的缩略图
 *
 *  @return 相册的缩略图
 */
- (UIImage *)posterImageWithSize:(CGSize)size;

/**
 *  枚举相册内所有的资源
 *
 *  @param albumSortType    相册内资源的排序方式，可以选择日期最新的排在最前面，也可以选择日期最新的排在最后面
 *  @param enumerationBlock 枚举相册内资源时调用的 block，参数 result 表示每次枚举时对应的资源。
 *                          枚举所有资源结束后，enumerationBlock 会被再调用一次，这时 result 的值为 nil。
 *                          可以以此作为判断枚举结束的标记
 */
- (void)enumerateAssetsWithOptions:(WLAlbumSortType)albumSortType usingBlock:(void (^)(WLAsset *resultAsset))enumerationBlock;

/**
 *  枚举相册内所有的资源，相册内资源按日期最新的排在最后面
 *
 *  @param enumerationBlock 枚举相册内资源时调用的 block，参数 result 表示每次枚举时对应的资源。
 *                          枚举所有资源结束后，enumerationBlock 会被再调用一次，这时 result 的值为 nil。
 *                          可以以此作为判断枚举结束的标记
 */
- (void)enumerateAssetsUsingBlock:(void (^)(WLAsset *result))enumerationBlock;


@end

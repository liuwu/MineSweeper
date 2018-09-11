//
//  WLAssetsGroup.m
//  Welian
//
//  Created by dong on 2017/3/31.
//  Copyright © 2017年 chuansongmen. All rights reserved.
//

#import "WLAssetsGroup.h"
#import "WLAsset.h"
#import "WLAssetsManager.h"

@interface WLAssetsGroup ()

@property(nonatomic, strong, readwrite) PHAssetCollection *phAssetCollection;
@property(nonatomic, strong, readwrite) PHFetchResult *phFetchResult;
@property (nonatomic, strong, readwrite) PHFetchOptions *pHFetchOptions;

@end

@implementation WLAssetsGroup

- (instancetype)initWithPHCollection:(PHAssetCollection *)phAssetCollection fetchAssetsOptions:(PHFetchOptions *)pHFetchOptions {
    self = [super init];
    if (self) {
        PHFetchResult *phFetchResult = [PHAsset fetchAssetsInAssetCollection:phAssetCollection options:pHFetchOptions];
        self.phFetchResult = phFetchResult;
        self.phAssetCollection = phAssetCollection;
        self.pHFetchOptions = pHFetchOptions;
    }
    return self;
}

- (instancetype)initWithPHCollection:(PHAssetCollection *)phAssetCollection {
    return [self initWithPHCollection:phAssetCollection fetchAssetsOptions:nil];
}

- (NSInteger)countOfAssetsWithMediaType:(PHAssetMediaType)mediaType {
    return [self.phFetchResult countOfAssetsWithMediaType:mediaType];
}

- (NSInteger)numberOfAllAssets {
    return self.phFetchResult.count;
}

- (NSString *)name {
    NSString *resultName = self.phAssetCollection.localizedTitle;
    return NSLocalizedString(resultName, resultName);
}

- (UIImage *)posterImageWithSize:(CGSize)size {
    __block UIImage *resultImage;
    NSInteger count = self.phFetchResult.count;
    if (count > 0) {
        PHAsset *asset = self.phFetchResult[count - 1];
        PHImageRequestOptions *pHImageRequestOptions = [[PHImageRequestOptions alloc] init];
        pHImageRequestOptions.synchronous = YES; // 同步请求
        pHImageRequestOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
        // targetSize 中对传入的 Size 进行处理，宽高各自乘以 ScreenScale，从而得到正确的图片
        [[[WLAssetsManager sharedInstance] phCachingImageManager] requestImageForAsset:asset targetSize:CGSizeMake(size.width * WLScreenScale(), size.height * WLScreenScale()) contentMode:PHImageContentModeAspectFill options:pHImageRequestOptions resultHandler:^(UIImage *result, NSDictionary *info) {
            resultImage = result;
        }];
    }
    return resultImage;
}

- (WLAssetsGroup *)refreshData {
    PHFetchResult *phFetchResult = [PHAsset fetchAssetsInAssetCollection:self.phAssetCollection options:self.pHFetchOptions];
    self.phFetchResult = phFetchResult;
    return self;
}

- (void)enumerateAssetsWithOptions:(WLAlbumSortType)albumSortType usingBlock:(void (^)(WLAsset *resultAsset))enumerationBlock {
    NSInteger resultCount = self.phFetchResult.count;
    if (albumSortType == WLAlbumSortTypeReverse) {
        for (NSInteger i = resultCount - 1; i >= 0; i--) {
            PHAsset *pHAsset = self.phFetchResult[i];
            WLAsset *asset = [[WLAsset alloc] initWithPHAsset:pHAsset];
            if (enumerationBlock) {
                enumerationBlock(asset);
            }
        }
    } else {
        for (NSInteger i = 0; i < resultCount; i++) {
            PHAsset *pHAsset = self.phFetchResult[i];
            WLAsset *asset = [[WLAsset alloc] initWithPHAsset:pHAsset];
            if (enumerationBlock) {
                enumerationBlock(asset);
            }
        }
    }
    /**
     *  For 循环遍历完毕，这时再调用一次 enumerationBlock，并传递 nil 作为实参，作为枚举资源结束的标记。
     *  该处理方式也是参照系统 ALAssetGroup 枚举结束的处理。
     */
    if (enumerationBlock) {
        enumerationBlock(nil);
    }
}

- (void)enumerateAssetsUsingBlock:(void (^)(WLAsset *resultAsset))enumerationBlock {
    [self enumerateAssetsWithOptions:WLAlbumSortTypePositive usingBlock:enumerationBlock];
}

@end

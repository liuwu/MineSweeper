//
//  WLAssetsManager.m
//  Welian
//
//  Created by dong on 2017/3/31.
//  Copyright © 2017年 chuansongmen. All rights reserved.
//

#import "WLAssetsManager.h"

void WLImageWriteToSavedPhotosAlbumWithAlbumAssetsGroup(UIImage *image, WLAssetsGroup *albumAssetsGroup, WLWriteAssetCompletionBlock completionBlock) {
    [[WLAssetsManager sharedInstance] saveImageWithImageRef:image.CGImage albumAssetsGroup:albumAssetsGroup orientation:(UIImageOrientation)image.imageOrientation completionBlock:completionBlock];
}

/// 保存图片到UserLibrary，该方法是一个 C 方法，与系统 ALAssetLibrary 保存图片的 C 方法 UIImageWriteToSavedPhotosAlbum 对应，方便调用
void WLImageWriteToSavedPhotosAlbumWithUserLibrary(UIImage *image, WLWriteAssetCompletionBlock completionBlock){
    [[WLAssetsManager sharedInstance] saveImageWithImageRef:image.CGImage albumAssetsGroup:NULL orientation:(UIImageOrientation)image.imageOrientation completionBlock:completionBlock];
}

void WLSaveVideoAtPathToSavedPhotosAlbumWithAlbumAssetsGroup(NSString *videoPath, WLAssetsGroup *albumAssetsGroup, WLWriteAssetCompletionBlock completionBlock) {
    [[WLAssetsManager sharedInstance] saveVideoWithVideoPathURL:[NSURL fileURLWithPath:videoPath] albumAssetsGroup:albumAssetsGroup completionBlock:completionBlock];
}

/// 保存视频到UserLibrary，该方法是一个 C 方法，与系统 ALAssetLibrary 保存图片的 C 方法 UIImageWriteToSavedPhotosAlbum 对应，方便调用
extern void WLSaveVideoAtPathToSavedPhotosAlbumWithUserLibrary(NSString *videoPath, WLWriteAssetCompletionBlock completionBlock) {
    [[WLAssetsManager sharedInstance] saveVideoWithVideoPathURL:[NSURL fileURLWithPath:videoPath] albumAssetsGroup:NULL completionBlock:completionBlock];
}

@implementation WLAssetsManager {
    PHCachingImageManager *_phCachingImageManager;
}

+ (WLAssetsManager *)sharedInstance {
    static dispatch_once_t onceToken;
    static WLAssetsManager *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

/**
 * 重写 +allocWithZone 方法，使得在给对象分配内存空间的时候，就指向同一份数据
 */

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [self sharedInstance];
}

+ (WLAssetAuthorizationStatus)authorizationStatus {
    __block WLAssetAuthorizationStatus status;
    // 获取当前应用对照片的访问授权状态
    PHAuthorizationStatus authorizationStatus = [PHPhotoLibrary authorizationStatus];
    if (authorizationStatus == PHAuthorizationStatusRestricted || authorizationStatus == PHAuthorizationStatusDenied) {
        status = WLAssetAuthorizationStatusNotAuthorized;
    } else if (authorizationStatus == PHAuthorizationStatusNotDetermined) {
        status = WLAssetAuthorizationStatusNotDetermined;
    } else {
        status = WLAssetAuthorizationStatusAuthorized;
    }
    return status;
}

+ (void)requestAuthorization:(void(^)(WLAssetAuthorizationStatus status))handler {
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus phStatus) {
        WLAssetAuthorizationStatus status;
        if (phStatus == PHAuthorizationStatusRestricted || phStatus == PHAuthorizationStatusDenied) {
            status = WLAssetAuthorizationStatusNotAuthorized;
        } else if (phStatus == PHAuthorizationStatusNotDetermined) {
            status = WLAssetAuthorizationStatusNotDetermined;
        } else {
            status = WLAssetAuthorizationStatusAuthorized;
        }
        if (handler) {
            handler(status);
        }
    }];
}

- (void)enumerateAllAlbumsWithAlbumContentType:(WLAlbumContentType)contentType showEmptyAlbum:(BOOL)showEmptyAlbum showSmartAlbumIfSupported:(BOOL)showSmartAlbumIfSupported usingBlock:(void (^)(WLAssetsGroup *resultAssetsGroup))enumerationBlock {
    // 根据条件获取所有合适的相册，并保存到临时数组中
    NSArray *tempAlbumsArray = [PHPhotoLibrary fetchAllAlbumsWithAlbumContentType:contentType showEmptyAlbum:showEmptyAlbum showSmartAlbum:showSmartAlbumIfSupported];
    
    // 创建一个 PHFetchOptions，用于 WLAssetsGroup 对资源的排序以及对内容类型进行控制
    PHFetchOptions *phFetchOptions = [PHPhotoLibrary createFetchOptionsWithAlbumContentType:contentType];
    
    // 遍历结果，生成对应的 WLAssetsGroup，并调用 enumerationBlock
    for (NSUInteger i = 0; i < [tempAlbumsArray count]; i++) {
        PHAssetCollection *phAssetCollection = [tempAlbumsArray objectAtIndex:i];
        WLAssetsGroup *assetsGroup = [[WLAssetsGroup alloc] initWithPHCollection:phAssetCollection fetchAssetsOptions:phFetchOptions];
        if (enumerationBlock) {
            enumerationBlock(assetsGroup);
        }
    }
    
    /**
     *  所有结果遍历完毕，这时再调用一次 enumerationBlock，并传递 nil 作为实参，作为枚举相册结束的标记。
     *  该处理方式也是参照系统 ALAssetsLibrary enumerateGroupsWithTypes 枚举结束的处理。
     */
    if (enumerationBlock) {
        enumerationBlock(nil);
    }
}

- (void)enumerateAllAlbumsWithAlbumContentType:(WLAlbumContentType)contentType usingBlock:(void (^)(WLAssetsGroup *resultAssetsGroup))enumerationBlock {
    [self enumerateAllAlbumsWithAlbumContentType:contentType showEmptyAlbum:NO showSmartAlbumIfSupported:YES usingBlock:enumerationBlock];
}

- (void)saveImageWithImageRef:(CGImageRef)imageRef albumAssetsGroup:(WLAssetsGroup *)albumAssetsGroup orientation:(UIImageOrientation)orientation completionBlock:(WLWriteAssetCompletionBlock)completionBlock {
    PHAssetCollection *albumPhAssetCollection = albumAssetsGroup.phAssetCollection;
    // 把图片加入到指定的相册对应的 PHAssetCollection
    [[PHPhotoLibrary sharedPhotoLibrary] addImageToAlbum:imageRef
                                    albumAssetCollection:albumPhAssetCollection
                                             orientation:orientation
                                       completionHandler:^(BOOL success, NSError *error) {
                                           if (success) {
                                               /**
                                                *  当图片成功加入到指定的 PHAssetCollection 中后，获取该 PHAssetCollection 中最新的一个资源，即刚刚加入的图片资源，
                                                *  从而生成图片对应的 WLAsset 并传给 completionBlock
                                                */
                                               PHAsset *phAsset = [PHPhotoLibrary fetchLatestAssetWithAssetCollection:albumPhAssetCollection];
                                               WLAsset *asset = [[WLAsset alloc] initWithPHAsset:phAsset];
                                               completionBlock(asset, error);
                                           } else {
                                               DLog(@"Get PHAsset of image error: %@", error);
                                               completionBlock(nil, error);
                                           }
                                       }];
}

- (void)saveVideoWithVideoPathURL:(NSURL *)videoPathURL albumAssetsGroup:(WLAssetsGroup *)albumAssetsGroup completionBlock:(WLWriteAssetCompletionBlock)completionBlock {
    PHAssetCollection *albumPhAssetCollection = albumAssetsGroup.phAssetCollection;
    // 把视频加入到指定的相册对应的 PHAssetCollection
    [[PHPhotoLibrary sharedPhotoLibrary] addVideoToAlbum:videoPathURL
                                    albumAssetCollection:albumPhAssetCollection
                                       completionHandler:^(BOOL success, NSError *error) {
                                           if (success) {
                                               /**
                                                *  当视频成功加入到指定的 PHAssetCollection 中后，获取该 PHAssetCollection 中最新的一个资源，即刚刚加入的视频资源，
                                                *  从而生成视频对应的 WLAsset 并传给 completionBlock
                                                */
                                               PHAsset *phAsset = [PHPhotoLibrary fetchLatestAssetWithAssetCollection:albumPhAssetCollection];
                                               WLAsset *asset = [[WLAsset alloc] initWithPHAsset:phAsset];
                                               completionBlock(asset, error);
                                           } else {
                                               DLog(@"Get PHAsset of video Error: %@", error);
                                               completionBlock(nil, error);
                                           }
                                       }];
}

- (PHCachingImageManager *)phCachingImageManager {
    if (!_phCachingImageManager) {
        _phCachingImageManager = [[PHCachingImageManager alloc] init];
    }
    return _phCachingImageManager;
}

@end


@implementation PHPhotoLibrary (WLAdd)

+ (PHFetchOptions *)createFetchOptionsWithAlbumContentType:(WLAlbumContentType)contentType {
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
    // 根据输入的内容类型过滤相册内的资源
    switch (contentType) {
        case WLAlbumContentTypeOnlyPhoto:
            fetchOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType = %i", PHAssetMediaTypeImage];
            break;
            
        case WLAlbumContentTypeOnlyVideo:
            fetchOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType = %i",PHAssetMediaTypeVideo];
            break;
            
        case WLAlbumContentTypeOnlyAudio:
            fetchOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType = %i",PHAssetMediaTypeAudio];
            break;
            
        default:
            break;
    }
    return fetchOptions;
}

+ (NSArray *)fetchAllAlbumsWithAlbumContentType:(WLAlbumContentType)contentType showEmptyAlbum:(BOOL)showEmptyAlbum showSmartAlbum:(BOOL)showSmartAlbum {
    NSMutableArray *tempAlbumsArray = [[NSMutableArray alloc] init];
    
    // 创建一个 PHFetchOptions，用于创建 WLAssetsGroup 对资源的排序和类型进行控制
    PHFetchOptions *fetchOptions = [PHPhotoLibrary createFetchOptionsWithAlbumContentType:contentType];
    
    PHFetchResult *fetchResult;
    if (showSmartAlbum) {
        // 允许显示系统的“智能相册”
        // 获取保存了所有“智能相册”的 PHFetchResult
        fetchResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
    } else {
        // 不允许显示系统的智能相册，但由于在 PhotoKit 中，“相机胶卷”也属于“智能相册”，因此这里从“智能相册”中单独获取到“相机胶卷”
        fetchResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    }
    // 循环遍历相册列表
    for (NSInteger i = 0; i < fetchResult.count; i++) {
        // 获取一个相册
        PHCollection *collection = fetchResult[i];
        if ([collection isKindOfClass:[PHAssetCollection class]]) {
            PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
            // 获取相册内的资源对应的 fetchResult，用于判断根据内容类型过滤后的资源数量是否大于 0，只有资源数量大于 0 的相册才会作为有效的相册显示
            PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:fetchOptions];
            if (fetchResult.count > 0 || showEmptyAlbum) {
                // 若相册不为空，或者允许显示空相册，则保存相册到结果数组
                // 判断如果是“相机胶卷”，则放到结果列表的第一位
                if (assetCollection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary) {
                    [tempAlbumsArray insertObject:assetCollection atIndex:0];
                } else {
                    [tempAlbumsArray addObject:assetCollection];
                }
            }
        } else {
            NSAssert(NO, @"Fetch collection not PHCollection: %@", collection);
        }
    }
    
    // 获取所有用户自己建立的相册
    PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    // 循环遍历用户自己建立的相册
    for (NSInteger i = 0; i < topLevelUserCollections.count; i++) {
        // 获取一个相册
        PHCollection *collection = topLevelUserCollections[i];
        if ([collection isKindOfClass:[PHAssetCollection class]]) {
            PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
            
            if (showEmptyAlbum) {
                // 允许显示空相册，直接保存相册到结果数组中
                [tempAlbumsArray addObject:assetCollection];
            } else {
                // 不允许显示空相册，需要判断当前相册是否为空
                PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:fetchOptions];
                // 获取相册内的资源对应的 fetchResult，用于判断根据内容类型过滤后的资源数量是否大于 0
                if (fetchResult.count > 0) {
                    [tempAlbumsArray addObject:assetCollection];
                }
            }
        }
    }
    NSArray *resultAlbumsArray = [tempAlbumsArray copy];
    return resultAlbumsArray;
}

+ (PHAsset *)fetchLatestAssetWithAssetCollection:(PHAssetCollection *)assetCollection {
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
    // 按时间对 PHAssetCollection 内的资源进行排序，最新的资源排在数组第一位
    fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    PHFetchResult *fetchResult = [PHAsset fetchAssetsWithOptions:fetchOptions];
    if (assetCollection) {
        fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:fetchOptions];
    }
    // 获取 PHAssetCollection 内第一个资源，即最新的资源
    PHAsset *latestAsset = fetchResult.firstObject;
    return latestAsset;
}

- (void)addImageToAlbum:(CGImageRef)imageRef albumAssetCollection:(PHAssetCollection *)albumAssetCollection orientation:(UIImageOrientation)orientation completionHandler:(void(^)(BOOL success, NSError *error))completionHandler {
    UIImage *targetImage = [UIImage imageWithCGImage:imageRef scale:WLScreenScale() orientation:orientation];
    [self performChanges:^{
        // 创建一个以图片生成新的 PHAsset，这时图片已经被添加到“相机胶卷”
        PHAssetChangeRequest *assetChangeRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:targetImage];

        if (albumAssetCollection.assetCollectionType == PHAssetCollectionTypeAlbum) {
            // 如果传入的相册类型为标准的相册（非“智能相册”和“时刻”），则把刚刚创建的 Asset 添加到传入的相册中。
            
            // 创建一个改变 PHAssetCollection 的请求，并指定相册对应的 PHAssetCollection
            PHAssetCollectionChangeRequest *assetCollectionChangeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:albumAssetCollection];
            /**
             *  把 PHAsset 加入到对应的 PHAssetCollection 中，系统推荐的方法是调用 placeholderForCreatedAsset ，
             *  返回一个的 placeholder 来代替刚创建的 PHAsset 的引用，并把该引用加入到一个 PHAssetCollectionChangeRequest 中。
             */
            [assetCollectionChangeRequest addAssets:@[[assetChangeRequest placeholderForCreatedAsset]]];
        }
        
    } completionHandler:^(BOOL success, NSError *error) {
        if (completionHandler) {
            /**
             *  performChanges:completionHandler 不在主线程执行，若用户在该 block 中操作 UI 时会产生一些问题，
             *  为了避免这种情况，这里该 block 主动放到主线程执行。
             */
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler(success, error);
            });
        }
//        if (!success) {
//            DLog(@"Creating asset of image error : %@", error);
//        } else {
//        }
    }];
}

- (void)addVideoToAlbum:(NSURL *)videoPathURL albumAssetCollection:(PHAssetCollection *)albumAssetCollection completionHandler:(void(^)(BOOL success, NSError *error))completionHandler {
    [self performChanges:^{
        // 创建一个以视频生成新的 PHAsset 的请求
        PHAssetChangeRequest *assetChangeRequest = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:videoPathURL];
        
        if (albumAssetCollection.assetCollectionType == PHAssetCollectionTypeAlbum) {
            // 如果传入的相册类型为标准的相册（非“智能相册”和“时刻”），则把刚刚创建的 Asset 添加到传入的相册中。
            
            // 创建一个改变 PHAssetCollection 的请求，并指定相册对应的 PHAssetCollection
            PHAssetCollectionChangeRequest *assetCollectionChangeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:albumAssetCollection];
            /**
             *  把 PHAsset 加入到对应的 PHAssetCollection 中，系统推荐的方法是调用 placeholderForCreatedAsset ，
             *  返回一个的 placeholder 来代替刚创建的 PHAsset 的引用，并把该引用加入到一个 PHAssetCollectionChangeRequest 中。
             */
            [assetCollectionChangeRequest addAssets:@[[assetChangeRequest placeholderForCreatedAsset]]];
        }
        
    } completionHandler:^(BOOL success, NSError *error) {
        if (completionHandler) {
            /**
             *  performChanges:completionHandler 不在主线程执行，若用户在该 block 中操作 UI 时会产生一些问题，
             *  为了避免这种情况，这里该 block 主动放到主线程执行。
             */
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler(success, error);
            });
        }
//        if (!success) {
//            DLog(@"Creating asset of video error: %@", error);
//        } else {
//        }
    }];
}

@end

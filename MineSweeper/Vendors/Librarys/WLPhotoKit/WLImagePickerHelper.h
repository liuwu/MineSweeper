//
//  WLImagePickerHelper.h
//  Welian
//
//  Created by dong on 2017/3/31.
//  Copyright © 2017年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WLAsset;

@interface WLImagePickerHelper : NSObject
/**
 *  判断一个由 QMUIAsset 对象组成的数组中是否包含特定的 QMUIAsset 对象
 *
 *  @param imageAssetArray  一个由 QMUIAsset 对象组成的数组
 *  @param targetImageAsset 需要被判断的 QMUIAsset 对象
 *
 */
+ (BOOL)imageAssetArray:(NSMutableArray *)imageAssetArray containsImageAsset:(WLAsset *)targetImageAsset;

/**
 *  从一个由 QMUIAsset 对象组成的数组中移除特定的 QMUIAsset 对象（如果这个 QMUIAsset 对象不在该数组中，则不作处理）
 *
 *  @param imageAssetArray  一个由 QMUIAsset 对象组成的数组
 *  @param targetImageAsset 需要被移除的 QMUIAsset 对象
 */
+ (void)imageAssetArray:(NSMutableArray *)imageAssetArray removeImageAsset:(WLAsset *)targetImageAsset;

@end

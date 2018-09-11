//
//  WLImagePickerHelper.m
//  Welian
//
//  Created by dong on 2017/3/31.
//  Copyright © 2017年 chuansongmen. All rights reserved.
//

#import "WLImagePickerHelper.h"
#import "WLAsset.h"
#import <Photos/PHCollection.h>
#import <Photos/PHFetchResult.h>

@implementation WLImagePickerHelper

+ (BOOL)imageAssetArray:(NSMutableArray *)imageAssetArray containsImageAsset:(WLAsset *)targetImageAsset {
    NSString *targetAssetIdentify = [targetImageAsset assetIdentity];
    for (NSUInteger i = 0; i < [imageAssetArray count]; i++) {
        WLAsset *imageAsset = [imageAssetArray objectAtIndex:i];
        if ([[imageAsset assetIdentity] isEqual:targetAssetIdentify]) {
            return YES;
        }
    }
    return NO;
}


+ (void)imageAssetArray:(NSMutableArray *)imageAssetArray removeImageAsset:(WLAsset *)targetImageAsset {
    NSString *targetAssetIdentify = [targetImageAsset assetIdentity];
    for (NSUInteger i = 0; i < [imageAssetArray count]; i++) {
        WLAsset *imageAsset = [imageAssetArray objectAtIndex:i];
        if ([[imageAsset assetIdentity] isEqual:targetAssetIdentify]) {
            [imageAssetArray removeObject:imageAsset];
            break;
        }
    }
}

@end

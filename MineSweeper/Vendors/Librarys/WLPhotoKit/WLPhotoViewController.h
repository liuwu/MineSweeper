//
//  WLPhotoViewController.h
//  Welian
//
//  Created by dong on 2017/3/31.
//  Copyright © 2017年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WLPhotoConst.h"
#import "WLAssetsManager.h"

@class WLPhotoViewController, WLAsset;

@protocol WLPhotoViewControllerDelegate <NSObject>

@optional

- (void)photoViewController:(WLPhotoViewController *)photoViewController didFinishPickingImageWithImagesAssetArray:(NSMutableArray<WLAsset *> *)imagesAssetArray;
- (void)photoViewControllerDidCancel:(WLPhotoViewController *)photoViewController;

@end

@interface WLPhotoViewController : UIViewController

// 默认WLAlbumSortTypeReverse
@property (nonatomic, assign) WLAlbumSortType albumSortType;

@property (nonatomic, assign) NSInteger maximumSelectImageCount;
@property (nonatomic, assign) NSInteger minimumSelectImageCount;
@property(nonatomic, strong) NSMutableArray<WLAsset *> *selectedImageAssetArray; // 当前被选择的图片对应的 WLAsset 对象数组
@property(nonatomic, assign) BOOL allowsMultipleSelection; // 是否允许图片多选，默认为 YES。如果为 NO，则不显示 checkbox 和底部工具栏。
@property (nonatomic, assign) NSInteger lineCount;  // 一行图片个数 默认4个
@property (nonatomic, weak) id<WLPhotoViewControllerDelegate> delegate;

@end

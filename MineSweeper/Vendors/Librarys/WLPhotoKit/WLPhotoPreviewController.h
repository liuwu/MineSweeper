//
//  WLPhotoPreviewController.h
//  Welian
//
//  Created by dong on 2017/4/1.
//  Copyright © 2017年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WLPhotoPreviewController, WLAsset;

@protocol WLPhotoPreviewControllerDelegate <NSObject>
@optional
- (void)photoPreviewController:(WLPhotoPreviewController *)photoPreviewController didSelectAtIndex:(NSInteger)index;
- (void)photoPreviewController:(WLPhotoPreviewController *)photoPreviewController didDeselectAtIndex:(NSInteger)index;

- (void)photoPreviewControllerDone:(WLPhotoPreviewController *)photoPreviewController;
@end

@interface WLPhotoPreviewController : UIViewController

@property (nonatomic, weak) id<WLPhotoPreviewControllerDelegate> delegate;

@property (nonatomic, assign) NSInteger currentImageIndex;
@property (nonatomic, assign) NSInteger maximumSelectImageCount;
@property (nonatomic, assign) NSInteger minimumSelectImageCount;

@property (nonatomic, strong) NSMutableArray<WLAsset *> *imagesAssetArray;
@property (nonatomic, strong) NSMutableArray<WLAsset *> *selectedImageAssetArray;

@end

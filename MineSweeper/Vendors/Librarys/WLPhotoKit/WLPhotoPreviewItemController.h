//
//  WLPhotoPreviewItemController.h
//  Welian
//
//  Created by dong on 2017/4/1.
//  Copyright © 2017年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WLPhotoPreviewItemController, WLAsset;

@protocol WLPhotoPreviewItemControllerDelegate <NSObject>

- (void)singleTouchInPhotoPreviewItemControllerZoomingImageView:(WLPhotoPreviewItemController *)photoPreviewItemController;

@end

@interface WLPhotoPreviewItemController : UIViewController

@property (nonatomic, weak) id<WLPhotoPreviewItemControllerDelegate>delegate;
@property (nonatomic, assign) NSInteger pageIndex;

+ (WLPhotoPreviewItemController *)photoItemControllerForPageIndex:(NSInteger)pageIndex imageAsset:(WLAsset *)imageAsset;

@end

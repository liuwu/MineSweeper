//
//  WLImagePickerCollectionViewCell.h
//  Welian
//
//  Created by dong on 2017/3/31.
//  Copyright © 2017年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WLAsset.h"

@class WLImagePickerCollectionViewCell;

typedef void(^WLPhotosCellOperationBlock)(WLImagePickerCollectionViewCell *cell);

@interface WLImagePickerCollectionViewCell : UICollectionViewCell

/// checkbox未被选中时显示的图片
@property(nonatomic, strong) UIImage *checkboxImage;

/// checkbox被选中时显示的图片
@property(nonatomic, strong) UIImage *checkboxCheckedImage;

@property(nonatomic, strong) UIImageView *contentImageView;
@property(nonatomic, strong, readonly) UIButton *checkboxButton;

@property(nonatomic, assign, getter=isEditing) BOOL editing;
@property(nonatomic, assign, getter=isChecked) BOOL checked;
@property(nonatomic, assign) WLAssetDownloadStatus downloadStatus; // Cell 中对应资源的下载状态，这个值的变动会相应地调整 UI 表现

/// control对象点击的回调
@property (nullable, copy, nonatomic)WLPhotosCellOperationBlock chooseImageDidSelectBlock;

@end

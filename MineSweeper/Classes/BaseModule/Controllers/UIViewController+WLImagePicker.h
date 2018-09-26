//
//  UIViewController+WLImagePicker.h
//  Welian
//
//  Created by adi on 2017/3/10.
//  Copyright © 2017年 chuansongmen. All rights reserved.
//

/**
 *  @author Haodi, 16-06-06 11:06:03
 *
 *  选取照片
 */
UIKIT_EXTERN NSString *const ActionTakePicktureName;

UIKIT_EXTERN NSString *const ActionSelectPicktureName;

typedef void (^ImagePickerImageBlock)(UIImage *image);
typedef void (^ImagePickerSuccessBlock)(UIImage *image, id resultInfo);
typedef void (^ImagePickerFailedBlock)(NSError *error);

#import <UIKit/UIKit.h>

@interface UIViewController (WLImagePicker)

@property (nonatomic, assign,getter=isEditingPhoto) BOOL editingPhoto;//是否编辑照片

@property (nonatomic, copy) ImagePickerImageBlock imageBlock;
@property (nonatomic, copy) ImagePickerSuccessBlock succesBlock;
@property (nonatomic, copy) ImagePickerFailedBlock failedBlock;


- (void)choosePictureimageBlock:(ImagePickerImageBlock)imageBlock successBlock:(ImagePickerSuccessBlock)imageSuccessBlock imagePickerFailedBlock:(ImagePickerFailedBlock)imageFailedBlock;

/**
 *  @author Haodi, 16-06-06 11:06:28
 *
 *  @param title             标题
 *  @param titles            必须是 ActionTakePicktureName，ActionSelectPicktureName
 */
- (void)choosePictureTitle:(NSString *)title actionButtonTitles:(NSArray<NSString *> *)titles imageBlock:(ImagePickerImageBlock)imageBlock successBlock:(ImagePickerSuccessBlock)imageSuccessBlock imagePickerFailedBlock:(ImagePickerFailedBlock)imageFailedBlock;


@end

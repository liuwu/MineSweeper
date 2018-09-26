//
//  UIViewController+WLImagePicker.m
//  Welian
//
//  Created by adi on 2017/3/10.
//  Copyright © 2017年 chuansongmen. All rights reserved.
//

#import "UIViewController+WLImagePicker.h"
#import "WLSystemAuth.h"
#import "WLOSSUploadFileTool.h"
#import "A2DynamicDelegate.h"

#import "UserModelClient.h"

NSString *const ActionTakePicktureName = @"拍照";

NSString *const ActionSelectPicktureName = @"从相册选择";

static const void *kEditingPhoto = &kEditingPhoto;

static NSString *const kImageKey = @"kImageKey";
static NSString *const kSuccessBlockKey = @"kSuccessBlockKey";
static NSString *const kfailtureBlockKey = @"kfailtureBlockKey";

@implementation UIViewController (WLImagePicker)

@dynamic imageBlock, succesBlock, failedBlock;


- (void)setEditingPhoto:(BOOL)editingPhoto{
    objc_setAssociatedObject(self,kEditingPhoto, @(editingPhoto), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)isEditingPhoto{
    return [objc_getAssociatedObject(self, kEditingPhoto) boolValue];
}

- (ImagePickerImageBlock)imageBlock {
    return (ImagePickerImageBlock)objc_getAssociatedObject(self, &kImageKey);
}
- (void)setImageBlock:(ImagePickerImageBlock)imageBlock{
    if (imageBlock)
       objc_setAssociatedObject(self, &kImageKey, imageBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (ImagePickerSuccessBlock)succesBlock {
    return (ImagePickerSuccessBlock)objc_getAssociatedObject(self, &kSuccessBlockKey);
}
- (void)setSuccesBlock:(ImagePickerSuccessBlock)succesBlock{
    if (succesBlock)
        objc_setAssociatedObject(self, &kSuccessBlockKey, succesBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (ImagePickerFailedBlock)failedBlock {
    return (ImagePickerFailedBlock)objc_getAssociatedObject(self, &kfailtureBlockKey);
}
-(void)setFailedBlock:(ImagePickerFailedBlock)failedBlock{
    if (failedBlock)
        objc_setAssociatedObject(self, &kfailtureBlockKey, failedBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma mark - 选取头像照片
- (void)choosePictureTitle:(NSString *)title actionButtonTitles:(NSArray<NSString *> *)titles imageBlock:(ImagePickerImageBlock)imageBlock successBlock:(ImagePickerSuccessBlock)imageSuccessBlock imagePickerFailedBlock:(ImagePickerFailedBlock)imageFailedBlock{
   
    [self.view endEditing:YES];
    typeof(self) __weak weakSelf = self;

    self.imageBlock = imageBlock;
    self.succesBlock = imageSuccessBlock;
    self.failedBlock = imageFailedBlock;
    
    [WLActionSheet showActionSheetWithTitle:title cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:titles handler:^(WLActionSheet *actionSheet, NSInteger index) {
        if (index == 1) {//从手机相册选择
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.allowsEditing = weakSelf.isEditingPhoto;
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                imagePicker.delegate = (id <UINavigationControllerDelegate, UIImagePickerControllerDelegate>)weakSelf;
                [weakSelf presentViewController:imagePicker animated:YES completion:nil];
            }else {
                [weakSelf showAlertViewWithTitle:@"相册不可用！！！"];
            }
        }else if (index == 2) {//拍照
            // 判断相机可以使用
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                //判断相机是否能够使用
                [WLSystemAuth showAlertWithAuthType:WLSystemAuthTypeCamera completionHandler:^(WLSystemAuthStatus status) {
                    if (status == WLSystemAuthStatusAuthorized) {
                        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                        imagePicker.allowsEditing = weakSelf.isEditingPhoto;
                        imagePicker.delegate = (id <UINavigationControllerDelegate, UIImagePickerControllerDelegate>)weakSelf;
                        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
                        imagePicker.navigationController.navigationBar.barStyle = UIBarStyleDefault;
                        [weakSelf presentViewController:imagePicker animated:YES completion:nil];
                    }
                }];
            }else {
                [weakSelf showAlertViewWithTitle:@"摄像头不可用！！！"];
            }
        }
    }];
}

- (void)choosePictureimageBlock:(ImagePickerImageBlock)imageBlock successBlock:(ImagePickerSuccessBlock)imageSuccessBlock imagePickerFailedBlock:(ImagePickerFailedBlock)imageFailedBlock
{
    [self choosePictureTitle:nil actionButtonTitles:@[ActionSelectPicktureName,ActionTakePicktureName] imageBlock:imageBlock successBlock:imageSuccessBlock imagePickerFailedBlock:imageFailedBlock];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //image就是你选取的照片
    UIImage *image = nil;
    if (self.isEditingPhoto == NO) {
        image  = [info valueForKey:UIImagePickerControllerOriginalImage];
    }else {
        image = [info valueForKey:UIImagePickerControllerEditedImage];
    }
//    NSURL *selectPhotoUrl = [info valueForKey:UIImagePickerControllerReferenceURL];
    if (image) {
        typeof(self) __weak weakSelf = self;
        self.imageBlock(image);
        [WLHUDView showHUDWithStr:@"上传中..." dim:YES];
        [UserModelClient changeUserLogoWithParams:nil
                                            image:[image fixOrientation]
                                          Success:^(id resultInfo) {
                                              [WLHUDView showSuccessHUD:@"上传成功"];
                                              weakSelf.succesBlock(image, resultInfo);
                                          } Failed:^(NSError *error) {
                                              [WLHUDView showErrorHUD:@"上传失败"];
                                              weakSelf.failedBlock(error);
                                          }];
        
//        [[WLOSSUploadFileTool sharedInstance] uploadImageToOSSService:image Success:^(id resultInfo) {
//            [WLHUDView showSuccessHUD:@"上传成功"];
//            weakSelf.succesBlock(image, resultInfo);
//        } Failed:^(NSError *error) {
//            [WLHUDView showErrorHUD:@"上传失败"];
//            weakSelf.failedBlock(error);
//        }];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - method
- (void)showAlertViewWithTitle:(NSString *)title{
     [[LGAlertView alertViewWithTitle:title message:nil style:LGAlertViewStyleAlert buttonTitles:nil cancelButtonTitle:nil destructiveButtonTitle:@"知道了！" actionHandler:nil cancelHandler:nil destructiveHandler:nil] showAnimated:YES completionHandler:nil];
}


@end

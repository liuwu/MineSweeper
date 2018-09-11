//
//  KSPhotoBrowser+WLAdd.m
//  Welian
//
//  Created by dong on 2018/2/7.
//  Copyright © 2018年 chuansongmen. All rights reserved.
//

#import "KSPhotoBrowser+WLAdd.h"
//#import "WLShareFriendsTool.h"
#import "WLAssetsManager.h"
#import "WLSystemAuth.h"

@implementation KSPhotoBrowser (WLAdd)

- (void)sendFriendImage:(UIImage *)image {
//    [[WLShareFriendsTool sharedWLShareFriendsTool] shareFriendsWithImage:image];
}

- (void)extractQRcodeResultJump:(NSString *)resultString {
//    [[AppDelegate sharedAppDelegate] wlopenURLString:resultString sourceViewControl:self];
}

- (void)saveToPhotosAlbumImage:(UIImage *)image {
    [WLSystemAuth showAlertWithAuthType:WLSystemAuthTypePhotos completionHandler:^(WLSystemAuthStatus status) {
        if (status == WLSystemAuthStatusAuthorized) {
            WLImageWriteToSavedPhotosAlbumWithUserLibrary(image, ^(WLAsset *asset, NSError *error) {
                if (error) {
                    [WLHUDView showErrorHUD:error.localizedDescription];
                }else{
                    [WLHUDView showSuccessHUD:@"保存成功"];
                }
            });
        }
    }];
}

@end

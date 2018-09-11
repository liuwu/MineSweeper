//
//  KSPhotoBrowser+WLAdd.h
//  Welian
//
//  Created by dong on 2018/2/7.
//  Copyright © 2018年 chuansongmen. All rights reserved.
//

#import "KSPhotoBrowser.h"

@interface KSPhotoBrowser (WLAdd)

- (void)sendFriendImage:(UIImage *)image;

- (void)saveToPhotosAlbumImage:(UIImage *)image;

- (void)extractQRcodeResultJump:(NSString *)resultString;


@end

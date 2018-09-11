//
//  WLPhoto3DTouchViewController.m
//  Welian
//
//  Created by dong on 2018/3/8.
//  Copyright © 2018年 chuansongmen. All rights reserved.
//

#import "WLPhoto3DTouchViewController.h"
#import "WLAssetsManager.h"
#import "WLSystemAuth.h"

@interface WLPhoto3DTouchViewController ()
@property (nonatomic, strong, readwrite) YYAnimatedImageView *imageView;
@end

@implementation WLPhoto3DTouchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView.image = self.image;
    [self.view addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.image.size);
        make.center.equalTo(self.view);
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.imageView setImageWithURL:[NSURL URLWithString:[self.imageUrlString wl_imageUrlManageScene:WLDownloadImageSceneBig condenseSize:CGSizeZero]] placeholder:self.image];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view addSubview:self.imageView];
}

- (YYAnimatedImageView *)imageView {
    if (!_imageView) {
        _imageView = [[YYAnimatedImageView alloc] init];
        _imageView.clipsToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}

- (NSArray<id<UIPreviewActionItem>> *)previewActionItems {
    UIPreviewAction *item = [UIPreviewAction actionWithTitle:@"保存图片" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        UIImage *imageAA = self.imageView.image;
        if (!imageAA) return;
        
        UIImage *image = [UIImage imageWithData:UIImageJPEGRepresentation(imageAA, 1)];
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
    }];
    return @[item];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

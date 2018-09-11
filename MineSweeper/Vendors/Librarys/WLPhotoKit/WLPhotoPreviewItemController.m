//
//  WLPhotoPreviewItemController.m
//  Welian
//
//  Created by dong on 2017/4/1.
//  Copyright © 2017年 chuansongmen. All rights reserved.
//

#import "WLPhotoPreviewItemController.h"
#import "WLZoomImageView.h"
#import "WLAsset.h"

@interface WLPhotoPreviewItemController () <WLZoomImageViewDelegate>

@property (nonatomic, strong) WLZoomImageView *zoomImageView;
@property (nonatomic, strong) WLAsset *imageAsset;
@end

@implementation WLPhotoPreviewItemController

- (BOOL)prefersHomeIndicatorAutoHidden {
    return YES;
}

+ (WLPhotoPreviewItemController *)photoItemControllerForPageIndex:(NSInteger)pageIndex imageAsset:(WLAsset *)imageAsset {
    return [[self alloc] initWithPageIndex:pageIndex imageAsset:imageAsset];
}

- (id)initWithPageIndex:(NSInteger)pageIndex imageAsset:(WLAsset *)imageAsset {
    if (self = [super init]) {
        _pageIndex = pageIndex;
        _imageAsset = imageAsset;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.zoomImageView = [[WLZoomImageView alloc] initWithFrame:self.view.bounds];
    self.zoomImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.zoomImageView.delegate = self;
    [self.view addSubview:self.zoomImageView];
    [self requestImageForZoomImageView];
}

- (void)requestImageForZoomImageView {
    @weakify(self)
    // 获取资源图片的预览图，这是一张适合当前设备屏幕大小的图片，最终展示时把图片交给组件控制最终展示出来的大小。
    // 系统相册本质上也是这么处理的，因此无论是系统相册，还是这个系列组件，由始至终都没有显示照片原图，
    // 这也是系统相册能加载这么快的原因。
    // 另外这里采用异步请求获取图片，避免获取图片时 UI 卡顿
    PHAssetImageProgressHandler phProgressHandler = ^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
        self.imageAsset.downloadProgress = progress;
        dispatch_async(dispatch_get_main_queue(), ^{
        });
    };
    
    self.imageAsset.requestID = [self.imageAsset requestPreviewImageWithCompletion:^void(UIImage *result, NSDictionary *info) {
        @strongify(self)
        self.zoomImageView.image = result;
        BOOL downlaodSucceed = (result && !info) || (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
        if (downlaodSucceed) {
            // 资源资源已经在本地或下载成功
            [self.imageAsset updateDownloadStatusWithDownloadResult:YES];
        } else if ([info objectForKey:PHImageErrorKey] ) {
            // 下载错误
            [self.imageAsset updateDownloadStatusWithDownloadResult:NO];
        }
        
    } withProgressHandler:phProgressHandler];
}

#pragma mark - WLZoomImageViewDelegate
- (void)singleTouchInZoomingImageView:(WLZoomImageView *)zoomImageView location:(CGPoint)location {
    if ([self.delegate respondsToSelector:@selector(singleTouchInPhotoPreviewItemControllerZoomingImageView:)]) {
        [self.delegate singleTouchInPhotoPreviewItemControllerZoomingImageView:self];
    }
}
//- (void)doubleTouchInZoomingImageView:(WLZoomImageView *)zoomImageView location:(CGPoint)location {
//    
//}
//- (void)longPressInZoomingImageView:(WLZoomImageView *)zoomImageView {
//    
//}


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

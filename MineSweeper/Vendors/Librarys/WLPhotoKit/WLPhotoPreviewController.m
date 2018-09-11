//
//  WLPhotoPreviewController.m
//  Welian
//
//  Created by dong on 2017/4/1.
//  Copyright © 2017年 chuansongmen. All rights reserved.
//

#import "WLPhotoPreviewController.h"
#import "WLAssetsManager.h"
#import "WLPhotoPreviewItemController.h"
#import "WLImagePickerHelper.h"
#import "WLPhotoBottomView.h"

@interface WLNavbarView : UIView

@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *selectButton;

@end

@implementation WLNavbarView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _title = [[UILabel alloc] init];
        _title.textColor = [UIColor whiteColor];
        [self addSubview:_title];
        _backButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_backButton setImage:[[WLDicHQFontImage iconWithName:@"back" fontSize:WLNavImagePtSize color:[UIColor whiteColor]] wl_alwaysOriginal] forState:UIControlStateNormal];
        [self addSubview:_backButton];
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectButton setImage:[UIImage wl_imageNameAlwaysOriginal:@"photo_check_default"] forState:UIControlStateNormal];
        [_selectButton setImage:[UIImage wl_imageNameAlwaysOriginal:@"photo_check_selected"] forState:UIControlStateSelected];
        [self addSubview:_selectButton];
        [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(20.f);
            make.size.mas_equalTo(CGSizeMake(40.f, 40.f));
            make.bottom.equalTo(self).offset(-10);
        }];
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(_backButton);
        }];
        [_selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-20.f);
            make.size.mas_equalTo(CGSizeMake(40.f, 40.f));
            make.bottom.equalTo(_backButton);
        }];
    }
    return self;
}

@end

@interface WLPhotoPreviewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource, WLPhotoPreviewItemControllerDelegate>

@property (nonatomic, weak) UIPageViewController *pageVC;
@property (nonatomic, strong) WLNavbarView *navBarView;
@property (nonatomic, strong) WLPhotoBottomView *bottomView;

@property (nonatomic, assign) BOOL isShowNavBar;
@end

@implementation WLPhotoPreviewController

- (BOOL)prefersHomeIndicatorAutoHidden {
    return YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.navigationController setNavigationBarHidden:NO];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _isShowNavBar = YES;
        _currentImageIndex = 0;
        _minimumSelectImageCount = 1;
        _maximumSelectImageCount = 9;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    UIPageViewController *pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:@{UIPageViewControllerOptionInterPageSpacingKey:@20.f}];
    pageViewController.delegate = self;
    pageViewController.dataSource = self;
    
    [self addChildViewController:pageViewController];
    self.pageVC = pageViewController;
    
    [self.view addSubview:self.pageVC.view];
    self.pageVC.view.frame = self.view.bounds;
    [self.pageVC didMoveToParentViewController:self];
    
    UIColor *backColor = WLRGBA(34.f, 34.f, 34.f, 0.7);
    _navBarView = [[WLNavbarView alloc] init];
    _navBarView.backgroundColor = backColor;
    [self.view addSubview:_navBarView];
    [_navBarView.backButton addTarget:self action:@selector(backItemClick) forControlEvents:UIControlEventTouchUpInside];
    [_navBarView.selectButton addTarget:self action:@selector(handleCheckBoxButtonClick) forControlEvents:UIControlEventTouchUpInside];

    _bottomView = [[WLPhotoBottomView alloc] init];
    _bottomView.backgroundColor = backColor;
    _bottomView.bottom = self.view.bottom;
    [self.view addSubview:_bottomView];
    [_bottomView.doneButton setTitle:@"完成" forState:UIControlStateNormal];
    [_bottomView.doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_bottomView.doneButton addTarget:self action:@selector(handleCheckDoenButtonClick) forControlEvents:UIControlEventTouchUpInside];
    _bottomView.previewButton.hidden = YES;
    [_navBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(ViewCtrlTopBarHeight);
    }];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        if (iPhoneX) {
            make.height.mas_equalTo(WLPhotoBottomViewHeigh+kWL_safeAreaHeight);
        }else{
            make.height.mas_equalTo(WLPhotoBottomViewHeigh);
        }
    }];
    [self updateImageCountAndCheckLimited];
    [self didSelectItemAtIndex:self.currentImageIndex];
}

#pragma mark WLBPCoverViewDelegate
-(void)didSelectItemAtIndex:(NSInteger)index {
    WLPhotoPreviewItemController *photoItemVC = [self newPhotoPreviewItemControllerWithIndex:index];
    [self.pageVC setViewControllers:@[photoItemVC]
                          direction:UIPageViewControllerNavigationDirectionForward
                           animated:NO
                         completion:nil];
    [self navBarTitleIndex:index];
}

#pragma UIPageViewControllerDataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger index = ((WLPhotoPreviewItemController *)viewController).pageIndex;
    if (index > 0) {
        index -= 1;
        return [self newPhotoPreviewItemControllerWithIndex:index];
    }
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger count = self.imagesAssetArray.count;
    NSInteger index = ((WLPhotoPreviewItemController *)viewController).pageIndex;
    if (index < count - 1) {
        index += 1;
        return [self newPhotoPreviewItemControllerWithIndex:index];
    }
    return nil;
}

#pragma UIPageViewControllerDelegate
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed
{
    WLPhotoPreviewItemController *photoItemVC = (WLPhotoPreviewItemController *)pageViewController.viewControllers[0];
    NSInteger index = photoItemVC.pageIndex;
    if (finished && completed) {
        [self navBarTitleIndex:index];
    }
}

#pragma mark - WLPhotoPreviewItemControllerDelegate 
- (void)singleTouchInPhotoPreviewItemControllerZoomingImageView:(WLPhotoPreviewItemController *)photoPreviewItemController {
    _isShowNavBar = !_isShowNavBar;
    NSTimeInterval time = 0.2f;
    if (_isShowNavBar) {
        [UIView animateWithDuration:time animations:^{
            self.navBarView.alpha = 1.f;
            self.bottomView.alpha = 1.f;
        }];
    }else{
        [UIView animateWithDuration:time animations:^{
            self.navBarView.alpha = 0;
            self.bottomView.alpha = 0;
        }];
    }
}

- (void)handleCheckBoxButtonClick {
    
    WLPhotoPreviewItemController *photoItemVC = (WLPhotoPreviewItemController *)self.pageVC.viewControllers[0];
    NSInteger index = photoItemVC.pageIndex;
    WLAsset *imageAsset = [self.imagesAssetArray objectAtIndex:index];
    BOOL isSelected = [self.selectedImageAssetArray containsObject:imageAsset];
    if (isSelected) {
        // 根据选择图片数控制预览和发送按钮的 enable，以及修改已选中的图片数
        [WLImagePickerHelper imageAssetArray:self.selectedImageAssetArray removeImageAsset:imageAsset];
        [self navBarTitleIndex:index];
        [self updateImageCountAndCheckLimited];
        if ([self.delegate respondsToSelector:@selector(photoPreviewController:didDeselectAtIndex:)]) {
            [self.delegate photoPreviewController:self didDeselectAtIndex:index];
        }
    } else {
        // 发出请求获取大图，如果图片在 iCloud，则会发出网络请求下载图片。这里同时保存请求 id，供取消请求使用
        UIImage *previewImage = [imageAsset previewImage];
        if (previewImage) {
            [self.selectedImageAssetArray addObject:imageAsset];
            // 资源资源已经在本地或下载成功
            [imageAsset updateDownloadStatusWithDownloadResult:YES];
            [self navBarTitleIndex:index];
            [self updateImageCountAndCheckLimited];
            if ([self.delegate respondsToSelector:@selector(photoPreviewController:didSelectAtIndex:)]) {
                [self.delegate photoPreviewController:self didSelectAtIndex:index];
            }
        }else{
            [WLHUDView showAttentionHUD:@"iCloud同步中..."];
            imageAsset.requestID = [imageAsset requestPreviewImageWithCompletion:^(UIImage *result, NSDictionary *info) {
                BOOL downloadSucceed = (result && !info) || (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
                if (downloadSucceed) {
                    // 资源资源已经在本地或下载成功
                    [imageAsset updateDownloadStatusWithDownloadResult:YES];
                } else if ([info objectForKey:PHImageErrorKey] ) {
                    // 下载错误
                    [imageAsset updateDownloadStatusWithDownloadResult:NO];
                }
            } withProgressHandler:^(double progress, NSError * _Nullable error, BOOL * _Nonnull stop, NSDictionary * _Nullable info) {
                
            }];
        }
    }
}


- (void)updateImageCountAndCheckLimited {
    NSInteger selectedImageCount = [_selectedImageAssetArray count];
    if (selectedImageCount) {
        [self.bottomView.doneButton setTitle:[NSString stringWithFormat:@"完成(%ld)",selectedImageCount] forState:UIControlStateNormal];
    }else{
        [self.bottomView.doneButton setTitle:@"完成" forState:UIControlStateNormal];
    }
    if (selectedImageCount >= _minimumSelectImageCount && selectedImageCount <= _maximumSelectImageCount) {
        [self.bottomView.doneButton setEnabled:YES];
    } else {
        [self.bottomView.doneButton setEnabled:NO];
    }
}

- (WLPhotoPreviewItemController *)newPhotoPreviewItemControllerWithIndex:(NSInteger)index {
    WLAsset *imageAsset = self.imagesAssetArray[index];
    WLPhotoPreviewItemController *photoItemVC = [WLPhotoPreviewItemController photoItemControllerForPageIndex:(index) imageAsset:imageAsset];
    photoItemVC.delegate = self;
    return photoItemVC;
}


- (void)handleCheckDoenButtonClick {
    if ([self.delegate respondsToSelector:@selector(photoPreviewControllerDone:)]) {
        [self.delegate photoPreviewControllerDone:self];
    }
}

- (void)navBarTitleIndex:(NSInteger)index {
    self.navBarView.title.text = [NSString stringWithFormat:@"%ld/%lu",(long)index+1, (unsigned long)self.imagesAssetArray.count];
    WLAsset *imageAsset = self.imagesAssetArray[index];
    [self.navBarView.selectButton setSelected:[self.selectedImageAssetArray containsObject:imageAsset]];
}

- (void)backItemClick {
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
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

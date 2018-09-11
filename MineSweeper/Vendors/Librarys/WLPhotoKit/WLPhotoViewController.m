//
//  WLPhotoViewController.m
//  Welian
//
//  Created by dong on 2017/3/31.
//  Copyright © 2017年 chuansongmen. All rights reserved.
//

#import "WLPhotoViewController.h"
#import "WLAssetsManager.h"

#import "WLImagePickerHelper.h"

#import "WLPhotoBottomView.h"
#import "WLAssetsGroupView.h"

#import "WLPhotoPreviewController.h"

#import "WLImagePickerCollectionViewCell.h"

@interface WLPhotoViewController () <UICollectionViewDelegate, UICollectionViewDataSource, WLAssetsGroupViewDelegate, WLPhotoPreviewControllerDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray <WLAsset *>*imagesAssetArray;

@property (nonatomic, weak) WLAssetsGroup *assetsGroup;

@property (nonatomic, strong) NSMutableArray *albumsArray;

@property (nonatomic, strong) UIButton *titleButton;

@property (nonatomic, assign) BOOL showsAssetsGroupSelection;
@property (nonatomic, strong) UIControl *overlayView;
@property (nonatomic, strong) WLAssetsGroupView *assetsGroupsView;
@property (nonatomic, strong) MASConstraint *groupsViewBottommas;

@property (nonatomic, strong) WLPhotoBottomView *bottomView;

@end

static NSString *kWLImagePickerCellIdentifier = @"kWLImagePickerCellIdentifier";

@implementation WLPhotoViewController

- (CGSize)cellImageSize {
    CGFloat imageWidth = floorf((SuperSize.width - WLPhotoImageSpacing*(self.lineCount+1))/self.lineCount);
    return CGSizeMake(imageWidth, imageWidth);
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _allowsMultipleSelection = YES;
        _lineCount = 4;
        _minimumSelectImageCount = 1;
        _maximumSelectImageCount = 9;
        _albumSortType = WLAlbumSortTypeReverse;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.titleView = self.titleButton;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelSelfVC)];
    
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.bottomView];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuide);
        } else {
            make.bottom.equalTo(self.view);
        }
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(WLPhotoBottomViewHeigh);
    }];
    self.albumsArray = [NSMutableArray array];
    @weakify(self)
    [[WLAssetsManager sharedInstance] enumerateAllAlbumsWithAlbumContentType:WLAlbumContentTypeOnlyPhoto usingBlock:^(WLAssetsGroup *resultAssetsGroup) {
        @strongify(self)
        if (resultAssetsGroup) {
            [self.albumsArray addObject:resultAssetsGroup];
        } else {
            WLAssetsGroup *assetsGroup = self.albumsArray.firstObject;
            [self refreshWithAssetsGroup:assetsGroup];
        }
    }];
    
    [self updateImageCountAndCheckLimited];
}

- (void)refreshWithAssetsGroup:(WLAssetsGroup *)assetsGroup {
    self.assetsGroup = assetsGroup;
    [self.imagesAssetArray removeAllObjects];
    
    [self.titleButton setTitle:assetsGroup.name forState:UIControlStateNormal];
    [self.titleButton wl_setImagePosition:WLImagePositionRight spacing:10.f];
    // 通过 WLAssetsGroup 获取该相册所有的图片 WLAsset，并且储存到数组中
    @weakify(self)
    [assetsGroup enumerateAssetsWithOptions:self.albumSortType usingBlock:^(WLAsset *resultAsset) {
        @strongify(self)
        if (resultAsset) {
            [self.imagesAssetArray addObject:resultAsset];
        } else {
            // result 为 nil，即遍历相片或视频完毕
            [self.collectionView reloadData];
        }
    }];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imagesAssetArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WLImagePickerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kWLImagePickerCellIdentifier forIndexPath:indexPath];
    if (self.imagesAssetArray.count <= indexPath.item) {
        return cell;
    }
    // 获取需要显示的资源
    WLAsset *imageAsset = [self.imagesAssetArray objectAtIndex:indexPath.item];
    // 异步请求资源对应的缩略图（因系统接口限制，iOS 8.0 以下为实际上同步请求）
    @weakify(self)
    [imageAsset requestThumbnailImageWithSize:[self cellImageSize] completion:^(UIImage *result, NSDictionary *info) {
        @strongify(self)
        if (!info || [[info objectForKey:PHImageResultIsDegradedKey] boolValue]) {
            // 模糊，此时为同步调用
            cell.contentImageView.image = result;
        } else if ([self qmui_itemVisibleAtIndexPath:indexPath collectionView:collectionView]) {
            // 清晰，此时为异步调用
            WLImagePickerCollectionViewCell *anotherCell = (WLImagePickerCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
            anotherCell.contentImageView.image = result;
        }
    }];
    // 响应选择
    cell.chooseImageDidSelectBlock = ^(WLImagePickerCollectionViewCell * cell){
        @strongify(self)
        NSIndexPath *index = [collectionView indexPathForCell:cell];
        [self handleCheckBoxButtonClick:index];
    };
    
    cell.editing = self.allowsMultipleSelection;
    if (cell.editing) {
        // 如果该图片的 WLAsset 被包含在已选择图片的数组中，则控制该图片被选中
        cell.checked = [WLImagePickerHelper imageAssetArray:self.selectedImageAssetArray containsImageAsset:imageAsset];
    }
    return cell;
}

- (BOOL)qmui_itemVisibleAtIndexPath:(NSIndexPath *)indexPath collectionView:(UICollectionView *)collectionView{
    NSArray *visibleItemIndexPaths = collectionView.indexPathsForVisibleItems;
    for (NSIndexPath *visibleIndexPath in visibleItemIndexPaths) {
        if ([indexPath isEqual:visibleIndexPath]) {
            return YES;
        }
    }
    return NO;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WLPhotoPreviewController *photoPreviewVC = [[WLPhotoPreviewController alloc] init];
    photoPreviewVC.delegate = self;
    photoPreviewVC.imagesAssetArray = self.imagesAssetArray;
    photoPreviewVC.selectedImageAssetArray = self.selectedImageAssetArray;
    photoPreviewVC.minimumSelectImageCount = self.minimumSelectImageCount;
    photoPreviewVC.maximumSelectImageCount = self.maximumSelectImageCount;
    photoPreviewVC.currentImageIndex = indexPath.row;
    [self.navigationController pushViewController:photoPreviewVC animated:YES];
}


#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self cellImageSize];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(WLPhotoImageSpacing,WLPhotoImageSpacing,WLPhotoImageSpacing,WLPhotoImageSpacing);
}

#pragma mark - WLAssetsGroupViewDelegate
- (void)assetsGroupsView:(WLAssetsGroupView *)assetsGroupViewController didSelectAssetsGroup:(WLAssetsGroup *)assGroup {
    [self assetsGroupDidSelected];
    if (![self.assetsGroup.phAssetCollection.localIdentifier isEqualToString:assGroup.phAssetCollection.localIdentifier]) {
        [self refreshWithAssetsGroup:assGroup];
    }
}

#pragma mark - WLPhotoPreviewControllerDelegate
- (void)photoPreviewController:(WLPhotoPreviewController *)photoPreviewController didSelectAtIndex:(NSInteger)index {
//    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
//    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    [self.collectionView reloadData];
    // 根据选择图片数控制预览和发送按钮的 enable，以及修改已选中的图片数
    [self updateImageCountAndCheckLimited];
}

- (void)photoPreviewController:(WLPhotoPreviewController *)photoPreviewController didDeselectAtIndex:(NSInteger)index {
//    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
//    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    [self.collectionView reloadData];
    // 根据选择图片数控制预览和发送按钮的 enable，以及修改已选中的图片数
    [self updateImageCountAndCheckLimited];
}

- (void)photoPreviewControllerDone:(WLPhotoPreviewController *)photoPreviewController {
    [self handleCheckDoenButtonClick];
}

- (void)handleCheckBoxButtonClick:(NSIndexPath *)indexPath {
    WLImagePickerCollectionViewCell *cell = (WLImagePickerCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    WLAsset *imageAsset = [self.imagesAssetArray objectAtIndex:indexPath.item];
    if (cell.checked) {
        // 移除选中状态
        cell.checked = NO;
        [WLImagePickerHelper imageAssetArray:_selectedImageAssetArray removeImageAsset:imageAsset];
        // 根据选择图片数控制预览和发送按钮的 enable，以及修改已选中的图片数
        [self updateImageCountAndCheckLimited];
    } else {
        if (_selectedImageAssetArray.count >= _maximumSelectImageCount) {
            NSString  *str = [NSString stringWithFormat:@"最多选择%lu张照片",(unsigned long)self.maximumSelectImageCount];
            [WLHUDView showAttentionHUD:str];
            return;
        }
        // 发出请求获取大图，如果图片在 iCloud，则会发出网络请求下载图片。这里同时保存请求 id，供取消请求使用
        [self requestImageWithIndexPath:indexPath];
    }
}

- (void)updateImageCountAndCheckLimited {
    NSInteger selectedImageCount = [_selectedImageAssetArray count];
    if (selectedImageCount > 0 && selectedImageCount >= _minimumSelectImageCount) {
        [self.bottomView.doneButton setTitle:[NSString stringWithFormat:@"完成(%ld)",(long)selectedImageCount] forState:UIControlStateNormal];
        [self.bottomView.doneButton setEnabled:YES];
    } else {
        if (selectedImageCount) {
            [self.bottomView.doneButton setTitle:[NSString stringWithFormat:@"完成(%ld)",(long)selectedImageCount] forState:UIControlStateNormal];
        }else{
            [self.bottomView.doneButton setTitle:@"完成" forState:UIControlStateNormal];
        }
        [self.bottomView.doneButton setEnabled:NO];
    }
    [self.bottomView.previewButton setEnabled:selectedImageCount];
}

- (void)requestImageWithIndexPath:(NSIndexPath *)indexPath {
    // 发出请求获取大图，如果图片在 iCloud，则会发出网络请求下载图片。这里同时保存请求 id，供取消请求使用
    WLAsset *imageAsset = [self.imagesAssetArray objectAtIndex:indexPath.item];
    WLImagePickerCollectionViewCell *cell = (WLImagePickerCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    UIImage *previewImage = [imageAsset previewImage];
    if (previewImage) {
        cell.checked = YES;
        [_selectedImageAssetArray addObject:imageAsset];
        // 资源资源已经在本地或下载成功
        [imageAsset updateDownloadStatusWithDownloadResult:YES];
        [self updateImageCountAndCheckLimited];
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

- (void)assetsGroupDidSelected {
    self.showsAssetsGroupSelection = !self.showsAssetsGroupSelection;
    if (self.showsAssetsGroupSelection) {
        [self showAssetsGroupView];
    }else{
        [self hideAssetsGroupView];
    }
}

- (void)showAssetsGroupView {
    [self.view insertSubview:self.overlayView belowSubview:self.assetsGroupsView];
    [self.overlayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuide);
        make.left.right.bottom.equalTo(self.view);
    }];
    [self.view layoutIfNeeded];
    
    [self.groupsViewBottommas uninstall];
    [self.view setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.3f
                     animations:^{
                         [self.view layoutIfNeeded];
                         self.overlayView.alpha = 0.7f;
                         self.titleButton.imageView.transform = CGAffineTransformMakeRotation(M_PI);
                     }completion:^(BOOL finished) {
                         
                     }];
}

- (void)hideAssetsGroupView {
    [self.groupsViewBottommas install];
    [self.view setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.3f
                     animations:^{
                         [self.view layoutIfNeeded];
                         self.overlayView.alpha = 0.0f;
                         self.titleButton.imageView.transform = CGAffineTransformMakeRotation(M_PI * 2);
                     }completion:^(BOOL finished) {
                         [_overlayView removeFromSuperview];
                         _overlayView = nil;
                     }];
}

- (void)handleCheckDoenButtonClick {
    if ([self.delegate respondsToSelector:@selector(photoViewController:didFinishPickingImageWithImagesAssetArray:)]) {
        [self.delegate photoViewController:self didFinishPickingImageWithImagesAssetArray:self.selectedImageAssetArray];
    }
}

- (void)cancelSelfVC {
    if ([self.delegate respondsToSelector:@selector(photoViewControllerDidCancel:)]) {
        [self.delegate photoViewControllerDidCancel:self];
    }
}

- (void)previewSelectedImage {
    
    WLPhotoPreviewController *photoPreviewVC = [[WLPhotoPreviewController alloc] init];
    photoPreviewVC.delegate = self;
    photoPreviewVC.imagesAssetArray = [self.selectedImageAssetArray mutableCopy];
    photoPreviewVC.selectedImageAssetArray = self.selectedImageAssetArray;
    photoPreviewVC.minimumSelectImageCount = self.minimumSelectImageCount;
    photoPreviewVC.maximumSelectImageCount = self.maximumSelectImageCount;
    photoPreviewVC.currentImageIndex = 0;
    [self.navigationController pushViewController:photoPreviewVC animated:YES];
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = WLPhotoImageSpacing;
        layout.minimumInteritemSpacing = WLPhotoImageSpacing;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[WLImagePickerCollectionViewCell class] forCellWithReuseIdentifier:kWLImagePickerCellIdentifier];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
    }
    return _collectionView;
}

- (UIButton *)titleButton{
    if (!_titleButton) {
        _titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _titleButton.frame = CGRectMake(0, 0, 150, 30);
        UIImage  *img = [UIImage imageNamed:@"navigationbar_arrow_down"];
        UIImage  *imgSelect = [UIImage imageNamed:@"navigationbar_arrow_up"];
        [_titleButton setImage:img forState:UIControlStateNormal];
        _titleButton.adjustsImageWhenHighlighted = NO;
        [_titleButton setImage:imgSelect forState:UIControlStateSelected];
        _titleButton.titleLabel.font = [UIFont systemFontOfSize:17];
        [_titleButton setTitleColor:[UIColor wl_hex0F6EF4] forState:UIControlStateNormal];
        [_titleButton addTarget:self action:@selector(assetsGroupDidSelected) forControlEvents:UIControlEventTouchUpInside];
    }
    return _titleButton;
}

- (WLAssetsGroupView *)assetsGroupsView{
    if (!_assetsGroupsView) {
        _assetsGroupsView = [[WLAssetsGroupView alloc] init];
        _assetsGroupsView.delegate = self;
        [self.view addSubview:_assetsGroupsView];
        CGFloat height = [_assetsGroupsView systemLayoutSizeFittingSize:UILayoutFittingExpandedSize].height;
        if (height>(ScreenHeight-180)) {
            height = (ScreenHeight-180);
        }
        [_assetsGroupsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.mas_topLayoutGuide).priorityLow();
            self.groupsViewBottommas = make.bottom.equalTo(self.mas_topLayoutGuideTop).priorityHigh();
            make.height.mas_equalTo(height);
        }];
    }
    return _assetsGroupsView;
}

- (UIControl *)overlayView{
    if (!_overlayView) {
        _overlayView = [[UIControl alloc] init];
        _overlayView.backgroundColor = [UIColor blackColor];
        _overlayView.alpha = 0;
        [_overlayView addTarget:self action:@selector(assetsGroupDidSelected) forControlEvents:UIControlEventTouchUpInside];
    }
    return _overlayView;
}

- (WLPhotoBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[WLPhotoBottomView alloc] init];
        _bottomView.qmui_borderPosition = QMUIBorderViewPositionTop;
        [_bottomView.doneButton addTarget:self action:@selector(handleCheckDoenButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView.previewButton addTarget:self action:@selector(previewSelectedImage) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomView;
}

- (NSMutableArray <WLAsset *>*)imagesAssetArray {
    if (!_imagesAssetArray) {
        _imagesAssetArray = [NSMutableArray array];
    }
    return _imagesAssetArray;
}

- (NSMutableArray<WLAsset *> *)selectedImageAssetArray {
    if (!_selectedImageAssetArray) {
        _selectedImageAssetArray = [NSMutableArray array];
    }
    return _selectedImageAssetArray;
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

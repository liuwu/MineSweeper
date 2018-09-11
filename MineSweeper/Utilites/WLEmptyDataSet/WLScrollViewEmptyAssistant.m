//
//  WLScrollViewEmptyAssistant.m
//  Welian
//
//  Created by zp on 2016/10/12.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import "WLScrollViewEmptyAssistant.h"
#import <objc/runtime.h>

static char const * const kEmptyAssistant = "kEmptyAssistant";

@implementation UIScrollView (WLEmptyAssistant)
- (WLScrollViewEmptyAssistant *)assistant
{
    return objc_getAssociatedObject(self, kEmptyAssistant);
}
- (void)setAssistant:(WLScrollViewEmptyAssistant *)assistant
{
    objc_setAssociatedObject(self, kEmptyAssistant, assistant, OBJC_ASSOCIATION_RETAIN);
}
@end

@implementation WLEmptyAssistantDataSet

- (id)copyWithZone:(NSZone *)zone {
    return [self modelCopy];
}

- (instancetype)init {
    if (self = [super init]) {
        self.emptyCenterOffset = -60.f;
        self.emptySpaceHeight = 20;
        self.allowScroll = NO;
        self.shouldAllowTouch = YES;
    }
    return self;
}

@end

@interface WLScrollViewEmptyAssistant ()<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong)   WLEmptyAssistantConfiger *emptyConfiger;
@property (nonatomic, strong)   WLEmptyAssistantConfiger *normalemptyConfiger;
@property (nonatomic, strong)   WLEmptyAssistantConfiger *loadingConfiger;
@property (nonatomic, strong)   WLEmptyAssistantConfiger *normalLoadingConfiger;
@property (nonatomic, strong)   WLEmptyAssistantConfiger *netWorkConfiger;

@property (nonatomic, copy)     NSString *emptyBtnTitle;
@property (nonatomic, copy)     void(^emptyBtnActionBlock)(void);
@property (nonatomic, copy)     void(^emptyViewActionBlock)(void);

@property (nonatomic, strong) WLEmptyAssistantDataSet *dataSet;

@end

@implementation WLScrollViewEmptyAssistant
{
    __weak UIScrollView *_emptyContentView;
}

///不带按钮
+ (WLScrollViewEmptyAssistant *)emptyWithContentView:(UIScrollView *)contentView
                                        dataSetBlock:(void(^)(WLEmptyAssistantDataSet *dataSet))dataSetBlock
                                       configerBlock:(void (^)(WLEmptyAssistantConfiger *configer))configerBlock
{
    return [self emptyWithContentView:contentView dataSetBlock:dataSetBlock configerBlock:configerBlock emptyBtnTitle:nil emptyBtnActionBlock:nil emptyTapViewActionBlock:nil];
}

+ (WLScrollViewEmptyAssistant *)emptyWithContentView:(UIScrollView *)contentView
                                        configerBlock:(void (^)(WLEmptyAssistantConfiger *configer))configerBlock
                             emptyTapViewActionBlock:(void(^)(void))viewActionBlock
{
    return [self emptyWithContentView:contentView dataSetBlock:nil configerBlock:configerBlock emptyBtnTitle:nil emptyBtnActionBlock:nil emptyTapViewActionBlock:viewActionBlock];
}

+ (WLScrollViewEmptyAssistant *)emptyWithContentView:(UIScrollView *)contentView
                                        configerBlock:(void (^)(WLEmptyAssistantConfiger *configer))configerBlock
                                        emptyBtnTitle:(NSString *)btnTitle
                                 emptyBtnActionBlock:(void(^)(void))btnActionBlock
                             emptyTapViewActionBlock:(void(^)(void))viewActionBlock
{
    return [self emptyWithContentView:contentView dataSetBlock:nil configerBlock:configerBlock emptyBtnTitle:btnTitle emptyBtnActionBlock:btnActionBlock emptyTapViewActionBlock:viewActionBlock];
}

+ (WLScrollViewEmptyAssistant *)emptyWithContentView:(UIScrollView *)contentView
                                        dataSetBlock:(void(^)(WLEmptyAssistantDataSet *dataSet))dataSetBlock
                                       configerBlock:(void (^)(WLEmptyAssistantConfiger *configer))configerBlock
                                       emptyBtnTitle:(NSString *)btnTitle
                                 emptyBtnActionBlock:(void(^)(void))btnActionBlock
                             emptyTapViewActionBlock:(void(^)(void))viewActionBlock
{
    WLEmptyAssistantDataSet *dataSet = [WLEmptyAssistantDataSet new];
    !dataSetBlock ?:dataSetBlock(dataSet);
    WLEmptyAssistantConfiger *configer = [WLEmptyAssistantConfiger new];
    !configerBlock ?: configerBlock(configer);
    WLScrollViewEmptyAssistant *emptyView = [[WLScrollViewEmptyAssistant alloc] initWithContentView:contentView
                                                                                           configer:configer
                                                                                            dataSet:dataSet];
    emptyView.emptyBtnTitle = btnTitle;
    emptyView.emptyBtnActionBlock = btnActionBlock;
    emptyView.emptyViewActionBlock = viewActionBlock;
    return emptyView;
}

- (id)initWithContentView:(UIScrollView *)contentView configer:(WLEmptyAssistantConfiger *)configer dataSet:(WLEmptyAssistantDataSet *)dataSet
{
    self = [super init];
    if (self) {
        _emptyViewType = LoadingType;
        _emptyContentView = contentView;
        _normalemptyConfiger = configer;
        _dataSet = dataSet;
        if (configer.isFirstLoading == YES) {
            [self accordingToLogical];
        }
        
        _emptyContentView.emptyDataSetSource = self;
        _emptyContentView.emptyDataSetDelegate = self;
        
        // check the scrollView's category   查看上面类目方法
        // catch the assistant in this way   持有对象，防止crash
        _emptyContentView.assistant = self;
    }
    return self;
}

#pragma mark - set

- (WLEmptyAssistantConfiger *)emptyConfiger {
    return _emptyConfiger ?: [WLEmptyAssistantConfiger new];
}

- (WLEmptyAssistantConfiger *)normalemptyConfiger {
    return _normalemptyConfiger ?: [WLEmptyAssistantConfiger new];
}

- (WLEmptyAssistantConfiger *)loadingConfiger {
    if (_loadingConfiger == nil) {
        _loadingConfiger = [WLEmptyAssistantConfiger new];
        _loadingConfiger.emptyImage = [UIImage imageNamed:@"loading_imgBlue_78x78"];
    }
    return _loadingConfiger;
}

- (WLEmptyAssistantConfiger *)normalLoadingConfiger {
    if (_normalLoadingConfiger) {
        _normalLoadingConfiger = [WLEmptyAssistantConfiger new];
        _normalLoadingConfiger.emptyImage = [UIImage imageNamed:@"loading_imgBlue_78x78"];
    }
    return _normalLoadingConfiger;
}

-(WLEmptyAssistantConfiger *)netWorkConfiger {
    if (_netWorkConfiger == nil) {
        _netWorkConfiger = [WLEmptyAssistantConfiger new];
        _netWorkConfiger.emptyTitle = @"找不到网络，请检查重试";
        _netWorkConfiger.emptyImage = [UIImage imageNamed:@"empty_nowifi"];
    }
    return _netWorkConfiger;

}

- (NSString *)emptyBtnTitle
{
    return _emptyBtnTitle ?: @"";
}

- (void)setConfigerWithEmptyViewType:(EmptyViewType)type Block:(void (^)(WLEmptyAssistantConfiger *configer))configerBlock {
    WLEmptyAssistantConfiger *configer;
    switch (type) {
        case NormalType:
            configer = self.normalemptyConfiger;
            break;
        case NetWorkAnomaliesType:
            configer = self.netWorkConfiger;
            break;
        case LoadingType:
            configer = self.loadingConfiger;
            break;
        case NormalLoadingType:
            configer = self.normalLoadingConfiger;
            break;
        default:
            break;
    }
    if (configerBlock) {
        configerBlock(configer);
    }
    self.emptyViewType = type;
}

- (void)setEmptyViewType:(EmptyViewType)emptyViewType {
    if (_emptyViewType == emptyViewType) {
        return;
    }
    _emptyViewType = emptyViewType;
    [self accordingToLogical];
    [_emptyContentView reloadEmptyDataSet];
}

//空白页面显示逻辑
- (void)accordingToLogical {
    switch (self.emptyViewType) {
        case NormalType:
            _emptyConfiger = _normalemptyConfiger;
            break;
        case LoadingType:{
            _emptyConfiger = self.loadingConfiger;
        }
            break;
        case NormalLoadingType:{
//            WLEmptyAssistantConfiger *normalLoadingConfiger = [_emptyConfiger copy];
//            normalLoadingConfiger.emptyImage = [UIImage imageNamed:@"loading_imgBlue_78x78"];
            _emptyConfiger = self.normalLoadingConfiger;//normalLoadingConfiger;
        }
            break;
        case NetWorkAnomaliesType:{
            _emptyConfiger = self.netWorkConfiger;
        }
            break;
        default:
            break;
    }
}

#pragma mark - DZNEmptyDataSetSource

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSDictionary *attributes = @{NSFontAttributeName: self.emptyConfiger.emptyTitleFont,
                                 NSForegroundColorAttributeName: self.emptyConfiger.emptyTitleColor};
    
    return [[NSAttributedString alloc] initWithString:self.emptyConfiger.emptyTitle
                                           attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: self.emptyConfiger.emptySubtitleFont,
                                 NSForegroundColorAttributeName: self.emptyConfiger.emptySubtitleColor,
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:self.emptyConfiger.emptySubtitle attributes:attributes];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return self.emptyConfiger.emptyImage;
}

- (UIColor *)imageTintColorForEmptyDataSet:(UIScrollView *)scrollView {
    if (self.emptyViewType == NormalLoadingType || self.emptyViewType == LoadingType) {
         return [UIColor wl_hex0F6EF4];
    }
    return nil;
}

- (CAAnimation *)imageAnimationForEmptyDataSet:(UIScrollView *)scrollView
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    animation.toValue = [NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI_2, 0.0, 0.0, 1.0) ];
    animation.duration = 0.25;
    animation.cumulative = YES;
    animation.removedOnCompletion = NO;
    animation.repeatCount = MAXFLOAT;
    
    return animation;
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    NSDictionary *attributes = @{NSFontAttributeName: self.emptyConfiger.emptyBtntitleFont,
                                 NSForegroundColorAttributeName: (state == UIControlStateNormal) ? self.emptyConfiger.emptyBtntitleColor : [UIColor whiteColor] };
    
    return [[NSAttributedString alloc] initWithString:self.emptyBtnTitle attributes:attributes];
}

- (UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    NSString *imageName = [self.emptyConfiger.emptyBtnImage lowercaseString];
    
    if (state == UIControlStateNormal) imageName = [imageName stringByAppendingString:@"_normal"];
    if (state == UIControlStateHighlighted) imageName = [imageName stringByAppendingString:@"_highlight"];
    
    UIEdgeInsets capInsets = UIEdgeInsetsMake(0, 20.0, 0, 20.0);
    UIEdgeInsets rectInsets = UIEdgeInsetsMake(-20.0, -60.0, -20.0, -60.0);
    
    return [[[UIImage imageNamed:imageName] resizableImageWithCapInsets:capInsets resizingMode:UIImageResizingModeStretch] imageWithAlignmentRectInsets:rectInsets];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIColor clearColor];
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return self.dataSet.allowScroll;
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return self.emptyConfiger.shouldDisplay ? self.emptyConfiger.shouldDisplay() : YES;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return self.dataSet.emptyCenterOffset;
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView
{
    return self.dataSet.emptySpaceHeight;
}

- (NSIndexPath *)placeholderIndexPath:(UIScrollView *)scrollView {
    return self.dataSet.placeholderIndexPath;
}

- (BOOL)emptyDataSetShouldAnimateImageView:(UIScrollView *)scrollView
{
    if (_emptyViewType == LoadingType || _emptyViewType == NormalLoadingType) {
        return YES;
    }
    return NO;
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView {
    return self.dataSet.shouldAllowTouch;
}

#pragma mark - DZNEmptyDataSetDelegate
- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    if (self.emptyConfiger.buttonAllowTouch == YES) {
        self.emptyViewType = NormalLoadingType;
        !self.emptyBtnActionBlock ?: self.emptyBtnActionBlock();
    }
}

-(void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    if (self.emptyConfiger.blankdAllowTouch == YES && (self.emptyViewType != NormalLoadingType && self.emptyViewType != LoadingType)) {
        self.emptyViewType = NormalLoadingType;
        !self.emptyViewActionBlock ?: self.emptyViewActionBlock();
    }
}

- (void)emptyDataSetWillDisappear:(UIScrollView *)scrollView {
    self.emptyViewType = NormalType;
}

@end

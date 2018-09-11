//
//  WLZoomImageView.h
//  Welian
//
//  Created by dong on 2017/4/3.
//  Copyright © 2017年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WLZoomImageView;

@protocol WLZoomImageViewDelegate <NSObject>

@optional
- (void)singleTouchInZoomingImageView:(WLZoomImageView *)zoomImageView location:(CGPoint)location;
- (void)doubleTouchInZoomingImageView:(WLZoomImageView *)zoomImageView location:(CGPoint)location;
- (void)longPressInZoomingImageView:(WLZoomImageView *)zoomImageView;

/// 是否支持缩放，默认为 YES
- (BOOL)enabledZoomViewInZoomImageView:(WLZoomImageView *)zoomImageView;

@end

@interface WLZoomImageView : UIView <UIScrollViewDelegate>

@property(nonatomic, weak) id<WLZoomImageViewDelegate> delegate;

@property(nonatomic, assign) CGFloat maximumZoomScale;

/// 设置当前要显示的图片，会把 livePhoto 相关内容清空，因此注意不要直接通过 imageView.image 来设置图片。
@property(nonatomic, strong) UIImage *image;

/// 用于显示图片的 UIImageView，注意不要通过 imageView.image 来设置图片，请使用 image 属性。
@property(nonatomic, strong, readonly) UIImageView *imageView;

@property (nonatomic, assign) BOOL allowCrop;
@property (nonatomic, assign) CGRect cropRect;

- (void)recoverSubviews;

@end

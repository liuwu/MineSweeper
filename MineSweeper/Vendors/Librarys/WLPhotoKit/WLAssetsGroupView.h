//
//  WLAssetsGroupView.h
//  Welian
//
//  Created by dong on 2017/4/6.
//  Copyright © 2017年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WLAssetsGroupView, WLAssetsGroup;

@interface WLAssetsGroupCell : UITableViewCell

@property (weak, nonatomic) UIImageView *photoView;
@property (weak, nonatomic) UILabel *photoName;
@property (weak, nonatomic) UILabel *photoNumbar;

@end

@protocol WLAssetsGroupViewDelegate <NSObject>

- (void)assetsGroupsView:(WLAssetsGroupView *)assetsGroupView didSelectAssetsGroup:(WLAssetsGroup *)assGroup;

@end

@interface WLAssetsGroupView : UIView
@property (nonatomic, weak) id<WLAssetsGroupViewDelegate> delegate;
// 相册列表 cell 的高度，同时也是相册预览图的宽高
@property(nonatomic, assign) CGFloat albumTableViewCellHeight;

- (void)reloadData;

@end

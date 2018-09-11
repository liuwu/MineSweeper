//
//  WLImagePickerCollectionViewCell.m
//  Welian
//
//  Created by dong on 2017/3/31.
//  Copyright © 2017年 chuansongmen. All rights reserved.
//

#import "WLImagePickerCollectionViewCell.h"

@interface WLImagePickerCollectionViewCell ()

@property(nonatomic, strong, readwrite) UIButton *checkboxButton;

@end

@implementation WLImagePickerCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initImagePickerCollectionViewCellUI];
        self.checkboxImage = [UIImage imageNamed:@"photo_check_default"];
        self.checkboxCheckedImage = [UIImage imageNamed:@"photo_check_selected"];
    }
    return self;
}

- (void)initImagePickerCollectionViewCellUI {
    _contentImageView = [[UIImageView alloc] init];
    _contentImageView.contentMode = UIViewContentModeScaleAspectFill;
    _contentImageView.clipsToBounds = YES;
    [self.contentView addSubview:_contentImageView];
    
    _checkboxButton = [[UIButton alloc] init];
    _checkboxButton.exclusiveTouch = YES;
    _checkboxButton.hidden = YES;
    [self.contentView addSubview:self.checkboxButton];
    [_checkboxButton addTarget:self action:@selector(chooseButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];

    
    [_contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [self.checkboxButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(self.contentView);
        make.width.height.mas_equalTo(self.contentView.mas_width).multipliedBy(0.5);
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat offset = ((self.checkboxButton.width - self.checkboxImage.size.width)/2) + 5.f;
    [self.checkboxButton setImageEdgeInsets:UIEdgeInsetsMake(0, offset, offset, 0)];
}

- (void)setCheckboxImage:(UIImage *)checkboxImage {
    if (![self.checkboxImage isEqual:checkboxImage]) {
        [self.checkboxButton setImage:checkboxImage forState:UIControlStateNormal];
    }
    _checkboxImage = checkboxImage;
}

- (void)setCheckboxCheckedImage:(UIImage *)checkboxCheckedImage {
    if (![self.checkboxCheckedImage isEqual:checkboxCheckedImage]) {
        [self.checkboxButton setImage:checkboxCheckedImage forState:UIControlStateSelected];
        [self.checkboxButton setImage:checkboxCheckedImage forState:UIControlStateSelected|UIControlStateHighlighted];
    }
    _checkboxCheckedImage = checkboxCheckedImage;
}

/** 选择按钮被点击 */
- (void)chooseButtonDidTap:(id)sender {
    if (self.chooseImageDidSelectBlock) {
        self.chooseImageDidSelectBlock(self);
    }
}

- (void)setChecked:(BOOL)checked {
    _checked = checked;
    if (_editing) {
        self.checkboxButton.selected = checked;
    }
}

- (void)setEditing:(BOOL)editing {
    _editing = editing;
    if (self.downloadStatus == WLAssetDownloadStatusSucceed) {
        self.checkboxButton.hidden = !_editing;
    }
}


@end

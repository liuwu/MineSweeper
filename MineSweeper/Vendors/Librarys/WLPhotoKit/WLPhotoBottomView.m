//
//  WLPhotoBottomView.m
//  Welian
//
//  Created by dong on 2017/4/7.
//  Copyright © 2017年 chuansongmen. All rights reserved.
//

#import "WLPhotoBottomView.h"
#import "WLPhotoConst.h"

@implementation WLPhotoBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [doneButton setTitle:@"完成" forState:UIControlStateNormal];
        [doneButton setTitleColor:[UIColor wl_hex0F6EF4] forState:UIControlStateNormal];
        [doneButton setTitleColor:[UIColor wl_HexADADAD] forState:UIControlStateDisabled];
        doneButton.titleLabel.font = WLFONT(16);
        [self addSubview:doneButton];
        self.doneButton = doneButton;
        [doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.height.mas_equalTo(WLPhotoBottomViewHeigh);
            make.right.equalTo(self).offset(-20.f);
        }];
        
        self.previewButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.previewButton setTitle:@"预览" forState:UIControlStateNormal];
        [self.previewButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.previewButton setTitleColor:[UIColor wl_HexADADAD] forState:UIControlStateDisabled];
        self.previewButton.titleLabel.font = WLFONT(16);
        [self addSubview:self.previewButton];
        [self.previewButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.height.equalTo(self.doneButton);
            make.left.equalTo(self).offset(20.f);
        }];
    }
    return self;
}

@end

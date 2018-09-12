//
//  WLTextField.m
//  weLian
//
//  Created by dong on 14/10/29.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "WLTextField.h"

@implementation WLTextField

- (instancetype)init {
    self = [self initWithFrame:CGRectZero];
    if (self) {   
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.backgroundColor = [UIColor whiteColor];
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        self.spellCheckingType = UITextSpellCheckingTypeNo;
    }
    return self;
}


- (void)setIsToBounds:(BOOL)isToBounds
{
    _isToBounds = isToBounds;
    if (isToBounds) {
        [self.layer setMasksToBounds:YES];
        [self.layer setCornerRadius:5];
    }
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    
    return CGRectInset( bounds , 10, 0 );
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectInset( bounds , 10, 0 );
}

@end

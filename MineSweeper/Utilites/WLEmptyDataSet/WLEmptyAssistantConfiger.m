//
//  WLEmptyAssistantConfiger.m
//  Welian
//
//  Created by zp on 2016/10/12.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import "WLEmptyAssistantConfiger.h"

@implementation WLEmptyAssistantConfiger
#pragma mark - YYModel
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self modelEncodeWithCoder:aCoder];
}

- (id)initWithCoder:(NSCoder *)aDecoder { self = [super init]; return [self modelInitWithCoder:aDecoder]; }
- (id)copyWithZone:(NSZone *)zone {
    return [self modelCopy];
}

- (instancetype)init
{
    if (self = [super init]) {
        self.buttonAllowTouch = YES;
        self.blankdAllowTouch = YES;
        self.isFirstLoading = YES;
    }
    return self;
}

- (NSString *)emptyTitle
{
    return _emptyTitle ?: @"";
}

- (NSString *)emptySubtitle
{
    return _emptySubtitle ?: @"";
}

- (UIFont *)emptyTitleFont
{
    return _emptyTitleFont ?: [UIFont systemFontOfSize:14.0f];
}

- (UIFont *)emptySubtitleFont
{
    return _emptySubtitleFont ?: [UIFont systemFontOfSize:14.0f];
}

- (UIFont *)emptyBtntitleFont
{
    return _emptyBtntitleFont ?: [UIFont systemFontOfSize:15.0f];
}

- (UIColor *)emptyTitleColor
{
    return _emptyTitleColor ?: [UIColor wl_Hex999999];
}

- (UIColor *)emptySubtitleColor
{
    return _emptySubtitleColor ?: [UIColor wl_Hex999999];
}

- (UIColor *)emptyBtntitleColor
{
    return _emptyBtntitleColor ?: [UIColor wl_hex0F6EF4];
}

- (NSString *)emptyBtnImage
{
    return _emptyBtnImage ?: @"empty_button";
}

@end

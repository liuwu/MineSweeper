//
//  CALayer+WLBorderConfig.h
//  Welian
//
//  Created by liuwu on 2016/11/21.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (WLBorderConfig)

@property(nonatomic, assign) UIColor* borderColorFromUIColor;
@property(nonatomic, assign) UIColor* shadowColorFromUIColor;

@property(nonatomic, assign) NSString* borderWidths;

@property (nonatomic, assign) UIEdgeInsets borderEdgeInsets;

- (void)wl_setRoundCornerRadius:(CGFloat)radius
                        corners:(UIRectCorner)corners
                    borderWidth:(CGFloat)borderWidth
                    borderColor:(UIColor *)borderColor
                 borderLineJoin:(CGLineJoin)borderLineJoin;

@end

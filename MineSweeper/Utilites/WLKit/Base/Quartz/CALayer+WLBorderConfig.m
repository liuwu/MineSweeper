//
//  CALayer+WLBorderConfig.m
//  Welian
//
//  Created by liuwu on 2016/11/21.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import "CALayer+WLBorderConfig.h"

@implementation CALayer (WLBorderConfig)
@dynamic borderEdgeInsets;

- (UIColor*)borderColorFromUIColor {
    return [UIColor colorWithCGColor:self.borderColor];
}

- (UIColor*)shadowColorFromUIColor {
    return [UIColor colorWithCGColor:self.shadowColor];
}

- (NSString*)borderWidths {
    return self.borderWidths;
}

- (void)setBorderColorFromUIColor:(UIColor*)color {
    self.borderColor = color.CGColor;
}

- (void)setShadowColorFromUIColor:(UIColor*)color {
    self.shadowColor = color.CGColor;
}

- (void)setBorderWidths:(NSString*)borderWidths {
    NSString *widthsStr = [[borderWidths stringByReplacingOccurrencesOfString:@"{" withString:@""]
                           stringByReplacingOccurrencesOfString:@"}" withString:@""];
    //widths:[top,right,bottom,left]
    NSArray *widths = [widthsStr componentsSeparatedByString:@","];
    float topWidth = [[widths objectAtIndex:0] floatValue];
    float rightWidth = [[widths objectAtIndex:1] floatValue];
    float bottomWidth = [[widths objectAtIndex:2] floatValue];
    float leftWidth = [[widths objectAtIndex:3] floatValue];
    [self setBorderEdgeInsets:UIEdgeInsetsMake(topWidth, leftWidth, bottomWidth, rightWidth)];
    
    /*
     if (topWidth!=0) {
     CALayer *border = [CALayer layer];
     border.backgroundColor = self.borderColor;
     border.frame = CGRectMake(0, 0, self.frame.size.width, topWidth);
     [self addSublayer:border];
     }
     if (rightWidth!=0) {
     CALayer *border = [CALayer layer];
     border.backgroundColor = self.borderColor;
     border.frame = CGRectMake(self.frame.size.width - rightWidth, 0, rightWidth, self.frame.size.height);
     [self addSublayer:border];
     }
     if (bottomWidth!=0) {
     CALayer *border = [CALayer layer];
     border.backgroundColor = self.borderColor;
     border.frame = CGRectMake(0, self.frame.size.height - bottomWidth, self.frame.size.width, bottomWidth);
     [self addSublayer:border];
     }
     if (leftWidth!=0) {
     CALayer *border = [CALayer layer];
     border.backgroundColor = self.borderColor;
     border.frame = CGRectMake(0, 0, leftWidth, self.frame.size.height);;
     [self addSublayer:border];
     }
     */
    
}

- (void)setBorderEdgeInsets:(UIEdgeInsets)borderEdgeInsets {
    float topWidth = borderEdgeInsets.top;
    float rightWidth = borderEdgeInsets.right;
    float bottomWidth = borderEdgeInsets.bottom;
    float leftWidth = borderEdgeInsets.left;
    
    if (topWidth!=0) {
        CALayer *border = [CALayer layer];
        border.backgroundColor = self.borderColor;
        border.frame = CGRectMake(0, 0, self.frame.size.width, topWidth);
        [self addSublayer:border];
    }
    if (rightWidth!=0) {
        CALayer *border = [CALayer layer];
        border.backgroundColor = self.borderColor;
        border.frame = CGRectMake(self.frame.size.width - rightWidth, 0, rightWidth, self.frame.size.height);
        [self addSublayer:border];
    }
    if (bottomWidth!=0) {
        CALayer *border = [CALayer layer];
        border.backgroundColor = self.borderColor;
        border.frame = CGRectMake(0, self.frame.size.height - bottomWidth, self.frame.size.width, bottomWidth);
        [self addSublayer:border];
    }
    if (leftWidth!=0) {
        CALayer *border = [CALayer layer];
        border.backgroundColor = self.borderColor;
        border.frame = CGRectMake(0, 0, leftWidth, self.frame.size.height);;
        [self addSublayer:border];
    }
    self.masksToBounds = YES;
}

- (void)wl_setRoundCornerRadius:(CGFloat)radius
                        corners:(UIRectCorner)corners
                    borderWidth:(CGFloat)borderWidth
                    borderColor:(UIColor *)borderColor
                 borderLineJoin:(CGLineJoin)borderLineJoin {
    
    if (corners != UIRectCornerAllCorners) {
        UIRectCorner tmp = 0;
        if (corners & UIRectCornerTopLeft) tmp |= UIRectCornerBottomLeft;
        if (corners & UIRectCornerTopRight) tmp |= UIRectCornerBottomRight;
        if (corners & UIRectCornerBottomLeft) tmp |= UIRectCornerTopLeft;
        if (corners & UIRectCornerBottomRight) tmp |= UIRectCornerTopRight;
        corners = tmp;
    }
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(self.bounds, borderWidth, borderWidth) byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
    path.lineWidth = borderWidth;
    path.lineJoinStyle = borderLineJoin;
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.strokeColor = borderColor.CGColor;
    maskLayer.path = path.CGPath;
    self.mask = maskLayer;
}

@end

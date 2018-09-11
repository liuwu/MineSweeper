//
//  WLActivityView.h
//  Welian
//
//  Created by dong on 15/3/4.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>

#define WINDOW_COLOR                            [UIColor colorWithRed:0 green:0 blue:0 alpha:0.35]
#define ANIMATE_DURATION                        0.25f

@interface WLActivityView : UIView

#pragma mark - Public method
- (id)initWithOneSectionArray:(NSArray *)oneArray andTwoArray:(NSArray *)twoArray;
- (id)initWithTitle:(NSAttributedString *)title oneSectionArray:(NSArray *)oneArray andTwoArray:(NSArray *)twoArray;

- (void)show;

- (void)tappedCancel;
@end

//
//  WLEmptyAssistantConfiger.h
//  Welian
//
//  Created by zp on 2016/10/12.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef BOOL(^ShouldDisplay)(void);

@interface WLEmptyAssistantConfiger : NSObject<NSCopying>

@property (nonatomic, strong)   UIImage *emptyImage;

// default @""
@property (nonatomic, copy)     NSString *emptyTitle;
// default systemFontOfSize:17.0f
@property (nonatomic, strong)   UIFont *emptyTitleFont;
// default darkGrayColor
@property (nonatomic, strong)   UIColor *emptyTitleColor;

// default @""
@property (nonatomic, copy)     NSString *emptySubtitle;
// default systemFontOfSize:15.0f
@property (nonatomic, strong)   UIFont *emptySubtitleFont;
// default lightGrayColor
@property (nonatomic, strong)   UIColor *emptySubtitleColor;


// default systemFontOfSize:17.0f
@property (nonatomic, strong)   UIFont *emptyBtntitleFont;
// default whiteColor
@property (nonatomic, strong)   UIColor *emptyBtntitleColor;
// default 
@property (nonatomic, strong)   NSString *emptyBtnImage;

// default YES
//按钮是否可以点击
@property (nonatomic, assign)   BOOL buttonAllowTouch;

// default YES
//空白页是否可以点击
@property (nonatomic, assign)   BOOL blankdAllowTouch;

// default YES
//是否第一次加载动画
@property (nonatomic, assign)   BOOL isFirstLoading;

// default NO
//数据源为空时是否渲染和显示
@property (nonatomic)   ShouldDisplay shouldDisplay;

@end

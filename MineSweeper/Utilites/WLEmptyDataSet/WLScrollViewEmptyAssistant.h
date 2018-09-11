//
//  WLScrollViewEmptyAssistant.h
//  Welian
//
//  Created by zp on 2016/10/12.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//  缺省页控件

#import <Foundation/Foundation.h>
#import "WLEmptyAssistantConfiger.h"
#import "UIScrollView+EmptyDataSet.h"

typedef NS_ENUM(NSUInteger, EmptyViewType) {
    NormalType,            //正常空白页
    NetWorkAnomaliesType,  //网络异常
    LoadingType,           //不带文案加载中
    NormalLoadingType,      //带文案加载中
    ParameterErrorType,    // 参数错误
};

@interface WLEmptyAssistantDataSet : NSObject<NSCopying>

@property (nonatomic, strong)   NSIndexPath *placeholderIndexPath;
//空白页整体位置默认是偏上
@property (nonatomic , assign)   CGFloat emptyCenterOffset;

//空白页的图片、按钮、文案之间的间距大小
@property (nonatomic, assign)   CGFloat emptySpaceHeight;

// default YES
//添加空白页后ScrollView是否可以继续拖拽
@property (nonatomic, assign)   BOOL allowScroll;

// default YES
//是否允许点击
@property (nonatomic, assign)   BOOL shouldAllowTouch;

// default NO
//数据源为空时是否渲染和显示
//@property (nonatomic)   ShouldDisplay shouldDisplay;

@end


@interface WLScrollViewEmptyAssistant : NSObject

///状态
@property (nonatomic, assign) EmptyViewType emptyViewType;

/// 自定义位置
+ (WLScrollViewEmptyAssistant *)emptyWithContentView:(UIScrollView *)contentView
                                        dataSetBlock:(void(^)(WLEmptyAssistantDataSet *dataSet))dataSetBlock
                                       configerBlock:(void (^)(WLEmptyAssistantConfiger *configer))configerBlock;

///不带按钮
+ (WLScrollViewEmptyAssistant *)emptyWithContentView:(UIScrollView *)contentView
                                        configerBlock:(void (^)(WLEmptyAssistantConfiger *configer))configerBlock
                             emptyTapViewActionBlock:(void(^)(void))viewActionBlock;

///带按钮
+ (WLScrollViewEmptyAssistant *)emptyWithContentView:(UIScrollView *)contentView
                                        configerBlock:(void (^)(WLEmptyAssistantConfiger *configer))configerBlock
                                        emptyBtnTitle:(NSString *)btnTitle
                                 emptyBtnActionBlock:(void(^)(void))btnActionBlock
                             emptyTapViewActionBlock:(void(^)(void))viewActionBlock;
/// 全部状态
+ (WLScrollViewEmptyAssistant *)emptyWithContentView:(UIScrollView *)contentView
                                        dataSetBlock:(void(^)(WLEmptyAssistantDataSet *dataSet))dataSetBlock
                                       configerBlock:(void (^)(WLEmptyAssistantConfiger *configer))configerBlock
                                       emptyBtnTitle:(NSString *)btnTitle
                                 emptyBtnActionBlock:(void(^)(void))btnActionBlock
                             emptyTapViewActionBlock:(void(^)(void))viewActionBlock;

- (void)setConfigerWithEmptyViewType:(EmptyViewType)type Block:(void (^)(WLEmptyAssistantConfiger *configer))configerBlock;

@end

@interface UIScrollView (WLEmptyAssistant)

@property (nonatomic, strong) WLScrollViewEmptyAssistant *assistant;

@end

//
//  UITextField+WLAdd.h
//  Welian_Normal_Demo
//
//  Created by weLian on 16/6/8.
//  Copyright © 2016年 杭州传送门网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 NS_ASSUME_NONNULL_BEGIN  NS_ASSUME_NONNULL_END
 在这两个宏之间的代码，所有简单指针对象都被假定为nonnull，因此我们只需要去指定那些nullable的指针。
 */
NS_ASSUME_NONNULL_BEGIN

/*
 UITextField的扩展类
 */
@interface UITextField (WLAdd)

// 是否禁用复制粘贴等功能
@property (nonatomic, assign) BOOL wl_isDisableOperate;

/**
 当前选中的字符串范围
 */
- (NSRange)wl_selectedRange;

/**
 设置选中所有的文字
 */
- (void)wl_selectAllText;

/**
 设置选定范围内的文本
 
 @param range  文档中选定文本的范围.
 */
- (void)wl_setSelectedRange:(NSRange)range;

@end

NS_ASSUME_NONNULL_END



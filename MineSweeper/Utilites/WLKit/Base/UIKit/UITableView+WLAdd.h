//
//  UITableView+WLAdd.h
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
 UITableView的扩展类
 */
@interface UITableView (WLAdd)

/**
 接收执行一系列的插入、删除或选择rows和secions的方法。
 
 @讨论 table执行一系列调用插入、删除或选择rows和sections的方法.
 如果你想在后续调用插入，删除，和选择操作(例如：cellForRowAtIndexPath: 和 indexPathsForVisibleRows)的方法同时执行动画。
 
 @讨论 如果不进行插入、删除和选择调用在这个block中，table的属性比如行数可能成为无效.
 你不能调用reloadData在block内; 如果你在group内调用这个方法，你将需要执行一些你自己的动画.
 
 @param block  一系列方法调用的block.
 */
- (void)wl_updateWithBlock:(void (^)(UITableView *tableView))block;

/**
 滚动到指定的row或section在屏幕中的位置
 */
- (void)wl_scrollToRow:(NSUInteger)row
             inSection:(NSUInteger)section
      atScrollPosition:(UITableViewScrollPosition)scrollPosition
              animated:(BOOL)animated;

/**
 在指定的位置插入一行
 */
- (void)wl_insertRow:(NSUInteger)row
           inSection:(NSUInteger)section
    withRowAnimation:(UITableViewRowAnimation)animation;

/**
 重新加载指定的行数
 */
- (void)wl_reloadRow:(NSUInteger)row
           inSection:(NSUInteger)section
    withRowAnimation:(UITableViewRowAnimation)animation;

/**
 删除指定的行
 */
- (void)wl_deleteRow:(NSUInteger)row
           inSection:(NSUInteger)section
    withRowAnimation:(UITableViewRowAnimation)animation;

/**
 在指定的indexpath插入一行
 */
- (void)wl_insertRowAtIndexPath:(NSIndexPath *)indexPath
               withRowAnimation:(UITableViewRowAnimation)animation;

/**
 重新加载指定indexpath的行
 */
- (void)wl_reloadRowAtIndexPath:(NSIndexPath *)indexPath
               withRowAnimation:(UITableViewRowAnimation)animation;

/**
 删除选择中的行数
 */
- (void)wl_deleteRowAtIndexPath:(NSIndexPath *)indexPath
               withRowAnimation:(UITableViewRowAnimation)animation;

/**
 插入一个指定的section
 */
- (void)wl_insertSection:(NSUInteger)section
        withRowAnimation:(UITableViewRowAnimation)animation;

/**
 删除指定的section
 */
- (void)wl_deleteSection:(NSUInteger)section
        withRowAnimation:(UITableViewRowAnimation)animation;

/**
 重新加载指定的section使用给定的动画效果
 */
- (void)wl_reloadSection:(NSUInteger)section
        withRowAnimation:(UITableViewRowAnimation)animation;

/**
 取消选中TableView的所有行
 */
- (void)wl_clearSelectedRowsAnimated:(BOOL)animated;

///reload可见的cell
- (void)wl_ReloadVisibleCellsWithRowAnimation:(UITableViewRowAnimation)animation;

@end

NS_ASSUME_NONNULL_END



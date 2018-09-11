//
//  UITableView+WLAdd.m
//  Welian_Normal_Demo
//
//  Created by weLian on 16/6/8.
//  Copyright © 2016年 杭州传送门网络科技有限公司. All rights reserved.
//

#import "UITableView+WLAdd.h"
#import "WLCGUtilities.h"

WLSYNTH_DUMMY_CLASS(UITableView_WLAdd)

@implementation UITableView (WLAdd)

- (void)wl_updateWithBlock:(void (^)(UITableView *tableView))block {
    [self updateWithBlock:block];
}

/**
 滚动到指定的row或section在屏幕中的位置
 */
- (void)wl_scrollToRow:(NSUInteger)row
             inSection:(NSUInteger)section
      atScrollPosition:(UITableViewScrollPosition)scrollPosition
              animated:(BOOL)animated {
    [self scrollToRow:row inSection:section atScrollPosition:scrollPosition animated:animated];
}

/**
 在指定的位置插入一行
 */
- (void)wl_insertRow:(NSUInteger)row
           inSection:(NSUInteger)section
    withRowAnimation:(UITableViewRowAnimation)animation {
    [self insertRow:row inSection:section withRowAnimation:animation];
}

/**
 重新加载指定的行数
 */
- (void)wl_reloadRow:(NSUInteger)row
           inSection:(NSUInteger)section
    withRowAnimation:(UITableViewRowAnimation)animation {
    [self reloadRow:row inSection:section withRowAnimation:animation];
}

/**
 删除指定的行
 */
- (void)wl_deleteRow:(NSUInteger)row
           inSection:(NSUInteger)section
    withRowAnimation:(UITableViewRowAnimation)animation {
    [self deleteRow:row inSection:section withRowAnimation:animation];
}

/**
 在指定的indexpath插入一行
 */
- (void)wl_insertRowAtIndexPath:(NSIndexPath *)indexPath
               withRowAnimation:(UITableViewRowAnimation)animation {
    [self insertRowAtIndexPath:indexPath withRowAnimation:animation];
}

/**
 重新加载指定indexpath的行
 */
- (void)wl_reloadRowAtIndexPath:(NSIndexPath *)indexPath
               withRowAnimation:(UITableViewRowAnimation)animation {
    [self reloadRowAtIndexPath:indexPath withRowAnimation:animation];
}

/**
 删除选择中的行数
 */
- (void)wl_deleteRowAtIndexPath:(NSIndexPath *)indexPath
               withRowAnimation:(UITableViewRowAnimation)animation {
    [self deleteRowAtIndexPath:indexPath withRowAnimation:animation];
}

/**
 插入一个指定的section
 */
- (void)wl_insertSection:(NSUInteger)section
        withRowAnimation:(UITableViewRowAnimation)animation {
    [self insertSection:section withRowAnimation:animation];
}

/**
 删除指定的section
 */
- (void)wl_deleteSection:(NSUInteger)section
        withRowAnimation:(UITableViewRowAnimation)animation {
    [self deleteSection:section withRowAnimation:animation];
}

/**
 重新加载指定的section使用给定的动画效果
 */
- (void)wl_reloadSection:(NSUInteger)section
        withRowAnimation:(UITableViewRowAnimation)animation {
    [self reloadSection:section withRowAnimation:animation];
}

/**
 取消选中TableView的所有行
 */
- (void)wl_clearSelectedRowsAnimated:(BOOL)animated {
    [self clearSelectedRowsAnimated:animated];
}

///reload可见的cell
- (void)wl_ReloadVisibleCellsWithRowAnimation:(UITableViewRowAnimation)animation {
    [self reloadRowsAtIndexPaths:self.indexPathsForVisibleRows withRowAnimation:animation];
}

@end

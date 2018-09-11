//
//  NSIndexPath+WLAdd.m
//  Welian
//
//  Created by weLian on 16/5/18.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import "NSIndexPath+WLAdd.h"
#import "WLCGUtilities.h"

WLSYNTH_DUMMY_CLASS(NSIndexPath_WLAdd)

@implementation NSIndexPath (WLAdd)

/**
 *  @author liuwu     , 16-05-18
 *
 *  计算前一行indexpath
 *  @return indexPath
 *  @since V2.7.9
 */
- (NSIndexPath *)wl_previousRow {
    return [NSIndexPath indexPathForRow:self.row - 1
                              inSection:self.section];
}

/**
 *  @author liuwu     , 16-05-18
 *
 *  计算下一行的indexPath
 *  @return indexPath
 *  @since V2.7.9
 */
- (NSIndexPath *)wl_nextRow {
    return [NSIndexPath indexPathForRow:self.row + 1
                              inSection:self.section];
}

/**
 *  @author liuwu     , 16-05-18
 *
 *  计算上一个item的indexpath
 *  @return indexapth
 *  @since V2.7.9
 */
- (NSIndexPath *)wl_previousItem {
    return [NSIndexPath indexPathForItem:self.item - 1
                               inSection:self.section];
}

/**
 *  @author liuwu     , 16-05-18
 *
 *  计算下一个item的indexpath
 *  @return indexpath
 *  @since V2.7.9
 */
- (NSIndexPath *)wl_nextItem {
    return [NSIndexPath indexPathForItem:self.item + 1
                               inSection:self.section];
}

/**
 *  @author liuwu     , 16-05-18
 *
 *  计算下一个section的indexpath
 *  @return indexpath
 *  @since V2.7.9
 */
- (NSIndexPath *)wl_nextSection {
    return [NSIndexPath indexPathForRow:self.row
                              inSection:self.section + 1];
}

/**
 *  @author liuwu     , 16-05-18
 *
 *  计算上一个section的indexpath
 *  @return indexPath
 *  @since V2.7.9
 */
- (NSIndexPath *)wl_previousSection {
    return [NSIndexPath indexPathForRow:self.row
                              inSection:self.section - 1];
}

@end

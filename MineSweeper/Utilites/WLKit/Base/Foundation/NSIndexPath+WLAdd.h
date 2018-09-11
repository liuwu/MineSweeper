//
//  NSIndexPath+WLAdd.h
//  Welian
//
//  Created by weLian on 16/5/18.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 NS_ASSUME_NONNULL_BEGIN  NS_ASSUME_NONNULL_END
 在这两个宏之间的代码，所有简单指针对象都被假定为nonnull，因此我们只需要去指定那些nullable的指针。
 */
NS_ASSUME_NONNULL_BEGIN


@interface NSIndexPath (WLAdd)

/**
*  @author liuwu     , 16-05-18
*
*  计算前一行indexpath
*  @return indexPath
*  @since V2.7.9
*/
- (NSIndexPath *)wl_previousRow;

/**
 *  @author liuwu     , 16-05-18
 *
 *  计算下一行的indexPath
 *  @return indexPath
 *  @since V2.7.9
 */
- (NSIndexPath *)wl_nextRow;

/**
 *  @author liuwu     , 16-05-18
 *
 *  计算上一个item的indexpath
 *  @return indexapth
 *  @since V2.7.9
 */
- (NSIndexPath *)wl_previousItem;

/**
 *  @author liuwu     , 16-05-18
 *
 *  计算下一个item的indexpath
 *  @return indexpath
 *  @since V2.7.9
 */
- (NSIndexPath *)wl_nextItem;

/**
 *  @author liuwu     , 16-05-18
 *
 *  计算下一个section的indexpath
 *  @return indexpath
 *  @since V2.7.9
 */
- (NSIndexPath *)wl_nextSection;

/**
 *  @author liuwu     , 16-05-18
 *
 *  计算上一个section的indexpath
 *  @return indexPath
 *  @since V2.7.9
 */
- (NSIndexPath *)wl_previousSection;

@end

NS_ASSUME_NONNULL_END

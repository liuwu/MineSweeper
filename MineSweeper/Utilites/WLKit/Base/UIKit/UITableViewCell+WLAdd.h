//
//  UITableViewCell+WLAdd.h
//  Welian
//
//  Created by liuwu on 2016/11/21.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (WLAdd)

/**
 *  创建nib的cell
 */
+ (UITableViewCell *)cellWithTableViewNib:(UITableView *)tableView;

+ (UITableViewCell *)tableViewCellForSourceView:(UIView *)sourceView;

@end

//
//  UITableViewCell+WLAdd.m
//  Welian
//
//  Created by liuwu on 2016/11/21.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import "UITableViewCell+WLAdd.h"

@implementation UITableViewCell (WLAdd)

+ (UITableViewCell *)cellWithTableViewNib:(UITableView *)tableView {
    NSString *identifer = NSStringFromClass([self class]);
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell == nil)
    {
        cell=[[[NSBundle mainBundle]loadNibNamed:identifer owner:self options:nil]lastObject];
    }
    
    return cell;
}

+ (UITableViewCell *)tableViewCellForSourceView:(UIView *)sourceView {
    
    for (UIView *next = [sourceView superview] ; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UITableViewCell class]]) {
            return (UITableViewCell*)nextResponder;
        }
    }
    return nil;
}

@end

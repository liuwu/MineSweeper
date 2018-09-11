//
//  WLShareSheetCell.h
//  
//
//  Created by ZZY on 16/3/28.
//
//

#import <UIKit/UIKit.h>
#import "WLActivity.h"

#define ZY_CancelButtonHeight       50.f    // 取消按钮的高度

#define ZY_ItemCellHeight           130.f   // 每个item的高度
#define ZY_ItemCellWidth            88.f    // 每个item的宽度
#define ZY_ItemCellPadding          28.f    // item之间的距离
#define WL_ItemCellTitleHeight      35.f

@interface WLShareItemCell : UICollectionViewCell

@property (nonatomic, strong) UIButton *iconView;
@property (nonatomic, strong) UITextView *titleView;
@property (nonatomic, strong) UILabel *bageView;
@property (nonatomic, strong) WLActivity *item;


@end

@interface WLShareSheetCell : UITableViewCell

@property (nonatomic, strong) NSArray *itemArray;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

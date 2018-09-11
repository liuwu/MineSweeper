//
//  REInlinePickerItem.h
//  RETableViewManagerExample
//
//  Created by Roman Efimov on 10/5/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "RETableViewItem.h"

@class REPickerItem;

@interface REInlinePickerItem : RETableViewItem

@property (weak, nonatomic) REPickerItem *pickerItem;

+ (instancetype)itemWithPickerItem:(REPickerItem *)pickerItem;
- (instancetype)initWithPickerItem:(REPickerItem *)pickerItem;

@end

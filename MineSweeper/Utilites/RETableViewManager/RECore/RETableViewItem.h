//
// RETableViewItem.h
// RETableViewManager
//
// Copyright (c) 2013 Roman Efimov (https://github.com/romaonthego)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import <Foundation/Foundation.h>
#import "REValidation.h"
#import "RETableViewCellStyle.h"

@class RETableViewSection;

@interface RETableViewItem : NSObject

// 自定义logo
@property (strong, nonatomic) UIImage *logoImage;

@property (copy, nonatomic) NSString *title;
// 标题颜色和字体
@property (copy, nonatomic) UIColor *titleLabelTextColor;
@property (copy, nonatomic) UIFont *titleLabelTextFont;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) UIImage *highlightedImage;
@property (assign, nonatomic) NSTextAlignment textAlignment;

@property (weak, nonatomic) RETableViewSection *section;

@property (copy, nonatomic) NSString *detailLabelText;
// 副标题颜色和字体
@property (copy, nonatomic) UIColor *titleDetailTextColor;
@property (copy, nonatomic) UIFont *titleDetailTextFont;
@property (assign, nonatomic) BOOL showTitleDetailTextNumberOfLine;
// 是否使用label中加亮字体，如果是YES，一下字段有效
@property (assign, nonatomic) BOOL detailLabelHintColor;
@property (copy, nonatomic) NSString *detailLabelHintText;
@property (copy, nonatomic) UIColor *titleDetailHintColor;
@property (copy, nonatomic) UIFont *titleDetailHintFont;

@property (assign, nonatomic) UITableViewCellStyle style;
@property (assign, nonatomic) UITableViewCellSelectionStyle selectionStyle;
@property (assign, nonatomic) UITableViewCellAccessoryType accessoryType;
@property (assign, nonatomic) UITableViewCellEditingStyle editingStyle;
@property (strong, nonatomic) UIView *accessoryView;
@property (assign, nonatomic) BOOL enabled;

@property (copy, nonatomic) void (^selectionHandler)(id item);
@property (copy, nonatomic) void (^accessoryButtonTapHandler)(id item);
@property (copy, nonatomic) void (^insertionHandler)(id item);
@property (copy, nonatomic) void (^deletionHandler)(id item);
@property (copy, nonatomic) void (^deletionHandlerWithCompletion)(id item, void (^)(void));
@property (copy, nonatomic) BOOL (^moveHandler)(id item, NSIndexPath *sourceIndexPath, NSIndexPath *destinationIndexPath);
@property (copy, nonatomic) void (^moveCompletionHandler)(id item, NSIndexPath *sourceIndexPath, NSIndexPath *destinationIndexPath);
@property (copy, nonatomic) void (^cutHandler)(id item);
@property (copy, nonatomic) void (^copyHandler)(id item);
@property (copy, nonatomic) void (^pasteHandler)(id item);

@property (assign, nonatomic) CGFloat cellHeight;
@property (copy, nonatomic) NSString *cellIdentifier;

// Action bar
@property (copy, nonatomic) void (^actionBarNavButtonTapHandler)(id item); //handler for nav button on ActionBar
@property (copy, nonatomic) void (^actionBarDoneButtonTapHandler)(id item); //handler for done button on ActionBar


// Error validation
//
@property (copy, nonatomic) NSString *name;
@property (strong, nonatomic) NSArray *validators;
@property (strong, readonly, nonatomic) NSArray *errors;

+ (instancetype)item;
+ (instancetype)itemWithTitle:(NSString *)title;
+ (instancetype)itemWithTitle:(NSString *)title
                accessoryType:(UITableViewCellAccessoryType)accessoryType
             selectionHandler:(void(^)(RETableViewItem *item))selectionHandler;
+ (instancetype)itemWithTitle:(NSString *)title
                accessoryType:(UITableViewCellAccessoryType)accessoryType
             selectionHandler:(void(^)(RETableViewItem *item))selectionHandler
    accessoryButtonTapHandler:(void(^)(RETableViewItem *item))accessoryButtonTapHandler;

- (instancetype)initWithTitle:(NSString *)title;
- (instancetype)initWithTitle:(NSString *)title
      accessoryType:(UITableViewCellAccessoryType)accessoryType
   selectionHandler:(void(^)(RETableViewItem *item))selectionHandler;
- (instancetype)initWithTitle:(NSString *)title
      accessoryType:(UITableViewCellAccessoryType)accessoryType
   selectionHandler:(void(^)(RETableViewItem *item))selectionHandler
accessoryButtonTapHandler:(void(^)(RETableViewItem *item))accessoryButtonTapHandler;

- (NSIndexPath *)indexPath;

///-----------------------------
/// @name Manipulating table view row
///-----------------------------

- (void)selectRowAnimated:(BOOL)animated;
- (void)selectRowAnimated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition;
- (void)deselectRowAnimated:(BOOL)animated;
- (void)reloadRowWithAnimation:(UITableViewRowAnimation)animation;
- (void)deleteRowWithAnimation:(UITableViewRowAnimation)animation;

@end

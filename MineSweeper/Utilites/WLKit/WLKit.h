//
//  WLKit.h
//  Welian
//
//  Created by weLian on 16/5/9.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>

#if __has_include(<WLKit/WLKit.h>)

FOUNDATION_EXPORT double WLKitVersionNumber;
FOUNDATION_EXPORT const unsigned char WLKitVersionString[];

#pragma mark - Base
#import <WLKit/WLKitMacro.h>
#import <WLKit/NSObject+WLAdd.h>
#import <WLKit/NSObject+WLAddForKVO.h>
#import <WLKit/NSString+WLAdd.h>
#import <WLKit/NSString+WLAddForHash.h>
#import <WLKit/NSString+WLAddForSize.h>
#import <WLKit/NSString+WLAddForRegex.h>
#import <WLKit/NSString+WLAddForPinyin.h>
#import <WLKit/NSData+WLAdd.h>
#import <WLKit/NSData+WLAddForHash.h>
#import <WLKit/NSDate+WLAdd.h>
#import <WLKit/NSDate+WLAddForTimeAgo.h>
#import <WLKit/NSArray+WLAdd.h>
#import <WLKit/NSDictionary+WLAdd.h>
#import <WLKit/NSNumber+WLAdd.h>
#import <WLKit/NSDecimalNumber+WLAdd>
#import <WLKit/NSTimer+WLAdd.h>
#import <WLKit/NSUserDefaults+WLAdd.h>
#import <WLKit/NSNotificationCenter+WLAdd.h>
#import <WLKit/NSBundle+WLAdd.h>
#import <WLKit/NSIndexPath+WLAdd.h>
#import <WLKit/NSFileManager+WLAdd.h>
#import <WLKit/NSUserDefaults+WLAdd.h>


#pragma mark - Quartz
#import <WLKit/CALayer+YYAdd.h>
#import <WLKit/WLCGUtilities.h>
#import <WLKit/CALayer+WLBorderConfig.h>


#pragma mark - UIKit
#import <WLKit/UIColor+WLAdd.h>
#import <WLKit/UIDevice+WLAddForInfo.h>
#import <WLKit/UIScreen+WLAdd.h>
#import <WLKit/UIView+WLAdd.h>
#import <WLKit/UIScrollView+WLAdd.h>
#import <WLKit/UITableView+WLAdd.h>
#import <WLKit/UITextField+WLAdd.h>
#import <WLKit/UIApplication+WLAdd.h>
#import <WLKit/UIFont+WLAdd.h>
#import <WLKit/UIImage+WLAdd.h>
#import <WLKit/UIButton+WLAdd.h>
#import <WLKit/UIWindow+WLAdd.h>
#import <WLKit/UISearchBar+WLAdd.h>
#import <WLKit/UIImage+WLRoundedCorner.h>
#import <WLKit/UIView+WLRoundedCorner.h>
#import <WLKit/UIViewController+WLAdd.h>
#import <WLKit/UINavigationBar+WLAwesome.h>
#import <WLKit/UIViewController+WLNavigationControl.h>
#import <WLKit/UITableViewCell+WLAdd.h>


#pragma mark - Utility
#import <WLKit/WLSystemManager.h>

#pragma mark - Text
#import <WLKit/WLFPSLabel.h>


#else

#pragma mark - Base
#import "WLKitMacro.h"
#import "NSObject+WLAdd.h"
#import "NSObject+WLAddForKVO.h"
#import "NSString+WLAdd.h"
#import "NSString+WLAddForHash.h"
#import "NSString+WLAddForSize.h"
#import "NSString+WLAddForRegex.h"
#import "NSString+WLAddForPinyin.h"
#import "NSData+WLAdd.h"
#import "NSData+WLAddForHash.h"
#import "NSDate+WLAdd.h"
#import "NSArray+WLAdd.h"
#import "NSDictionary+WLAdd.h"
#import "NSNumber+WLAdd.h"
#import "NSDecimalNumber+WLAdd.h"
#import "NSTimer+WLAdd.h"
#import "NSUserDefaults+WLAdd.h"
#import "NSNotificationCenter+WLAdd.h"
#import "NSBundle+WLAdd.h"
#import "NSIndexPath+WLAdd.h"
#import "NSFileManager+WLAdd.h"
#import "NSUserDefaults+WLAdd.h"


#pragma mark - Quartz
#import "CALayer+WLAdd.h"
#import "WLCGUtilities.h"
#import "CALayer+WLBorderConfig.h"


#pragma mark - UIKit
#import "UIColor+WLAdd.h"
#import "UIDevice+WLAddForInfo.h"
#import "UIScreen+WLAdd.h"
#import "UIView+WLAdd.h"
#import "UIScrollView+WLAdd.h"
#import "UITableView+WLAdd.h"
#import "UITextField+WLAdd.h"
#import "UIApplication+WLAdd.h"
#import "UIFont+WLAdd.h"
#import "UIImage+WLAdd.h"
#import "UIButton+WLAdd.h"
#import "UIWindow+WLAdd.h"
#import "UILabel+WLAdd.h"
#import "UISearchBar+WLAdd.h"
#import "UIImage+WLRoundedCorner.h"
#import "UIView+WLRoundedCorner.h"
#import "UIViewController+WLAdd.h"
#import "UIViewController+WLNavigationControl.h"
#import "UINavigationBar+WLAwesome.h"
#import "UITableViewCell+WLAdd.h"
#import "UINavigationController+WLAdd.h"



#pragma mark - Utility
#import "WLSystemManager.h"

#pragma mark - Text
#import "WLFPSLabel.h"


#endif




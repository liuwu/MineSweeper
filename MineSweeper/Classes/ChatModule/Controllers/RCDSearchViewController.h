//
//  RCDSearchViewController.h
//  RCloudMessage
//
//  Created by 张改红 on 16/9/18.
//  Copyright © 2016年 RongCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QDCommonViewController.h"

@class RCDSearchResultModel;
@protocol RCDSearchViewDelegate <NSObject>
- (void)onSearchCancelClick;
- (void)didSelectChatModel:(RCSearchConversationResult *)result;
@end

@interface RCDSearchViewController : QDCommonViewController <UINavigationControllerDelegate>

@property(nonatomic, weak) id<RCDSearchViewDelegate> delegate;

@end

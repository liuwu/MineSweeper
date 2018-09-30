//
//  INoticeInfoModel.h
//  MineSweeper
//
//  Created by liuwu on 2018/9/30.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "INoticeModel.h"

@interface INoticeInfoModel : NSObject

@property (nonatomic, copy) NSNumber *pages;
@property (nonatomic, copy) NSString *count;
@property (nonatomic, copy) NSString *page;
@property (nonatomic, copy) NSArray *list;

@end

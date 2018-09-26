//
//  IGameGroupModel.h
//  MineSweeper
//
//  Created by liuwu on 2018/9/22.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IGameGroupModel : NSObject<NSCopying>

@property (nonatomic, copy) NSString *groupId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *chat_image;

@end

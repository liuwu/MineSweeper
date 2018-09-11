//
//  WLActivity.h
//  Welian
//
//  Created by dong on 2016/11/24.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WLActivity : NSObject

@property(nonatomic, copy) NSString *activityTitle;
@property(nonatomic, strong) UIImage *activityImage;
@property (nonatomic, copy) void (^selectionHandler)(void); /**< 点击后的事件处理 */

+ (instancetype)activityWithTitle:(NSString *)title image:(UIImage *)image handler:(void (^)(void))handler;

@property (nonatomic, assign) BOOL showBage;

@end

//
//  WLActivity.m
//  Welian
//
//  Created by dong on 2016/11/24.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import "WLActivity.h"

@implementation WLActivity

+ (instancetype)activityWithTitle:(NSString *)title image:(UIImage *)image handler:(void (^)(void))handler{
    WLActivity *activity = [[WLActivity alloc] init];
    activity.activityTitle = title;
    activity.activityImage = image;
    activity.selectionHandler = handler;
    return activity;
}

@end

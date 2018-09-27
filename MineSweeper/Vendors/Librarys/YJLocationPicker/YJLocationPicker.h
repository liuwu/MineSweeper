//
//  YJLocationPicker.h
//  PickerDemo
//
//  Created by 刘永杰 on 16/8/22.
//  Copyright © 2016年 sail. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ICityModel.h"

typedef void(^SelectedLocation)(ICityModel *province, ICityModel *city);

@interface YJLocationPicker : UIButton

@property (copy, nonatomic)SelectedLocation selectedLocation;

//初始化回传
- (instancetype)initWithProvince:(NSArray *)provinceArray
                        cityDict:(NSDictionary *)cityDict
                 SlectedLocation:(SelectedLocation)selectedLocation;
//显示
- (void)show;

@end

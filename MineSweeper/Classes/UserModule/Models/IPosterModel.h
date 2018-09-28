//
//  IPosterModel.h
//  MineSweeper
//
//  Created by liuwu on 2018/9/27.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPosterModel : NSObject

// 名称
@property (nonatomic, copy) NSString *app_name;
// 二维码
@property (nonatomic, copy) NSString *app_qrcode;
// logo
@property (nonatomic, copy) NSString *app_logo;

//app_qrcode:(NSString *)https://test.cnsunrun.com//saoleiapp//Uploads/System/Image/5bab2b8b8c40d.jpg
//app_name:(NSString *)番茄
//app_logo:(NSString *)https://test.cnsunrun.com//saoleiapp//Uploads/System/Image/5bab2ce233193.png

@end

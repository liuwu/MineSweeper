//
//  IUserQrCodeModel.h
//  MineSweeper
//
//  Created by liuwu on 2018/9/23.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IUserQrCodeModel : NSObject

// 手机
@property (nonatomic, copy) NSString *userId;
// 姓名
@property (nonatomic, copy) NSString *nickname;
// 真实姓名
@property (nonatomic, copy) NSString *mobile;
// 用户ID
@property (nonatomic, copy) NSString *uid;
// 二维码地址
@property (nonatomic, copy) NSString *qrcode;

//id:(NSString *)713
//mobile:(NSString *)15271946326
//nickname:(NSString *)chen
//uid:(long)1000713
//qrcode:(NSString *)https://test.cnsunrun.com/saoleiapp/Uploads/QRcode/713.png?time=1537689090

@end

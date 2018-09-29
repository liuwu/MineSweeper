//
//  SWQRCodeViewController.h
//  SWQRCode_Objc
//
//  Created by zhuku on 2018/4/4.
//  Copyright © 2018年 selwyn. All rights reserved.
//

#import "SWQRCode.h"
#import "QDCommonViewController.h"

typedef void(^SWQRCodeScanBlock)(NSString *scanValue);

@interface SWQRCodeViewController : QDCommonViewController// UIViewController

@property (nonatomic, strong) SWQRCodeConfig *codeConfig;

- (instancetype)initWithScanBlock:(SWQRCodeScanBlock)scanBlock;

@end

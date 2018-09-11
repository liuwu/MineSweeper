//
//  WLSystemAuth.m
//  Welian
//
//  Created by 好迪 on 16/5/5.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import "WLSystemAuth.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import <CoreLocation/CoreLocation.h>
#import <AddressBook/AddressBook.h>
#import <Contacts/Contacts.h>
#import <MessageUI/MessageUI.h>

#import <CoreTelephony/CTCellularData.h>

#pragma mark - UIAlertView extention
static const void *kAlertViewParamsKey = &kAlertViewParamsKey;

static const void *kAlertViewAuthType = &kAlertViewAuthType;


@interface UIAlertView (extention)

@property (nonatomic, strong)id params;

@property (nonatomic, assign) WLSystemAuthType authType;

@end

@implementation UIAlertView (extention)

- (void)setParams:(id)params{
    objc_setAssociatedObject(self,kAlertViewParamsKey, params, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)params{
    return objc_getAssociatedObject(self, kAlertViewParamsKey);
}

- (void)setAuthType:(WLSystemAuthType)authType{
    objc_setAssociatedObject(self,kAlertViewAuthType, @(authType), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (WLSystemAuthType)authType{
    return [objc_getAssociatedObject(self, kAlertViewAuthType) integerValue];
}

@end

@implementation WLSystemAuth

+ (instancetype)shareInstance{
    static WLSystemAuth *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[WLSystemAuth alloc] init];
    });
    return shared;
}


+ (void)showAlertWithAuthType:(WLSystemAuthType)authType completionHandler:(void (^)(WLSystemAuthStatus status))handler{
    switch (authType) {
        case WLSystemAuthTypeCamera:
            [self showAlertForMediaType:AVMediaTypeVideo completionHandler:handler];
            break;
        case WLSystemAuthTypePhotos:
            [self showAlertForPHAuth:handler];
            break;
        case WLSystemAuthTypeContacts:
            [self showAlertForContactsAuth:handler];
            break;
        case WLSystemAuthTypeLocation:
            [self showAlertForLocationAuth:handler];
            break;
        case WLSystemAuthTypeEmail:
            [self showAlertForEmailAuth:handler];
            break;
        case WLSystemAuthTypeNetwork:
            if (kiOS9Later) {
                [self showAlertForNetwork:handler];
            }
            break;
        case WLSystemAuthTypeMicrophone:
            [self showAlertForMediaType:AVMediaTypeAudio completionHandler:handler];
            break;
        default:
            DLog(@"暂未支持");
            break;
    }
}

#pragma mark - show alert view
+ (void)showAlertViewWithType:(WLSystemAuthType)authType{
    NSString *Title, *prefs;
    NSString *displayName = [[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    switch (authType) {
        case WLSystemAuthTypeCamera:
            Title = [NSString stringWithFormat:@"请在iPhone的“设置-隐私-相机”选项中，允许【%@】访问您的相机",displayName];
            prefs = @"prefs:root=Privacy&&path=CAMERA";
            break;
        case WLSystemAuthTypePhotos:
            Title = [NSString stringWithFormat:@"请在iPhone的“设置-隐私-照片”选项中，允许【%@】访问您的照片",displayName];
            prefs = @"prefs:root=Privacy&&path=PHOTOS";
            break;
        case WLSystemAuthTypeContacts:
            Title = [NSString stringWithFormat:@"请在iPhone的“设置-隐私-通讯录”选项中，允许【%@】访问您的通讯录",displayName];
            prefs = @"prefs:root=Privacy&&path=CONTACTS";
            break;
        case WLSystemAuthTypeLocation:
            Title = [NSString stringWithFormat:@"请在iPhone的“设置-隐私-定位服务”选项中，允许【%@】访问您的位置",displayName];
            prefs = @"prefs:root=LOCATION_SERVICES";
            break;
        case WLSystemAuthTypeEmail:
            Title = [NSString stringWithFormat:@"请在iPhone的“设置-邮件、通讯录、日历”选项中，设置邮箱账号"];
            prefs = @"prefs:root=ACCOUNT_SETTINGS";
            break;
        case WLSystemAuthTypeNetwork:
            Title = [NSString stringWithFormat:@"请在iPhone的“设置-【%@】-无线数据”选项中，打开无线局域网与蜂窝移动数据",displayName];
            prefs = @"prefs:root=Bundle identifier";
            break;
        case WLSystemAuthTypeMicrophone:
            Title = [NSString stringWithFormat:@"请在iPhone的“设置-隐私-麦克风”选项中，允许【%@】访问您的麦克风",displayName];
            prefs = @"prefs:root=Privacy&&path=Microphone";
            break;
        case WLSystemAuthTypeEKEvent:
            Title = [NSString stringWithFormat:@"请在iPhone的“设置-隐私-麦克风”选项中，允许【%@】访问您的麦克风",displayName];
            prefs = @"prefs:root=Privacy&&path=Microphone";
            break;
        default:
            Title = @"未支持";
            break;
    }
    
    [self showAlertViewWithMessage:Title toUrl:prefs authType:authType];
}

+ (void)showAlertViewWithMessage:(NSString *)message toUrl:(NSString *)prefs authType:(WLSystemAuthType)authType{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:[self shareInstance] cancelButtonTitle:@"暂不" otherButtonTitles:@"去设置",nil];
        alertView.params = prefs;
        alertView.authType = authType;
        [alertView show];
    });
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSString *prefs = alertView.params;
        NSURL *url = [NSURL URLWithString:prefs];
        if (kIOS8Later && alertView.authType != WLSystemAuthTypeEmail) {
           url= [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        }
        if([[UIApplication sharedApplication]canOpenURL:url]){
            [[UIApplication sharedApplication]openURL:url];
        }
    }
}

#pragma mark - private Method
+ (void)showAlertForEKEventContactsAuth:(void (^)(WLSystemAuthStatus status))handler{
    
}

// 摄像头 相机
+ (void)showAlertForMediaType:(AVMediaType)mediaType completionHandler:(void (^)(WLSystemAuthStatus status))handler{
    AVAuthorizationStatus authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    switch (authorizationStatus) {
        case AVAuthorizationStatusNotDetermined:{
            [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (granted) {
                        handler(WLSystemAuthStatusAuthorized);
                    }
                    else{
                        handler(WLSystemAuthStatusUnknownError);
                    }
                });
            }];
            break;
        }
        case AVAuthorizationStatusAuthorized:
            handler(WLSystemAuthStatusAuthorized);
            break;
        case AVAuthorizationStatusRestricted:
            NSLog(@"受限，有可能开启了访问限制");
        case AVAuthorizationStatusDenied:
            NSLog(@"访问受限");
            if (mediaType == AVMediaTypeVideo) {
                [self showAlertViewWithType:WLSystemAuthTypeCamera];
            }else if (mediaType == AVMediaTypeAudio) {
                [self showAlertViewWithType:WLSystemAuthTypeMicrophone];
            }
            handler(WLSystemAuthStatusUnknownError);
            break;
    }
}

// 照片
+ (void)showAlertForPHAuth:(void (^)(WLSystemAuthStatus))handler{
    PHAuthorizationStatus authorizationStatus = [PHPhotoLibrary authorizationStatus];
    switch (authorizationStatus) {
        case PHAuthorizationStatusNotDetermined:{
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    status == PHAuthorizationStatusAuthorized?handler(WLSystemAuthStatusAuthorized):(void)NULL;
                });
            }];
            break;
        }
        case PHAuthorizationStatusAuthorized:
            handler(WLSystemAuthStatusAuthorized);
            break;
        case PHAuthorizationStatusRestricted:
        case PHAuthorizationStatusDenied:
            [self showAlertViewWithType:WLSystemAuthTypePhotos];
            handler(WLSystemAuthStatusUnknownError);
            break;
    }
}

// 通讯录
+ (void)showAlertForContactsAuth:(void (^)(WLSystemAuthStatus))handler{
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    switch (status) {
        case kABAuthorizationStatusNotDetermined:{
            ABAddressBookRef addressBook = NULL;
            ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (granted) {
                        handler(WLSystemAuthStatusAuthorized);
                    }
                    else{
                        handler(WLSystemAuthStatusUnknownError);
                    }
                });
            });
        }
            break;
        case kABAuthorizationStatusAuthorized:
            handler(WLSystemAuthStatusAuthorized);
            break;
        case kABAuthorizationStatusRestricted:
        case kABAuthorizationStatusDenied:
            [self showAlertViewWithType:WLSystemAuthTypeContacts];
            handler(WLSystemAuthStatusUnknownError);
            break;
    }
}

// 位置
+ (void)showAlertForLocationAuth:(void (^)(WLSystemAuthStatus))handler{
     CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (status) {
            case kCLAuthorizationStatusNotDetermined:{
                if(handler){
                    handler(WLSystemAuthStatusOther);
                }
            }
                break;
//            case kCLAuthorizationStatusAuthorized:
            case kCLAuthorizationStatusAuthorizedAlways:
            case kCLAuthorizationStatusAuthorizedWhenInUse:
                if (handler) {
                    handler(WLSystemAuthStatusAuthorized);
                }
                break;
            case kCLAuthorizationStatusRestricted:
            case kCLAuthorizationStatusDenied:
                [self showAlertViewWithType:WLSystemAuthTypeLocation];
                if (handler) {
                    handler(WLSystemAuthStatusUnknownError);
                }
                break;
        }
    });
}

+ (void)showAlertForNetwork:(void (^)(WLSystemAuthStatus))handler {
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable: {
                CTCellularData *cellularData = [[CTCellularData alloc]init];
                cellularData.cellularDataRestrictionDidUpdateNotifier =  ^(CTCellularDataRestrictedState state){
                    //获取联网状态
                    switch (state) {
                        case kCTCellularDataRestricted:
                        case kCTCellularDataRestrictedStateUnknown:
                            DLog(@"被限制，未知");
                            [self showAlertViewWithType:WLSystemAuthTypeNetwork];
                            if (handler) {
                                handler(WLSystemAuthStatusUnknownError);
                            }
                            break;
                        case kCTCellularDataNotRestricted:
                            if (handler) {
                                handler(WLSystemAuthStatusAuthorized);
                            }
                            DLog(@"无限制");
                            break;
                        default:
                            break;
                    };
                };
                break;
            }
            case AFNetworkReachabilityStatusUnknown:
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi: {
                
                break;
            }
        }
    }];
}

+ (void)showAlertForEmailAuth:(void (^)(WLSystemAuthStatus))handler{
     BOOL canSendMail = [MFMailComposeViewController canSendMail];
    dispatch_async(dispatch_get_main_queue(), ^{
        if(canSendMail){
            if (handler) {
                handler(WLSystemAuthStatusAuthorized);
            }
        }
        else{
            [self showAlertViewWithType:WLSystemAuthTypeEmail];
            if (handler) {
                handler(WLSystemAuthStatusUnknownError);
            }
        }
    });
}

@end




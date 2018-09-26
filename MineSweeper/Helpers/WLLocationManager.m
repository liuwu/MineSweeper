//
//  WLLocationManager.m
//  Welian
//
//  Created by zp on 16/8/18.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import "WLLocationManager.h"
#import "NSError+Extend.h"

@interface WLLocationManager ()<BMKGeoCodeSearchDelegate,BMKLocationAuthDelegate,BMKLocationManagerDelegate>
//地理编码:地名—>经纬度坐标
@property (nonatomic, copy) GeocodeSuccessBlock geocodeSuccessBlock;
@property (nonatomic, copy) GeocodeFailureBlock geocodeFailureBlock;
//反地理编码:经纬度坐标—>地名
@property (nonatomic, copy) RegeocodeSuccessBlock regeocodeSuccessBlock;
@property (nonatomic, copy) RegeocodeFailureBlock regeocodeFailureBlock;

@property (nonatomic, copy) LocationSuccessBlock locationSuccessBlock;
@property (nonatomic, copy) LocationFaileBlock locationFaileBlock;

@property (nonatomic , strong)BMKGeoCodeSearch   *searcher;
@property (nonatomic, strong) BMKLocationManager *locationManager;

@end

@implementation WLLocationManager

+ (instancetype)locationManager {
    WLLocationManager *locationM = [[WLLocationManager alloc] init];
    return locationM;
}

#pragma mark – Lifecycle
- (instancetype)init {
    self = [super init];
    if (self) {
        [[BMKLocationAuth sharedInstance] checkPermisionWithKey:[WLServiceInfo sharedServiceInfo].BMKKey authDelegate:self];
    }
    return self;
}

#pragma mark 开始定位
- (void)wl_startUpdatingLocationWithShowAlert:(BOOL)isShow successBlock:(LocationSuccessBlock)successBlock faileBlock:(LocationFaileBlock)faileBlock {
    //定位服务是否可用
    self.locationSuccessBlock = successBlock;
    self.locationFaileBlock = faileBlock;
    if (![WLLocationManager isLocationEnabled]) {
        if (isShow) {
            [[LGAlertView alertViewWithTitle:@"定位服务已关闭" message:@"前往“设置”>“隐私”>“定位服务”打开"  style:LGAlertViewStyleAlert buttonTitles:nil cancelButtonTitle:nil destructiveButtonTitle:@"知道了" actionHandler:nil cancelHandler:nil destructiveHandler:nil] showAnimated:YES completionHandler:nil];
        }
        if(self.locationFaileBlock){
            self.locationFaileBlock([NSError errorWithMsg:@"无权限"]);
        }
    }else {
        [self.locationManager requestLocationWithReGeocode:YES withNetworkState:NO completionBlock:^(BMKLocation * _Nullable location, BMKLocationNetworkState state, NSError * _Nullable error) {
            if (error) {
                if(self.locationFaileBlock){
                    self.locationFaileBlock(error);
                }
            } else {
                BMKLocationReGeocode *rgcData = location.rgcData;
                //定位的城市
                [NSUserDefaults setObject:@{@"name":rgcData.city,@"cityid":rgcData.cityCode} forKey:kWL_LocationCityKey];
                if(self.locationSuccessBlock){
                    self.locationSuccessBlock(location);
                }
            }
        }];
    }
}

#pragma mark 停止定位
- (void)wl_stopLocation {
    if (_locationManager) {
        [self.locationManager stopUpdatingLocation];
    }
}
#pragma mark 根据地址得到经纬度
- (void)wl_geocodeAddress:(BMKGeoCodeSearchOption *)address andSuccess:(GeocodeSuccessBlock)success andFailure:(GeocodeFailureBlock)failure {
    self.geocodeSuccessBlock = success;
    self.geocodeFailureBlock = failure;
    //异步函数，返回结果在BMKGeoCodeSearchDelegate的
    [self.searcher geoCode:address];
}
#pragma mark 根据经纬度得到地址
- (void)wl_regeocodeLocation:(CLLocation *)location andSuccess:(RegeocodeSuccessBlock)success andFailure:(RegeocodeFailureBlock)failure {
    self.regeocodeSuccessBlock = success;
    self.regeocodeFailureBlock = failure;
    BMKReverseGeoCodeSearchOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeSearchOption alloc]init];
    reverseGeoCodeSearchOption.location = location.coordinate;
    //异步函数，返回结果在BMKGeoCodeSearchDelegate的
    [self.searcher reverseGeoCode:reverseGeoCodeSearchOption];
}

#pragma mark 地理编码Delegate
/**
 *返回地址信息搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结BMKGeoCodeSearch果
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeSearchResult *)result errorCode:(BMKSearchErrorCode)error {
    if (error == BMK_SEARCH_NO_ERROR) {
        if (self.geocodeSuccessBlock) {
            self.geocodeSuccessBlock(result);
        }
    }
    else {
        if(self.geocodeFailureBlock){
            self.geocodeFailureBlock(error);
        }
        DLog(@"未找到结果");
    }
}
/**
 *返回反地理编码搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeSearchResult *)result errorCode:(BMKSearchErrorCode)error {
    if (error == BMK_SEARCH_NO_ERROR) {
        if (self.regeocodeSuccessBlock) {
            self.regeocodeSuccessBlock(result);
        }
    }
    else {
        if(self.regeocodeFailureBlock){
            self.regeocodeFailureBlock(error);
        }
        DLog(@"未找到结果");
    }
}

-(BMKGeoCodeSearch *)searcher {
    if (!_searcher) {
        _searcher = [[BMKGeoCodeSearch alloc]init];
        _searcher.delegate = self;
    }
    return _searcher;
}

- (BMKLocationManager *)locationManager {
    if (!_locationManager) {
        //初始化实例
        _locationManager = [[BMKLocationManager alloc] init];
        //设置delegate
        //    _locationManager.delegate = self;
        //设置返回位置的坐标系类型
        _locationManager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
        //设置距离过滤参数
        _locationManager.distanceFilter = 1000.f;
        //设置预期精度参数
        _locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
        //设置应用位置类型
        _locationManager.activityType = CLActivityTypeAutomotiveNavigation;
        //设置是否自动停止位置更新
        _locationManager.pausesLocationUpdatesAutomatically = NO;
        //设置位置获取超时时间
        _locationManager.locationTimeout = 10;
        //设置获取地址信息超时时间
        _locationManager.reGeocodeTimeout = 10;
    }
    return _locationManager;
}

+ (BOOL)isLocationEnabled {
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusDenied) {
        return NO;
    }else {
        return YES;
    }
}

@end

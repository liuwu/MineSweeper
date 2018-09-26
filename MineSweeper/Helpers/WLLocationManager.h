//
//  WLLocationManager.h
//  Welian
//
//  Created by zp on 16/8/18.
//  Copyright © 2016年 chuansongmen. All rights reserved.
/**
 *打开定位服务
 *需要在info.plist文件中添加(以下二选一，两个都添加默认使用NSLocationWhenInUseUsageDescription)：
 *NSLocationWhenInUseUsageDescription 允许在前台使用时获取GPS的描述
 *NSLocationAlwaysUsageDescription 允许永远可获取GPS的描述
 */
//  基于 百度地图SDK 封装地理编码 反地理编码，基于 百度定位SDK 封装定位

#import <Foundation/Foundation.h>
//百度地图
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
//百度定位
#import <BMKLocationkit/BMKLocationComponent.h>
#import <BMKLocationkit/BMKLocationAuth.h>

//定位
typedef void(^LocationSuccessBlock)(BMKLocation *location);
typedef void(^LocationFaileBlock)(NSError *error);
//地理编码:地名—>经纬度坐标
typedef void(^GeocodeSuccessBlock) (BMKGeoCodeSearchResult *geoCodeResult);
typedef void(^GeocodeFailureBlock) (BMKSearchErrorCode error);
//反地理编码:经纬度坐标—>地名
typedef void(^RegeocodeSuccessBlock) (BMKReverseGeoCodeSearchResult *reverseGeoCodeResult);
typedef void(^RegeocodeFailureBlock) (BMKSearchErrorCode error);

@interface WLLocationManager : NSObject
+ (instancetype)locationManager;
///开始定位
- (void)wl_startUpdatingLocationWithShowAlert:(BOOL)isShow successBlock:(LocationSuccessBlock)successBlock faileBlock:(LocationFaileBlock)faileBlock;
///根据地址得到经纬度
- (void)wl_geocodeAddress:(BMKGeoCodeSearchOption *)address andSuccess:(GeocodeSuccessBlock)success andFailure:(GeocodeFailureBlock)failure;
///根据经纬度得到地址
- (void)wl_regeocodeLocation:(CLLocation *)location andSuccess:(RegeocodeSuccessBlock)success andFailure:(RegeocodeFailureBlock)failure;
///停止定位
- (void)wl_stopLocation;
//是否可以定位
+ (BOOL)isLocationEnabled;

@end

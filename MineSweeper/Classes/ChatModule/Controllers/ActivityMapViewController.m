//
//  ActivityMapViewController.m
//  Welian
//
//  Created by weLian on 15/1/6.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "ActivityMapViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件

@interface ActivityMapViewController ()<BMKGeoCodeSearchDelegate,BMKMapViewDelegate>

@property (strong,nonatomic) NSString *city;
@property (strong,nonatomic) NSString *address;
@property (strong,nonatomic) BMKMapView *mapView;
@property (strong,nonatomic) BMKGeoCodeSearch *geocodesearch;

@property (nonatomic, strong) RCLocationMessage *locationMsg;

@end

@implementation ActivityMapViewController

- (void)dealloc {
    _geocodesearch = nil;
    _mapView = nil;
}

- (NSString *)title {
    return @"位置";
}

- (instancetype)initWithAddress:(NSString *)address city:(NSString *)city {
    self = [super init];
    if (self) {
        self.city = city;
        self.address = address;
    }
    return self;
}

- (instancetype)initWithRCLocationMsg:(RCLocationMessage *)locationMsg {
    self = [super init];
    if (self) {
        self.locationMsg = locationMsg;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.mapView];
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    if (self.locationMsg) {
        BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
        annotation.coordinate = self.locationMsg.location;
        annotation.title = self.locationMsg.locationName;
        [self showSelectAnnotation:annotation];
    }else{
        BMKGeoCodeSearchOption *geoCodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
        geoCodeSearchOption.city = [_city isKindOfClass:[NSNull class]] ? @"" : _city;
        geoCodeSearchOption.address = _address;
        BOOL flag = [self.geocodesearch geoCode:geoCodeSearchOption];
        [WLHUDView showHUDWithStr:@"获取位置中..." dim:NO];
        if(flag){
            DLog(@"geo检索发送成功");
        }else{
            DLog(@"geo检索发送失败");
        }
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil;
    _geocodesearch.delegate = nil;
    [WLHUDView hiddenHud];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    _mapView.delegate = self;
    _geocodesearch.delegate = self;
}

//实现Deleage处理回调结果
//接收正向编码结果
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeSearchResult *)result errorCode:(BMKSearchErrorCode)error{
    [WLHUDView hiddenHud];
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
        annotation.coordinate = result.location;
        annotation.title = _address;
        [self showSelectAnnotation:annotation];
    }else {
        DLog(@"抱歉，未找到结果");
        [WLHUDView showAttentionHUD:@"未找到地理位置！"];
    }
}

- (void)showSelectAnnotation:(BMKPointAnnotation *)annotation {
    [_mapView addAnnotation:annotation];
    
    //设定地图中心点坐标
    [_mapView setCenterCoordinate:annotation.coordinate animated:YES];
    
    //设定当前地图的显示范围
    [_mapView setRegion:BMKCoordinateRegionMake(annotation.coordinate,BMKCoordinateSpanMake(0.02,0.02))];
    //设置地图缩放级别
    [_mapView setZoomLevel:19];
    //设置选中标记
    [_mapView selectAnnotation:annotation animated:YES];
}

- (BMKAnnotationView *)_mapView:(BMKMapView *)_mapView viewForAnnotation:(id <BMKAnnotation>)annotation {
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        return newAnnotationView;
    }
    return nil;
}

#pragma mark - InitMethod
- (BMKMapView*)mapView {
    if (_mapView==nil) {
        _mapView = [BMKMapView new];
        _mapView.zoomEnabled=YES;
        _mapView.zoomEnabledWithTap=YES;
    }
    return _mapView;
}

- (BMKGeoCodeSearch*)geocodesearch {
    if (_geocodesearch==nil) {
        _geocodesearch=[[BMKGeoCodeSearch alloc]init];
    }
    return _geocodesearch;
}


@end

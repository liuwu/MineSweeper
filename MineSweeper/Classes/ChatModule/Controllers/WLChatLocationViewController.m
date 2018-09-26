//
//  WLChatLocationViewController.m
//  Welian
//
//  Created by dong on 15/10/22.
//  Copyright © 2015年 chuansongmen. All rights reserved.
//

#import "WLChatLocationViewController.h"

#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件

#define kBaiduMapMaxHeight [UIScreen mainScreen].bounds.size.height-100
#define kCurrentLocationBtnWH 60
#define kPading 10

@interface WLChatLocationViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,UITableViewDataSource,UITableViewDelegate>
{
    BOOL isFirstLocation;
    SendLocationMsgeBlock _locationMesgBlock;
}

@property(nonatomic,strong)BMKMapView* mapView;
@property(nonatomic,strong)BMKLocationService* locService;
@property(nonatomic,strong)BMKGeoCodeSearch* geocodesearch;

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataSource;

@property(nonatomic,assign)CLLocationCoordinate2D currentCoordinate;
@property(nonatomic,assign)NSInteger currentSelectLocationIndex;
@property(nonatomic,strong)UIImageView *centerCallOutImageView;
@property(nonatomic,strong)UIButton *currentLocationBtn;
@end

static NSString *locationCellid = @"locationCellid";

@implementation WLChatLocationViewController

- (NSString *)title {return @"位置";}

- (instancetype)initWithSendLocationMsgeBlock:(SendLocationMsgeBlock)locMesgBlcok
{
    self = [super init];
    if (self) {
        _locationMesgBlock = locMesgBlcok;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self wl_setLeftItemWithTitle:@"取消" image:nil target:self action:@selector(cancelSelfVC)];
    [self wl_setRightItemWithTitle:@"发送" image:nil target:self action:@selector(sendLocationMessage)];
//    self.navigationItem.rightBarButtonItem.enabled = NO;
    [self configUI];
    [self startLocation];
}

- (void)cancelSelfVC
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendLocationMessage
{
    UIImage *image = [self.mapView takeSnapshot];
    if (_locationMesgBlock) {
        if (_dataSource.count > 0) {
            BMKPoiInfo *model=[self.dataSource objectAtIndex:0];
            RCLocationMessage *locationMsg = [RCLocationMessage messageWithLocationImage:image location:model.pt locationName:model.name];
            _locationMesgBlock(locationMsg);
        } else {
            RCLocationMessage *locationMsg = [RCLocationMessage messageWithLocationImage:image location:_currentCoordinate locationName:@"我的位置"];
            _locationMesgBlock(locationMsg);
        }
    }
    [self cancelSelfVC];
}

-(void)configUI
{
    [self.view addSubview:self.mapView];
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.height.equalTo(@([UIScreen mainScreen].bounds.size.height*0.7));
    }];
    
    [self.view addSubview:self.centerCallOutImageView];
    [self.view bringSubviewToFront:self.centerCallOutImageView];
    [self.centerCallOutImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mapView.mas_centerX);
        make.centerY.equalTo(self.mapView.mas_centerY).offset(-15);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [self.mapView layoutIfNeeded];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mapView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    self.currentLocationBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    
    [self.currentLocationBtn setImage:[UIImage imageNamed:@"location_back_icon"] forState:UIControlStateNormal];
    [self.currentLocationBtn setImage:[UIImage imageNamed:@"location_blue_icon"] forState:UIControlStateSelected];
    [self.currentLocationBtn addTarget:self action:@selector(startLocation) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.currentLocationBtn];
    [self.view bringSubviewToFront:self.currentLocationBtn];
    [self.currentLocationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kCurrentLocationBtnWH, kCurrentLocationBtnWH));
        make.bottom.equalTo(self.mapView.mas_bottom).offset(-10);
        make.right.equalTo(self.view.mas_right).offset(-10);
    }];
}

-(void)startLocation
{
    isFirstLocation=YES;//首次定位
    self.currentSelectLocationIndex=0;
    self.currentLocationBtn.selected=YES;
    
    [self.locService startUserLocationService];
    self.mapView.showsUserLocation = NO;//先关闭显示的定位图层
    self.mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    self.mapView.showsUserLocation = YES;//显示定位图层
}

-(void)startGeocodesearchWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    BMKReverseGeoCodeSearchOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeSearchOption alloc]init];
    reverseGeocodeSearchOption.location = coordinate;
    BOOL flag = [self.geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag){
        DLog(@"反geo检索发送成功");
    }else{
        DLog(@"反geo检索发送失败");
    }
}

-(void)setCurrentCoordinate:(CLLocationCoordinate2D)currentCoordinate
{
    _currentCoordinate=currentCoordinate;
    [self startGeocodesearchWithCoordinate:currentCoordinate];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.mapView viewWillAppear];
    self.mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    self.locService.delegate = self;
    self.geocodesearch.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil; // 不用时，置nil
    self.locService.delegate = nil;
    self.geocodesearch.delegate = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    if (_mapView)
    {
        _mapView = nil;
    }
    if (_geocodesearch)
    {
        _geocodesearch = nil;
    }
    if (_locService)
    {
        _locService=nil;
    }
}

#pragma mark - BMKMapViewDelegate
/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [self.mapView setCenterCoordinate:userLocation.location.coordinate];
    [self.mapView updateLocationData:userLocation];
    isFirstLocation=NO;
    self.currentLocationBtn.selected=NO;
    self.currentCoordinate=userLocation.location.coordinate;
    if (self.currentCoordinate.latitude!=0)
    {
        [self.locService stopUserLocationService];
    }
    
}

/**
 *在地图View停止定位后，会调用此函数
 *@param mapView 地图View
 */
- (void)didStopLocatingUser
{
    NSLog(@"stop locate");
}

/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
    
}

- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if (isFirstLocation || !self.currentCoordinate.latitude) return;
//    CLLocationCoordinate2D tt =[mapView convertPoint:self.centerCallOutImageView.center toCoordinateFromView:self.centerCallOutImageView];
    self.currentCoordinate=mapView.centerCoordinate;
}

#pragma mark - BMKGeoCodeSearchDelegate

/**
 *返回地址信息搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结BMKGeoCodeSearch果
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeSearchResult *)result errorCode:(BMKSearchErrorCode)error
{
    NSLog(@"返回地址信息搜索结果,失败-------------");
}

/**
 *返回反地理编码搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果
 *@param error 错误号，@see BMKSearchErrorCode
 */

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeSearchResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR)
    {
        [self.dataSource removeAllObjects];
        //把当前定位信息自定义组装 放进数组首位
        BMKPoiInfo *first =[[BMKPoiInfo alloc]init];
        first.address=result.address;
        first.name=result.addressDetail.streetName;
        first.pt=result.location;
        first.city=result.addressDetail.city;
        [self.dataSource addObject:first];
        [self.tableView reloadData];
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
}

#pragma mark - TableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:locationCellid];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:locationCellid];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailTextLabel.textColor=[UIColor grayColor];
    }
    BMKPoiInfo *model=[self.dataSource objectAtIndex:indexPath.row];
    cell.textLabel.text=model.name;
    cell.detailTextLabel.text=model.address;
    
    if (self.currentSelectLocationIndex==indexPath.row){
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }else {
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//        BMKPoiInfo *model=[self.dataSource objectAtIndex:indexPath.row];
//    //    BMKMapStatus *mapStatus =[self.mapView getMapStatus];
//    //    mapStatus.targetGeoPt=model.pt;
//        [self.mapView setCenterCoordinate:model.pt animated:YES];
//    //    [self.mapView setMapStatus:mapStatus withAnimation:YES];
//        self.currentSelectLocationIndex=indexPath.row;
//        [self.tableView reloadData];
}

#pragma mark - InitMethod
-(BMKMapView*)mapView
{
    if (_mapView==nil)
    {
        _mapView =[BMKMapView new];
        _mapView.zoomEnabled=YES;
        _mapView.zoomEnabledWithTap=YES;
        _mapView.zoomLevel=18;
        BMKLocationViewDisplayParam *myLocationParam = [[BMKLocationViewDisplayParam alloc] init];
        myLocationParam.isAccuracyCircleShow = NO;
        [_mapView updateLocationViewWithParam:myLocationParam];
    }
    return _mapView;
}

-(BMKLocationService*)locService
{
    if (_locService==nil)
    {
        _locService = [[BMKLocationService alloc]init];
        //设置定位精确度
//        [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
        _locService.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    }
    return _locService;
}
-(BMKGeoCodeSearch*)geocodesearch
{
    if (_geocodesearch==nil)
    {
        _geocodesearch=[[BMKGeoCodeSearch alloc]init];
    }
    return _geocodesearch;
}

-(UITableView*)tableView
{
    if (_tableView==nil)
    {
        _tableView=[UITableView new];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        
    }
    return _tableView;
}

-(UIImageView*)centerCallOutImageView
{
    if (_centerCallOutImageView==nil)
    {
        _centerCallOutImageView=[UIImageView new];
        [_centerCallOutImageView setImage:[UIImage imageNamed:@"map_annotation"]];
    }
    return _centerCallOutImageView;
}

-(NSMutableArray*)dataSource
{
    if (_dataSource==nil) {
        _dataSource=[[NSMutableArray alloc]init];
    }
    
    return _dataSource;
}


@end

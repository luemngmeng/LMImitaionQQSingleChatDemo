//
//  LMLocationViewController.m
//  LMImitaionQQSingleChatDemo
//
//  Created by mengmenglu on 3/17/16.
//  Copyright © 2016 Hangzhou TaiXuan Network Technology Co., Ltd. All rights reserved.
//

#import "LMLocationViewController.h"

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

static LMLocationViewController *defaultLocation = nil;
@interface LMLocationViewController ()<MKMapViewDelegate,CLLocationManagerDelegate>{
    
    MKPointAnnotation *_annotation;
    CLLocationManager *_locationManager;
    CLLocationCoordinate2D _currentLocationCoordinate;
    BOOL _isSendLocation;  // 是否发送过地址
}


/**
 *  导航栏左侧的返回按钮
 */
@property (nonatomic,strong) UIButton *backButton;


/**
 *  导航右侧的返回按钮
 */
@property (nonatomic,strong) UIButton *sendButton;


/**
 *  地图视图
 */
@property (nonatomic,strong) MKMapView *mapView;


/**
 *  地址信息
 */
@property (strong, nonatomic) NSString *addressString;


@end

@implementation LMLocationViewController


#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"位置信息";
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    // 添加子视图
    [self addConfigSubview];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Method
#pragma mark 初始化
- (instancetype)init {  // 为定位过，无定位信息
    
    self = [super init];
    
    if (self) {
        _isSendLocation = YES;
    }
    
    return self;
}

- (instancetype)initWithLocation:(CLLocationCoordinate2D)locationCoordinate { // 已定位，有定位信息
    
    self = [super init];
    
    if (self) {
        _isSendLocation = NO;
        _currentLocationCoordinate = locationCoordinate;
    }
    
    return self;
}

#pragma mark - class methods

+ (instancetype)defaultLocation
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultLocation = [[LMLocationViewController alloc] init];
    });
    
    return defaultLocation;
}

#pragma mark  config subview
#pragma mark 添加子视图
- (void)addConfigSubview {

    // 添加地图视图
    [self.view addSubview:self.mapView];
    
    // 设置导航栏
    // 添加导航栏左侧按钮
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:self.backButton];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    
    // 添加导航栏右侧视图
    if (_isSendLocation) {
        
        self.mapView.showsUserLocation = YES ; // 显示当前位置
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.sendButton];
        [self.navigationItem setRightBarButtonItem:rightItem];
        
        // 开始定位
        [self startLocation];
        
    } else {
        
        // 已经传过来定位的信息直接添加大头针
        [self removeToLocation:_currentLocationCoordinate];
    }

}

#pragma mark 设置导航栏右侧发送按钮
- (UIButton *)sendButton {
    
    if (!_sendButton) {
        
        _sendButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [_sendButton setTitleColor:[UIColor colorWithRed:32 / 255.0 green:134 / 255.0 blue:158 / 255.0 alpha:1.0] forState:UIControlStateNormal];
        [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_sendButton addTarget:self action:@selector(sendLocation) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _sendButton;
}

#pragma mark 设置导航栏左侧返回按钮
- (UIButton *)backButton {
    
    if (!_backButton) {
        
        _backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 30)];
        [_backButton setImage:[UIImage imageNamed:@"trReturn.png"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _backButton;
}

#pragma makr 地图视图
- (MKMapView *)mapView {
    
    if (!_mapView) {
        _mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
        _mapView.delegate = self;
        _mapView.mapType = MKMapTypeStandard;
        _mapView.zoomEnabled = YES;
    }
    
    return _mapView;
}

#pragma mark - Action Method
#pragma mark 发送定位地址信息
- (void)sendLocation {
   
    if (_delegate && [_delegate respondsToSelector:@selector(sendLocationLatitude:longitude:andAddress:)]) {
        [_delegate sendLocationLatitude:_currentLocationCoordinate.latitude longitude:_currentLocationCoordinate.longitude andAddress:_addressString];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 返回上一页或者根目录
- (void)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - MKMapView Delegate
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    
    __weak typeof(self) weakSelf = self;
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        if (!error && placemarks.count >0) {
            
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            weakSelf.addressString = placemark.name;
            
            //添加大大头针
            [self removeToLocation:userLocation.coordinate];
        }
    }];
    
}

- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error {
    
    if (error.code == 0) {
        
        NSString *message = [error.userInfo objectForKey:NSLocalizedRecoverySuggestionErrorKey];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:message
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"ok", @"OK")
                                                  otherButtonTitles:nil, nil];
        [alertView show];
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
   
    switch (status) {
            
        case kCLAuthorizationStatusNotDetermined:
            if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
            {
                [_locationManager requestWhenInUseAuthorization];
            }
            break;
        case kCLAuthorizationStatusDenied:
        {
            
        }
        default:
            break;
    }
}


#pragma mark - Public Method
#pragma mark 开始定位
- (void)startLocation {
    
    if ([CLLocationManager locationServicesEnabled]) {
        
        if (!_locationManager) {
            _locationManager = [[CLLocationManager alloc] init];
            _locationManager.delegate = self;
            _locationManager.distanceFilter = 5;
            _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
            
            if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]){
                [_locationManager performSelector:@selector(requestWhenInUseAuthorization)];
            }
            
            if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                [_locationManager requestWhenInUseAuthorization];
            }
        }
    }
}


-(void)createAnnotationWithCoords:(CLLocationCoordinate2D)coords
{
    if (_annotation == nil) {
        _annotation = [[MKPointAnnotation alloc] init];
    }
    else{
        [_mapView removeAnnotation:_annotation];
    }
    _annotation.coordinate = coords;
    [_mapView addAnnotation:_annotation];
}

- (void)removeToLocation:(CLLocationCoordinate2D)locationCoordinate
{
    
    _currentLocationCoordinate = locationCoordinate;
    float zoomLevel = 0.001;
    
    MKCoordinateRegion region = MKCoordinateRegionMake(_currentLocationCoordinate, MKCoordinateSpanMake(zoomLevel, zoomLevel));
    MKCoordinateRegion newRegion = [_mapView regionThatFits:region];
    [_mapView setRegion:newRegion animated:YES];
    
    [self createAnnotationWithCoords:_currentLocationCoordinate];
    
}


@end

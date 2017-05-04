//
//  MMLocationManager.m
//  MMLocationManager
//
//  Created by Chen Yaoqiang on 13-12-24.
//  Copyright (c) 2013年 Chen Yaoqiang. All rights reserved.
//

#import "MMLocationManager.h"

static BOOL isNeedCity;

@interface MMLocationManager ()<UIAlertViewDelegate>
{
    BOOL isOpen;
}

@property (nonatomic, strong) LocationBlock locationBlock;
@property (nonatomic, strong) NSStringBlock cityBlock;
@property (nonatomic, strong) NSStringBlock addressBlock;
@property (nonatomic, strong) LocationErrorBlock errorBlock;

@end

@implementation MMLocationManager

+ (MMLocationManager *)shareLocation;
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (id)init {
    self = [super init];
    if (self) {
        NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
        isNeedCity = YES;
        float longitude = [standard floatForKey:MMLastLongitude];
        float latitude = [standard floatForKey:MMLastLatitude];
        self.longitude = longitude;
        self.latitude = latitude;
        self.lastCoordinate = CLLocationCoordinate2DMake(longitude,latitude);
        self.lastCity = [standard objectForKey:MMLastCity];
        self.lastAddress=[standard objectForKey:MMLastAddress];
    }
    return self;
}

- (void) getLocationCoordina:(LocationBlock)locaiontBlock
{
    self.locationBlock = [locaiontBlock copy];
    isOpen = NO;
    if (_locationBlock) {
        _locationBlock(CLLocationCoordinate2DMake(0, 0));
        _locationBlock = nil;
    }
}

- (void) getLocationCoordinate:(LocationBlock) locaiontBlock
{
    isOpen = NO;
    isNeedCity = NO;
    self.locationBlock = [locaiontBlock copy];
    [self startLocation];
}

- (void) getLocationCoordinate:(LocationBlock) locaiontBlock  withAddress:(NSStringBlock) addressBlock
{
    isOpen = NO;
    self.locationBlock = [locaiontBlock copy];
    self.addressBlock = [addressBlock copy];
    [self startLocation];
}

- (void) getAddress:(NSStringBlock)addressBlock
{
    isOpen = NO;
    self.addressBlock = [addressBlock copy];
    [self startLocation];
}

- (void) getCity:(NSStringBlock)cityBlock
{
    isOpen = NO;
    isNeedCity = YES;
    self.cityBlock = [cityBlock copy];
    [self startLocation];
    //NSLog(@"获取城市 ");
    
}

- (void) getCity:(NSStringBlock)cityBlock error:(LocationErrorBlock) errorBlock
{
    isOpen = NO;
    self.cityBlock = [cityBlock copy];
    self.errorBlock = [errorBlock copy];
    [self startLocation];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    CLLocation * newLocation = userLocation.location;
    self.lastCoordinate = newLocation.coordinate;
    
    NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
    
    [standard setObject:@(self.lastCoordinate.longitude) forKey:MMLastLongitude];
    [standard setObject:@(self.lastCoordinate.latitude) forKey:MMLastLatitude];
    
    if (_locationBlock) {
        _locationBlock(_lastCoordinate);
        _locationBlock = nil;
    }
    
    if (!isNeedCity) {
        return;
    }
    
    
    CLGeocoder *clGeoCoder = [[CLGeocoder alloc] init];
    CLGeocodeCompletionHandler handle = ^(NSArray *placemarks,NSError *error)
    {
        //NSLog(@"定位城市");
        for (CLPlacemark * placeMark in placemarks)
        {
            NSDictionary *addressDic=placeMark.addressDictionary;
            
            NSString *state=[addressDic objectForKey:@"State"];
            NSString *city=[addressDic objectForKey:@"City"];
            NSString *subLocality=[addressDic objectForKey:@"SubLocality"];
            NSString *street=[addressDic objectForKey:@"Street"];
            
            self.lastCity = city;
            self.lastAddress=[NSString stringWithFormat:@"%@%@%@%@",state,city,subLocality,street];
            
            [standard setObject:self.lastCity forKey:MMLastCity];
            [standard setObject:self.lastAddress forKey:MMLastAddress];
            
            [self stopLocation];
        }
        
        if (_cityBlock) {
            _cityBlock(_lastCity);
            _cityBlock = nil;
        }
        
        if (_addressBlock) {
            _addressBlock(_lastAddress);
            _addressBlock = nil;
        }
    };
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [clGeoCoder reverseGeocodeLocation:newLocation completionHandler:handle];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    //NSLog(@"定位");
    
    if (_locationManager) {
        [_locationManager stopUpdatingLocation];
        _locationManager = nil;
    }
    
    CLLocation * newLocation = locations.lastObject;
    self.lastCoordinate = newLocation.coordinate;
    
    NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
    
    [standard setObject:@(self.lastCoordinate.longitude) forKey:MMLastLongitude];
    [standard setObject:@(self.lastCoordinate.latitude) forKey:MMLastLatitude];
    
    if (_locationBlock) {
        _locationBlock(_lastCoordinate);
        _locationBlock = nil;
    }
    
    if (!isNeedCity) {
        return;
    }
    
    
    CLGeocoder *clGeoCoder = [[CLGeocoder alloc] init];
    CLGeocodeCompletionHandler handle = ^(NSArray *placemarks,NSError *error)
    {
        
        NSInteger i = 0;
        for (CLPlacemark * placeMark in placemarks)
        {
            i++;
            NSDictionary *addressDic=placeMark.addressDictionary;
            
            NSString *state=[addressDic objectForKey:@"State"];
            NSString *city=[addressDic objectForKey:@"City"];
            NSString *subLocality=[addressDic objectForKey:@"SubLocality"];
            NSString *street=[addressDic objectForKey:@"Street"];
            
            self.lastCity = city;
            self.lastAddress=[NSString stringWithFormat:@"%@%@%@%@",state,city,subLocality,street];
            
            [standard setObject:self.lastCity forKey:MMLastCity];
            [standard setObject:self.lastAddress forKey:MMLastAddress];
            
            [self stopLocation];
        }
        
        
        if (_cityBlock) {
            _cityBlock(_lastCity);
            _cityBlock = nil;
        }
        
        if (_addressBlock) {
            _addressBlock(_lastAddress);
            _addressBlock = nil;
        }
    };
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [clGeoCoder reverseGeocodeLocation:newLocation completionHandler:handle];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    
    NSLog(@"定位失败");
    
    if (_locationBlock) {
        _locationBlock(CLLocationCoordinate2DMake(0, 0));
        _locationBlock = nil;
    }
    if (_cityBlock) {
        _cityBlock(@"成都");
        _cityBlock = nil;
    }
    
    if (_locationManager) {
        [_locationManager stopUpdatingLocation];
        _locationManager = nil;
    }
    
    if (error.code == kCLErrorDenied) {
        // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
        if (!isOpen) {
            isOpen = YES;
            if (IOS8){
                UIAlertView *tempA = [[UIAlertView alloc]initWithTitle:@"提示" message:@"未开启定位服务，现在开启！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [tempA show];
            }
            else{
                UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"定位服务未开启" message:@"请在设置－>隐私－>定位服务开启定位服务！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
            }
        }
        
    }
    else {
//        UIAlertView *tempA = [[UIAlertView alloc]initWithTitle:@"提醒" message:@"定位失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [tempA show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    NSLog(@"aaiiii = %d",status);
    
    switch (status) {
            
            
        case kCLAuthorizationStatusDenied :
        {
            // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
            
            if (_locationBlock) {
                _locationBlock(CLLocationCoordinate2DMake(0, 0));
                _locationBlock = nil;
            }
            if (_cityBlock) {
                _cityBlock(@"");
                _cityBlock = nil;
            }
            
            if (!isOpen) {
                isOpen = YES;
                if (IOS8){
                    UIAlertView *tempA = [[UIAlertView alloc]initWithTitle:@"提示" message:@"未开启定位服务，现在开启！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    [tempA show];
                }
                else{
                    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"定位服务未开启" message:@"请在设置－>隐私－>定位服务开启定位服务！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertView show];
                }
            }
            
        }
            break;
        case kCLAuthorizationStatusAuthorizedAlways :
            NSLog(@"==========");
            if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
            {
                NSLog(@"调用");
                
                [_locationManager requestAlwaysAuthorization];
            }
            break;
        case kCLAuthorizationStatusRestricted:
        {
            // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
            UIAlertView *tempA = [[UIAlertView alloc]initWithTitle:@"提醒" message:@"定位服务无法使用！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [tempA show];
            
            if (_locationBlock) {
                _locationBlock(CLLocationCoordinate2DMake(0, 0));
                _locationBlock = nil;
            }
            if (_cityBlock) {
                _cityBlock(@"成都");
                _cityBlock = nil;
            }
        }
        default:
            
            break;
    }
}

-(void)startLocation
{
    if (IOS8){
        if(_locationManager){
            _locationManager = nil;
        }
        //地图定位
        _locationManager = [[CLLocationManager alloc]init];
        [_locationManager requestAlwaysAuthorization];
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;//最好的定位
        _locationManager.distanceFilter = kCLDistanceFilterNone;//设置最小距离
        _locationManager.delegate = self;
        [_locationManager startUpdatingLocation];//更新定位
    }
    else{
        if (_mapView) {
            _mapView = nil;
        }
        _mapView = [[MKMapView alloc] init];
        _mapView.delegate = self;
        _mapView.showsUserLocation = YES;
    }
    
}

-(void)stopLocation
{
    _mapView.showsUserLocation = NO;
    _mapView = nil;
}

- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    [self stopLocation];
}

@end

//
//  lhGPS.m
//  GasStation
//
//  Created by bosheng on 15/8/19.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import "lhGPS.h"
#import <AudioToolbox/AudioToolbox.h>

#import "SharedMapView.h"
#import "Toast+UIView.h"

@implementation lhGPS

+ (instancetype)sharedInstanceGPS
{
    static lhGPS * sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[lhGPS alloc] init];
    });
    
    return sharedInstance;
}

- (void)prepareData:(UIViewController *)tempVC startLocation:(CLLocationCoordinate2D)startCoord endLocation:(CLLocationCoordinate2D)endCoord
{
    self.tempV = tempVC;
    
    _startPoint = [AMapNaviPoint locationWithLatitude:startCoord.latitude longitude:startCoord.longitude];
    _endPoint   = [AMapNaviPoint locationWithLatitude:endCoord.latitude longitude:endCoord.longitude];
    
    [self initMapView];
    
    [self initNaviManager];
    
    [self initIFlySpeech];
    
    [self initNaviViewController];
}

- (void)startNaviGPS
{
    [self startGPSNavi];//开始导航
}

#pragma mark - Button Action

- (void)startGPSNavi
{
    // 算路
    [self calculateRoute];
}

- (void)calculateRoute
{
    NSArray *startPoints = @[_startPoint];
    NSArray *endPoints   = @[_endPoint];
    
    if(![self.naviManager calculateDriveRouteWithStartPoints:startPoints endPoints:endPoints wayPoints:nil drivingStrategy:0]){//路径计算失败
        [lhColor showAlertWithMessage:@"路径计算失败~" withSuperView:self.tempV.view withHeih:DeviceMaxHeight/2];
        [lhColor disAppearActivitiView:self.tempV.view];
    }
    
}

#pragma mark - Initialized

- (void)initMapView
{
    if (self.mapView == nil)
    {
        self.mapView = [[SharedMapView sharedInstance] mapView];
    }
    
    [[SharedMapView sharedInstance] stashMapViewStatus];
    
    self.mapView.frame = [UIScreen mainScreen].bounds;
    
    self.mapView.delegate = self;
}

- (void)initNaviManager
{
    if (self.naviManager == nil)
    {
        _naviManager = [[AMapNaviManager alloc] init];
    }
    
    self.naviManager.delegate = self;
}

- (void)initIFlySpeech
{
    if (self.iFlySpeechSynthesizer == nil)
    {
        _iFlySpeechSynthesizer = [IFlySpeechSynthesizer sharedInstance];
    }
    
    _iFlySpeechSynthesizer.delegate = self;
}

#pragma mark - Handle Action
- (void)returnAction
{
    [self clearMapView];
}

#pragma mark - Utility

- (void)clearMapView
{
    self.mapView.showsUserLocation = NO;
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    [self.mapView removeOverlays:self.mapView.overlays];
    
    self.mapView.delegate = nil;
    
    [[SharedMapView sharedInstance] popMapViewStatus];
}

#pragma mark - Init & Construct

- (void)initNaviViewController
{
    if (_naviViewController == nil)
    {
        _naviViewController = [[AMapNaviViewController alloc] initWithMapView:self.mapView delegate:self];
    }
}

#pragma mark - AMapNaviManager Delegate

- (void)naviManager:(AMapNaviManager *)naviManager error:(NSError *)error
{
    [lhColor disAppearActivitiView:self.tempV.view];
    //NSLog(@"error:{%@}",error.localizedDescription);
}

- (void)naviManager:(AMapNaviManager *)naviManager didPresentNaviViewController:(UIViewController *)naviViewController
{
    
    [self.naviManager startGPSNavi];
    
    //NSLog(@"didPresentNaviViewController");
}

- (void)naviManager:(AMapNaviManager *)naviManager didDismissNaviViewController:(UIViewController *)naviViewController
{
    NSString * classStr = [NSString stringWithFormat:@"%@",[self.tempV class]];
    if ([@"lhMainViewController" isEqualToString:classStr]) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    }
    //NSLog(@"didDismissNaviViewController");
}

- (void)naviManagerOnCalculateRouteSuccess:(AMapNaviManager *)naviManager
{
    //NSLog(@"OnCalculateRouteSuccess");
    
    [lhColor disAppearActivitiView:self.tempV.view];
    [self.naviManager presentNaviViewController:self.naviViewController animated:YES];
    
}

- (void)naviManager:(AMapNaviManager *)naviManager onCalculateRouteFailure:(NSError *)error
{
    //NSLog(@"onCalculateRouteFailure");
    [lhColor disAppearActivitiView:self.tempV.view];
    
    [lhColor showAlertWithMessage:@"算路失败~" withSuperView:self.tempV.view withHeih:DeviceMaxHeight/2];
    
//    [self.tempV.view makeToast:@"算路失败"
//                duration:2.0
//                position:[NSValue valueWithCGPoint:CGPointMake(160, 240)]];
    
}

- (void)naviManagerNeedRecalculateRouteForYaw:(AMapNaviManager *)naviManager
{
    //NSLog(@"NeedReCalculateRouteForYaw");
}

- (void)naviManager:(AMapNaviManager *)naviManager didStartNavi:(AMapNaviMode)naviMode
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    //NSLog(@"didStartNavi");
}

- (void)naviManagerDidEndEmulatorNavi:(AMapNaviManager *)naviManager
{
//    //NSLog(@"DidEndEmulatorNavi");
}

- (void)naviManagerOnArrivedDestination:(AMapNaviManager *)naviManager
{
//    //NSLog(@"OnArrivedDestination");
}

- (void)naviManager:(AMapNaviManager *)naviManager onArrivedWayPoint:(int)wayPointIndex
{
//    //NSLog(@"onArrivedWayPoint");
}

- (void)naviManager:(AMapNaviManager *)naviManager didUpdateNaviLocation:(AMapNaviLocation *)naviLocation
{
//        //NSLog(@"didUpdateNaviLocation");
}

- (void)naviManager:(AMapNaviManager *)naviManager didUpdateNaviInfo:(AMapNaviInfo *)naviInfo
{
//        //NSLog(@"didUpdateNaviInfo");
}

- (BOOL)naviManagerGetSoundPlayState:(AMapNaviManager *)naviManager
{
//        //NSLog(@"GetSoundPlayState");
    
    return 0;
}

- (void)naviManager:(AMapNaviManager *)naviManager playNaviSoundString:(NSString *)soundString soundStringType:(AMapNaviSoundType)soundStringType
{
    //NSLog(@"playNaviSoundString:{%ld:%@}", (long)soundStringType, soundString);
    
    if (soundStringType == AMapNaviSoundTypePassedReminder)
    {
        //用系统自带的声音做简单例子，播放其他提示音需要另外配置
        AudioServicesPlaySystemSound(1009);
    }
    else
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [_iFlySpeechSynthesizer startSpeaking:soundString];
        });
    }
}

- (void)naviManagerDidUpdateTrafficStatuses:(AMapNaviManager *)naviManager
{
    //NSLog(@"DidUpdateTrafficStatuses");
}

#pragma mark - AManNaviViewController Delegate
- (void)naviViewControllerCloseButtonClicked:(AMapNaviViewController *)naviViewController
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [self.iFlySpeechSynthesizer stopSpeaking];
    });
    
    [self.naviManager stopNavi];
    
    [self.naviManager dismissNaviViewControllerAnimated:YES];
}

- (void)naviViewControllerMoreButtonClicked:(AMapNaviViewController *)naviViewController
{
    if (self.naviViewController.viewShowMode == AMapNaviViewShowModeCarNorthDirection)
    {
        self.naviViewController.viewShowMode = AMapNaviViewShowModeMapNorthDirection;
    }
    else
    {
        self.naviViewController.viewShowMode = AMapNaviViewShowModeCarNorthDirection;
    }
}

- (void)naviViewControllerTurnIndicatorViewTapped:(AMapNaviViewController *)naviViewController
{
    [self.naviManager readNaviInfoManual];
}

#pragma mark - iFlySpeechSynthesizer Delegate

- (void)onCompleted:(IFlySpeechError *)error
{
    //NSLog(@"Speak Error:{%d:%@}", error.errorCode, error.errorDesc);
}

@end

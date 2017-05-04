//
//  lhGPS.h
//  GasStation
//
//  Created by bosheng on 15/8/19.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AMapNaviKit/MAMapKit.h>
#import <AMapNaviKit/AMapNaviKit.h>
#import "iflyMSC/IFlySpeechSynthesizer.h"
#import "iflyMSC/IFlySpeechSynthesizerDelegate.h"

@interface lhGPS : NSObject<MAMapViewDelegate,AMapNaviManagerDelegate,IFlySpeechSynthesizerDelegate,AMapNaviViewControllerDelegate>

@property (nonatomic, weak) MAMapView *mapView;

@property (nonatomic, strong) AMapNaviManager *naviManager;

@property (nonatomic, strong) IFlySpeechSynthesizer *iFlySpeechSynthesizer;

@property (nonatomic, strong) AMapNaviViewController * naviViewController;

@property (nonatomic, strong) AMapNaviPoint * startPoint;
@property (nonatomic, strong) AMapNaviPoint * endPoint;

@property (nonatomic, strong) UIViewController * tempV;

+ (instancetype)sharedInstanceGPS;
- (void)prepareData:(UIViewController *)tempVC startLocation:(CLLocationCoordinate2D)startCoord endLocation:(CLLocationCoordinate2D)endCoord;
- (void)startNaviGPS;
- (void)returnAction;

@end

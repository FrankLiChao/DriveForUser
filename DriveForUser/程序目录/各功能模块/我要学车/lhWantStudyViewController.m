//
//  lhWantStudyViewController.m
//  Drive
//
//  Created by bosheng on 15/7/27.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import "lhWantStudyViewController.h"
#import "MMLocationManager.h"
#import "lhMineAnnotationView.h"
#import "lhCarAnnotationView.h"
#import "lhSchoolAnnotationView.h"
#import "lhCustomPointAnnotation.h"
#import "lhSymbolCustumButton.h"
#import "lhDriverDetailViewController.h"
#import "lhDriverListTableViewCell.h"
#import "FrankSchoolListTableViewCell.h"
#import "lhStudyGuideViewController.h"
#import "MJRefresh.h"
#import "FrankSchoolDetailView.h"
//#import "TQStarRatingView.h"
#import "UIImageView+WebCache.h"
#import "FrankSchoolDetailView.h"
#import "FrankCoachListView.h"
#import "FrankSchoolListView.h"
#import <MapKit/MapKit.h>
#import "lhGPS.h"

#define defaultZoomLevel 0.130 //地图默认放大等级
#define minZoomLevel 0.002 //地图最小放大等级
#define maxZoomLevel 150 //地图最大放大等级

@interface lhWantStudyViewController ()<MKMapViewDelegate>
{
    MKMapView * stuMapView;//地图查看找教练
    lhSymbolCustumButton * scBtn;//找教练按钮
    lhSymbolCustumButton * scBtn1;//找驾校按钮
    NSMutableSet * carArray1;
    NSMutableSet        * carArray;//存储车大头针，使用set避免重复添加
    NSMutableSet        * schoolArray;//存储学校大头针
    NSMutableSet        * schoolArray1;
    NSMutableSet        * addrArray;
    CGFloat             lastZoomLevel;//记录上一次的地图放大等级
    BOOL                isUserMoveMap;//用户移动地图
    
    UIView              * listLookView;//列表查看找教练
    UIImageView         * symbImgView;//排序标识箭头
    UIView              * symbLeftLine;//左边线条
    UIView              * symbRightLine;//右边线条
    UITableView         * listLookTableView;//列表查看表格
    
    BOOL                isFirst;//第一次初始化
    NSInteger           coachOrSchool;  //用于标示找教练还是找驾校（1：标示找教练，2:标示找驾校）
    UIView              * listLookschool;  //列表查看驾校
//    NSDictionary * coachDic;    //教练列表信息
    
    lhCarAnnotationView * tempCaView;//存储当前点开的大头针
    NSMutableString     *schIdStr;
    NSString            *coachIdStr;
    NSArray             *gdCoachArray;  //高德地图的教练数据
    NSArray             *gdSchArray;    //高德驾校数据
}

@end

@implementation lhWantStudyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self firmInit];
    [[lhColor shareColor]originalInit:self title:@"找教练" imageName:nil backButton:YES];
    lhSymbolCustumButton * cBtn1 = [[lhSymbolCustumButton alloc]initWithFrame:CGRectMake(DeviceMaxWidth-60, 20, 51, 44)];
    [cBtn1 setBackgroundImage:imageWithName(@"studyGuideIcon") forState:UIControlStateNormal];
    cBtn1.tLabel.text = @"学车指南";
    [cBtn1 addTarget:self action:@selector(studyGuideEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cBtn1];
    [self addFixedAnnotation];
}

-(void)initData{
    carArray = [NSMutableSet set];
    schoolArray = [NSMutableSet set];
    carArray1 = [NSMutableSet set];
    schoolArray1 = [NSMutableSet set];
    addrArray = [NSMutableSet set];
    coachOrSchool = 1;
    isFirst = YES;
    isUserMoveMap = NO;
    lastZoomLevel = defaultZoomLevel;
}

//创建地图默认标点
-(void)addFixedAnnotation
{   
    NSDictionary * temD8 = @{@"x":@"30.709127",@"y":@"108.346281"};
    CLLocationCoordinate2D c = [self coordinateAccordingXY:temD8];
    [self locationToAPoint:c];
    [self addAnnotationa:c title:@"" positionStr:@"" withType:MINE_ANNOTATIN withTag:1111];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - touch
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch * touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.view];
//
//    //点击图标备注
//    //点击了事件，点击查看详情或点击导航
//    if (tempCaView) {
//        //点击的点当前的图标生效,避免覆盖无法点击
//        CGRect sRect = tempCaView.carBtn.superview.frame;
//        
//        //导航按钮区域
//        CGRect nRect = CGRectMake(sRect.origin.x+tempCaView.leftBtn.frame.origin.x,sRect.origin.y+tempCaView.leftBtn.frame.origin.y, tempCaView.leftBtn.frame.size.width, tempCaView.leftBtn.frame.size.height);
//        //详情区域
//        CGRect nRect1 = CGRectMake(sRect.origin.x+tempCaView.tImgView.frame.origin.x,sRect.origin.y+tempCaView.tImgView.frame.origin.y, tempCaView.leftBtn.frame.origin.x, tempCaView.tImgView.frame.size.height);
//        //导航区域
//        if (CGRectContainsPoint(nRect, touchPoint)) {
//            [self tapGEvent1:tempCaView.leftBtn];
//            return;
//        }
//        else if (CGRectContainsPoint(nRect1, touchPoint)){
//            [self tapGEventTimg:tempCaView.tImgView];
//            return;
//        }
//    }
    
    NSLog(@"点击");
    //点击图标
    
    if (coachOrSchool == 1) {
        lhCarAnnotationView * temCa = nil;
        for (lhCarAnnotationView * ca in carArray){
            ca.tImgView.hidden = YES;
            ca.carBtn.selected = NO;
            [ca setSelected:NO animated:NO];
            
            //点击的点当前的图标生效,避免覆盖无法点击
            CGRect sRect = ca.carBtn.superview.frame;
            CGRect nRect = CGRectMake(sRect.origin.x+ca.carBtn.frame.origin.x, sRect.origin.y+ca.carBtn.frame.origin.y, ca.carBtn.frame.size.width, ca.carBtn.frame.size.height);
            if (CGRectContainsPoint(nRect, touchPoint)) {
                temCa = ca;
            }
        }
        if (temCa) {
            [self tapCarEvent:temCa.carBtn];
        }
        else{
            tempCaView = nil;
        }
    }
    else{
        lhSchoolAnnotationView * temCa = nil;
        for (lhSchoolAnnotationView * ca in schoolArray){
            ca.tImgView.hidden = YES;
            ca.schBtn.selected = NO;
            [ca setSelected:NO animated:NO];
            
            //点击的点当前的图标生效,避免覆盖无法点击
            CGRect sRect = ca.schBtn.superview.frame;
            CGRect nRect = CGRectMake(sRect.origin.x+ca.schBtn.frame.origin.x, sRect.origin.y+ca.schBtn.frame.origin.y, ca.schBtn.frame.size.width, ca.schBtn.frame.size.height);
            if (CGRectContainsPoint(nRect, touchPoint)) {
                temCa = ca;
            }
        }
        if (temCa) {
            [self tapSchoolEvent:temCa.schBtn];
        }
        else{
            tempCaView = nil;
        }
    }
}

- (void)request:(CLLocationCoordinate2D )cc
{
    NSString * nowLocation = [NSString stringWithFormat:@"%.6f,%.6f",cc.longitude,cc.latitude];

//    [lhColor addActivityView:self.view];
    NSDictionary *dic = @{@"tableid":GDMapDriverTableId,
                          @"center":nowLocation,
                          @"radius":@"50000",
                          @"limit":@"20",
                          @"page":@"1",
                          @"key":GDMapKey};
    FLLog(@"dic = %@",dic);
    [FrankNetworkManager postReqeustWithURL:GAODE(@"datasearch/around") params:dic successBlock:^(id returnData){
        FLLog(@"returnData = %@",returnData);
        if ([[returnData objectForKey:@"status"]integerValue] == 1) {
            NSMutableArray * lastMapArray = [[NSMutableArray alloc]initWithArray:mapArray];
            mapArray = [NSArray arrayWithArray:[returnData objectForKey:@"datas"]];
            NSMutableArray * tempDeleteA = [NSMutableArray array];
            NSMutableArray * tempAddA = [NSMutableArray array];
            NSMutableArray * tempAddA1 = [NSMutableArray array];
            for (NSDictionary * oneD in mapArray) {
                for (NSDictionary * o in lastMapArray){
                    if ([[oneD objectForKey:@"_location"] isEqualToString:[o objectForKey:@"_location"]]) {
                        [tempAddA addObject:oneD];
                        [tempAddA1 addObject:o];
                    }
                }
            }
            
            if (tempAddA.count == mapArray.count) {
                return;
            }
            
            [lastMapArray removeObjectsInArray:tempAddA1];
            tempDeleteA = lastMapArray;//之前不等的，即之前需要删除的
            
            NSMutableArray * tempMapArray = [NSMutableArray arrayWithArray:mapArray];
            [tempMapArray removeObjectsInArray:tempAddA];
            NSArray * addA = tempMapArray;//现在不等的，即现在需要添加的
            
            NSMutableArray * deleteAnno1 = [NSMutableArray array];//需要删除的大头针
            NSMutableArray * deleteAnno = [NSMutableArray array];//需要删除的大头针
            for (lhCustomPointAnnotation * cpa in carArray1){
                for (NSDictionary * one in tempDeleteA) {
                    CLLocationCoordinate2D tempC = [lhColor coordWithLocationStr:[one objectForKey:@"_location"]];
                    if (cpa.coordinate.latitude == tempC.latitude && cpa.coordinate.longitude == tempC.longitude) {
                        [deleteAnno1 addObject:cpa];
                    }
                }
            }
            for (lhCustomPointAnnotation * cpa in carArray){
                for (NSDictionary * one in tempDeleteA) {
                    CLLocationCoordinate2D tempC = [lhColor coordWithLocationStr:[one objectForKey:@"_location"]];
                    if (cpa.coordinate.latitude == tempC.latitude && cpa.coordinate.longitude == tempC.longitude) {
                        [deleteAnno addObject:cpa];
                    }
                }
            }
            
            //删除大头针
            [stuMapView removeAnnotations:deleteAnno1];
            [stuMapView removeAnnotations:deleteAnno];
            NSLog(@"deleteAnno = %@\ndeleteAnno1 = %@",deleteAnno,deleteAnno1);
            
            //删除数组中存储的大头针
            NSMutableArray * carA = [NSMutableArray arrayWithArray:[carArray allObjects]];
            NSMutableArray * carB = [NSMutableArray arrayWithArray:[carArray1 allObjects]];
            
            [carB removeObjectsInArray:deleteAnno1];
            [carA removeObjectsInArray:deleteAnno];
            
            carArray = [NSMutableSet setWithArray:carA];
            carArray1 = [NSMutableSet setWithArray:carB];
            
            [self addAnno:addA];
        }else{
            [FrankTools requestFailAlertShow:[returnData objectForKey:@"msg"]];
        }
    } failureBlock:^(NSError *error) {
        FLLog(@"%@",error.localizedDescription);
        [FrankTools wangluoAlertShow];
    } showHUD:NO];
}

- (void)getData:(NSNotification *)noti
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:noti.name object:nil];
    if (!noti.userInfo || [noti.userInfo class] == [[NSNull alloc]class]) {
        
        [lhColor wangluoAlertShow];
        
    }
    if ([[noti.userInfo objectForKey:@"status"]integerValue] == 1) {
        
        NSMutableArray * lastMapArray = [[NSMutableArray alloc]initWithArray:mapArray];
        mapArray = [NSArray arrayWithArray:[noti.userInfo objectForKey:@"datas"]];
        NSMutableArray * tempDeleteA = [NSMutableArray array];
        NSMutableArray * tempAddA = [NSMutableArray array];
        NSMutableArray * tempAddA1 = [NSMutableArray array];
        for (NSDictionary * oneD in mapArray) {
            for (NSDictionary * o in lastMapArray){
                if ([[oneD objectForKey:@"_location"] isEqualToString:[o objectForKey:@"_location"]]) {
                    [tempAddA addObject:oneD];
                    [tempAddA1 addObject:o];
                }
            }
        }
        
        if (tempAddA.count == mapArray.count) {
            return;
        }
        
        [lastMapArray removeObjectsInArray:tempAddA1];
        tempDeleteA = lastMapArray;//之前不等的，即之前需要删除的
        
        NSMutableArray * tempMapArray = [NSMutableArray arrayWithArray:mapArray];
        [tempMapArray removeObjectsInArray:tempAddA];
        NSArray * addA = tempMapArray;//现在不等的，即现在需要添加的
        
        NSMutableArray * deleteAnno1 = [NSMutableArray array];//需要删除的大头针
        NSMutableArray * deleteAnno = [NSMutableArray array];//需要删除的大头针
        for (lhCustomPointAnnotation * cpa in carArray1){
            for (NSDictionary * one in tempDeleteA) {
                CLLocationCoordinate2D tempC = [lhColor coordWithLocationStr:[one objectForKey:@"_location"]];
                if (cpa.coordinate.latitude == tempC.latitude && cpa.coordinate.longitude == tempC.longitude) {
                    [deleteAnno1 addObject:cpa];
                }
            }
        }
        for (lhCustomPointAnnotation * cpa in carArray){
            for (NSDictionary * one in tempDeleteA) {
                CLLocationCoordinate2D tempC = [lhColor coordWithLocationStr:[one objectForKey:@"_location"]];
                if (cpa.coordinate.latitude == tempC.latitude && cpa.coordinate.longitude == tempC.longitude) {
                    [deleteAnno addObject:cpa];
                }
            }
        }
        
        //删除大头针
        [stuMapView removeAnnotations:deleteAnno1];
        [stuMapView removeAnnotations:deleteAnno];
        NSLog(@"deleteAnno = %@\ndeleteAnno1 = %@",deleteAnno,deleteAnno1);
        
        //删除数组中存储的大头针
        NSMutableArray * carA = [NSMutableArray arrayWithArray:[carArray allObjects]];
        NSMutableArray * carB = [NSMutableArray arrayWithArray:[carArray1 allObjects]];
        
        [carB removeObjectsInArray:deleteAnno1];
        [carA removeObjectsInArray:deleteAnno];
        
        carArray = [NSMutableSet setWithArray:carA];
        carArray1 = [NSMutableSet setWithArray:carB];
        
        [self addAnno:addA];
    }
}

-(NSArray *)relocationAnnotation:(NSMutableArray *)lastSchoolArray{
    NSMutableArray * tempDeleteA = [NSMutableArray array];
    NSMutableArray * tempAddA = [NSMutableArray array];
    NSMutableArray * tempAddA1 = [NSMutableArray array];
    for (NSDictionary * oneD in gdSchArray) {
        for (NSDictionary * o in lastSchoolArray){
            if ([[oneD objectForKey:@"_location"] isEqualToString:[o objectForKey:@"_location"]]) {
                [tempAddA addObject:oneD];
                [tempAddA1 addObject:o];
            }
        }
    }
    
    if (tempAddA.count == gdSchArray.count) {
        return nil;
    }
    
    [lastSchoolArray removeObjectsInArray:tempAddA1];
    tempDeleteA = lastSchoolArray;//之前不等的，即之前需要删除的
    
    NSMutableArray * tempMapArray = [NSMutableArray arrayWithArray:gdSchArray];
    [tempMapArray removeObjectsInArray:tempAddA];
    NSArray * addA = tempMapArray;//现在不等的，即现在需要添加的
    
    NSMutableArray * deleteAnno1 = [NSMutableArray array];//需要删除的大头针
    NSMutableArray * deleteAnno = [NSMutableArray array];//需要删除的大头针
    for (lhCustomPointAnnotation * cpa in schoolArray1){
        for (NSDictionary * one in tempDeleteA) {
            CLLocationCoordinate2D tempC = [lhColor coordWithLocationStr:[one objectForKey:@"_location"]];
            if (cpa.coordinate.latitude == tempC.latitude && cpa.coordinate.longitude == tempC.longitude) {
                [deleteAnno1 addObject:cpa];
            }
        }
    }
    for (lhCustomPointAnnotation * cpa in schoolArray){
        for (NSDictionary * one in tempDeleteA) {
            CLLocationCoordinate2D tempC = [lhColor coordWithLocationStr:[one objectForKey:@"_location"]];
            if (cpa.coordinate.latitude == tempC.latitude && cpa.coordinate.longitude == tempC.longitude) {
                [deleteAnno addObject:cpa];
            }
        }
    }
    
    //删除大头针
    [stuMapView removeAnnotations:deleteAnno1];
    [stuMapView removeAnnotations:deleteAnno];
    
    //删除数组中存储的大头针
    NSMutableArray * carA = [NSMutableArray arrayWithArray:[schoolArray allObjects]];
    NSMutableArray * carB = [NSMutableArray arrayWithArray:[schoolArray1 allObjects]];
    
    [carB removeObjectsInArray:deleteAnno1];
    [carA removeObjectsInArray:deleteAnno];
    
    schoolArray = [NSMutableSet setWithArray:carA];
    schoolArray1 = [NSMutableSet setWithArray:carB];
    
    return addA;
}

-(void)requestSchoolForMap:(CLLocationCoordinate2D )cc{
    NSString *nowLocation = [NSString stringWithFormat:@"%.6f,%.6f",cc.longitude,cc.latitude];
    NSDictionary *dic = @{@"tableid":GDMapSchoolTableId,
                          @"center":nowLocation,
                          @"radius":@"50000",
                          @"limit":@"10",
                          @"page":@"1",
                          @"key":GDMapKey};
    [FrankNetworkManager postReqeustWithURL:GAODE(@"datasearch/around") params:dic successBlock:^(id returnData){
        if ([[returnData objectForKey:@"status"]integerValue] == 1) {
            gdSchArray = [returnData objectForKey:@"datas"];
            NSLog(@"gdSchArray = %@",gdSchArray);
            schIdStr = [[NSMutableString alloc] init];
            for (int i=0; i < [gdSchArray count]; i++) {
                [schIdStr appendString:[NSString stringWithFormat:@"%@",[[gdSchArray objectAtIndex:i] objectForKey:@"driving_id"]]];
                [schIdStr appendString:@","];
                NSDictionary * oneDic = [NSDictionary dictionaryWithDictionary:[gdSchArray objectAtIndex:i]];
                NSString * locationStr = [NSString stringWithFormat:@"%@",[oneDic objectForKey:@"_location"]];
                NSRange range = [locationStr rangeOfString:@","];
                if (range.length) {
                    NSString * latitudeStr = [locationStr substringFromIndex:range.location+1];
                    NSString * longitudeStr = [locationStr substringToIndex:range.location];
                    NSDictionary * temD = @{@"x":latitudeStr,@"y":longitudeStr};
                    
                    [self addAnnotationa:[self coordinateAccordingXY:temD] title:@"车位置" positionStr:@"位置信息" withType:SCHOOL_ANNOTATION withTag:i];
                }
            }
        }else{
            [FrankTools requestFailAlertShow:[returnData objectForKey:@"msg"]];
        }
    } failureBlock:^(NSError *error) {
        FLLog(@"%@",error.localizedDescription);
        [FrankTools wangluoAlertShow];
    } showHUD:NO];
}

- (void)addAnno:(NSArray *)annoArray
{
    NSMutableString * str = [NSMutableString string];
    NSLog(@"annoArray = %@",annoArray);
    gdCoachArray = [[NSArray alloc] initWithArray:annoArray];
    for (int i=0; i < annoArray.count; i++) {
        NSDictionary * oneDic = [NSDictionary dictionaryWithDictionary:[annoArray objectAtIndex:i]];
        NSString * locationStr = [NSString stringWithFormat:@"%@",[oneDic objectForKey:@"_location"]];
        NSRange range = [locationStr rangeOfString:@","];
        if (range.length) {
            NSString * latitudeStr = [locationStr substringFromIndex:range.location+1];
            NSString * longitudeStr = [locationStr substringToIndex:range.location];
            NSDictionary * temD = @{@"x":latitudeStr,@"y":longitudeStr};
            
            [self addAnnotationa:[self coordinateAccordingXY:temD] title:@"车位置" positionStr:@"位置信息" withType:CAR_ANNOTATION withTag:i];
            [str appendString:[NSString stringWithFormat:@"%@",[oneDic objectForKey:@"coach_id"]]];
            if (i < annoArray.count-1) {
                [str appendString:@","];
            }
        }
    }
    coachIdStr = [[NSString alloc] init];
    coachIdStr = [NSString stringWithFormat:@"%@",str];
}

#pragma mark - firmInit
- (void)firmInit
{
    stuMapView = [[MKMapView alloc]initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, DeviceMaxHeight)];
    stuMapView.rotateEnabled = NO;
    stuMapView.zoomEnabled = YES;
    stuMapView.mapType = MKMapTypeStandard;
    stuMapView.delegate = self;
    stuMapView.showsUserLocation = YES;
    [self.view addSubview:stuMapView];
    
    //右侧定位与放大缩小
    UIButton * scaleBigBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    scaleBigBtn.frame = CGRectMake(DeviceMaxWidth-40*widthRate, DeviceMaxHeight-49-75*widthRate, 30*widthRate, 30*widthRate);
    [scaleBigBtn setBackgroundImage:imageWithName(@"scaleToBig") forState:UIControlStateNormal];
    [scaleBigBtn addTarget:self action:@selector(scaleBigBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    [stuMapView addSubview:scaleBigBtn];
    
    UIButton * scaleSmallBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    scaleSmallBtn.frame = CGRectMake(DeviceMaxWidth-40*widthRate, DeviceMaxHeight-49-45*widthRate, 30*widthRate, 30*widthRate);
    [scaleSmallBtn setBackgroundImage:imageWithName(@"scaleToSmall") forState:UIControlStateNormal];
    [scaleSmallBtn addTarget:self action:@selector(scaleSmallBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    [stuMapView addSubview:scaleSmallBtn];
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(DeviceMaxWidth-37*widthRate, DeviceMaxHeight-49-45*widthRate, 24*widthRate, 0.5)];
    lineView.backgroundColor = [lhColor colorFromHexRGB:contentTitleColorStr1];
    [stuMapView addSubview:lineView];
    
    UIButton * locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    locationBtn.backgroundColor = [UIColor whiteColor];
    locationBtn.frame = CGRectMake(DeviceMaxWidth-40*widthRate, DeviceMaxHeight-49-110*widthRate, 30*widthRate, 30*widthRate);
    [locationBtn setBackgroundImage:imageWithName(@"locationToMyAddress") forState:UIControlStateNormal];
    locationBtn.layer.masksToBounds = YES;
    locationBtn.layer.cornerRadius = 3;
    locationBtn.layer.allowsEdgeAntialiasing = YES;
    [locationBtn addTarget:self action:@selector(locationBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    [stuMapView addSubview:locationBtn];
    
    UIButton *myGasStation = [UIButton buttonWithType:UIButtonTypeCustom];
    myGasStation.backgroundColor = [UIColor whiteColor];
    myGasStation.frame = CGRectMake(DeviceMaxWidth-40*widthRate, DeviceMaxHeight-49-145*widthRate, 30*widthRate, 30*widthRate);
    [myGasStation setBackgroundImage:imageWithName(@"xuecheList") forState:UIControlStateNormal];
    myGasStation.layer.masksToBounds = YES;
    myGasStation.layer.cornerRadius = 3;
    myGasStation.layer.allowsEdgeAntialiasing = YES;
    [myGasStation addTarget:self action:@selector(listDisplayIconEvent:) forControlEvents:UIControlEventTouchUpInside];
    [stuMapView addSubview:myGasStation];
    
    UIImageView * imgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, DeviceMaxHeight-54, DeviceMaxWidth-20, 44)];
    imgView.userInteractionEnabled = YES;
    imgView.image = imageWithName(@"studyLowBg");
    [self.view addSubview:imgView];
    
    scBtn = [[lhSymbolCustumButton alloc]initWithFrame1:CGRectMake(DeviceMaxWidth/4-40.5, 0, 51, 44)];
    scBtn.tLabel.text = @"找教练";
    scBtn.tLabel.textColor = [lhColor colorFromHexRGB:mainColorStr];
    [scBtn setBackgroundImage:imageWithName(@"studyFindDriver") forState:UIControlStateNormal];
    [scBtn setBackgroundImage:imageWithName(@"studyFindDriver_S") forState:UIControlStateSelected];
    [scBtn addTarget:self action:@selector(coachBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    [imgView addSubview:scBtn];
    scBtn.selected = YES;
    
    scBtn1 = [[lhSymbolCustumButton alloc]initWithFrame1:CGRectMake(DeviceMaxWidth/4*3-45.5, 0, 51, 44)];
    scBtn1.tLabel.text = @"找驾校";
    scBtn1.tLabel.textColor = [lhColor colorFromHexRGB:@"777777"];
    [scBtn1 setBackgroundImage:imageWithName(@"studyFindSchool") forState:UIControlStateNormal];
    [scBtn1 setBackgroundImage:imageWithName(@"studyFindSchool_S") forState:UIControlStateSelected];
    [scBtn1 addTarget:self action:@selector(schoolBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    [imgView addSubview:scBtn1];
/*
    [[lhColor shareColor]locationAddress:^(CLLocationCoordinate2D locationCorrrdinate) {
        
        [self locationToAPoint:locationCorrrdinate];
        [self addAnnotationa:locationCorrrdinate title:@"" positionStr:@"" withType:MINE_ANNOTATIN withTag:1111];
        
        [self request:locationCorrrdinate];

    }];
*/
    /*
    NSDictionary * temD8 = @{@"x":@"30.545719",@"y":@"104.062918"};
    CLLocationCoordinate2D c = [self coordinateAccordingXY:temD8];
    [self locationToAPoint:c withType:MINE_ANNOTATIN];
    [self addAnnotationa:c title:@"" positionStr:@"" withType:MINE_ANNOTATIN withTag:1111];
    [self request:c];
    */
    MKCoordinateRegion region = MKCoordinateRegionMake(DefaultCoordnate, MKCoordinateSpanMake(lastZoomLevel, lastZoomLevel));
    [stuMapView setRegion:[stuMapView regionThatFits:region] animated:NO];
    
    [[lhColor shareColor]locationAddress:^(CLLocationCoordinate2D locationCorrrdinate) {
        [lhColor shareColor].nowLocation = locationCorrrdinate;
        isUserMoveMap = YES;
        [self locationToAPoint:locationCorrrdinate];
        [self request:locationCorrrdinate];
    }];
    
}

#pragma mark -定位
- (CLLocationCoordinate2D)coordinateAccordingXY:(NSDictionary *)temD
{
    CGFloat x = [[temD objectForKey:@"x"]floatValue];
    CGFloat y = [[temD objectForKey:@"y"]floatValue];
    
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(x,y);
    return coord;
}

- (void)locationBtnEvent
{
    [[lhColor shareColor]locationAddress:^(CLLocationCoordinate2D locationCorrrdinate) {
        
        if (kCLAuthorizationStatusDenied == [CLLocationManager authorizationStatus] ||
            kCLAuthorizationStatusRestricted == [CLLocationManager authorizationStatus]) {
            
        }
        else{
            isUserMoveMap = YES;
            [self locationToAPoint:locationCorrrdinate];
        }
        
    }];
}


//放大
- (void)scaleBigBtnEvent
{
    lastZoomLevel -= lastZoomLevel/3;
    if (lastZoomLevel < minZoomLevel) {
        lastZoomLevel = minZoomLevel;
    }
    MKCoordinateRegion region = MKCoordinateRegionMake(stuMapView.region.center, MKCoordinateSpanMake(lastZoomLevel, lastZoomLevel));
    [stuMapView setRegion:[stuMapView regionThatFits:region] animated:YES];
}

//缩小
- (void)scaleSmallBtnEvent
{
    lastZoomLevel += lastZoomLevel/3;
    
    if (lastZoomLevel > maxZoomLevel) {
        lastZoomLevel = maxZoomLevel;
    }
    
    MKCoordinateRegion region = MKCoordinateRegionMake(stuMapView.region.center, MKCoordinateSpanMake(lastZoomLevel, lastZoomLevel));
    [stuMapView setRegion:[stuMapView regionThatFits:region] animated:YES];
}

#pragma mark - 找教练
- (void)coachBtnEvent
{
    coachOrSchool = 1;
    if (scBtn.selected) {
        return;
    }
    scBtn1.selected = NO;
    scBtn1.tLabel.textColor = [lhColor colorFromHexRGB:@"777777"];
    
    scBtn.selected = YES;
    scBtn.tLabel.textColor = [lhColor colorFromHexRGB:mainColorStr];
    
    for (lhSchoolAnnotationView * s in schoolArray) {
        s.hidden = YES;
    }
    for (lhCarAnnotationView * c in carArray){
        c.hidden = NO;
    }
    for (lhMineAnnotationView * addr in addrArray) {
        addr.tImgView.hidden = YES;
        addr.mineBtn.selected = NO;
    }
    [lhColor mergeTitle:@"找教练"];
}

#pragma mark - 找驾校
- (void)schoolBtnEvent
{
    coachOrSchool = 2;
//    NSDictionary * temD8 = @{@"x":@"30.545719",@"y":@"104.062918"};
//    CLLocationCoordinate2D c = [self coordinateAccordingXY:temD8];
//    [self locationToAPoint:c withType:MINE_ANNOTATIN];
//    [self addAnnotationa:c title:@"" positionStr:@"" withType:SCHOOL_ANNOTATION withTag:111];
    [self requestSchoolForMap:[lhColor shareColor].nowLocation];
    if (scBtn1.selected) {
        return;
    }
    scBtn.selected = NO;
    scBtn.tLabel.textColor = [lhColor colorFromHexRGB:@"777777"];
    
    scBtn1.selected = YES;
    scBtn1.tLabel.textColor = [lhColor colorFromHexRGB:mainColorStr];
    
    NSLog(@"高德驾校的点 = %@",schoolArray);
    for (lhSchoolAnnotationView * s in schoolArray) {
        s.hidden = NO;
    }

    for (lhCarAnnotationView * c in carArray){
        c.hidden = YES;
    }
    
    for (lhMineAnnotationView *addr in addrArray) {
        addr.tImgView.hidden = YES;
        addr.mineBtn.selected = NO;
    }
    [lhColor mergeTitle:@"找驾校"];
}

#pragma mark - 定位到某一个点
- (void)locationToAPoint:(CLLocationCoordinate2D)point
{
    MKCoordinateRegion region = MKCoordinateRegionMake(point, MKCoordinateSpanMake(lastZoomLevel, lastZoomLevel));
    [stuMapView setRegion:[stuMapView regionThatFits:region] animated:YES];
    
}

#pragma mark - addAnnotation
- (void)addAnnotationa:(CLLocationCoordinate2D)position title:(NSString *)title positionStr:(NSString *)positionStr withType:(annotationStyle)type withTag:(NSInteger)tag
{
    if (type) {
        lhCustomPointAnnotation * pointAnnitation = [[lhCustomPointAnnotation alloc]init];
        pointAnnitation.tag = tag;
        pointAnnitation.type = type;
        pointAnnitation.coordinate = position;
        pointAnnitation.title = title;
        pointAnnitation.subtitle = positionStr;
        [stuMapView addAnnotation:pointAnnitation];
        
        if (type == CAR_ANNOTATION) {
            [carArray1 addObject:pointAnnitation];
        }
        else if(type == SCHOOL_ANNOTATION){
            [schoolArray1 addObject:pointAnnitation];
        }
    }
    else{
        
        MKPointAnnotation *pointAnnitation = [[MKPointAnnotation alloc]init];
        pointAnnitation.coordinate = position;
        pointAnnitation.title = title;
        pointAnnitation.subtitle = positionStr;
        [stuMapView addAnnotation:pointAnnitation];
    }
    
}

#pragma mark - MKMapViewDelegate
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    NSLog(@"位置改变");
    
    if (isFirst) {
        isFirst = NO;
        
        return;
    }
    
    if (!isUserMoveMap) {
        isUserMoveMap = YES;
    }
    else{
        for (lhCarAnnotationView * ca in carArray){
            ca.tImgView.hidden = YES;
            ca.carBtn.selected = NO;
            [ca setSelected:NO animated:NO];
        }
        tempCaView = nil;
        
        for (lhSchoolAnnotationView *sch in schoolArray){
            sch.tImgView.hidden = YES;
            sch.schBtn.selected = NO;
            [sch setSelected:NO animated:NO];
        }
    }
//    
//    [stuMapView removeFromSuperview];
//    [self.view addSubview:stuMapView];
    
    if (coachOrSchool == 1) {
        [self request:mapView.region.center];
    }else{
        [self requestSchoolForMap:mapView.region.center];
    }

    
//    NSArray * carA = [NSArray arrayWithArray:[carArray allObjects]];
//    [stuMapView removeAnnotations:carA];
//    
//    NSArray * carb = [NSArray arrayWithArray:[carArray1 allObjects]];
//    [stuMapView removeAnnotations:carb];
//    
//    [carArray1 removeAllObjects];
//    [carArray removeAllObjects];
//
//    NSArray * schoolA = [NSArray arrayWithArray:[schoolArray allObjects]];
//    [stuMapView removeAnnotations:schoolA];
//    
//    NSArray * schoolB = [NSArray arrayWithArray:[schoolArray1 allObjects]];
//    [stuMapView removeAnnotations:schoolB];
//    
//    [schoolArray removeAllObjects];
//    [schoolArray1 removeAllObjects];
//    
//    CLLocationCoordinate2D curCoordinate = [stuMapView convertPoint:stuMapView.center toCoordinateFromView:stuMapView];
//    if (coachOrSchool == 1) {
//        [self request:curCoordinate];
//    }else{
//        [self requestSchoolForMap:curCoordinate];
//    }
    
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
//    for (MKPinAnnotationView * pinView in views) {
//        MKPointAnnotation * pink = (MKPointAnnotation *)pinView;
//        if (pink.coordinate.latitude == companyCoords.latitude && pink.coordinate.longitude == companyCoords.longitude) {
//            pinView.pinColor = MKPinAnnotationColorPurple;
//        }
//    }
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation class] == [lhCustomPointAnnotation class]) {
        lhCustomPointAnnotation * cpAnno = (lhCustomPointAnnotation *)annotation;
        if (cpAnno.type == MINE_ANNOTATIN) {
            static NSString * kPin = @"minePin";
            
            lhMineAnnotationView * pinView = (lhMineAnnotationView *)
            [mapView dequeueReusableAnnotationViewWithIdentifier:kPin];
            
            if (!pinView) {
                pinView = [[lhMineAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:kPin];
                
                [pinView setDraggable:YES];
            }
            
            [pinView.mineBtn addTarget:self action:@selector(tapMineEvent:) forControlEvents:UIControlEventTouchUpInside];
            UITapGestureRecognizer * tapG = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGpsEvent:)];
            pinView.gpsImage.tag = cpAnno.tag;
            pinView.gpsImage.userInteractionEnabled = YES;
            [pinView.gpsImage addGestureRecognizer:tapG];
            //            [pinView setSelected:NO animated:NO];
            
            pinView.draggable = NO;
            if (addrArray.count == 0) {
                [addrArray addObject:pinView];
            }
            return pinView;
        }
        else if(cpAnno.type == CAR_ANNOTATION){
            static NSString * kPin = @"carPin";
            lhCarAnnotationView * pinView = (lhCarAnnotationView *)
            [mapView dequeueReusableAnnotationViewWithIdentifier:kPin];
            
            if (!pinView) {
                pinView = [[lhCarAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:kPin];
                
                [pinView setDraggable:YES];
            }
            
            //车子事件
            [pinView.carBtn addTarget:self action:@selector(tapCarEvent:) forControlEvents:UIControlEventTouchUpInside];
            //司机事件
            UITapGestureRecognizer * tapG = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGEvent:)];
            pinView.tImgView.tag = cpAnno.tag;
            [pinView.tImgView addGestureRecognizer:tapG];
            
            UITapGestureRecognizer *tapG1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGEvent:)];
            [pinView.starImgView addGestureRecognizer:tapG1];
            

            pinView.draggable = NO;
            
            if (coachOrSchool == 1) {
                pinView.hidden = NO;
            }
            else{
                pinView.hidden = YES;
            }
            
            
            [carArray addObject:pinView];
            NSLog(@"carArray = %@",carArray);
            return pinView;
        }
        else if(cpAnno.type == SCHOOL_ANNOTATION){
            static NSString * kPin = @"schoolPin";
            lhSchoolAnnotationView * pinView = (lhSchoolAnnotationView  *)
            [mapView dequeueReusableAnnotationViewWithIdentifier:kPin];
            
            if (!pinView) {
                pinView = [[lhSchoolAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:kPin];
                
                [pinView setDraggable:YES];
            }
            
            //车子事件
            [pinView.schBtn addTarget:self action:@selector(tapSchoolEvent:) forControlEvents:UIControlEventTouchUpInside];
            //司机事件
            UITapGestureRecognizer * tapG = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGEvent:)];
            pinView.tImgView.tag = cpAnno.tag;
            [pinView.tImgView addGestureRecognizer:tapG];
            
            UITapGestureRecognizer *tapG1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGEvent:)];
            [pinView.starImgView addGestureRecognizer:tapG1];
            
            pinView.draggable = NO;
            
            if (coachOrSchool == 1) {
                pinView.hidden = YES;
            }
            else{
                pinView.hidden = NO;
            }
            [schoolArray addObject:pinView];
//            NSLog(@"schoolArray = %@",schoolArray);
            return pinView;
        }
    }
    return nil;
}

#pragma mark - 点击我个位置图标
- (void)tapMineEvent:(UIButton *)btn_
{
    lhMineAnnotationView * carAnn = (lhMineAnnotationView *)btn_.superview;
    if (btn_.selected) {
        btn_.selected = NO;
        carAnn.tImgView.hidden = YES;
        [carAnn setSelected:NO animated:NO];
    }
    else{
        btn_.selected = YES;
        carAnn.tImgView.hidden = NO;
        [carAnn setSelected:YES animated:YES];
        
        [self locationToAPoint:carAnn.annotation.coordinate];
    }
    
    NSLog(@"点击个人图片");
    
    
}

- (void)tapGpsEvent:(UIImageView *)image
{
    NSString * latiStr = @"30.709127";
    NSString * lotiStr = @"108.346281";
    CLLocationCoordinate2D endLocation = CLLocationCoordinate2DMake([latiStr doubleValue], [lotiStr doubleValue]);
//    [lhColor addActivityView123:self.view];
    __weak typeof(self) ws = self;
    [[lhColor shareColor]locationAddress:^(CLLocationCoordinate2D locationCorrrdinate) {
        if (locationCorrrdinate.latitude == DefaultCoordnate.latitude) {
//            [lhColor disAppearActivitiView:ws.view];
            [lhColor showAlertWithMessage:@"获取位置失败~" withSuperView:ws.view withHeih:DeviceMaxHeight/2];
        }
        else{
            CLLocationCoordinate2D nowLocation = locationCorrrdinate;
            if (nowLocation.longitude != 0) {
                [[lhGPS sharedInstanceGPS]prepareData:ws startLocation:nowLocation endLocation:endLocation];//准备数据
                
                [[lhGPS sharedInstanceGPS]startNaviGPS];//开始导航
            }
            else{
                [lhColor showAlertWithMessage:@"获取定位有误~" withSuperView:ws.view withHeih:DeviceMaxHeight/2];
            }
        }
    }];
}

#pragma mark - 点击车子
- (void)tapCarEvent:(UIButton *)btn_
{
    lhCarAnnotationView * carAnn = (lhCarAnnotationView *)btn_.superview;
    NSLog(@"%ld",carAnn.tImgView.tag);
    NSLog(@"gdCoachArray = %@",gdCoachArray);
    NSDictionary * coachMapDic = [gdCoachArray objectAtIndex:carAnn.tImgView.tag];
    NSLog(@"coachMapDic = %@",coachMapDic);
    //多次选择会导致大头针移动出问题
    if (btn_.selected) {
        btn_.selected = NO;
        carAnn.tImgView.hidden = YES;
        [carAnn setSelected:NO animated:NO];
    }
    else{
        for (lhSchoolAnnotationView * s in carArray) {
            s.tImgView.hidden = YES;
            [s setSelected:NO animated:NO];
        }
        btn_.selected = YES;
        carAnn.tImgView.hidden = NO;
        [carAnn setSelected:YES animated:YES];
        carAnn.nameLabel.text = [coachMapDic objectForKey:@"_name"];
        carAnn.starImgView.number = [[coachMapDic objectForKey:@"coachScore"] doubleValue];
        coachId = [coachMapDic objectForKey:@"coach_id"];
        carAnn.dAgeLabel.text = [NSString stringWithFormat:@"教龄：%@年",[coachMapDic objectForKey:@"coachTeachAge"]];
        carAnn.priceLabel.text = [NSString stringWithFormat:@"￥：%@起",[coachMapDic objectForKey:@"coachFee"]];
        NSString *photoStr = [NSString stringWithFormat:@"%@%@",[lhColor shareColor].fileWebUrl,[coachMapDic objectForKey:@"photoUrl"]];
        if (![[coachMapDic objectForKey:@"photoUrl"] isEqualToString:@""]) {
            [lhColor checkImageWithName:[coachMapDic objectForKey:@"photoUrl"] withUrlStr:photoStr withImgView:carAnn.headImgView withPlaceHolder:imageWithName(@"defaultHead")];
        }else {
            [carAnn.headImgView setImage:imageWithName(@"defaultHead")];
        }
//                [self locationToAPoint:carAnn.annotation.coordinate withType:MINE_ANNOTATIN]; //点击重新定位
        isUserMoveMap = NO;
        [self locationToAPoint:carAnn.annotation.coordinate];
    }
}

#pragma mark - 点击驾校
-(void)tapSchoolEvent:(UIButton *)button_{
    lhSchoolAnnotationView * schAnn = (lhSchoolAnnotationView *)button_.superview;
    if (schAnn.tImgView.tag >= gdSchArray.count) {
        return;
    }
    NSDictionary * mapSchoolDic = [gdSchArray objectAtIndex:schAnn.tImgView.tag];
    NSLog(@"mapSchoolDic = %@",mapSchoolDic);
    if (button_.selected) {
        button_.selected = NO;
        schAnn.tImgView.hidden = YES;
        [schAnn setSelected:NO animated:NO];
    }
    else{
        for (lhSchoolAnnotationView * s in schoolArray) {
            s.tImgView.hidden = YES;
        }
        button_.selected = YES;
        
        NSLog(@"aa  = %@",mapSchoolDic);
        schAnn.tImgView.hidden = NO;
        [schAnn setSelected:YES animated:YES];
        schAnn.nameLabel.text = [mapSchoolDic objectForKey:@"_name"];
        schAnn.priceLabel.text = [NSString stringWithFormat:@"￥ %@起",[mapSchoolDic objectForKey:@"schoolFee"]];
         NSString *string = [NSString stringWithFormat:@"%@%@",[lhColor shareColor].fileWebUrl,[mapSchoolDic objectForKey:@"photoUrl"]];
        if (![[mapSchoolDic objectForKey:@"photoUrl"] isEqualToString:@""]) {
            [lhColor checkImageWithName:[mapSchoolDic objectForKey:@"photoUrl"] withUrlStr:string withImgView:schAnn.headImgView withPlaceHolder:imageWithName(@"defaultHead")];
        }
        drivingId = [mapSchoolDic objectForKey:@"driving_id"];
        isUserMoveMap = NO;
        [self locationToAPoint:schAnn.annotation.coordinate];
    }
}

//点击司机
- (void)tapGEvent:(UITapGestureRecognizer *)tapView
{
    if (coachOrSchool == 1) {
        NSLog(@"点击司机%ld",(long)tapView.view.tag);
        lhDriverDetailViewController * ddVC = [[lhDriverDetailViewController alloc]init];
        ddVC.coachID = coachId;
        [self.navigationController pushViewController:ddVC animated:YES];
        
    }else{
        NSLog(@"点击驾校%ld",(long)tapView.view.tag);
        FrankSchoolDetailView *schDetail = [[FrankSchoolDetailView alloc] init];
        schDetail.schoolID = drivingId;
        [self.navigationController pushViewController:schDetail animated:YES];
    }
}

#pragma mark - 点击我的位置图标
/*
- (void)tapMineEvent:(UIButton *)btn_
{
    lhMineAnnotationView * carAnn = (lhMineAnnotationView *)btn_.superview;
    if (btn_.selected) {
        btn_.selected = NO;
        [carAnn setSelected:NO animated:NO];
    }
    else{
        btn_.selected = YES;
        [carAnn setSelected:YES animated:YES];
        
        [self locationToAPoint:carAnn.annotation.coordinate withType:MINE_ANNOTATIN];
    }
    
    NSLog(@"点击个人图片");
    
    
}
*/
#pragma mark - 学车指南
- (void)studyGuideEvent
{
    lhStudyGuideViewController * sgVC = [[lhStudyGuideViewController alloc]init];
    [self.navigationController pushViewController:sgVC animated:YES];
}

#pragma mark - 列表查看教练驾校
- (void)listDisplayIconEvent:(UIButton *)button_
{
    if (coachOrSchool == 1) {
        FrankCoachListView *coachList = [[FrankCoachListView alloc] init];
        coachList.coachIdStr = coachIdStr;
        coachList.coachArray = [[NSMutableArray alloc] initWithArray:mapArray];
        [self.navigationController pushViewController:coachList animated:YES];
    }else{
        FrankSchoolListView *schoolList = [[FrankSchoolListView alloc] init];
        NSLog(@"驾校列表 = %@",gdSchArray);
        schoolList.schoolListAy = gdSchArray;
        [self.navigationController pushViewController:schoolList animated:YES];
    }
}

#pragma mark - 下拉刷新
- (void)headerRefresh
{
    [listLookTableView headerEndRefreshing];
    NSLog(@"下拉刷新");
}

#pragma mark - view
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [lhColor assignmentForTempVC:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

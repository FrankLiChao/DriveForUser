//
//  lhWantStudyViewController.h
//  Drive
//
//  Created by bosheng on 15/7/27.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface lhWantStudyViewController : UIViewController{
    NSInteger coachCount; //教练及驾校列表的总条数
    NSInteger schoolCount; //驾校总条数
    NSArray *coachListArry; //教练列表的数组
    NSArray *schListArry;   //驾校列表数组
    NSDictionary *schDetailDic;
    NSDictionary *mapForCoach;
    NSArray * mapArray;         //高德的教练数据
//    NSArray * mapForSchool;
    NSString *coachId;      //拼接的coachId字符串
    NSString *drivingId;    //拼接的drivingId字符串
    NSArray *coachDataArray;    //存储用于地图显示的教练数据
    NSArray *schDataArray;      //存储用于地图显示的驾校数据
}

@end

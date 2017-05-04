//
//  FrankAppointmentCarView.h
//  Drive
//
//  Created by lichao on 15/8/11.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FrankAppointmentCarView : UIViewController<UIScrollViewDelegate>{
    UILabel * weekNum;
    UIButton *dateNum;
    NSInteger totalDay;
    NSInteger week;                 //当天对应的星期数
    NSInteger day;                  //当天
    NSDateComponents *cmps;
    NSInteger selectDay;
}

@property (nonatomic,strong)NSString *coachName;

@end

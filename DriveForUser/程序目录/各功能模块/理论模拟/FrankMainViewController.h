//
//  ViewController.h
//  PracticeSimulation
//
//  Created by lichao on 15/7/15.
//  Copyright (c) 2015年 LiFrank. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FrankPracticeView;

@interface FrankMainViewController : UIViewController<UITabBarDelegate,UIAlertViewDelegate>{
    UIScrollView *mainScrollView;
    UITabBar *_tabBar;  
    CGFloat spaceValue;                         //适配设备的空隙参数
    FrankPracticeView *practiceViewController;
//    NSInteger wrongCount;                       //错题总数
//    NSInteger collectCount;                     //收藏总数
    UILabel *showWrongNumber;                   //显示错题的view
    UILabel *showCollectNub;                    //显示收藏的View
}


@end


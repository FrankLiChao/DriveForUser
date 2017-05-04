//
//  AppDelegate.h
//  DriveForUser
//
//  Created by lichao on 16/3/21.
//  Copyright © 2016年 LiFrank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate,WXApiDelegate,UIScrollViewDelegate,UIAlertViewDelegate>
{
    BOOL isLocationing;
}

@property (strong, nonatomic) UIWindow *window;


@end


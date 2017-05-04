//
//  lhFirmOrderViewController.h
//  Drive
//
//  Created by bosheng on 15/8/11.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface lhFirmOrderViewController : UIViewController

@property (nonatomic,strong)NSDictionary *userDic;
@property (nonatomic,assign)NSInteger orderType;
@property (nonatomic,strong)NSString *examAddress;

- (void)toOrderView;

@end

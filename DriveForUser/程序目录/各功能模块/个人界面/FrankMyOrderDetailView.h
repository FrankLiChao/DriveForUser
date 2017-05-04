//
//  FrankMyOrderDetailView.h
//  Drive
//
//  Created by lichao on 15/8/19.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FrankMyOrderDetailView : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>{
    UITableView *myTableView;
    UIView *lineTag;
//    BOOL selectOrder;  //默认选择驾校车的订单（No）, 教练车为（yes）。
}
@property (nonatomic,strong)NSArray *myOrderArry;

@end

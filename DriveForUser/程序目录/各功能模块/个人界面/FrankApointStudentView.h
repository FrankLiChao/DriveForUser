//
//  FrankApointStudentView.h
//  Drive
//
//  Created by lichao on 15/8/11.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FrankApointStudentView : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    UITableView *myStudentTab;
    NSMutableArray * myStuArray;
    NSInteger pNo;
    NSInteger totalPNo;
}
@property(nonatomic,strong)NSString *appointId;

@end

//
//  FrankTopicsView.h
//  Drive
//
//  Created by lichao on 15/11/6.
//  Copyright © 2015年 bosheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FrankTopicsView : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    UITableView *myTableView;
}

@property (nonatomic,strong)NSString *titleString;
@property (nonatomic,strong)NSArray *categoryArray;
@property (nonatomic,strong)NSString *category;

-(void)refreshTabView;

@end

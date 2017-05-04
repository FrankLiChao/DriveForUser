//
//  FrankSubjectListView.h
//  Drive
//
//  Created by lichao on 15/8/3.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FrankSubjectListView : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    NSArray *nameArray;
    NSArray *timeArray;
    NSArray *indexArray;
    UITableView *subjectListView;
}

@end

@interface FrankSubjectListViewCell : UITableViewCell{
    
}

@property (nonatomic,strong)UILabel *lableForIndex;
@property (nonatomic,strong)UIImageView *imageForStudents;
@property (nonatomic,strong)UILabel *lableForName;
@property (nonatomic,strong)UILabel *lableForTime;
@property (nonatomic,strong)UILabel *lableForScore;

@end
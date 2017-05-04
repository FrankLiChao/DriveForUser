//
//  FrankChapterPracticeView.h
//  Drive
//
//  Created by lichao on 15/7/30.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FrankPracticeView;

@interface FrankChapterPracticeView : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    UITableView *chapterView;
}

@property NSMutableArray *chapterArray;
@property (nonatomic,assign)NSInteger subject; //表示科目（0：表示科目一  1：表示科目四）

@end

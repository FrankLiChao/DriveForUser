//
//  PracticeViewController.h
//  PracticeSimulation
//
//  Created by lichao on 15/7/16.
//  Copyright (c) 2015年 LiFrank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "lhSymbolCustumButton.h"

@class FrankPageContentView;
@class FrankCollectionView;
@class ManageSqlite;
@class Practice;
@class FrankChapterPracticeView;

@interface FrankPracticeView : UIViewController<UIPageViewControllerDelegate,UITabBarDelegate>{
    UITabBar            *_tabBar;
    UITabBarItem        *lableItem;
    UITabBarItem        *collectionItem;
    UITabBarItem        *explainItem;
    UITabBarItem        *commitItem;
    ManageSqlite        *manageSqlite;
    UILabel             *lableForTimer;
    NSTimer             *countdownTimer;
    NSInteger           totalNumber;
    NSArray             *plistArray;
    NSInteger           timeForseconds;
    FrankCollectionView *collectionView;
    NSMutableArray      *rootArray;              //用来存储模拟考试的数据字典
    NSMutableArray      *recordArray;            //用于存储每次考试的数据
}

@property (nonatomic, strong) UISwipeGestureRecognizer  *leftSwipeGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer  *rightSwipeGestureRecognizer;
@property (retain, nonatomic) UIPageViewController      *pageViewController;
@property (retain,nonatomic)  FrankPageContentView      *pageContentView;
@property (nonatomic,strong)  lhSymbolCustumButton      *titileExplain;      //标题栏解释按钮
@property (strong,nonatomic)  Practice                  *practiceManage;
@property (nonatomic,strong)  UITabBarItem              *explainItem;
@property NSInteger                                     datacount;           //数据库的总记录数
@property NSMutableArray *sqliteArray;                  //用于保存从sqlite查询出来的数据
@property NSInteger scoreForTest;                       //表示考试的分数
@property BOOL swipeRight;                              //标示向左还是向右滑动页面
@property NSInteger recordIndex;                        //进入哪一个考试记录
@property (assign,nonatomic)jumpType recordJump;        //记录从哪个页面跳转而来
@property (nonatomic,strong)NSString *titleStr;         //记录页面的title
@property (nonatomic,assign)NSInteger subType;          //表示科目（0：表示科目一  1：表示科目四）

-(void)nextPageControl:(NSNumber *)number;
- (FrankPageContentView *)viewControllerAtIndex:(NSInteger)index;
-(void)hideCollectionView;
-(void)hideOrShowExplain:(BOOL)action;

@end

//
//  PageViewController.h
//  PracticeSimulation
//
//  Created by lichao on 15/7/16.
//  Copyright (c) 2015年 LiFrank. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FrankPracticeView;
@class FrankTableViewCell;

@interface FrankPageContentView : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    CGSize sizeOfLable;
    UITableView *myTabView;
}

@property(weak,nonatomic)UILabel *titleLabel;
@property(weak,nonatomic)UIImageView *backgroundImageView;
@property(strong,nonatomic)FrankPracticeView *delegate;
@property(strong,nonatomic)UILabel *textView;
@property NSInteger testID;
@property NSInteger pageIndex;
@property NSString  *titleText;
@property NSString  *imageName;
@property NSString  *answerA;
@property NSString  *answerB;
@property NSString  *answerC;
@property NSString  *answerD;
@property NSInteger answer;
@property NSString  *analysis;
@property NSInteger collect;
@property NSInteger questionType;
@property NSInteger subType;        //表示科目一还是科目四

@property (nonatomic,strong)UIScrollView *myScrollView;

-(void) hideTextView;
@end

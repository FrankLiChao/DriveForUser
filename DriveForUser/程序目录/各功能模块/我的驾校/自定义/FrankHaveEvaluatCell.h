//
//  FrankHaveEvaluatCell.h
//  Drive
//
//  Created by lichao on 15/9/10.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TQStarRatingView.h"

@interface FrankHaveEvaluatCell : UITableViewCell

@property(nonatomic,strong)UIView  *bgView;
@property(nonatomic,strong)UILabel *sub;                   //科目
@property(nonatomic,strong)UILabel *timeLable;             //创建时间
@property(nonatomic,strong)UILabel *timeLab;               //预约时间
@property(nonatomic,strong)UILabel *time;                  //预约时段
@property(nonatomic,strong)UILabel *schoollab;             //驾校
@property(nonatomic,strong)UILabel *coachlab;              //教练
@property(nonatomic,strong)TQStarRatingView *coachRatingBar;   //教练评分
@property(nonatomic,strong)TQStarRatingView *carRatingBar;     //车况评分
@property(nonatomic,strong)UILabel      *myEvaluat;        //我的评价

@end

//
//  FrankWaitEvaluatiCell.h
//  Drive
//
//  Created by lichao on 15/8/21.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FrankWaitEvaluatiCell : UITableViewCell

@property(nonatomic,strong)UILabel *sub;            //科目
@property(nonatomic,strong)UILabel *timeLable;      //创建时间
@property(nonatomic,strong)UILabel *timeLab;        //预约时间
@property(nonatomic,strong)UILabel *time;           //预约时段
@property(nonatomic,strong)UILabel *schoollab;      //驾校
@property(nonatomic,strong)UILabel *coachlab;       //教练
@property(nonatomic,strong)UIButton *cancelBtn;     //取消按钮
@property(nonatomic,strong)UIButton *evaluatBtn;    //评价按钮
@end

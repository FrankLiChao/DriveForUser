//
//  FrankHaveEvaluatCell.m
//  Drive
//
//  Created by lichao on 15/9/10.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import "FrankHaveEvaluatCell.h"

@implementation FrankHaveEvaluatCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.bgView = [[UIView alloc] initWithFrame:CGRectMake(5*widthRate, 10*widthRate, DeviceMaxWidth-10*widthRate, 180*widthRate)];
        self.bgView.layer.borderWidth = 0.5f;
        self.bgView.layer.cornerRadius = 4;
        self.bgView.layer.masksToBounds = YES;
        self.bgView.layer.borderColor = [[UIColor grayColor] CGColor];
        [self addSubview:self.bgView];
        
        self.sub = [[UILabel alloc] initWithFrame:CGRectMake(20*widthRate, 10*widthRate, 100*widthRate, 20*widthRate)];
        self.sub.font = [UIFont systemFontOfSize:18];
        self.sub.text = @"科目二";
        self.sub.textColor = [lhColor colorFromHexRGB:lineColorStr];
        [self.bgView addSubview:self.sub];
        
        self.timeLable = [[UILabel alloc] initWithFrame:CGRectMake(DeviceMaxWidth-100*widthRate, 10*widthRate, 100*widthRate, 20*widthRate)];
        self.timeLable.font = [UIFont systemFontOfSize:15];
        self.timeLable.text = @"2015-08-23";
        self.timeLable.textColor = [lhColor colorFromHexRGB:contentTitleColorStr1];
        [self.bgView addSubview:self.timeLable];
        
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 40*widthRate, DeviceMaxWidth-10*widthRate, 0.5)];
        line.backgroundColor = [UIColor grayColor];
        [self.bgView addSubview:line];
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, 45*widthRate, 100*widthRate, 20*widthRate)];
        lab.font = [UIFont systemFontOfSize:15];
        lab.textColor = [lhColor colorFromHexRGB:lineColorStr];
        lab.text = @"预约练车时间";
        [self.bgView addSubview:lab];
        
        self.timeLab = [[UILabel alloc] initWithFrame:CGRectMake(110*widthRate, 45*widthRate, 100*widthRate, 20*widthRate)];
        self.timeLab.font = [UIFont systemFontOfSize:13];
        self.timeLab.text = @"2015-08-21";
        [self.bgView addSubview:self.timeLab];
        
        self.time = [[UILabel alloc] initWithFrame:CGRectMake(180*widthRate, 45*widthRate, 130*widthRate, 20*widthRate)];
        self.time.font = [UIFont systemFontOfSize:13];
        self.time.text = @"上午 7:00-12:00";
        [self.bgView addSubview:self.time];
        
        self.schoollab = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, 70*widthRate, 100*widthRate, 20*widthRate)];
        self.schoollab.font = [UIFont systemFontOfSize:13];
        self.schoollab.textColor = [lhColor colorFromHexRGB:contentTitleColorStr1];
        self.schoollab.text = [NSString stringWithFormat:@"驾校：%@",@"天欣驾校"];
        [self.bgView addSubview:self.schoollab];
        
        self.coachlab = [[UILabel alloc] initWithFrame:CGRectMake(120*widthRate, 70*widthRate, 100*widthRate, 20*widthRate)];
        self.coachlab.font = [UIFont systemFontOfSize:13];
        self.coachlab.textColor = [lhColor colorFromHexRGB:contentTitleColorStr1];
        self.coachlab.text = [NSString stringWithFormat:@"教练：%@",@"李教练"];
        [self.bgView addSubview:self.coachlab];
        
        UIView * lineV1 = [[UIView alloc]initWithFrame:CGRectMake(0, 98*widthRate, DeviceMaxWidth-10*widthRate, 0.5)];
        lineV1.backgroundColor = [lhColor colorFromHexRGB:contentTitleColorStr1];
        [self.bgView addSubview:lineV1];
        
        UILabel *labe = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, 105*widthRate, 60*widthRate, 20*widthRate)];
        labe.text = @"教练评分";
        labe.font = [UIFont systemFontOfSize:13];
        [self.bgView addSubview:labe];
        
        self.coachRatingBar = [[TQStarRatingView alloc] initWithFrame:CGRectMake(60*widthRate, 100*widthRate, 100*widthRate, 30*widthRate) numberOfStar:5 distance:5*widthRate HeiDistance:6*widthRate];
        self.coachRatingBar.number = 5.0f;
        self.coachRatingBar.userInteractionEnabled = NO;
        [self.bgView addSubview:self.coachRatingBar];
        
        UILabel *carLab = [[UILabel alloc] initWithFrame:CGRectMake(160*widthRate, 105*widthRate, 60*widthRate, 20*widthRate)];
        carLab.font = [UIFont systemFontOfSize:13];
        carLab.text = @"车况评分";
        [self.bgView addSubview:carLab];
        
        self.carRatingBar = [[TQStarRatingView alloc] initWithFrame:CGRectMake(210*widthRate, 100*widthRate, 100*widthRate, 30*widthRate) numberOfStar:5 distance:5*widthRate HeiDistance:6*widthRate];
        self.carRatingBar.number = 5.0f;
        self.carRatingBar.userInteractionEnabled = NO;
        [self.bgView addSubview:self.carRatingBar];
        
        self.myEvaluat = [[UILabel alloc] initWithFrame:CGRectZero];
        self.myEvaluat.font = [UIFont systemFontOfSize:13];
        self.myEvaluat.numberOfLines = 0;
        self.myEvaluat.text = @"我的评价: 值此2015中国—阿拉伯国家博览会开幕之枝";
        [self.bgView addSubview:self.myEvaluat];
        
    }
    return self;
}

@end

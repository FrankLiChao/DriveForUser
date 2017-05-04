//
//  FrankWaitEvaluatiCell.m
//  Drive
//
//  Created by lichao on 15/8/21.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import "FrankWaitEvaluatiCell.h"

@implementation FrankWaitEvaluatiCell

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
        UIView *lableView = [[UIView alloc] initWithFrame:CGRectMake(5*widthRate, 10*widthRate, DeviceMaxWidth-10*widthRate, 150*widthRate)];
        lableView.layer.borderWidth = 0.8f;
        lableView.layer.cornerRadius = 4;
        lableView.layer.masksToBounds = YES;
        lableView.layer.borderColor = [[UIColor grayColor] CGColor];
        [self addSubview:lableView];
        
        self.sub = [[UILabel alloc] initWithFrame:CGRectMake(20*widthRate, 10*widthRate, 100*widthRate, 20*widthRate)];
        self.sub.font = [UIFont systemFontOfSize:18];
        self.sub.text = @"科目二";
        self.sub.textColor = [lhColor colorFromHexRGB:lineColorStr];
        [lableView addSubview:self.sub];
        
        self.timeLable = [[UILabel alloc] initWithFrame:CGRectMake(DeviceMaxWidth-100*widthRate, 10*widthRate, 100*widthRate, 20*widthRate)];
        self.timeLable.font = [UIFont systemFontOfSize:15];
        self.timeLable.text = @"2015-08-23";
        self.timeLable.textColor = [lhColor colorFromHexRGB:contentTitleColorStr1];
        [lableView addSubview:self.timeLable];
        
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 40*widthRate, DeviceMaxWidth-10*widthRate, 0.5)];
        line.backgroundColor = [UIColor grayColor];
        [lableView addSubview:line];
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(20*widthRate, 45*widthRate, 150*widthRate, 20*widthRate)];
        lab.font = [UIFont systemFontOfSize:15];
        lab.textColor = [lhColor colorFromHexRGB:lineColorStr];
        lab.text = @"预约练车时间";
        [lableView addSubview:lab];
        
        self.timeLab = [[UILabel alloc] initWithFrame:CGRectMake(20*widthRate, 65*widthRate, 150*widthRate, 20*widthRate)];
        self.timeLab.font = [UIFont systemFontOfSize:15];
        self.timeLab.text = @"2015-08-21";
        [lableView addSubview:self.timeLab];
        
        self.time = [[UILabel alloc] initWithFrame:CGRectMake(20*widthRate, 85*widthRate, 180*widthRate, 20*widthRate)];
        self.time.font = [UIFont systemFontOfSize:15];
        self.time.text = @"上午（7:00 - 12:00）";
        [lableView addSubview:self.time];
        
        self.schoollab = [[UILabel alloc] initWithFrame:CGRectMake(DeviceMaxWidth/2+30*widthRate, 55*widthRate, 100*widthRate, 20*widthRate)];
        self.schoollab.font = [UIFont systemFontOfSize:13];
        self.schoollab.textColor = [lhColor colorFromHexRGB:contentTitleColorStr1];
        self.schoollab.text = [NSString stringWithFormat:@"驾校：%@",@"天欣驾校"];
        [lableView addSubview:self.schoollab];
        
        self.coachlab = [[UILabel alloc] initWithFrame:CGRectMake(DeviceMaxWidth/2+30*widthRate, 75*widthRate, 100*widthRate, 20*widthRate)];
        self.coachlab.font = [UIFont systemFontOfSize:13];
        self.coachlab.textColor = [lhColor colorFromHexRGB:contentTitleColorStr1];
        self.coachlab.text = [NSString stringWithFormat:@"教练：%@",@"李教练"];
        [lableView addSubview:self.coachlab];
        
        UIView * lineV1 = [[UIView alloc]initWithFrame:CGRectMake(0, 115*widthRate, DeviceMaxWidth-10*widthRate, 0.5)];
        lineV1.backgroundColor = [lhColor colorFromHexRGB:contentTitleColorStr1];
        [lableView addSubview:lineV1];
        
        self.evaluatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.evaluatBtn.frame = CGRectMake(DeviceMaxWidth-90*widthRate, 120*widthRate, 70*widthRate, 25*widthRate);
        [self.evaluatBtn setTitle:@"评价" forState:UIControlStateNormal];
        self.evaluatBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.evaluatBtn setBackgroundImage:imageWithName(@"contactDraiver") forState:UIControlStateNormal];
        [lableView addSubview:self.evaluatBtn];
        
        self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cancelBtn.frame = CGRectMake(DeviceMaxWidth-90*widthRate, 120*widthRate, 70*widthRate, 25*widthRate);
        [self.cancelBtn setTitle:@"取消预约" forState:UIControlStateNormal];
        self.cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.cancelBtn setBackgroundImage:imageWithName(@"contactDraiver") forState:UIControlStateNormal];
        [lableView addSubview:self.cancelBtn];
    }
    return self;
}

@end

//
//  FrankStudentApointCell.m
//  Drive
//
//  Created by lichao on 16/1/11.
//  Copyright © 2016年 bosheng. All rights reserved.
//

#import "FrankStudentApointCell.h"

@implementation FrankStudentApointCell

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
    
    if (self) { //50
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 50*widthRate)];
        [self addSubview:bgView];
        
        UILabel *point = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, 21*widthRate, 8*widthRate, 8*widthRate)];
        point.backgroundColor = [lhColor colorFromHexRGB:mainColorStr];
        point.layer.cornerRadius = 4*widthRate;
        point.layer.masksToBounds = YES;
        [bgView addSubview:point];
        
        self.subLab = [[UILabel alloc] initWithFrame:CGRectMake(28*widthRate, 15*widthRate, 60*widthRate, 20*widthRate)];
        self.subLab.text = @"科目二";
        self.subLab.font = [UIFont systemFontOfSize:15];
        self.subLab.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
        [bgView addSubview:self.subLab];
        
        self.timeLab = [[UILabel alloc] initWithFrame:CGRectMake(95*widthRate, 15*widthRate, 90*widthRate, 20*widthRate)];
        self.timeLab.text = @"10:00-12:00";
        self.timeLab.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
        self.timeLab.font = [UIFont systemFontOfSize:15];
        [bgView addSubview:self.timeLab];
        
        self.countLab = [[UILabel alloc] initWithFrame:CGRectMake(195*widthRate, 15*widthRate, 50*widthRate, 20*widthRate)];
        self.countLab.text = @"3/5";
        self.countLab.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
        self.countLab.font = [UIFont systemFontOfSize:15];
        [bgView addSubview:self.countLab];
        
        self.apointBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.apointBtn.frame = CGRectMake(DeviceMaxWidth-70*widthRate, 12*widthRate, 60*widthRate, 26*widthRate);
        self.apointBtn.backgroundColor = [lhColor colorFromHexRGB:mainColorStr];
//        [self.apointBtn setBackgroundImage:imageWithName(@"studentApointPractice") forState:UIControlStateNormal];
        self.apointBtn.layer.cornerRadius = 5*widthRate;
        [self.apointBtn setTitle:@"预约" forState:UIControlStateNormal];
        [self.apointBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [bgView addSubview:self.apointBtn];
        
        UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(10*widthRate, 50*widthRate-0.5, DeviceMaxWidth-10*widthRate, 0.5)];
        lineV.backgroundColor = [lhColor colorFromHexRGB:contentTitleColorStr1];
        [bgView addSubview:lineV];
    }
    return self;
}

@end

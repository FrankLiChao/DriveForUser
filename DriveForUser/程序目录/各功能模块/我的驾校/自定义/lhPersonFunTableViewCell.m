//
//  lhPersonFunTableViewCell.m
//  Drive
//
//  Created by bosheng on 15/7/30.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import "lhPersonFunTableViewCell.h"

@implementation lhPersonFunTableViewCell

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
        //304*40
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.headImgView = [[UIImageView alloc]initWithFrame:CGRectMake(20*widthRate, 8*widthRate, 24*widthRate, 24*widthRate)];
        [self addSubview:self.headImgView];
        
        self.topline = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 304*widthRate, 0.5)];
        self.topline.backgroundColor = [lhColor colorFromHexRGB:viewColorStr];
        self.topline.hidden = YES;
        [self addSubview:self.topline];

        self.titLabel = [[UILabel alloc]initWithFrame:CGRectMake(55*widthRate, 3*widthRate, 100*widthRate, 34*widthRate)];
        self.titLabel.textColor = [UIColor blackColor];
        self.titLabel.font = [UIFont systemFontOfSize:15];
        self.titLabel.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
        [self addSubview:self.titLabel];
        
        self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(160*widthRate, 3*widthRate, 135*widthRate, 34*widthRate)];
        self.contentLabel.textAlignment = NSTextAlignmentRight;
        self.contentLabel.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
        self.contentLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.contentLabel];
        
        self.lowline0 = [[UIView alloc]initWithFrame:CGRectMake(15*widthRate, 40*widthRate-0.5, DeviceMaxWidth-30*widthRate, 0.5)];
        self.lowline0.hidden = YES;
        self.lowline0.backgroundColor = [lhColor colorFromHexRGB:viewColorStr];
        [self addSubview:self.lowline0];
        
        self.lowline = [[UIView alloc]initWithFrame:CGRectMake(0, 40*widthRate-0.5, DeviceMaxWidth, 0.5)];
        self.lowline.backgroundColor = [lhColor colorFromHexRGB:viewColorStr];
        [self addSubview:self.lowline];
        self.lowline.hidden = YES;
    }
    
    return self;
}

@end

//
//  FrankSchoolListTableViewCell.m
//  Drive
//
//  Created by lichao on 15/8/6.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import "FrankSchoolListTableViewCell.h"

@implementation FrankSchoolListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.sNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(10*widthRate, 9*widthRate, 20*widthRate, 15)];
        self.sNumLabel.text = @"1";
        self.sNumLabel.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
        self.sNumLabel.font = [UIFont fontWithName:fontName size:13];
        [self addSubview:self.sNumLabel];
        
        self.sImgView = [[UIImageView alloc]initWithFrame:CGRectMake(30*widthRate, 9*widthRate, 62*widthRate, 53*widthRate)];
        self.sImgView.backgroundColor = [UIColor grayColor];
        [self addSubview:self.sImgView];
        
        self.sNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(102*widthRate, 7*widthRate, 125*widthRate, 30*widthRate)];
        self.sNameLabel.text = @"长征驾校";
        self.sNameLabel.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
        self.sNameLabel.font = [UIFont fontWithName:fontName size:13];
        self.sNumLabel.numberOfLines = 0;
        [self addSubview:self.sNameLabel];
        
        self.starImgView = [[TQStarRatingView alloc] initWithFrame:CGRectMake(230*widthRate, 10*widthRate+(17*widthRate-15)/2, 80*widthRate, 30*widthRate) numberOfStar:5 distance:5*widthRate HeiDistance:9*widthRate];
        [self addSubview:self.starImgView];
        self.starImgView.number = 5.0f;
        self.starImgView.userInteractionEnabled = NO;
        
        self.stuNumber = [[UILabel alloc]initWithFrame:CGRectMake(102*widthRate, 42*widthRate, 80*widthRate, 17*widthRate)];
        self.stuNumber.text = @"100万+";
        self.stuNumber.textColor = [lhColor colorFromHexRGB:contentTitleColorStr1];
        self.stuNumber.font = [UIFont fontWithName:fontName size:12];
        [self addSubview:self.stuNumber];
        
        self.priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(180*widthRate, 42*widthRate, 80*widthRate, 17*widthRate)];
        self.priceLabel.text = @"￥30000";
        self.priceLabel.textColor = [lhColor colorFromHexRGB:lineColorStr];
        self.priceLabel.font = [UIFont fontWithName:fontName size:12];
        [self addSubview:self.priceLabel];
        
        self.distanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(250*widthRate, 42*widthRate, 50*widthRate, 17*widthRate)];
        self.distanceLabel.text = @"900m";
        self.distanceLabel.textAlignment = NSTextAlignmentRight;
        self.distanceLabel.textColor = [lhColor colorFromHexRGB:contentTitleColorStr1];
        self.distanceLabel.font = [UIFont fontWithName:fontName size:12];
        [self addSubview:self.distanceLabel];
        
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(10*widthRate, 70*widthRate, DeviceMaxWidth-20*widthRate, 0.5)];
        lineView.backgroundColor = [lhColor colorFromHexRGB:viewColorStr];
        [self addSubview:lineView];
        
        
    }
    return self;
}

@end

//
//  lhCityTableViewCell.m
//  Drive
//
//  Created by bosheng on 15/8/10.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import "lhCityTableViewCell.h"

@implementation lhCityTableViewCell

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
        //40
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.cityLabel = [[UILabel alloc]initWithFrame:CGRectMake(25*widthRate, 0, DeviceMaxWidth-50*widthRate, 40*widthRate)];
        self.cityLabel.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
        self.cityLabel.font = [UIFont fontWithName:fontName size:14];
        [self addSubview:self.cityLabel];
        
        self.lowView = [[UIView alloc]initWithFrame:CGRectMake(25*widthRate, 40*widthRate-0.5, DeviceMaxWidth-50*widthRate, 0.5)];
        self.lowView.backgroundColor = [lhColor colorFromHexRGB:contentTitleColorStr];
        [self addSubview:self.lowView];
    }
    
    return self;
}

@end

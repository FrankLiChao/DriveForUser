//
//  lhHotCityTableViewCell.m
//  Drive
//
//  Created by bosheng on 15/8/10.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import "lhHotCityTableViewCell.h"

@implementation lhHotCityTableViewCell

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
        //120
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.lowView = [[UIView alloc]initWithFrame:CGRectMake(0, 120*widthRate-0.5, DeviceMaxWidth-25*widthRate, 0.5)];
        self.lowView.backgroundColor = [lhColor colorFromHexRGB:contentTitleColorStr];
        [self addSubview:self.lowView];
    }
    
    return self;
}

@end

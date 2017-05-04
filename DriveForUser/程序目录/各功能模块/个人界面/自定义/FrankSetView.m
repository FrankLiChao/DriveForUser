//
//  FrankSetView.m
//  Drive
//
//  Created by lichao on 15/10/27.
//  Copyright © 2015年 bosheng. All rights reserved.
//

#import "FrankSetView.h"

@implementation FrankSetView

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
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20*widthRate, 0, 200*widthRate, 40*widthRate)];
        self.titleLabel.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.titleLabel];
        
        self.yjtImgView = [[UIImageView alloc]initWithFrame:CGRectMake(294*widthRate, 16*widthRate, 6*widthRate, 8*widthRate)];
        self.yjtImgView.image = imageWithName(@"youjiantouImage");
        [self addSubview:self.yjtImgView];
        
        self.mSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(250*widthRate, 5*widthRate, 60*widthRate, 30*widthRate)];
        self.mSwitch.on = YES;
        [self addSubview:self.mSwitch];
        self.mSwitch.hidden = YES;
        
        self.topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 0.5)];
        self.topLine.backgroundColor = tableDefSepLineColor;
        [self addSubview:self.topLine];
        
        self.lowLine = [[UIView alloc]initWithFrame:CGRectMake(0, 40*widthRate-0.5, DeviceMaxWidth, 0.5)];
        self.lowLine.backgroundColor = tableDefSepLineColor;
        [self addSubview:self.lowLine];
    }
    
    return self;
}

@end

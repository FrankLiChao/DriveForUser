//
//  lhZFPayTableViewCell.m
//  GasStation
//
//  Created by bosheng on 15/11/6.
//  Copyright © 2015年 bosheng. All rights reserved.
//

#import "lhZFPayTableViewCell.h"

@implementation lhZFPayTableViewCell

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
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.titleLabel];
        
        self.conBtn = [[UIButton alloc] initWithFrame:CGRectMake(DeviceMaxWidth-160*widthRate, 0, 150*widthRate, 40*widthRate)];
        self.conBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [self.conBtn setTitle:ourServicePhone forState:UIControlStateNormal];
        [self.conBtn setTitleColor:[lhColor colorFromHexRGB:mainColorStr] forState:UIControlStateNormal];
        self.conBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.conBtn];
        self.conBtn.hidden = YES;
        
        self.yjtImgView = [[UIImageView alloc]initWithFrame:CGRectMake(DeviceMaxWidth-25*widthRate, 14*widthRate, 12*widthRate, 12*widthRate)];
        self.yjtImgView.image = imageWithName(@"youjiantou");
        [self addSubview:self.yjtImgView];
        
        CGFloat ff = 5*widthRate;
        if (iPhone5 || iPhone6 || iPhone6plus) {
            ff = 7*widthRate;
        }
        self.mSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(255*widthRate, ff, 50*widthRate, 30*widthRate)];
        self.mSwitch.on = NO;
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

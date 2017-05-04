//
//  FrankTableViewCell.m
//  Drive
//
//  Created by lichao on 15/7/27.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import "FrankTableViewCell.h"

@implementation FrankTableViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier

{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _selectType = 0;
        
        _lableForImage = [[UILabel alloc] initWithFrame:CGRectMake(15*widthRate, 12*widthRate, 16*widthRate, 16*widthRate)];
        _lableForImage.font = [UIFont fontWithName:fontName size:15];
        _lableForImage.textAlignment = NSTextAlignmentCenter;
        _lableForImage.layer.masksToBounds = YES;
        _lableForImage.layer.cornerRadius = 8.0*widthRate;
        _lableForImage.layer.borderWidth = 0.5;
        _lableForImage.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
        [self addSubview:_lableForImage];
        
        UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, 40*widthRate, DeviceMaxWidth, 0.5)];
        lineV.backgroundColor = [lhColor colorFromHexRGB:viewColorStr];
        [self addSubview:lineV];
        
        self.answerForLab = [[UILabel alloc] initWithFrame:CGRectMake(45*widthRate, 0, DeviceMaxWidth-60*widthRate, 40*widthRate)];
        self.answerForLab.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
        self.answerForLab.font = [UIFont systemFontOfSize:14];
        self.answerForLab.numberOfLines = 0;
        self.answerForLab.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.answerForLab];
    }
    return self;
}


@end

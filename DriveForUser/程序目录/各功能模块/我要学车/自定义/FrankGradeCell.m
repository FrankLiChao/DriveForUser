//
//  FrankGradeCell.m
//  Drive
//
//  Created by lichao on 15/12/11.
//  Copyright © 2015年 bosheng. All rights reserved.
//

#import "FrankGradeCell.h"

@implementation FrankGradeCell

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
        self.nameLable = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, 10*widthRate, 220*widthRate, 20*widthRate)];
        self.nameLable.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
        self.nameLable.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.nameLable];
        
        self.priceLable = [[UILabel alloc] initWithFrame:CGRectMake(DeviceMaxWidth-100*widthRate, 10*widthRate, 90*widthRate, 20*widthRate)];
        self.priceLable.font = [UIFont systemFontOfSize:15];
        self.priceLable.textAlignment = NSTextAlignmentRight;
        self.priceLable.textColor = [lhColor colorFromHexRGB:lineColorStr];
        [self addSubview:self.priceLable];
        
        UIView * lineV = [[UIView alloc] initWithFrame:CGRectMake(10*widthRate, 40*widthRate-0.5, DeviceMaxWidth-20*widthRate, 0.5)];
        lineV.backgroundColor = [lhColor colorFromHexRGB:viewColorStr];
        [self addSubview:lineV];
    }
    return self;
}

@end

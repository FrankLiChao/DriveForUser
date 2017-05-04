//
//  FrankMessageCell.m
//  Drive
//
//  Created by lichao on 15/10/26.
//  Copyright © 2015年 bosheng. All rights reserved.
//

#import "FrankMessageCell.h"

@implementation FrankMessageCell

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
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.bgLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth-20*widthRate, 90*widthRate)];
//        self.bgLab.layer.borderWidth = 0.5;
//        self.bgLab.layer.borderColor = [[lhColor colorFromHexRGB:contentTitleColorStr1] CGColor];
//        self.bgLab.layer.cornerRadius = 4.0;
        self.bgLab.layer.allowsEdgeAntialiasing = YES;
        self.bgLab.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.bgLab];
        
        self.tLab = [[UILabel alloc] initWithFrame:CGRectMake(20*widthRate, 10*widthRate, 200*widthRate, 20*widthRate)];
        self.tLab.text = @"优惠活动";
        self.tLab.font = [UIFont systemFontOfSize:15];
        self.tLab.textColor = [lhColor colorFromHexRGB:lineColorStr];
        [self addSubview:self.tLab];
        
        self.titleTime = [[UILabel alloc] initWithFrame:CGRectMake(225*widthRate, 10*widthRate, 90*widthRate, 20*widthRate)];
        self.titleTime.text = @"2016-1-18";
        self.titleTime.font = [UIFont systemFontOfSize:15];
        self.titleTime.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
        [self addSubview:self.titleTime];
        
        self.hdImage = [[UIImageView alloc] initWithFrame:CGRectMake(20*widthRate, 40*widthRate, 40*widthRate, 40*widthRate)];
        [self addSubview:self.hdImage];
        
        self.contentLab = [[UILabel alloc] initWithFrame:CGRectMake(70*widthRate, 40*widthRate, DeviceMaxWidth-90*widthRate, 40*widthRate)];
        self.contentLab.text = @"天府大道加油站，9月3日--9月9日加油即送饮料一瓶";
        self.contentLab.textColor = [lhColor colorFromHexRGB:contentTitleColorStr1];
        self.contentLab.font = [UIFont systemFontOfSize:13];
        self.contentLab.numberOfLines = 0;
        [self addSubview:self.contentLab];
        
    }
    return self;
}

@end

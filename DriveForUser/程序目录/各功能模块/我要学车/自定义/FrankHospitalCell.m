//
//  FrankHospitalCell.m
//  Drive
//
//  Created by lichao on 15/11/21.
//  Copyright © 2015年 bosheng. All rights reserved.
//

#import "FrankHospitalCell.h"

@implementation FrankHospitalCell

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
        CGFloat withX = 8*widthRate;
        self.headImageV = [[UIImageView alloc] initWithFrame:CGRectMake(withX, 10*widthRate, 50*widthRate, 50*widthRate)];
        [self.headImageV setImage:imageWithName(@"hospital")];
        self.headImageV.layer.cornerRadius = 25*widthRate;
        [self addSubview:self.headImageV];
        
        withX += 60*widthRate;
        
        self.hospitalName = [[UILabel alloc] initWithFrame:CGRectMake(withX, 12*widthRate, DeviceMaxWidth-80*widthRate, 20*widthRate)];
        self.hospitalName.text = @"成都华西医院";
        self.hospitalName.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
        self.hospitalName.font = [UIFont systemFontOfSize:15];
//        self.hospitalName.backgroundColor = [UIColor redColor];
        [self addSubview:self.hospitalName];
        
        self.addressName = [[UILabel alloc] initWithFrame:CGRectMake(withX, 38*widthRate, 150*widthRate, 20*widthRate)];
        self.addressName.text = @"成都天府三街";
//        self.addressName.backgroundColor = [UIColor redColor];
        self.addressName.font = [UIFont systemFontOfSize:13];
        self.addressName.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
        [self addSubview:self.addressName];
        
        withX += 200*widthRate;
        
        self.distance = [[UILabel alloc] initWithFrame:CGRectMake(DeviceMaxWidth-100*widthRate, 40*widthRate, 50*widthRate, 20*widthRate)];
        self.distance.text = @"1.5Km";
        self.distance.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
        self.distance.textAlignment = NSTextAlignmentCenter;
        self.distance.font = [UIFont systemFontOfSize:11];
        [self addSubview:self.distance];
        if (iPhone5) {
            self.distance.frame = CGRectMake(DeviceMaxWidth-100*widthRate, 40*widthRate, 60*widthRate, 20*widthRate);
        }
        
        self.GPSView = [[UIImageView alloc] initWithFrame:CGRectMake(DeviceMaxWidth-35*widthRate, 20*widthRate, 30*widthRate, 30*widthRate)];
        [self.GPSView setImage:imageWithName(@"gohere")];
        [self addSubview:self.GPSView];
        
        UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, 69.5*widthRate, DeviceMaxWidth, 0.5)];
        lineV.backgroundColor = [lhColor colorFromHexRGB:contentTitleColorStr1];
        [self addSubview:lineV];
    }
    return self;
}

@end

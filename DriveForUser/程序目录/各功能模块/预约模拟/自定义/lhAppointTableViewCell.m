//
//  lhAppointTableViewCell.m
//  Drive
//
//  Created by bosheng on 15/8/11.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import "lhAppointTableViewCell.h"

@implementation lhAppointTableViewCell

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
        
        self.lowView = [[UIView alloc]initWithFrame:CGRectMake(0*widthRate, 40*widthRate-0.5, DeviceMaxWidth, 0.5)];
        self.lowView.backgroundColor = [lhColor colorFromHexRGB:buttonColorStr];
        [self addSubview:self.lowView];
        
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15*widthRate, 5*widthRate, 200*widthRate, 30*widthRate)];
        self.nameLabel.textColor = [lhColor colorFromHexRGB:contentTitleColorStr1];
        self.nameLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.nameLabel];
        
        self.numLabel = [[UILabel alloc]initWithFrame:CGRectMake(160*widthRate, 5*widthRate, 60*widthRate, 30*widthRate)];
        self.numLabel.textAlignment = NSTextAlignmentCenter;
        self.numLabel.textColor = [lhColor colorFromHexRGB:otherColorStr];
        self.numLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.numLabel];
        
        UIImage * img = imageWithName(@"mainBtnBg");
        img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        UIImage * imgS = imageWithName(@"mainBtnBg_S");
        imgS = [imgS resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        self.appButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.appButton.frame = CGRectMake(245*widthRate, 5*widthRate, 60*widthRate, 30*widthRate);
        [self.appButton setBackgroundImage:img forState:UIControlStateNormal];
        [self.appButton setBackgroundImage:imgS forState:UIControlStateSelected];
        [self.appButton setTitle:@"预约" forState:UIControlStateNormal];
        [self.appButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.appButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.appButton];
    }
    
    return self;
}

@end

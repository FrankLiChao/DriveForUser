//
//  lhSchListTableViewCell.m
//  Drive
//
//  Created by bosheng on 15/8/4.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import "lhSchListTableViewCell.h"

@implementation lhSchListTableViewCell

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
        
        self.topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 0.5)];
        self.topView.backgroundColor = [lhColor colorFromHexRGB:buttonColorStr];
        [self addSubview:self.topView];
        self.topView.hidden = YES;
        
        self.lowView = [[UIView alloc]initWithFrame:CGRectMake(0, 40*widthRate-0.5, DeviceMaxWidth, 0.5)];
        self.lowView.backgroundColor = [lhColor colorFromHexRGB:buttonColorStr];
        [self addSubview:self.lowView];
        
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15*widthRate, 5*widthRate, 200*widthRate, 30*widthRate)];
        self.nameLabel.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
        self.nameLabel.font = [UIFont fontWithName:fontName size:15];
        [self addSubview:self.nameLabel];
        
        UIImage * img = imageWithName(@"mainBtnBg");
        UIImage * imgS = imageWithName(@"mainBtnBg_S");
        imgS = [imgS resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        self.appButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.appButton.frame = CGRectMake(245*widthRate, 5*widthRate, 60*widthRate, 30*widthRate);
        [self.appButton setBackgroundImage:imgS forState:UIControlStateSelected];
        [self.appButton setBackgroundImage:img forState:UIControlStateNormal];
        [self.appButton setTitle:@"预约" forState:UIControlStateNormal];
        [self.appButton setTitle:@"已约满" forState:UIControlStateSelected];
        [self.appButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.appButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [self addSubview:self.appButton];
    }
    
    return self;
}

@end

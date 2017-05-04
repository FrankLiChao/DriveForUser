//
//  lhMyStudentsListTableViewCell.m
//  Drive
//
//  Created by bosheng on 15/8/9.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import "lhMyStudentsListTableViewCell.h"

@implementation lhMyStudentsListTableViewCell

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
        //80
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.hImgView = [[UIImageView alloc]initWithFrame:CGRectMake(15*widthRate, 10*widthRate, 60*widthRate, 60*widthRate)];
        self.hImgView.layer.cornerRadius = 30*widthRate;
        self.hImgView.layer.masksToBounds = YES;
//        self.hImgView.backgroundColor = [UIColor grayColor];
        [self addSubview:self.hImgView];

        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(88*widthRate, 13*widthRate, DeviceMaxWidth-110*widthRate, 17*widthRate)];
        self.nameLabel.text = @"李师傅";
        self.nameLabel.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
//        self.nameLabel.font = [UIFont fontWithName:fontName size:15];
        self.nameLabel.font = [UIFont boldSystemFontOfSize:15];
        [self addSubview:self.nameLabel];
        
        self.stuNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(88*widthRate, 35*widthRate, 120*widthRate, 15)];
        self.stuNumLabel.text = @"学员号 : 13041276";
        self.stuNumLabel.textColor = [lhColor colorFromHexRGB:contentTitleColorStr1];
        self.stuNumLabel.font = [UIFont fontWithName:fontName size:12];
        [self addSubview:self.stuNumLabel];
        
//        UIImageView * imgView = [[UIImageView alloc]initWithFrame:CGRectMake(88*widthRate, 30*widthRate+20*widthRate, 180*widthRate, 0.5)];
//        imgView.image = imageWithName(@"stuListXian");
//        [self addSubview:imgView];
        
        NSString *str = @"该学员科目二进行中";
        NSMutableAttributedString *as = [[NSMutableAttributedString alloc] initWithString:str];
        [as addAttribute:NSForegroundColorAttributeName value:[lhColor colorFromHexRGB:contentTitleColorStr1] range:NSMakeRange(0, 3)];
        self.statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(88*widthRate, 72*widthRate-19*widthRate, 150*widthRate, 15*widthRate)];
//        self.statusLabel.text = @"该学员科目二进行中";
        self.statusLabel.textColor = [lhColor colorFromHexRGB:mainColorStr];
        self.statusLabel.font = [UIFont fontWithName:fontName size:14];
        self.statusLabel.attributedText = as;
        [self addSubview:self.statusLabel];
        
        self.telBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.telBtn setBackgroundImage:imageWithName(@"stuListTell") forState:UIControlStateNormal];
        self.telBtn.frame = CGRectMake(DeviceMaxWidth-48*widthRate, 23*widthRate, 34*widthRate, 34*widthRate);
        [self addSubview:self.telBtn];
        
//        self.WXBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [self.WXBtn setBackgroundImage:imageWithName(@"stuListWXIcon") forState:UIControlStateNormal];
//        self.WXBtn.frame = CGRectMake(255*widthRate, 30*widthRate+15.5, 33*widthRate, 33*widthRate);
//        [self addSubview:self.WXBtn];
        
        self.lowView = [[UIView alloc]initWithFrame:CGRectMake(0, 80*widthRate-0.6, DeviceMaxWidth, 0.6)];
        self.lowView.backgroundColor = [lhColor colorFromHexRGB:viewColorStr];
        [self addSubview:self.lowView];
        
    }
    
    return self;
}


@end

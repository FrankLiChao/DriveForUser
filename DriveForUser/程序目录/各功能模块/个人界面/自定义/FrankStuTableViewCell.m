//
//  FrankStuTableViewCell.m
//  Drive
//
//  Created by lichao on 15/8/14.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import "FrankStuTableViewCell.h"

@implementation FrankStuTableViewCell

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
        //60
        self.hdImage = [[UIImageView alloc] initWithFrame:CGRectMake(10*widthRate, 10*widthRate, 40*widthRate, 40*widthRate)];
        self.hdImage.layer.cornerRadius = 20*widthRate;
//        self.hdImage.layer.borderColor = [[lhColor colorFromHexRGB:viewColorStr] CGColor];
        self.hdImage.layer.masksToBounds = YES;
//        self.hdImage.layer.allowsEdgeAntialiasing = YES;
//        self.hdImage.layer.borderWidth = 0.5;
        //defaultHead  oneHead
        [self.hdImage setImage:imageWithName(@"defaultHead")];
        [self addSubview:self.hdImage];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.nameLable = [[UILabel alloc] initWithFrame:CGRectMake(60*widthRate, 10*widthRate, 90*widthRate, 20*widthRate)];
        self.nameLable.text = @"张三";
        self.nameLable.font = [UIFont systemFontOfSize:15];
        self.nameLable.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
        [self addSubview:self.nameLable];
        
        self.numberLable = [[UILabel alloc] initWithFrame:CGRectMake(60*widthRate, 35*widthRate, 140*widthRate, 20*widthRate)];
        self.numberLable.text = [NSString stringWithFormat:@"学员编号：%@",@"23458"];
        self.numberLable.font = [UIFont systemFontOfSize:14];
        self.numberLable.textColor = [lhColor colorFromHexRGB:contentTitleColorStr1];
        [self addSubview:self.numberLable];
        
        self.phoneImage = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.phoneImage setBackgroundImage:imageWithName(@"stuListTell") forState:UIControlStateNormal];
        self.phoneImage.frame = CGRectMake(276*widthRate, 15*widthRate, 30*widthRate, 30*widthRate);
        [self addSubview:self.phoneImage];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10*widthRate, 59.5*widthRate, DeviceMaxWidth-20*widthRate, 0.5)];
        line.backgroundColor = [lhColor colorFromHexRGB:contentTitleColorStr1];
        [self addSubview:line];
//        self.weChatImage = [UIButton buttonWithType:UIButtonTypeCustom];
//        [self.weChatImage setBackgroundImage:imageWithName(@"stuListWXIcon") forState:UIControlStateNormal];
//        self.weChatImage.frame = CGRectMake(270*widthRate, 5*widthRate, 33*widthRate, 33*widthRate);
//        [self addSubview:self.weChatImage];
    }
    
    return self;
}

@end

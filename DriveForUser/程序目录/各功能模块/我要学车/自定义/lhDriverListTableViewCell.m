//
//  lhDriverListTableViewCell.m
//  Drive
//
//  Created by bosheng on 15/7/29.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import "lhDriverListTableViewCell.h"

@implementation lhDriverListTableViewCell

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
        //70
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.numLabel = [[UILabel alloc]initWithFrame:CGRectMake(10*widthRate, 9*widthRate, 13*widthRate, 15*widthRate)];
        self.numLabel.text = @"1";
        self.numLabel.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
        self.numLabel.font = [UIFont fontWithName:fontName size:15];
        [self addSubview:self.numLabel];
        
        self.hImgView = [[UIImageView alloc]initWithFrame:CGRectMake(23*widthRate, 9*widthRate, 60*widthRate, 60*widthRate)];
        self.hImgView.backgroundColor = [UIColor grayColor];
        [self addSubview:self.hImgView];
        
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(95*widthRate, 9*widthRate, 200*widthRate, 17*widthRate)];
        self.nameLabel.text = @"李师傅";
        self.nameLabel.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
        self.nameLabel.font = [UIFont fontWithName:fontName size:15];
        [self addSubview:self.nameLabel];
        
//        self.genderLabel = [[UILabel alloc]initWithFrame:CGRectMake(150*widthRate, 10*widthRate, 20*widthRate, 17*widthRate)];
//        self.genderLabel.text = @"男";
//        self.genderLabel.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
//        self.genderLabel.font = [UIFont fontWithName:fontName size:13];
//        [self addSubview:self.genderLabel];
        
//        self.ageLabel = [[UILabel alloc]initWithFrame:CGRectMake(180*widthRate, 10*widthRate, 50*widthRate, 17*widthRate)];
//        self.ageLabel.text = @"45岁";
//        self.ageLabel.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
//        self.ageLabel.font = [UIFont fontWithName:fontName size:13];
//        [self addSubview:self.ageLabel];
        
        self.starImgView = [[TQStarRatingView alloc] initWithFrame:CGRectMake(95*widthRate, 25*widthRate, 80*widthRate, 30*widthRate) numberOfStar:5 distance:5*widthRate HeiDistance:9*widthRate];
        [self addSubview:self.starImgView];
        self.starImgView.number = 5.0f;
        self.starImgView.userInteractionEnabled = NO;
        
//        NSString * alStr = @"已培训学员4332人";
//        NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:alStr];
//        [str addAttribute:NSForegroundColorAttributeName value:[lhColor colorFromHexRGB:lineColorStr] range:NSMakeRange(5, alStr.length-6)];
//        self.alLabel = [[UILabel alloc]initWithFrame:CGRectMake(92*widthRate, 28*widthRate, 108*widthRate, 17*widthRate)];
//        self.alLabel.textColor = [lhColor colorFromHexRGB:contentTitleColorStr1];
//        self.alLabel.font = [UIFont fontWithName:fontName size:12];
//        self.alLabel.attributedText = str;
//        [self addSubview:self.alLabel];
        
//        NSString * alStr1 = @"学员通过率 : 90%";
//        NSMutableAttributedString * str1 = [[NSMutableAttributedString alloc] initWithString:alStr1];
//        [str1 addAttribute:NSForegroundColorAttributeName value:[lhColor colorFromHexRGB:lineColorStr] range:NSMakeRange(8, alStr1.length-8)];
//        self.slLabel  = [[UILabel alloc]initWithFrame:CGRectMake(202*widthRate, 28*widthRate, 98*widthRate, 17*widthRate)];
//        self.slLabel.textColor = [lhColor colorFromHexRGB:contentTitleColorStr1];
//        self.slLabel.attributedText = str1;
//        self.slLabel.textAlignment = NSTextAlignmentRight;
//        self.slLabel.font = [UIFont fontWithName:fontName size:12];
//        [self addSubview:self.slLabel];
        
        self.dAgeLabel = [[UILabel alloc]initWithFrame:CGRectMake(95*widthRate, 50*widthRate, 70*widthRate, 17*widthRate)];
        self.dAgeLabel.text = @"教龄 : 5年";
        self.dAgeLabel.textColor = [lhColor colorFromHexRGB:contentTitleColorStr1];
        self.dAgeLabel.font = [UIFont fontWithName:fontName size:12];
        [self addSubview:self.dAgeLabel];
        
        self.priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(DeviceMaxWidth-100*widthRate, 30*widthRate, 90*widthRate, 17*widthRate)];
        self.priceLabel.text = @"￥30000 起";
        self.priceLabel.textColor = [lhColor colorFromHexRGB:mainColorStr];
        self.priceLabel.textAlignment = NSTextAlignmentRight;
        self.priceLabel.font = [UIFont systemFontOfSize:17];
        [self addSubview:self.priceLabel];
        
        self.distanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(150*widthRate, 50*widthRate, 50*widthRate, 17*widthRate)];
        self.distanceLabel.text = @"900m";
        self.distanceLabel.textAlignment = NSTextAlignmentRight;
        self.distanceLabel.textColor = [lhColor colorFromHexRGB:contentTitleColorStr1];
        self.distanceLabel.font = [UIFont fontWithName:fontName size:12];
        [self addSubview:self.distanceLabel];
        
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(10*widthRate, 79.5*widthRate, DeviceMaxWidth-20*widthRate, 0.5)];
        lineView.backgroundColor = [lhColor colorFromHexRGB:viewColorStr];
        [self addSubview:lineView];
    }
    
    return self;
}

@end

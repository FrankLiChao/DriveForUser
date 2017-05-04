//
//  lhDiscussTableViewCell.m
//  Drive
//
//  Created by bosheng on 15/7/30.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import "lhDiscussTableViewCell.h"

@implementation lhDiscussTableViewCell

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
        
        self.hdImage = [[UIImageView alloc] initWithFrame:CGRectMake(10*widthRate, 10*widthRate, 40*widthRate, 40*widthRate)];
        [self.hdImage setImage:imageWithName(@"twoHead")];
        self.hdImage.layer.cornerRadius = 20*widthRate;
        [self addSubview:self.hdImage];
        
        self.idLabel = [[UILabel alloc]initWithFrame:CGRectMake(60*widthRate, 5*widthRate, 150*widthRate, 20*widthRate)];
        self.idLabel.text = @"id号";
        self.idLabel.textColor = [lhColor colorFromHexRGB:@"2a80b9"];
        self.idLabel.font = [UIFont fontWithName:fontName size:13];
        [self addSubview:self.idLabel];
        
        self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(60*widthRate, 25*widthRate, 130*widthRate, 20*widthRate)];
        self.timeLabel.text = @"2015-07-06 08:23";
        self.timeLabel.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
        self.timeLabel.font = [UIFont fontWithName:fontName size:13];
        [self addSubview:self.timeLabel];
        
        NSString * contentStr = @"这个教练非常好";
        NSMutableAttributedString * as = [[NSMutableAttributedString alloc]initWithString:contentStr];
        NSMutableParagraphStyle * ps = [[NSMutableParagraphStyle alloc]init];
        [ps setLineSpacing:5];
        [ps setLineBreakMode:NSLineBreakByTruncatingTail];
        [as addAttribute:NSParagraphStyleAttributeName value:ps range:NSMakeRange(0, contentStr.length)];
        self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(60*widthRate, 48*widthRate, DeviceMaxWidth-70*widthRate, 25*widthRate)];
        self.contentLabel.numberOfLines = 0;
        self.contentLabel.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
        self.contentLabel.attributedText = as;
        self.contentLabel.font = [UIFont fontWithName:fontName size:13];
        [self addSubview:self.contentLabel];
        
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(10*widthRate, 80*widthRate-0.5*widthRate, DeviceMaxWidth-20*widthRate, 0.5)];
        lineView.backgroundColor = [lhColor colorFromHexRGB:viewColorStr];
        [self addSubview:lineView];
    }
    
    return self;
}

@end

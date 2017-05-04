//
//  FrankCommentCell.m
//  Drive
//
//  Created by lichao on 15/12/29.
//  Copyright © 2015年 bosheng. All rights reserved.
//

#import "FrankCommentCell.h"

@implementation FrankCommentCell

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
        self.hdImageV = [[UIImageView alloc] initWithFrame:CGRectMake(10*widthRate, 5*widthRate, 30*widthRate, 30*widthRate)];
        [self.hdImageV setImage:imageWithName(@"defaultHead")];
        self.hdImageV.layer.cornerRadius = 15*widthRate;
        self.hdImageV.layer.masksToBounds = YES;
        [self addSubview:self.hdImageV];
        
        self.name = [[UILabel alloc] initWithFrame:CGRectMake(50*widthRate, 5*widthRate, DeviceMaxWidth-60*widthRate, 15*widthRate)];
        self.name.text = @"该死的温柔";
        self.name.font = [UIFont systemFontOfSize:15];
        self.name.textColor = [lhColor colorFromHexRGB:@"221714"];
        [self addSubview:self.name];
        
        self.time = [[UILabel alloc] initWithFrame:CGRectMake(50*widthRate, 20*widthRate, DeviceMaxWidth-60*widthRate, 15*widthRate)];
        self.time.text = @"3小时前";
        self.time.font = [UIFont systemFontOfSize:12];
        self.time.textColor = [lhColor colorFromHexRGB:contentTitleColorStr1];
        [self addSubview:self.time];
        
        self.content = [[UILabel alloc] initWithFrame:CGRectMake(50*widthRate, 40*widthRate, DeviceMaxWidth-60*widthRate, 30*widthRate)];
        self.content.text = @"不会倒车怎么考科目二啊";
        self.content.font = [UIFont systemFontOfSize:13];
        self.content.textColor = [lhColor colorFromHexRGB:@"221714"];
        [self addSubview:self.content];
        
        UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(10*widthRate, 70*widthRate-0.5, DeviceMaxWidth-10*widthRate, 0.5)];
        lineV.backgroundColor = [lhColor colorFromHexRGB:viewColorStr];
        [self addSubview:lineV];
    }
    return self;
}

@end

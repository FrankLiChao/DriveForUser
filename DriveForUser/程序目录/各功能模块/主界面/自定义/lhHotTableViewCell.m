//
//  lhHotTableViewCell.m
//  Drive
//
//  Created by bosheng on 15/8/4.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import "lhHotTableViewCell.h"

@implementation lhHotTableViewCell

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
        //110
        
        _headImageV = [[UIImageView alloc]initWithFrame:CGRectMake(10*widthRate, 8*widthRate, 110*widthRate, 94*widthRate)];
        _headImageV.image = imageWithName(@"lunboPic3.jpg");
        _headImageV.clipsToBounds = YES;
        _headImageV.autoresizesSubviews = YES;
        [self addSubview:_headImageV];
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(130*widthRate, 8*widthRate, 180*widthRate, 60*widthRate)];
        _titleLabel.font = [UIFont fontWithName:fontName size:14];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
        NSString * ssStr = @"江西蓝天驾驶学校创建于2004年，是江西省国家一级驾驶员培训机构";
        
        if ([ssStr class] == [[NSNull alloc]class] || ssStr.length == 0) {
            ssStr = @"无主题";
        }
        
        NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc]initWithString:ssStr];
        NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle1 setLineSpacing:4];
        [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [ssStr length])];
        _titleLabel.attributedText = attributedString1;
        _titleLabel.numberOfLines = 2;
        [_titleLabel sizeToFit];
        [self addSubview:_titleLabel];
        
        _jELable = [[UILabel alloc]initWithFrame:CGRectMake(130*widthRate, 10*widthRate+_titleLabel.frame.size.height, 180*widthRate, 60*widthRate)];
        _jELable.numberOfLines = 2;
        _jELable.font = [UIFont fontWithName:fontName size:12];
        _jELable.font = [UIFont systemFontOfSize:12];
        _jELable.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
        NSString * ssStr1 = @"江西蓝天驾驶学校现拥有“一校三区”（昌东校区、昌北校区和昌南校区），总投资3亿元，总面积830余亩。";
        
        NSMutableAttributedString * attributedString2 = [[NSMutableAttributedString alloc]initWithString:ssStr1];
        NSMutableParagraphStyle * paragraphStyle2 = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle2 setLineSpacing:4];
        [attributedString2 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle2 range:NSMakeRange(0, [ssStr1 length])];
        _jELable.attributedText = attributedString2;
        _jELable.lineBreakMode = NSLineBreakByTruncatingTail;
        [_jELable sizeToFit];
        [self addSubview:_jELable];
        _jELable.frame = CGRectMake(130*widthRate,46*widthRate, 180*widthRate, _jELable.frame.size.height);
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(130*widthRate, 80*widthRate, 115*widthRate, 20*widthRate)];
        _nameLabel.font = [UIFont systemFontOfSize:13];
        _nameLabel.font = [UIFont systemFontOfSize:fontSizeMin];
        _nameLabel.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
        _nameLabel.text = @"王校长";
        [self addSubview:_nameLabel];
        
        //时间
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(250*widthRate, 80*widthRate, 60*widthRate, 20*widthRate)];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
        _timeLabel.adjustsFontSizeToFitWidth = YES;
        _timeLabel.font = [UIFont systemFontOfSize:13];
        _timeLabel.font = [UIFont systemFontOfSize:fontSizeMin];
        _timeLabel.text = @"2分钟前";
        [self addSubview:_timeLabel];
        
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 110*widthRate-0.5, DeviceMaxWidth, 0.5)];
        lineView.backgroundColor = [lhColor colorFromHexRGB:viewColorStr];
        [self addSubview:lineView];
        
    }
    
    return self;
}

@end

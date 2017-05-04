//
//  lhPersonFunDriverViewController.m
//  Drive
//
//  Created by bosheng on 15/8/7.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import "lhPersonFunDriverTableViewCell.h"


@implementation lhPersonFunDriverTableViewCell

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
        //304*40
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        self.titLabel = [[UILabel alloc]initWithFrame:CGRectMake(60*widthRate, 3*widthRate, 150*widthRate, 34*widthRate)];
        self.titLabel.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
        self.titLabel.font = [UIFont fontWithName:fontName size:14];
        [self addSubview:self.titLabel];
        
        self.lowline = [[UIView alloc]initWithFrame:CGRectMake(55*widthRate, 40*widthRate-0.5, DeviceMaxWidth-75*widthRate, 0.5)];
        self.lowline.backgroundColor = [lhColor colorFromHexRGB:viewColorStr];
        [self addSubview:self.lowline];
        self.lowline.hidden = YES;
        
        self.jtImgView = [[UIImageView alloc]initWithFrame:CGRectMake(285*widthRate, 12.5*widthRate, 9*widthRate, 15*widthRate)];
        self.jtImgView.image = imageWithName(@"youjiantou");
        [self addSubview:self.jtImgView];
        
        UIView * lineV = [[UIView alloc]initWithFrame:CGRectMake(55*widthRate, 0, 0.5, 40*widthRate)];
        lineV.backgroundColor = [lhColor colorFromHexRGB:viewColorStr];
        [self addSubview:lineV];
        
    }
    
    return self;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  lhQuestionTypeTableViewCell.m
//  GasStation
//
//  Created by bosheng on 16/2/22.
//  Copyright © 2016年 bosheng. All rights reserved.
//

#import "lhQuestionTypeTableViewCell.h"

@implementation lhQuestionTypeTableViewCell

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
        //92
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _hView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceMaxWidth/3, 92*widthRate)];
        [self addSubview:_hView1];
        
        _hImgView1 = [[UIImageView alloc]initWithFrame:CGRectMake((DeviceMaxWidth/3-30*widthRate)/2, 20*widthRate, 30*widthRate, 30*widthRate)];
        [_hView1 addSubview:_hImgView1];
        
        _tLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 55*widthRate, DeviceMaxWidth/3, 25*widthRate)];
        _tLabel1.font = [UIFont boldSystemFontOfSize:15];
        _tLabel1.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
        _tLabel1.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_tLabel1];
        
        _hView2 = [[UIView alloc]initWithFrame:CGRectMake(DeviceMaxWidth/3, 0, DeviceMaxWidth/3, 92*widthRate)];
        [self addSubview:_hView2];
        
        _hImgView2 = [[UIImageView alloc]initWithFrame:CGRectMake((DeviceMaxWidth/3-30*widthRate)/2, 20*widthRate, 30*widthRate, 30*widthRate)];
        [_hView2 addSubview:_hImgView2];
        
        _tLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(DeviceMaxWidth/3, 55*widthRate, DeviceMaxWidth/3, 25*widthRate)];
        _tLabel2.font = [UIFont boldSystemFontOfSize:15];
        _tLabel2.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
        _tLabel2.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_tLabel2];
        
        _hView3 = [[UIView alloc]initWithFrame:CGRectMake(DeviceMaxWidth/3*2, 0, DeviceMaxWidth/3, 92*widthRate)];
        [self addSubview:_hView3];
        
        _hImgView3 = [[UIImageView alloc]initWithFrame:CGRectMake((DeviceMaxWidth/3-30*widthRate)/2, 20*widthRate, 30*widthRate, 30*widthRate)];
        [_hView3 addSubview:_hImgView3];
        
        _tLabel3 = [[UILabel alloc]initWithFrame:CGRectMake(DeviceMaxWidth/3*2, 55*widthRate, DeviceMaxWidth/3, 25*widthRate)];
        _tLabel3.font = [UIFont boldSystemFontOfSize:15];
        _tLabel3.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
        _tLabel3.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_tLabel3];
        
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(DeviceMaxWidth/3-0.25, 0, 0.5, 92*widthRate)];
        lineView.backgroundColor = tableDefSepLineColor;
        [self addSubview:lineView];
        
        UIView * lineView2 = [[UIView alloc]initWithFrame:CGRectMake(DeviceMaxWidth/3*2-0.25, 0, 0.5, 92*widthRate)];
        lineView2.backgroundColor = tableDefSepLineColor;
        [self addSubview:lineView2];
        
        UIView * lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 92*widthRate-0.5, DeviceMaxWidth, 0.5)];
        lineView1.backgroundColor = tableDefSepLineColor;
        [self addSubview:lineView1];
    }
    
    return self;
}

@end

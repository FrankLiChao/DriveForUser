//
//  lhFunctionCollectionViewCell.m
//  Drive
//
//  Created by bosheng on 15/7/27.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import "lhFunctionCollectionViewCell.h"

@implementation lhFunctionCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.titleImgView = [[UIImageView alloc]initWithFrame:CGRectMake(11*widthRate, 0, 51*widthRate, 51*widthRate)];
        [self.contentView addSubview:self.titleImgView];
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 60*widthRate, 73*widthRate, 14)];
        self.titleLabel.font = [UIFont fontWithName:fontName size:14];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
        [self.contentView addSubview:self.titleLabel];
        
    }
    
    return self;
}

@end

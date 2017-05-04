//
//  CollectionViewCell.m
//  PracticeSimulation
//
//  Created by lichao on 15/7/23.
//  Copyright (c) 2015年 LiFrank. All rights reserved.
//

#import "FrankCollectionViewCell.h"

@implementation FrankCollectionViewCell

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.btnForSelectCell = [[UILabel alloc] initWithFrame:CGRectMake(3*widthRate, 3*widthRate, CGRectGetWidth(self.frame)-5*widthRate, CGRectGetWidth(self.frame)-5*widthRate)];
        self.btnForSelectCell.textAlignment = NSTextAlignmentCenter;
        self.btnForSelectCell.layer.masksToBounds = YES;
        self.btnForSelectCell.layer.cornerRadius = (CGRectGetWidth(self.frame)-5*widthRate)/2;
        self.btnForSelectCell.layer.borderWidth = 1.0;
        self.btnForSelectCell.font = [UIFont systemFontOfSize: 12.0];
        [self addSubview:self.btnForSelectCell];
    }
    return self;
}

@end

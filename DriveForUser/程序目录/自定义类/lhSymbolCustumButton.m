//
//  lhSymbolCustumButton.m
//  Drive
//
//  Created by bosheng on 15/7/29.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import "lhSymbolCustumButton.h"

@implementation lhSymbolCustumButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.tLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 29, 53, 15)];
        self.tLabel.font = [UIFont fontWithName:fontName size:11];
        self.tLabel.textColor = [UIColor whiteColor];
        self.tLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.tLabel];
    }
    return self;
}

- (instancetype)initWithFrame1:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.tLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 26.5, 51, 15)];
        self.tLabel.font = [UIFont fontWithName:fontName size:11];
        self.tLabel.textColor = [UIColor whiteColor];
        self.tLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.tLabel];
    }
    
    return self;
}

- (instancetype)initWithFrame2:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.imgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.imgBtn.frame = CGRectMake(20*widthRate, 15*widthRate, 40*widthRate, 40*widthRate);
        self.imgBtn.userInteractionEnabled = NO;
        [self addSubview:self.imgBtn];
        
        self.tLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 56*widthRate, frame.size.width, 30*widthRate)];
        self.tLabel.textAlignment = NSTextAlignmentCenter;
        self.tLabel.font = [UIFont fontWithName:fontName size:13];
        self.tLabel.textColor = [lhColor colorFromHexRGB:contentTitleColorStr1];
        [self addSubview:self.tLabel];
    }
    return self;
}

-(instancetype)initWithFrankFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.titView = [[UIImageView alloc] initWithFrame:CGRectMake(40*widthRate, 40*widthRate, 80*widthRate, 80*widthRate)];
        [self addSubview:self.titView];
        
        self.titLable = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height-40*widthRate, frame.size.width, 20*widthRate)];
        [self addSubview:self.titLable];
        if (iPhone4) {
            self.titView.frame = CGRectMake(50*widthRate, 25*widthRate, 60*widthRate, 60*widthRate);
            self.titLable.frame = CGRectMake(0, frame.size.height-35*widthRate, frame.size.width, 20*widthRate);
        }else if (iPhone6 || iPhone6plus){
            self.titLable.frame = CGRectMake(0, frame.size.height-45*widthRate, frame.size.width, 20*widthRate);
        }
    }
    return self;
}

-(instancetype)initWithFrankFrame1:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.titView = [[UIImageView alloc] initWithFrame:CGRectMake(25*widthRate, 20*widthRate, 30*widthRate, 30*widthRate)];
        [self addSubview:self.titView];
        
        self.titLable = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height-30*widthRate, frame.size.width, 20*widthRate)];
        [self addSubview:self.titLable];
        if (iPhone4) {
            self.titView.frame = CGRectMake(30*widthRate, 15*widthRate, 20*widthRate, 20*widthRate);
            self.titLable.frame = CGRectMake(0, frame.size.height-25*widthRate, frame.size.width, 20*widthRate);
        }else if (iPhone6 || iPhone6plus){
            self.titLable.frame = CGRectMake(0, frame.size.height-35*widthRate, frame.size.width, 20*widthRate);
        }
    }
    return self;
}


@end

//
//  lhCustomAnnotationView.m
//  Drive
//
//  Created by bosheng on 15/7/28.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import "lhMineAnnotationView.h"

@implementation lhMineAnnotationView

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.frame = CGRectMake(0, 0, 200, 276);
        self.backgroundColor = [UIColor clearColor];

        //大头针的图片
        self.mineBtn = [[UIButton alloc]initWithFrame:CGRectMake(76, 90, 48, 48)];
        [self.mineBtn setBackgroundImage:imageWithName(@"kaochangtubiao") forState:UIControlStateNormal];
        [self.mineBtn setBackgroundImage:imageWithName(@"kaochangtubiao") forState:UIControlStateSelected];
        [self addSubview:self.mineBtn];
        
        self.tImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 200, 90)];
        self.tImgView.userInteractionEnabled = YES;
        self.tImgView.hidden = YES;
        self.tImgView.image = imageWithName(@"kaochangtanchuang");
        [self addSubview:self.tImgView];
        
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 19, 140, 15)];
        self.nameLabel.textColor = [lhColor colorFromHexRGB:blackForShow];
        self.nameLabel.font = [UIFont fontWithName:fontName size:15];
        //        self.nameLabel.backgroundColor = [UIColor redColor];
        self.nameLabel.text = @"万州区高峰考场";
        [self.tImgView addSubview:self.nameLabel];
        
        self.addrLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 44, 140, 15)];
        self.addrLabel.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
        self.addrLabel.font = [UIFont fontWithName:fontName size:13];
        self.addrLabel.text = @"重庆市万州区高峰镇";
        [self.tImgView addSubview:self.addrLabel];
        
        self.gpsImage = [[UIImageView alloc] initWithFrame:CGRectMake(150, 8, 40, 40)];
        [self.gpsImage setImage:imageWithName(@"kaochangdaohang")];
        [self.tImgView addSubview:self.gpsImage];
        
        self.golabel = [[UILabel alloc]initWithFrame:CGRectMake(150, 48, 50, 22)];
        self.golabel.textColor = [UIColor colorWithRed:64/255.0 green:189/255.0 blue:244/255.0 alpha:1.0];
        self.golabel.font = [UIFont fontWithName:fontName size:13];
        self.golabel.text = @"到这儿";
        [self.tImgView addSubview:self.golabel];
        
    }
    
    return self;
}

//- (void)setType:(NSInteger)type
//{
//    if (type == CAR_ANNOTATION) {
//        self.backgroundColor = [UIColor clearColor];
//        //大头针的图片
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 22*widthRate, 28*widthRate)];
//        [imageView setImage:imageWithName(@"studyCar")];
//        [self addSubview:imageView];
//    }
//    else if(type == MINE_ANNOTATIN){
//        self.backgroundColor = [UIColor clearColor];
//        //大头针的图片
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20*widthRate, 32*widthRate)];
//        [imageView setImage:imageWithName(@"studyMineAddress")];
//        [self addSubview:imageView];
//    }
//    
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

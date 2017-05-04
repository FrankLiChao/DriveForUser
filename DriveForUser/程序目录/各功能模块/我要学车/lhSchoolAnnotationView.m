//
//  lhSchoolAnnotationView.m
//  Drive
//
//  Created by bosheng on 15/7/29.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import "lhSchoolAnnotationView.h"

@implementation lhSchoolAnnotationView

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.frame = CGRectMake(0, 0, 200, 276);
        self.backgroundColor = [UIColor clearColor];
        //大头针的图片
        self.schBtn = [[UIButton alloc]initWithFrame:CGRectMake(76, 90, 48, 48)];
        [self.schBtn setBackgroundImage:imageWithName(@"schoolForMap") forState:UIControlStateNormal];
        [self.schBtn setBackgroundImage:imageWithName(@"schoolForMap") forState:UIControlStateSelected];
        [self addSubview:self.schBtn];
        
        self.tImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 200, 90)];
        self.tImgView.userInteractionEnabled = YES;
        self.tImgView.hidden = YES;
        self.tImgView.image = imageWithName(@"clickAnnomationPic");
        [self addSubview:self.tImgView];
        
        self.headImgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 50, 50)];
        self.headImgView.layer.cornerRadius = 4;
        self.headImgView.layer.masksToBounds = YES;
        self.headImgView.image = imageWithName(@"default_header_icon");
        [self.tImgView addSubview:self.headImgView];
        
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 8, 100, 14)];
        self.nameLabel.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
        self.nameLabel.font = [UIFont fontWithName:fontName size:13];
//        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        self.nameLabel.text = @"长征驾校";
        [self.tImgView addSubview:self.nameLabel];
        
        self.starImgView = [[TQStarRatingView alloc]initWithFrame:CGRectMake(80, 28, 80, 14) numberOfStar:5 distance:3 HeiDistance:0];
        self.starImgView.userInteractionEnabled = NO;
        self.starImgView.number = 5.0;
        [self.tImgView addSubview:self.starImgView];
        
        self.dAgeLabel = [[UILabel alloc]initWithFrame:CGRectMake(45, 35, 67, 14)];
        self.dAgeLabel.textColor = [lhColor colorFromHexRGB:@"999999"];
        self.dAgeLabel.font = [UIFont fontWithName:fontName size:13];
        self.dAgeLabel.text = @"驾龄 : 5年";
//        [self.tImgView addSubview:self.dAgeLabel];
        
        self.priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 47, 100, 14)];
        self.priceLabel.textColor = [lhColor colorFromHexRGB:lineColorStr];
        self.priceLabel.font = [UIFont fontWithName:fontName size:13];
//        self.priceLabel.textAlignment = NSTextAlignmentCenter;
        self.priceLabel.text = @"￥ 3000起";
        [self.tImgView addSubview:self.priceLabel];
        
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

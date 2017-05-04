//
//  lhCustomAnnotationView.m
//  Drive
//
//  Created by bosheng on 15/7/28.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import "lhCarAnnotationView.h"

@implementation lhCarAnnotationView

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {

        self.frame = CGRectMake(0, 0, 200, 276);
        self.backgroundColor = [UIColor clearColor];
        //大头针的图片
        self.carBtn = [[UIButton alloc]initWithFrame:CGRectMake(76, 90, 48, 48)];
        [self.carBtn setBackgroundImage:imageWithName(@"coachCarForMap") forState:UIControlStateNormal];
        [self.carBtn setBackgroundImage:imageWithName(@"coachCarForMap") forState:UIControlStateSelected];
        [self addSubview:self.carBtn];
        
        self.tImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 200, 90)];
        self.tImgView.userInteractionEnabled = YES;
        self.tImgView.hidden = YES;
        self.tImgView.image = imageWithName(@"clickAnnomationPicOther");
        [self addSubview:self.tImgView];
        
        self.headImgView = [[UIImageView alloc]initWithFrame:CGRectMake(27, 7, 36, 36)];
        self.headImgView.layer.cornerRadius = 18;
        self.headImgView.layer.masksToBounds = YES;
        self.headImgView.image = imageWithName(@"defaultHead");
        [self.tImgView addSubview:self.headImgView];
        
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 48, 75, 14)];
        self.nameLabel.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
        self.nameLabel.font = [UIFont fontWithName:fontName size:13];
//        self.nameLabel.backgroundColor = [UIColor redColor];
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        self.nameLabel.text = @"李师傅";
        [self.tImgView addSubview:self.nameLabel];
        
        self.starImgView = [[TQStarRatingView alloc]initWithFrame:CGRectMake(95, 8, 80, 14) numberOfStar:5 distance:3 HeiDistance:0];
        self.starImgView.userInteractionEnabled = NO;
        self.starImgView.number = 5.0;
        [self.tImgView addSubview:self.starImgView];
        
        self.dAgeLabel = [[UILabel alloc]initWithFrame:CGRectMake(95, 29, 85, 14)];
        self.dAgeLabel.textColor = [lhColor colorFromHexRGB:@"999999"];
        self.dAgeLabel.font = [UIFont fontWithName:fontName size:13];
//        self.dAgeLabel.textAlignment = NSTextAlignmentCenter;
        self.dAgeLabel.text = @"驾龄 : 5年";
        [self.tImgView addSubview:self.dAgeLabel];
        
        self.priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(95, 48, 85, 14)];
        self.priceLabel.textColor = [lhColor colorFromHexRGB:lineColorStr];
        self.priceLabel.font = [UIFont fontWithName:fontName size:13];
//        self.priceLabel.textAlignment = NSTextAlignmentCenter;
        self.priceLabel.text = @"￥ 3000起";
        [self.tImgView addSubview:self.priceLabel];
        
        
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

//
//  lhDriverDetailViewController.h
//  Drive
//
//  Created by bosheng on 15/7/28.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TQStarRatingView.h"

@interface lhDriverDetailViewController : UIViewController{
    UIView * lineView;
    UIImageView * hImgView;
    UILabel * nameLabel;
    UILabel * genderLabel;
    UILabel * ageLabel;
    TQStarRatingView * starImgView;
    UILabel * dAgeLabel;
    UILabel * priceLabel;
    UILabel * alLabel;
    UILabel * schoolName;
    NSDictionary *dicData;
    UIImageView *coachCar;
    UIImageView * pictureForCar;
    UIImageView *pictureForSite1;
    UIImageView *pictureForSite2;
    UIImageView *pictureForSite3;
}

@property(nonatomic,retain)NSString *coachID;

@end

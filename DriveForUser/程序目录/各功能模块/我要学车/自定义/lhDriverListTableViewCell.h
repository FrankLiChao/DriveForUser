//
//  lhDriverListTableViewCell.h
//  Drive
//
//  Created by bosheng on 15/7/29.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TQStarRatingView.h"

@interface lhDriverListTableViewCell : UITableViewCell

@property (nonatomic,strong)UILabel * numLabel;
@property (nonatomic,strong)UIImageView * hImgView;
@property (nonatomic,strong)UILabel * nameLabel;
@property (nonatomic,strong)UILabel * genderLabel;
@property (nonatomic,strong)UILabel * ageLabel;
@property (nonatomic,strong)TQStarRatingView * starImgView;
@property (nonatomic,strong)UILabel * alLabel;
@property (nonatomic,strong)UILabel * slLabel;
@property (nonatomic,strong)UILabel * dAgeLabel;
@property (nonatomic,strong)UILabel * priceLabel;
@property (nonatomic,strong)UILabel * distanceLabel;

@end

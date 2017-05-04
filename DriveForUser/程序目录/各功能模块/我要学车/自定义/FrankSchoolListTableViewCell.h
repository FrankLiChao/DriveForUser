//
//  FrankSchoolListTableViewCell.h
//  Drive
//
//  Created by lichao on 15/8/6.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TQStarRatingView.h"

@interface FrankSchoolListTableViewCell : UITableViewCell
    
@property (nonatomic,strong)UILabel * sNumLabel;        //序号
@property (nonatomic,strong)UIImageView * sImgView;     //图片
@property (nonatomic,strong)UILabel * sNameLabel;       //驾校名称
@property (nonatomic,strong)TQStarRatingView * starImgView;    //驾校星
@property (nonatomic,strong)UILabel * stuNumber;        //学员数目
@property (nonatomic,strong)UILabel * priceLabel;       //价格
@property (nonatomic,strong)UILabel * distanceLabel;    //距离

@end

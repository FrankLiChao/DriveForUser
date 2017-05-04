//
//  lhCustomAnnotationView.h
//  Drive
//
//  Created by bosheng on 15/7/28.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "TQStarRatingView.h"

@interface lhCarAnnotationView : MKAnnotationView{
    
}

@property (nonatomic,strong)UIButton * carBtn;
@property (nonatomic,strong)UIImageView * tImgView;

@property (nonatomic,strong)UIImageView * headImgView;
@property (nonatomic,strong)UILabel * nameLabel;
@property (nonatomic,strong)TQStarRatingView * starImgView;
@property (nonatomic,strong)UILabel * dAgeLabel;
@property (nonatomic,strong)UILabel * priceLabel;
//@property (nonatomic,strong)UIButton * 

@end

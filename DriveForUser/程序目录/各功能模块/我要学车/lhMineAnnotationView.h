//
//  lhCustomAnnotationView.h
//  Drive
//
//  Created by bosheng on 15/7/28.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface lhMineAnnotationView : MKAnnotationView{
    
}

@property (nonatomic,strong)UIButton * mineBtn;
@property (nonatomic,strong)UIImageView * tImgView;

@property (nonatomic,strong)UILabel * nameLabel;    //标识的名称
@property (nonatomic,strong)UILabel * addrLabel;    //标识的地址
@property (nonatomic,strong)UIImageView * gpsImage; //导航图标
@property (nonatomic,strong)UILabel *golabel;

@end

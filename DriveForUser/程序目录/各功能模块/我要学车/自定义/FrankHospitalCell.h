//
//  FrankHospitalCell.h
//  Drive
//
//  Created by lichao on 15/11/21.
//  Copyright © 2015年 bosheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FrankHospitalCell : UITableViewCell

@property (nonatomic,strong)UIImageView *headImageV;
@property (nonatomic,strong)UILabel *hospitalName;
@property (nonatomic,strong)UILabel *addressName;
@property (nonatomic,strong)UILabel *distance;
@property (nonatomic,strong)UIImageView *GPSView;
@property (nonatomic,strong)UIButton *clickGPS;

@end

//
//  lhSettingTableViewCell.h
//  GasStation
//
//  Created by liuhuan on 15/9/4.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface lhSettingTableViewCell : UITableViewCell

@property(nonatomic,strong)UILabel * titleLabel;

@property(nonatomic,strong)UIImageView * yjtImgView;
@property(nonatomic,strong)UISwitch * mSwitch;

@property (nonatomic,strong)UIView * topLine;
@property (nonatomic,strong)UIView * lowLine;

@end

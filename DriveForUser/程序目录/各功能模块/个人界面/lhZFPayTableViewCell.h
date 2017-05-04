//
//  lhZFPayTableViewCell.h
//  GasStation
//
//  Created by bosheng on 15/11/6.
//  Copyright © 2015年 bosheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface lhZFPayTableViewCell : UITableViewCell

@property(nonatomic,strong)UILabel * titleLabel;
@property (nonatomic,strong)UIButton * conBtn;

@property(nonatomic,strong)UIImageView * yjtImgView;
@property(nonatomic,strong)UISwitch * mSwitch;

@property (nonatomic,strong)UIView * topLine;
@property (nonatomic,strong)UIView * lowLine;

@end

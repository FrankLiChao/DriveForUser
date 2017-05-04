//
//  lhMyStudentsListTableViewCell.h
//  Drive
//
//  Created by bosheng on 15/8/9.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface lhMyStudentsListTableViewCell : UITableViewCell

@property (nonatomic,strong)UIImageView * hImgView;

@property (nonatomic,strong)UILabel * nameLabel;
@property (nonatomic,strong)UILabel * stuNumLabel;
@property (nonatomic,strong)UILabel * statusLabel;
@property (nonatomic,strong)UIButton * telBtn;
//@property (nonatomic,strong)UIButton * WXBtn;

@property (nonatomic,strong)UIView * lowView;


@end

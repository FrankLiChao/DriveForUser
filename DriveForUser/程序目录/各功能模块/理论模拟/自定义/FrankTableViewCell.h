//
//  FrankTableViewCell.h
//  Drive
//
//  Created by lichao on 15/7/27.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FrankTableViewCell : UITableViewCell

@property(strong,nonatomic)UILabel     *lableForImage; //用于显示A B C D
@property(strong,nonatomic)UILabel     *answerForLab; //用于显示A B C D的答案
@property (nonatomic,assign)NSInteger  selectType;      //0:表示未被选中  1：表示选中


@end

//
//  FrankStudentApointCell.h
//  Drive
//
//  Created by lichao on 16/1/11.
//  Copyright © 2016年 bosheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FrankStudentApointCell : UITableViewCell

@property (nonatomic,strong)UILabel *subLab;        //科目
@property (nonatomic,strong)UILabel *timeLab;       //练车时段
@property (nonatomic,strong)UILabel *countLab;      //练车人数
@property (nonatomic,strong)UIButton *apointBtn;    //查看按钮

@end

//
//  FrankMyOderDetailCell.h
//  Drive
//
//  Created by lichao on 15/8/19.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FrankMyOrderDetailView;

@interface FrankMyOderDetailCell : UITableViewCell{
    NSString *serverTime;
}

@property (nonatomic ,strong)UILabel *subjectType;      //科目名称
@property (nonatomic,strong)UILabel  *createTime;       //创建时间
@property (nonatomic,strong)UILabel  *examName;         //预约考场
@property (nonatomic,strong)UILabel  *reserverTime;     //预约时间
@property (nonatomic,strong)UILabel  *vehicleNumber;    //预约车号（车牌号）
@property (nonatomic,strong)UILabel  *number;           //预约的排号(排号开始时间)
@property (nonatomic,strong)NSString *reserverStatus;   //预约状态
@property (nonatomic,strong)UILabel  *licenceType;      //车牌号类型
//@property (nonatomic,strong)FrankMyOrderDetailView *delegate;
//@property (nonatomic,strong)UIButton *deleteBtn;
@property (nonatomic,strong)UIButton *cancelBtn;
@property NSInteger  index;
@end

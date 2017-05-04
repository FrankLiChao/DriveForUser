//
//  FrankMyOderDetailCell.m
//  Drive
//
//  Created by lichao on 15/8/19.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import "FrankMyOderDetailCell.h"
#import "FrankMyOrderDetailView.h"

@implementation FrankMyOderDetailCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) { //120
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(10*widthRate, 0, DeviceMaxWidth-20*widthRate, 120*widthRate)];
        bgView.layer.borderWidth = 0.8f;
        bgView.layer.borderColor = [[UIColor grayColor] CGColor];
        bgView.layer.cornerRadius = 4.0f;
        [self addSubview:bgView];
        
        self.subjectType = [[UILabel alloc] initWithFrame:CGRectMake(20*widthRate, 5*widthRate, 70*widthRate, 20*widthRate)];
        self.subjectType.font = [UIFont systemFontOfSize:18];
        self.subjectType.textColor = [lhColor colorFromHexRGB:lineColorStr];
        self.subjectType.text = @"科目二";
        [self addSubview:self.subjectType];
        
        UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(100*widthRate, 5*widthRate, 100*widthRate, 20*widthRate)];
        lb.font = [UIFont systemFontOfSize:15];
        lb.text = @"考试车预约";
        lb.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
        [self addSubview:lb];
        
        self.createTime = [[UILabel alloc] initWithFrame:CGRectMake(DeviceMaxWidth-90*widthRate, 5*widthRate, 80*widthRate, 20*widthRate)];
        self.createTime.text = @"2015-8-19";
        self.createTime.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
        self.createTime.font = [UIFont systemFontOfSize:13];
        [self addSubview:self.createTime];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10*widthRate, 30*widthRate, DeviceMaxWidth-20*widthRate, 0.5)];
        line.backgroundColor = [UIColor grayColor];
        [self addSubview:line];
        
        self.examName = [[UILabel alloc] initWithFrame:CGRectMake(20*widthRate, 35*widthRate, 180*widthRate, 20*widthRate)];
        if (iPhone6 || iPhone6plus) {
            self.examName.frame = CGRectMake(20*widthRate, 35*widthRate, 200*widthRate, 20*widthRate);
        }
        self.examName.text = @"预约考场：万州考场";
        self.examName.font = [UIFont systemFontOfSize:13];
        self.examName.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
        [self addSubview:self.examName];
        
        self.licenceType = [[UILabel alloc] initWithFrame:CGRectMake(210*widthRate, 35*widthRate, 90*widthRate, 20*widthRate)];
        if (iPhone6 || iPhone6plus) {
            self.licenceType.frame = CGRectMake(230*widthRate, 35*widthRate, 70*widthRate, 20*widthRate);
        }
        self.licenceType.text = @"驾照类型：C1";
        self.licenceType.textAlignment = NSTextAlignmentRight;
        self.licenceType.font = [UIFont systemFontOfSize:13];
        self.licenceType.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
        [self addSubview:self.licenceType];
        
        self.reserverTime = [[UILabel alloc]initWithFrame:CGRectMake(20*widthRate, 55*widthRate, 200*widthRate, 20*widthRate)];
        self.reserverTime.font = [UIFont systemFontOfSize:13];
        self.reserverTime.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
        self.reserverTime.text = @"预约时间：2015年08月13日";
        [self addSubview:self.reserverTime];
        
        self.vehicleNumber = [[UILabel alloc] initWithFrame:CGRectMake(20*widthRate, 75*widthRate, 250*widthRate, 20*widthRate)];
        self.vehicleNumber.font = [UIFont systemFontOfSize:13];
        self.vehicleNumber.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
        self.vehicleNumber.text = @"预约车辆：03号车（川A12345）";
        [self addSubview:self.vehicleNumber];
        
        self.number = [[UILabel alloc] initWithFrame:CGRectMake(20*widthRate, 95*widthRate, 250*widthRate, 20*widthRate)];
        self.number.font = [UIFont systemFontOfSize:13];
        self.number.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
        self.number.text = @"预约排号：第5位";
        [self addSubview:self.number];
        
//        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(10*widthRate, 120*widthRate, DeviceMaxWidth-20*widthRate, 0.5)];
//        line1.backgroundColor = [UIColor grayColor];
//        [self addSubview:line1];
/*
        self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.deleteBtn.frame = CGRectMake(DeviceMaxWidth-150*widthRate, 125*widthRate, 60*widthRate, 20*widthRate);
        [self.deleteBtn setBackgroundImage:imageWithName(@"whiteBtn") forState:UIControlStateNormal];
        [self.deleteBtn setTitle:@"删除订单" forState:UIControlStateNormal];
        [self.deleteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.deleteBtn.titleLabel.font = [UIFont systemFontOfSize:13];
//        [self.deleteBtn addTarget:self action:@selector(clickDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.deleteBtn];

        self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cancelBtn.frame = CGRectMake(DeviceMaxWidth-80*widthRate, 125*widthRate, 60*widthRate, 20*widthRate);
        [self.cancelBtn setBackgroundImage:imageWithName(@"whiteBtn") forState:UIControlStateNormal];
        [self.cancelBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        [self.cancelBtn setTitleColor:[lhColor colorFromHexRGB:contentTitleColorStr] forState:UIControlStateNormal];
        self.cancelBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:self.cancelBtn];
 */
    }
    return self;
}

-(void)clickCancelBtn:(id)sender{
    UIButton *btn = (UIButton *)sender;
    self.index = btn.tag-1;
    NSLog(@"取消订单");
    if (btn.selected) {
        btn.selected = NO;
    }else{
        btn.selected = YES;
    }
    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"取消订单" message:@"您已下单并支付成功，若取消订单，\n我们将扣取20%手续费，\n确认取消订单？" delegate:self cancelButtonTitle:@"是" otherButtonTitles:@"否", nil];
    alertView.tag = 2;
    [alertView show];
    
    
}

-(void)postCancelMyorder:(NSNotification *)infor{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:infor.name object:nil];
    if (!infor.userInfo || [infor.userInfo class] == [[NSNull alloc]class]) {
        [lhColor wangluoAlertShow];
        return;
    }
    if ([[infor.userInfo objectForKey:@"status"]integerValue] == 1) {
        NSLog(@"取消订单成功 = %@",infor.userInfo);
        UIAlertView * confirm = [[UIAlertView alloc]initWithTitle:@"取消订单" message:@"确认取消订单？" delegate:self cancelButtonTitle:@"是" otherButtonTitles:@"否", nil];
        confirm.tag = 3;
        [confirm show];
        
    }
    else{
        [lhColor requestFailAlertShow:infor];
    }

}
 
-(void)requestServerTime{
    NSDictionary *dic = @{@"id":[[lhColor shareColor].userInfo objectForKey:@"id"]};
    
    [FrankNetworkManager postReqeustWithURL:PATH(@"user/serverTime") params:dic successBlock:^(id returnData){
        if ([[returnData objectForKey:@"status"]integerValue] == 1) {
            NSLog(@"继续支付 = %@",returnData);
            NSLog(@"服务器时间 = %@",[returnData objectForKey:@"date"]);
            serverTime = [returnData objectForKey:@"date"];
        }else{
            [FrankTools requestFailAlertShow:[returnData objectForKey:@"msg"]];
        }
    } failureBlock:^(NSError *error) {
        FLLog(@"%@",error.localizedDescription);
        [FrankTools wangluoAlertShow];
    } showHUD:NO];
}

@end

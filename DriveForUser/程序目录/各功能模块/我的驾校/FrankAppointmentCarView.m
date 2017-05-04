//
//  FrankAppointmentCarView.m
//  Drive
//
//  Created by lichao on 15/8/11.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import "FrankAppointmentCarView.h"
#import "FrankStudentApointCell.h"

@interface FrankAppointmentCarView ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>{
    UIScrollView *myScrollView;
    UITableView *myTableView;
    NSArray *dataForStu;
    CGFloat globalHight;
}

@end

@implementation FrankAppointmentCarView

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestServerTime];
    [[lhColor shareColor]originalInit:self title:@"预约练车" imageName:nil backButton:YES];
//    [self initFrame];

}

///3.5.1.获取服务器时间user/serverTime
-(void)requestServerTime{
    [FrankNetworkManager postReqeustWithURL:PATH(@"system/currentTime") params:@{} successBlock:^(id returnData){
        if ([[returnData objectForKey:@"status"]integerValue] == 1) {
            NSDate * date = [NSDate dateWithTimeIntervalSince1970:[[returnData objectForKey:@"data"] doubleValue]/1000];
            NSDateFormatter * df = [[NSDateFormatter alloc]init];
            [df setDateFormat:@"yyyy-MM-dd"];
            cmps = [self getTimeFromString:[NSString stringWithFormat:@"%@",[df stringFromDate:date]]];
            if (cmps) {
                [self initFrame];
            }
            [self requestCoachDateDetail];
        }else{
            [lhColor requestFailAlertShow:[returnData objectForKey:@"msg"]];
        }
    } failureBlock:^(NSError *error) {
        FLLog(@"%@",error.localizedDescription);
        [lhColor wangluoAlertShow];
    } showHUD:NO];
}

//获取学员预约详情
-(void)requestCoachDateDetail{
    [lhColor addActivityView123:myTableView];
    NSString *serverTime = [NSString stringWithFormat:@"%ld-%ld-%ld",(long)[cmps year],(long)[cmps month],selectDay];
    NSString *setDay = [NSString stringWithFormat:@"%ld%ld",[cmps month],selectDay];
    NSString *firstDay = [NSString stringWithFormat:@"%ld%ld",[cmps month],[cmps day]];
    if ([setDay integerValue] < [firstDay integerValue]) {
        NSInteger nowYear = [cmps year];
        NSInteger nowMonth = [cmps month] + 1;
        if (nowMonth > 12) {
            nowYear = [cmps year] + 1;
            nowMonth = 1;
        }
        serverTime = [NSString stringWithFormat:@"%ld-%ld-%ld",nowYear,nowMonth,selectDay];
    }
    
    NSDictionary *dic = @{@"practiceDate":serverTime,
                          @"id":[[lhColor shareColor].userInfo objectForKey:@"id"]
                          };
    NSLog(@"dic=%@",dic);
    
    [FrankNetworkManager postReqeustWithURL:PATH(@"practice/schedule") params:dic successBlock:^(id returnData){
        [lhColor disAppearActivitiView:myTableView];
        if ([[returnData objectForKey:@"status"]integerValue] == 1) {
            dataForStu = [returnData objectForKey:@"data"];
//            [self initFrame];
            if (dataForStu.count) {
                [lhColor removeNullLabelWithSuperView:myScrollView];
            }else{
                [lhColor addANullLabelWithSuperView:myScrollView withFrame:CGRectMake(0, 220*widthRate, DeviceMaxWidth, 100*widthRate) withText:@"教练暂未发布练车信息~"];
            }
            [myTableView reloadData];
            myTableView.frame = CGRectMake(0, globalHight, DeviceMaxWidth, dataForStu.count*50*widthRate);
            myScrollView.contentSize = CGSizeMake(DeviceMaxWidth, globalHight+myTableView.frame.size.height);
        }else{
            [lhColor requestFailAlertShow:[returnData objectForKey:@"msg"]];
        }
    } failureBlock:^(NSError *error) {
        FLLog(@"%@",error.localizedDescription);
        [lhColor wangluoAlertShow];
        [lhColor disAppearActivitiView:myTableView];
    } showHUD:NO];
}

/**
 *  初始化界面
 */
-(void)initFrame{
    myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, DeviceMaxWidth, DeviceMaxHeight)];
    myScrollView.showsVerticalScrollIndicator = NO;
    myScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:myScrollView];
    
    CGFloat hight = 0;
    
    UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(0, hight, DeviceMaxWidth, 40*widthRate)];
    bgview.backgroundColor = [lhColor colorFromHexRGB:viewColorStr];
    [myScrollView addSubview:bgview];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, hight+17*widthRate, 6*widthRate, 6*widthRate)];
    lab.layer.cornerRadius = 3*widthRate;
    lab.layer.masksToBounds = YES;
    lab.backgroundColor = [UIColor grayColor];
    [myScrollView addSubview:lab];
    
    UILabel *selectT = [[UILabel alloc] initWithFrame:CGRectMake(21*widthRate, 10*widthRate, 100*widthRate, 20*widthRate)];
    selectT.text = @"日期选择";
    selectT.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
    selectT.font = [UIFont systemFontOfSize:15];
    [myScrollView addSubview:selectT];
    hight += 40*widthRate;
    
    UIView *dataView = [[UIView alloc] initWithFrame:CGRectMake(0, hight, DeviceMaxWidth, 130*widthRate)];
    dataView.backgroundColor = [UIColor whiteColor];
    [myScrollView addSubview:dataView];
    
    UILabel *timeForYear = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, 18*widthRate, DeviceMaxWidth-20*widthRate, 20*widthRate)];
    timeForYear.text = [NSString stringWithFormat:@"%ld年%ld月",(long)[cmps year],(long)[cmps month]];
    timeForYear.textColor = [lhColor colorFromHexRGB:mainColorStr];
    timeForYear.font = [UIFont systemFontOfSize:18];
    timeForYear.textAlignment = NSTextAlignmentCenter;
    [dataView addSubview:timeForYear];
    
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(10*widthRate, hight+45*widthRate, DeviceMaxWidth-20*widthRate, 0.5)];
    lineV.backgroundColor = [lhColor colorFromHexRGB:contentTitleColorStr1];
    [myScrollView addSubview:lineV];
    
    //    cmps = [self getTimeFromString:@"2016-01-07"];
    CGFloat space = 0;
    for (int i=0; i<7; i++) {
        if (!cmps) {
            return;
        }
        NSArray *weekArray = @[@"周六",@"周日",@"周一",@"周二",@"周三",@"周四",@"周五"];
        weekNum = [[UILabel alloc] init];
        weekNum.tag = i+1;
        weekNum.font = [UIFont systemFontOfSize:13];
        space = 44*widthRate;
        weekNum.frame = CGRectMake(16*widthRate+i*space, 50*widthRate, 50*widthRate, 20*widthRate);
        
        dateNum = [UIButton buttonWithType:UIButtonTypeCustom];
        dateNum.frame = CGRectMake(12*widthRate+i*space, 82*widthRate, 30*widthRate, 30*widthRate);
        dateNum.layer.cornerRadius = 15.0f;
        dateNum.layer.borderColor = [[lhColor colorFromHexRGB:lineColorStr] CGColor];
        if (selectDay == 0) {
            selectDay = [cmps day];
        }
        NSInteger num = selectDay-[cmps day];
        if (selectDay == 0 && i==0) {
            dateNum.selected = YES;
        }
        if (num==i) {
            dateNum.selected = YES;
        }
        [dateNum setBackgroundImage:[UIImage imageNamed:@"timeForLianChe"] forState:UIControlStateSelected];
        [dateNum setTitle:[NSString stringWithFormat:@"%ld",((day+i)%totalDay == 0)?(totalDay):((day+i)%totalDay)] forState:UIControlStateNormal];
        [dateNum setTitle:[NSString stringWithFormat:@"%ld",((day+i)%totalDay == 0)?(totalDay):((day+i)%totalDay)] forState:UIControlStateSelected];
        [dateNum setTitleColor:[lhColor colorFromHexRGB:blackForShow] forState:UIControlStateNormal];
        [dateNum setTitleColor:[lhColor colorFromHexRGB:mainColorStr] forState:UIControlStateSelected];
        [dateNum addTarget:self action:@selector(selectTime:) forControlEvents:UIControlEventTouchUpInside];
        
        dateNum.tag = 100+i;
        weekNum.text = weekArray[(week+i)%7];
        [dataView addSubview:weekNum];
        [dataView addSubview:dateNum];
    }
    
    hight += 130*widthRate;
    
    UIView *bgView1 = [[UIView alloc] initWithFrame:CGRectMake(0, hight, DeviceMaxWidth, 40*widthRate)];
    bgView1.backgroundColor = [lhColor colorFromHexRGB:viewColorStr];
    [myScrollView addSubview:bgView1];
    
    UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, 17*widthRate, 6*widthRate, 6*widthRate)];
    lab1.layer.cornerRadius = 3*widthRate;
    lab1.layer.masksToBounds = YES;
    lab1.backgroundColor = [UIColor grayColor];
    [bgView1 addSubview:lab1];
    
    UILabel *practice = [[UILabel alloc] initWithFrame:CGRectMake(21*widthRate, 10*widthRate, 80*widthRate, 20*widthRate)];
    practice.text = @"预约练车";
    practice.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
    practice.font = [UIFont systemFontOfSize:15];
    [bgView1 addSubview:practice];
    
    UILabel *lab2 = [[UILabel alloc] initWithFrame:CGRectMake(100*widthRate, 17*widthRate, 6*widthRate, 6*widthRate)];
    lab2.layer.cornerRadius = 3*widthRate;
    lab2.layer.masksToBounds = YES;
    lab2.backgroundColor = [UIColor grayColor];
    [bgView1 addSubview:lab2];
    
    UILabel *coachLab = [[UILabel alloc] initWithFrame:CGRectMake(111*widthRate, 10*widthRate, DeviceMaxWidth-121*widthRate, 20*widthRate)];
//    coachLab.text = @"教练员--申球斯";
    coachLab.text = [NSString stringWithFormat:@"教练员--%@",self.coachName];
    coachLab.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
    coachLab.font = [UIFont systemFontOfSize:15];
    [bgView1 addSubview:coachLab];
    
    hight += 40*widthRate;
    
    globalHight = hight;
    
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, hight, DeviceMaxWidth, dataForStu.count*50*widthRate) style:UITableViewStylePlain];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.scrollEnabled = NO;
    myTableView.showsVerticalScrollIndicator = NO;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [myScrollView addSubview:myTableView];
    
    hight += myTableView.frame.size.height;
    
    myScrollView.contentSize = CGSizeMake(DeviceMaxWidth, hight+64);
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataForStu.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50*widthRate;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * tifier = @"cellName";
    
    FrankStudentApointCell *cell = [tableView dequeueReusableCellWithIdentifier:tifier];
    if (cell == nil) {
        cell = [[FrankStudentApointCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *dic = [dataForStu objectAtIndex:indexPath.row];
    if ([[dic objectForKey:@"subjectType"] integerValue]== 1) {
        cell.subLab.text = @"科目二";
    }else if ([[dic objectForKey:@"subjectType"] integerValue] == 2){
        cell.subLab.text = @"科目三";
    }else if ([[dic objectForKey:@"subjectType"] integerValue] == 3){
        cell.subLab.text = @"考前训练";
    }
    cell.timeLab.text = [NSString stringWithFormat:@"%@-%@",[dic objectForKey:@"beginTime"],[dic objectForKey:@"endTime"]];
    cell.countLab.text = [NSString stringWithFormat:@"%ld/%ld",[[dic objectForKey:@"consumeCount"] integerValue],[[dic objectForKey:@"capacity"] integerValue]];
    cell.apointBtn.tag = indexPath.row;
    [cell.apointBtn addTarget:self action:@selector(clickApointBtn:) forControlEvents:UIControlEventTouchUpInside];
    if ([[dic objectForKey:@"applied"] integerValue]) {
        [cell.apointBtn setTitle:@"取消" forState:UIControlStateNormal];
        cell.apointBtn.backgroundColor = [UIColor colorWithRed:98.0/255.0 green:237.0/255.0 blue:154.0/255.0 alpha:1.0];
//        [cell.apointBtn setBackgroundImage:imageWithName(@"cansoleApoint") forState:UIControlStateNormal];
    }else{
        [cell.apointBtn setTitle:@"预约" forState:UIControlStateNormal];
        cell.apointBtn.backgroundColor = [lhColor colorFromHexRGB:mainColorStr];
//        [cell.apointBtn setBackgroundImage:imageWithName(@"studentApointPractice") forState:UIControlStateNormal];
        if ([[dic objectForKey:@"consumeCount"] integerValue] == [[dic objectForKey:@"capacity"] integerValue]) {
            [cell.apointBtn setTitle:@"已满" forState:UIControlStateNormal];
//            [cell.apointBtn setBackgroundImage:imageWithName(@"apointFull") forState:UIControlStateNormal];
            cell.apointBtn.backgroundColor = [UIColor redColor];
        }
    }
    return cell;
}

-(void)clickApointBtn:(UIButton *)button_{
    NSArray *subArray = @[@"科目二",@"科目三",@"考前训练"];
    NSInteger number = [[[dataForStu objectAtIndex:button_.tag] objectForKey:@"subjectType"] integerValue];
    NSString *subStr = [subArray objectAtIndex:number-1];
    NSString *timeStr = [NSString stringWithFormat:@"%@-%@",[[dataForStu objectAtIndex:button_.tag] objectForKey:@"beginTime"],[[dataForStu objectAtIndex:button_.tag] objectForKey:@"endTime"]];
    NSString *dataStr = [NSString stringWithFormat:@"%ld月%ld日",(long)[cmps month],selectDay];
    if ([button_.titleLabel.text isEqualToString:@"取消"]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定要取消本次预约？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = button_.tag;
        [alertView show];
    }else if ([button_.titleLabel.text isEqualToString:@"预约"]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"\n科目：%@\n\n日期：%@\n\n时间：%@",subStr,dataStr,timeStr] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = button_.tag;
        [alertView show];
    }else if ([button_.titleLabel.text isEqualToString:@"已满"]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该时段已约满，请选择该科目的其它时段。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"buttonIndex = %ld  %@",buttonIndex,[dataForStu objectAtIndex:alertView.tag]);
    if (buttonIndex == 1) {
        NSDictionary *dic = @{@"scheduleId":[[dataForStu objectAtIndex:alertView.tag] objectForKey:@"id"],
                              @"id":[[lhColor shareColor].userInfo objectForKey:@"id"]
                              };
        NSLog(@"dic=%@",dic);
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:alertView.tag inSection:0];
        FrankStudentApointCell *cell = [myTableView cellForRowAtIndexPath:indexPath];
        if ([cell.apointBtn.titleLabel.text isEqualToString:@"预约"]) {
            [FrankNetworkManager postReqeustWithURL:PATH(@"practice/apply") params:dic successBlock:^(id returnData){
                if ([[returnData objectForKey:@"status"]integerValue] == 1) {
                    [lhColor showAlertWithMessage:@"预约成功" withSuperView:self.view withHeih:DeviceMaxHeight/2];
                    [self requestCoachDateDetail];
                }else{
                    [lhColor requestFailAlertShow:[returnData objectForKey:@"msg"]];
                }
            } failureBlock:^(NSError *error) {
                FLLog(@"%@",error.localizedDescription);
                [lhColor wangluoAlertShow];
            } showHUD:NO];
        }else if ([cell.apointBtn.titleLabel.text isEqualToString:@"取消"]){
            [FrankNetworkManager postReqeustWithURL:PATH(@"practice/cancel") params:dic successBlock:^(id returnData){
                if ([[returnData objectForKey:@"status"]integerValue] == 1) {
                    [lhColor showAlertWithMessage:@"取消预约成功" withSuperView:self.view withHeih:DeviceMaxHeight/2];
                    [self requestCoachDateDetail];
                }else{
                    [lhColor requestFailAlertShow:[returnData objectForKey:@"msg"]];
                }
            } failureBlock:^(NSError *error) {
                FLLog(@"%@",error.localizedDescription);
                [lhColor wangluoAlertShow];
            } showHUD:NO];
        }
    }
}

-(NSDateComponents *)getTimeFromString:(NSString *)str{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    comps = [calendar components:unitFlags fromDate:[dateFormatter dateFromString:str]];
    week = [comps weekday];
    day = [comps day];
    NSRange days = [calendar rangeOfUnit:NSDayCalendarUnit
                           inUnit:NSMonthCalendarUnit
                          forDate:[dateFormatter dateFromString:str]];
    totalDay = days.length;
    return comps;
}

-(void)selectTime:(UIButton *)button_{
    NSLog(@"%ld",button_.tag);
    for (int i=0; i<7; i++) {
        UIButton *btn = [self.view viewWithTag:100+i];
        if (button_.tag != i+100) {
            btn.selected = NO;
        }
    }
    if (button_.selected) {
        button_.selected = NO;
    }else{
        button_.selected = YES;
        selectDay = [button_.titleLabel.text integerValue];
    }
    
    [self requestCoachDateDetail];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [lhColor assignmentForTempVC:self];
}

@end

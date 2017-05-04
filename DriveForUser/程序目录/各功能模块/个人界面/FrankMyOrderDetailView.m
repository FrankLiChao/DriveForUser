//
//  FrankMyOrderDetailView.m
//  Drive
//
//  Created by lichao on 15/8/19.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import "FrankMyOrderDetailView.h"
#import "FrankMyOderDetailCell.h"
//#import "FrankCoachesCarOderCell.h"

@interface FrankMyOrderDetailView (){
    NSArray *coachCarOrder;
}

@end

@implementation FrankMyOrderDetailView
@synthesize myOrderArry;

- (void)viewDidLoad {
    [super viewDidLoad];
    [[lhColor shareColor]originalInit:self title:@"我的订单" imageName:nil backButton:YES];
//    [self createTitleView];
    [self requstSimulateOrder];
}

-(void)requstSimulateOrder{
    [lhColor addActivityView123:self.view];
    NSDictionary *dic = @{@"id":[[lhColor shareColor].userInfo objectForKey:@"id"]};
    
    [FrankNetworkManager postReqeustWithURL:PATH(@"simulate/testCarOrderList") params:dic successBlock:^(id returnData){
        [lhColor disAppearActivitiView:self.view];
        if ([[returnData objectForKey:@"status"]integerValue] == 1) {
            NSLog(@"订单查询成功 = %@",returnData);
            myOrderArry = [returnData objectForKey:@"data"];
            [self initFrameView];
            if (![myOrderArry count]) {
                [lhColor addANullLabelWithSuperView:myTableView withFrame:CGRectMake(10*widthRate, 70*widthRate, 300*widthRate, 20*widthRate) withText:@"暂无订单数据"];
            }
        }else{
            [FrankTools requestFailAlertShow:[returnData objectForKey:@"msg"]];
        }
    } failureBlock:^(NSError *error) {
        FLLog(@"%@",error.localizedDescription);
        [FrankTools wangluoAlertShow];
        [lhColor disAppearActivitiView:self.view];
    } showHUD:NO];
}

-(void)requstCoachCarOrder{
    [lhColor addActivityView123:self.view];
    NSDictionary *dic = @{@"id":[[lhColor shareColor].userInfo objectForKey:@"id"]};
    
    [FrankNetworkManager postReqeustWithURL:PATH(@"simulate/coachCarOrderList") params:dic successBlock:^(id returnData){
        [lhColor disAppearActivitiView:self.view];
        if ([[returnData objectForKey:@"status"]integerValue] == 1) {
            NSLog(@"教练车订单查询成功 = %@",returnData);
            coachCarOrder = [returnData objectForKey:@"data"];
            if ([coachCarOrder count]) {
                [myTableView reloadData];
            }
        }else{
            [FrankTools requestFailAlertShow:[returnData objectForKey:@"msg"]];
        }
    } failureBlock:^(NSError *error) {
        FLLog(@"%@",error.localizedDescription);
        [FrankTools wangluoAlertShow];
        [lhColor disAppearActivitiView:self.view];
    } showHUD:NO];
}

-(void)createTitleView{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, DeviceMaxWidth, 40*widthRate)];
    [self.view addSubview:titleView];
    
    UIButton *testCarOrder = [UIButton buttonWithType:UIButtonTypeCustom];
    testCarOrder.frame = CGRectMake(0, 0, DeviceMaxWidth/2, 40*widthRate);
    [testCarOrder setTitle:@"考试车订单" forState:UIControlStateNormal];
    [testCarOrder setTitleColor:[lhColor colorFromHexRGB:contentTitleColorStr] forState:UIControlStateNormal];
    [testCarOrder setTitleColor:[lhColor colorFromHexRGB:lineColorStr] forState:UIControlStateSelected];
    testCarOrder.titleLabel.font = [UIFont systemFontOfSize:15];
    testCarOrder.tag = 1;
    testCarOrder.selected = YES;
    [testCarOrder addTarget:self action:@selector(clickChooseBtn:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:testCarOrder];
    
    UIButton *coachesCarOrder = [UIButton buttonWithType:UIButtonTypeCustom];
    coachesCarOrder.frame = CGRectMake(DeviceMaxWidth/2, 0, DeviceMaxWidth/2, 40*widthRate);
    coachesCarOrder.tag = 2;
    [coachesCarOrder setTitle:@"教练车订单" forState:UIControlStateNormal];
    [coachesCarOrder setTitleColor:[lhColor colorFromHexRGB:contentTitleColorStr] forState:UIControlStateNormal];
    [coachesCarOrder setTitleColor:[lhColor colorFromHexRGB:lineColorStr] forState:UIControlStateSelected];
    coachesCarOrder.titleLabel.font = [UIFont systemFontOfSize:15];
    [coachesCarOrder addTarget:self action:@selector(clickChooseBtn:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:coachesCarOrder];
    
    lineTag = [[UIView alloc]initWithFrame:CGRectMake(DeviceMaxWidth/2, 64+41*widthRate, DeviceMaxWidth/2, 2*widthRate)];
    lineTag.backgroundColor = [lhColor colorFromHexRGB:lineColorStr];
    [self.view addSubview:lineTag];
}

-(void)initFrameView{
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, DeviceMaxWidth, DeviceMaxHeight-64) style:UITableViewStylePlain];
    myTableView.dataSource = self;
    myTableView.delegate = self;
    myTableView.backgroundColor = [UIColor whiteColor];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:myTableView];
}

-(void)clickChooseBtn:(id)sender{
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 1) {
        [myTableView removeFromSuperview];
        [self initFrameView];
        [self requstSimulateOrder];
        [lineTag removeFromSuperview];
        lineTag = [[UIView alloc]initWithFrame:CGRectMake(0, 64+41*widthRate, DeviceMaxWidth/2, 2*widthRate)];
        lineTag.backgroundColor = [lhColor colorFromHexRGB:lineColorStr];
        [self.view addSubview:lineTag];
    }else if (btn.tag == 2){
        [myTableView removeFromSuperview];
        [self initFrameView];
        [self requstCoachCarOrder];
        [lineTag removeFromSuperview];
        lineTag = [[UIView alloc]initWithFrame:CGRectMake(DeviceMaxWidth/2, 64+41*widthRate, DeviceMaxWidth/2, 2*widthRate)];
        lineTag.backgroundColor = [lhColor colorFromHexRGB:lineColorStr];
        [self.view addSubview:lineTag];
    }
    for (int i=1; i<=2; i++) {
        if (btn.tag == i) {
            btn.selected = YES;
        }else{
            ((UIButton *)[self.view viewWithTag:i]).selected = NO;
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [myOrderArry count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10*widthRate;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130*widthRate;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * indentifier = @"myOderCell";
    FrankMyOderDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[FrankMyOderDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.cancelBtn addTarget:self action:@selector(clickDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
    if ([myOrderArry count]) {
        cell.cancelBtn.tag = indexPath.row+1;
        if ([[myOrderArry[indexPath.row] objectForKey:@"subjectType"] integerValue] == 2) {
            cell.subjectType.text = @"科目二";
        }else if ([[myOrderArry[indexPath.row] objectForKey:@"subjectType"] integerValue] == 3){
            cell.subjectType.text = @"科目三";
        }
        cell.createTime.text = [NSString stringWithFormat:@"%@",[self getTimeFromString:[myOrderArry[indexPath.row] objectForKey:@"createTime"]]];
        cell.reserverTime.text = [NSString stringWithFormat:@"预约时间 : %@",[self getTimeFromString:[myOrderArry[indexPath.row] objectForKey:@"reserveTime"]]];
        cell.examName.text = [NSString stringWithFormat:@"预约考场：%@",[myOrderArry[indexPath.row] objectForKey:@"examName"]];
        cell.licenceType.text = [NSString stringWithFormat:@"驾照类型：%@",[myOrderArry[indexPath.row] objectForKey:@"drivingType"]];
        cell.vehicleNumber.text = [NSString stringWithFormat:@"预约车辆：%@号车（%@）",[myOrderArry[indexPath.row] objectForKey:@"vehicleNumber"],[myOrderArry[indexPath.row] objectForKey:@"plateNumber"]];
        cell.number.text = [NSString stringWithFormat:@"预约排号：第%@位",[myOrderArry[indexPath.row] objectForKey:@"number"]];
        //            [cell.cancelBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        
    }
    return cell;
}

#pragma mark - clickEvent
-(void)clickDeleteBtn:(id)sender{
    UIButton *btn = (UIButton *)sender;
    NSLog(@"订单  = %@",myOrderArry[btn.tag-1]);
    if (btn.selected) {
        btn.selected = NO;
    }else{
        btn.selected = YES;
    }
    NSDictionary *dic = @{@"id":[[lhColor shareColor].userInfo objectForKey:@"id"],
                          @"orderId":[myOrderArry[btn.tag-1] objectForKey:@"orderId"]};
    
    [FrankNetworkManager postReqeustWithURL:PATH(@"simulate/deleteOrder") params:dic successBlock:^(id returnData){
        if ([[returnData objectForKey:@"status"]integerValue] == 1) {
            NSLog(@"删除订单成功 = %@",returnData);
            [lhColor showAlertWithMessage:@"取消订单成功" withSuperView:self.view withHeih:DeviceMaxWidth/2];
            [myTableView reloadData];
        }else{
            [FrankTools requestFailAlertShow:[returnData objectForKey:@"msg"]];
        }
    } failureBlock:^(NSError *error) {
        FLLog(@"%@",error.localizedDescription);
        [FrankTools wangluoAlertShow];
    } showHUD:NO];
}

-(void)clickCancelBtn:(id)sender{
    UIAlertView * confirm = [[UIAlertView alloc]initWithTitle:@"取消订单" message:@"确认取消订单？" delegate:self cancelButtonTitle:@"是" otherButtonTitles:@"否", nil];
    [confirm show];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSDictionary *dic = @{@"id":[[lhColor shareColor].userInfo objectForKey:@"id"],
                          @"orderId":[myOrderArry[0] objectForKey:@"ordreId"]};
    
    [FrankNetworkManager postReqeustWithURL:PATH(@"simulate/cancelOrder") params:dic successBlock:^(id returnData){
        if ([[returnData objectForKey:@"status"]integerValue] == 1) {
            [lhColor showAlertWithMessage:@"取消订单成功" withSuperView:self.view withHeih:DeviceMaxWidth/2];
            [self requstSimulateOrder];
        }else{
            [FrankTools requestFailAlertShow:[returnData objectForKey:@"msg"]];
        }
    } failureBlock:^(NSError *error) {
        FLLog(@"%@",error.localizedDescription);
        [FrankTools wangluoAlertShow];
    } showHUD:NO];
}

-(NSString *)getTimeFromString:(NSString *)str{
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:[str doubleValue]/1000];
    NSDateFormatter * df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM-dd"];
    return [df stringFromDate:date];
}

-(void)refreshCell{
    [self requstSimulateOrder];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [lhColor assignmentForTempVC:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

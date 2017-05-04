//
//  lhFirmOrderViewController.m
//  Drive
//
//  Created by bosheng on 15/8/11.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import "lhFirmOrderViewController.h"
#import "lhMyAppOrderViewController.h"

#import "WXApi.h"

#define maxTimeCount 15*60

@interface lhFirmOrderViewController ()<UIAlertViewDelegate>
{
    NSInteger counTime;//时间
    NSTimer * moveTimer;//计时器
    
    //支付宝支付
    NSDictionary * orderDic;
    NSDictionary * payDic;
    NSMutableDictionary * saveDi;
    
    UILabel * timeLabel;
    NSInteger payType;
    UIScrollView * maxScrollView;
}

@end

@implementation lhFirmOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[lhColor shareColor]originalInit:self title:@"订单信息" imageName:nil backButton:NO];
    
    counTime = maxTimeCount;
    NSLog(@"data = %@",self.userDic);
    
    UIButton * backBg = [[UIButton alloc]initWithFrame:CGRectMake(2, 20, 40, 44)];
    [backBg setBackgroundImage:imageWithName(@"back") forState:UIControlStateNormal];
    [self.view addSubview:backBg];
    [backBg addTarget:self action:@selector(backButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    if (self.orderType == 1) {
        [self initFrameView];
    }else{
        [self firmInit];
    }
    
}

-(void)initFrameView
{
    CGFloat hight = 0;
    maxScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, DeviceMaxWidth, DeviceMaxHeight)];
    maxScrollView.showsVerticalScrollIndicator = NO;
    maxScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:maxScrollView];
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 80*widthRate)];
    titleView.backgroundColor = [lhColor colorFromHexRGB:mainColorStr];
    [maxScrollView addSubview:titleView];
    
    UIImageView *moneyImage = [[UIImageView alloc] initWithFrame:CGRectMake(40*widthRate, 10*widthRate, 30*widthRate, 30*widthRate)];
    [moneyImage setImage:imageWithName(@"moneyTag")];
    [titleView addSubview:moneyImage];
    
    UILabel *moneyLab = [[UILabel alloc] initWithFrame:CGRectMake(60*widthRate, 10*widthRate, DeviceMaxWidth-120*widthRate, 60*widthRate)];
//    NSLog(@"订单信息 = %@",self.userDic);
//    moneyLab.text = @"50.00";
    moneyLab.text = [NSString stringWithFormat:@"%@.0",[self.userDic objectForKey:@"deposit"]];
    moneyLab.textColor = [UIColor whiteColor];
    moneyLab.font = [UIFont boldSystemFontOfSize:65];
    moneyLab.textAlignment = NSTextAlignmentCenter;
    [titleView addSubview:moneyLab];
    if (iPhone5) {
        moneyImage.frame = CGRectMake(35*widthRate, 10*widthRate, 30*widthRate, 30*widthRate);
        moneyLab.font = [UIFont boldSystemFontOfSize:60];
    }
    
    
//    UILabel *timeLab = [[UILabel alloc] initWithFrame:CGRectMake(20*widthRate, 90*widthRate, DeviceMaxWidth-20*widthRate, 30*widthRate)];
//    timeLab.text = @"29 : 59";
//    timeLab.font = [UIFont systemFontOfSize:35];
//    timeLab.textColor = [UIColor whiteColor];
//    timeLab.textAlignment = NSTextAlignmentCenter;
//    [titleView addSubview:timeLab];
    
    hight += 80*widthRate;
    
    UIView *apontOrder = [[UIView alloc] initWithFrame:CGRectMake(0, hight, DeviceMaxWidth, 40*widthRate)];
    apontOrder.backgroundColor = [lhColor colorFromHexRGB:viewColorStr];
    [maxScrollView addSubview:apontOrder];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15*widthRate, 17*widthRate, 6*widthRate, 6*widthRate)];
    lab.layer.cornerRadius = 3*widthRate;
    lab.layer.masksToBounds = YES;
    lab.backgroundColor = [UIColor grayColor];
    [apontOrder addSubview:lab];
    
    UILabel *selectT = [[UILabel alloc] initWithFrame:CGRectMake(26*widthRate, 10*widthRate, 100*widthRate, 20*widthRate)];
    selectT.text = @"预约信息";
    selectT.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
    selectT.font = [UIFont systemFontOfSize:15];
    [apontOrder addSubview:selectT];
    
    hight += 40*widthRate;
    
    UIView *orderView = [[UIView alloc] initWithFrame:CGRectMake(10*widthRate, hight, DeviceMaxWidth-20*widthRate, 9*30*widthRate)];
    [maxScrollView addSubview:orderView];
    
    UILabel *apoint = [[UILabel alloc] initWithFrame:CGRectMake(0, 6*widthRate, 8*widthRate, 8*widthRate)];
    apoint.layer.cornerRadius = 4*widthRate;
    apoint.layer.masksToBounds = YES;
    apoint.backgroundColor = [lhColor colorFromHexRGB:mainColorStr];
    [orderView addSubview:apoint];
    
    NSArray *nameArray = @[@"姓        名",@"预约考场",@"考场地址",@"预约时间",@"预约车辆",@"预约车型",@"预约排号",@"身份证号",@"联系电话"];
//    NSArray *contentArray = @[@"李超",@"重庆市万州区高峰科目二考场",@"重庆市万州区",@"2016年1月17日",@"1号车",@"C1",@"17号",@"510626199004074419",@"13258358090"];
    NSMutableArray * tempA = [NSMutableArray array];
    NSString * dStr = [NSString stringWithFormat:@"%@",[self.userDic objectForKey:@"reserverTime"]];
    if (dStr && dStr.length>=10) {
        dStr = [dStr substringToIndex:10];
    }
    NSString * t;
    NSInteger n = [[self.userDic objectForKey:@"reserverNumber"] integerValue];
    if (n < 10) {
        t = [NSString stringWithFormat:@"0%ld号",(long)n];
    }
    else{
        t = [NSString stringWithFormat:@"%ld号",(long)n];
    }
    
    [tempA addObject:[self.userDic objectForKey:@"reserverName"]];
    [tempA addObject:[self.userDic objectForKey:@"examName"]];
    [tempA addObject:self.examAddress];
    [tempA addObject:dStr];
//    [tempA addObject:[NSString stringWithFormat:@"%@号车(%@)",[self.userDic objectForKey:@"reserverVehicleNumber"],[self.userDic objectForKey:@"reserverPlateNumber"]]];
    [tempA addObject:[NSString stringWithFormat:@"%@号车",[self.userDic objectForKey:@"reserverVehicleNumber"]]];
    [tempA addObject:[self.userDic objectForKey:@"drivingType"]];
    [tempA addObject:t];
    [tempA addObject:[self.userDic objectForKey:@"reserverIdCard"]];
    [tempA addObject:[self.userDic objectForKey:@"reserverPhone"]];
    for (int i = 0; i < 9; i++) {
        NSString * str = [NSString stringWithFormat:@"%@:  %@",[nameArray objectAtIndex:i],[tempA objectAtIndex:i]];
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(13*widthRate, i*20*widthRate, DeviceMaxWidth-45*widthRate, 20*widthRate)];
        label.text = str;
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
        [orderView addSubview:label];
        
        hight += 20*widthRate;
    }
    
    UIView *payView = [[UIView alloc] initWithFrame:CGRectMake(0, hight, DeviceMaxWidth, 40*widthRate)];
    payView.backgroundColor = [lhColor colorFromHexRGB:viewColorStr];
    [maxScrollView addSubview:payView];
    
    UILabel *payLab = [[UILabel alloc] initWithFrame:CGRectMake(15*widthRate, 17*widthRate, 6*widthRate, 6*widthRate)];
    payLab.layer.cornerRadius = 3*widthRate;
    payLab.layer.masksToBounds = YES;
    payLab.backgroundColor = [UIColor grayColor];
    [payView addSubview:payLab];
    
    UILabel *selectPay = [[UILabel alloc] initWithFrame:CGRectMake(26*widthRate, 10*widthRate, 200*widthRate, 20*widthRate)];
    selectPay.text = @"请选择支付方式";
    selectPay.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
    selectPay.font = [UIFont systemFontOfSize:15];
    [payView addSubview:selectPay];
    
    hight += 40*widthRate;
    
    UIView *selectPayView = [[UIView alloc] initWithFrame:CGRectMake(0, hight, DeviceMaxWidth, 50*widthRate)];
    selectPayView.backgroundColor = [UIColor whiteColor];
    [maxScrollView addSubview:selectPayView];
    
    UIButton *weixinPayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    weixinPayBtn.frame = CGRectMake(10*widthRate, 10*widthRate, 147*widthRate, 30*widthRate);
    weixinPayBtn.tag = 500;
    [weixinPayBtn setBackgroundImage:imageWithName(@"weixinPayImage_No") forState:UIControlStateNormal];
    [weixinPayBtn setBackgroundImage:imageWithName(@"weixinPayImage_Yes") forState:UIControlStateSelected];
    [weixinPayBtn addTarget:self action:@selector(selectPayWay:) forControlEvents:UIControlEventTouchUpInside];
    [selectPayView addSubview:weixinPayBtn];
    
    UIButton *zhifubPayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    zhifubPayBtn.frame = CGRectMake(DeviceMaxWidth-157*widthRate, 10*widthRate, 147*widthRate, 30*widthRate);
    zhifubPayBtn.tag = 501;
    [zhifubPayBtn setBackgroundImage:imageWithName(@"zhifubaoPayImage_No") forState:UIControlStateNormal];
    [zhifubPayBtn setBackgroundImage:imageWithName(@"zhifubaoPayImage_Yes") forState:UIControlStateSelected];
    [zhifubPayBtn addTarget:self action:@selector(selectPayWay:) forControlEvents:UIControlEventTouchUpInside];
    [selectPayView addSubview:zhifubPayBtn];
    
    hight += 50*widthRate;
    
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(10*widthRate, hight-0.5, DeviceMaxWidth-10*widthRate, 0.5)];
    lineV.backgroundColor = [lhColor colorFromHexRGB:contentTitleColorStr1];
    [maxScrollView addSubview:lineV];
    
    hight += 10*widthRate;
    
    NSString *str = @"温馨提示：\n如果预约两次都未到场，本月将无法再次预约";
    NSMutableAttributedString * as = [[NSMutableAttributedString alloc]	initWithString:str];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:5];
    [as addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, str.length)];    UILabel * tLabel = [[UILabel alloc]initWithFrame:CGRectMake(20*widthRate, hight, DeviceMaxWidth-30*widthRate, 40*widthRate)];
    tLabel.numberOfLines = 0;
    tLabel.attributedText = as;
    tLabel.font = [UIFont systemFontOfSize:15];
    tLabel.textColor = [lhColor colorFromHexRGB:mainColorStr];
    [tLabel sizeToFit];
    [maxScrollView addSubview:tLabel];
    
    hight += 40*widthRate;
    
    UIButton *payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    payButton.frame = CGRectMake(0, hight+30*widthRate, DeviceMaxWidth, 50*widthRate);
    payButton.backgroundColor = [lhColor colorFromHexRGB:lineColorStr];
    [payButton setTitle:@"确认支付" forState:UIControlStateNormal];
    [payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    payButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [payButton addTarget:self action:@selector(createOrder) forControlEvents:UIControlEventTouchUpInside];
    [maxScrollView addSubview:payButton];
    
    hight += 80*widthRate;
    
    maxScrollView.contentSize = CGSizeMake(DeviceMaxWidth, hight+64+5*widthRate);
}

-(void)selectPayWay:(UIButton *)button_{
    UIButton *weiBtn = (UIButton *)[self.view viewWithTag:500];
    UIButton *zhifuBtn = (UIButton *)[self.view viewWithTag:501];
    if (button_.tag == 500) {
        zhifuBtn.selected = NO;
    }else if (button_.tag ==501){
        weiBtn.selected = NO;
    }
    if (button_.selected) {
        button_.selected = NO;
    }else{
        button_.selected = YES;
        if (button_.tag == 500) {
            payType = 1;
        }else if (button_.tag == 501){
            payType = 2;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 返回
- (void)backButtonEvent
{
//    [self deleteOrderById:[NSString stringWithFormat:@"%@",[[orderDic objectForKey:@"data"] objectForKey:@"id"]]];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark - 创建预约模拟订单
- (void)createOrder
{
    //请求我的驾校数据
    [lhColor addActivityView:self.view];
    NSDictionary * dic = @{@"id":[[lhColor shareColor].userInfo objectForKey:@"id"],
                           @"payType":[NSString stringWithFormat:@"%ld",payType],
                           @"money":[NSString stringWithFormat:@"%@",[self.userDic objectForKey:@"amountMoney"]],
                           @"orderId":[self.userDic objectForKey:@"orderId"],
                           };
    [FrankNetworkManager postReqeustWithURL:PATH(@"order/simulation/pay") params:dic successBlock:^(id returnData){
        [lhColor disAppearActivitiView:self.view];
        if ([[returnData objectForKey:@"status"]integerValue] == 1) {
            
        }else{
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请求失败" message:[NSString stringWithFormat:@"%@",[returnData objectForKey:@"msg"]] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            alertView.tag = 2;
            [alertView show];
        }
    } failureBlock:^(NSError *error) {
        FLLog(@"%@",error.localizedDescription);
        [lhColor disAppearActivitiView:self.view];
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"连接失败" message:@"请检查网络或稍后重试！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alertView.tag = 2;
        [alertView show];
    } showHUD:NO];
}


- (void)createOrderEvent:(NSNotification *)noti
{
    [lhColor disAppearActivitiView:self.view];
    NSLog(@"结果%@",noti.userInfo);
    [[NSNotificationCenter defaultCenter]removeObserver:self name:noti.name object:nil];
    if (!noti.userInfo || [noti.userInfo class] == [NSNull class]) {
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"连接失败" message:@"请检查网络或稍后重试！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alertView.tag = 2;
        [alertView show];
    }
    else if([[noti.userInfo objectForKey:@"status"]integerValue] == 1){
        orderDic = [NSMutableDictionary dictionaryWithDictionary:[noti.userInfo objectForKey:@"data"]];
        NSLog(@"orderDic = %@",orderDic);
        [self firmBtnEvent];
    }
    else{
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请求失败" message:[NSString stringWithFormat:@"%@",[noti.userInfo objectForKey:@"msg"]] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alertView.tag = 2;
        [alertView show];
    }
}

#pragma mark - firmInit
- (void)firmInit
{
    CGFloat hight = 0;
    maxScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, DeviceMaxWidth, DeviceMaxHeight)];
    maxScrollView.showsVerticalScrollIndicator = NO;
    maxScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:maxScrollView];
    
    UIView *apontOrder = [[UIView alloc] initWithFrame:CGRectMake(0, hight, DeviceMaxWidth, 40*widthRate)];
    apontOrder.backgroundColor = [lhColor colorFromHexRGB:viewColorStr];
    [maxScrollView addSubview:apontOrder];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15*widthRate, 17*widthRate, 6*widthRate, 6*widthRate)];
    lab.layer.cornerRadius = 3*widthRate;
    lab.layer.masksToBounds = YES;
    lab.backgroundColor = [UIColor grayColor];
    [apontOrder addSubview:lab];
    
    UILabel *selectT = [[UILabel alloc] initWithFrame:CGRectMake(26*widthRate, 10*widthRate, 100*widthRate, 20*widthRate)];
    selectT.text = @"预约信息";
    selectT.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
    selectT.font = [UIFont systemFontOfSize:15];
    [apontOrder addSubview:selectT];
    
    hight += 40*widthRate;
    
    UIView *orderView = [[UIView alloc] initWithFrame:CGRectMake(10*widthRate, hight, DeviceMaxWidth-20*widthRate, 9*30*widthRate)];
    [maxScrollView addSubview:orderView];
    
    UILabel *apoint = [[UILabel alloc] initWithFrame:CGRectMake(0, 6*widthRate, 8*widthRate, 8*widthRate)];
    apoint.layer.cornerRadius = 4*widthRate;
    apoint.layer.masksToBounds = YES;
    apoint.backgroundColor = [lhColor colorFromHexRGB:mainColorStr];
    [orderView addSubview:apoint];
    
    NSArray *nameArray = @[@"姓        名",@"预约考场",@"考场地址",@"预约时间",@"预约车辆",@"预约车型",@"预约排号",@"身份证号",@"联系电话"];
//        NSArray *contentArray = @[@"李超",@"重庆市万州区高峰科目二考场",@"重庆市万州区",@"2016年1月17日",@"1号车",@"C1",@"17号",@"510626199004074419",@"13258358090"];
    NSMutableArray * contentArray = [NSMutableArray array];
    NSString * dStr = [NSString stringWithFormat:@"%@",[self.userDic objectForKey:@"reserverTime"]];
    if (dStr && dStr.length>=10) {
        dStr = [dStr substringToIndex:10];
    }
    NSString * t;
    NSInteger n = [[self.userDic objectForKey:@"reserverNumber"] integerValue];
    if (n < 10) {
        t = [NSString stringWithFormat:@"0%ld号",(long)n];
    }
    else{
        t = [NSString stringWithFormat:@"%ld号",(long)n];
    }
    
    [contentArray addObject:[self.userDic objectForKey:@"reserverName"]];
    [contentArray addObject:[self.userDic objectForKey:@"examName"]];
    [contentArray addObject:@"重庆市万州区"];
    [contentArray addObject:dStr];
//    [contentArray addObject:[NSString stringWithFormat:@"%@号车(%@)",[self.userDic objectForKey:@"reserverVehicleNumber"],[self.userDic objectForKey:@"reserverPlateNumber"]]];
    [contentArray addObject:[NSString stringWithFormat:@"%@号车",[self.userDic objectForKey:@"reserverVehicleNumber"]]];
    [contentArray addObject:[self.userDic objectForKey:@"drivingType"]];
    [contentArray addObject:t];
    [contentArray addObject:[self.userDic objectForKey:@"reserverIdCard"]];
    [contentArray addObject:[self.userDic objectForKey:@"reserverPhone"]];
    for (int i = 0; i < 9; i++) {
        NSString * str = [NSString stringWithFormat:@"%@:  %@",[nameArray objectAtIndex:i],[contentArray objectAtIndex:i]];
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(13*widthRate, i*25*widthRate, DeviceMaxWidth-45*widthRate, 25*widthRate)];
        label.text = str;
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
        [orderView addSubview:label];
        
        hight += 25*widthRate;
    }
    
    hight += 10*widthRate;
    
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(10*widthRate, hight-0.5, DeviceMaxWidth-10*widthRate, 0.5)];
    lineV.backgroundColor = [lhColor colorFromHexRGB:contentTitleColorStr1];
    [maxScrollView addSubview:lineV];
    
    hight += 10*widthRate;
    
    NSString *str = @"温馨提示：\n如果预约两次都未到场，本月将无法再次预约";
    NSMutableAttributedString * as = [[NSMutableAttributedString alloc]	initWithString:str];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:5];
    [as addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, str.length)];    UILabel * tLabel = [[UILabel alloc]initWithFrame:CGRectMake(20*widthRate, hight, DeviceMaxWidth-30*widthRate, 40*widthRate)];
    tLabel.numberOfLines = 0;
    tLabel.attributedText = as;
    tLabel.font = [UIFont systemFontOfSize:15];
    tLabel.textColor = [lhColor colorFromHexRGB:mainColorStr];
    [tLabel sizeToFit];
    [maxScrollView addSubview:tLabel];
    
    maxScrollView.contentSize = CGSizeMake(DeviceMaxWidth, hight);
    
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 2) {
        
        [self backButtonEvent];
    }
    else if(alertView.tag == 4){
        if (buttonIndex == 0) {//重新选择，删除订单
//            [self deleteOrderById];
//            isJiXuPay = NO;
//            [self refreshBuyNum];
        }
        else if(buttonIndex == 1){//继续支付,刷新购买数量，再进行支付
            //NSLog(@"继续支付");
//            isJiXuPay = YES;
//            [self refreshBuyNum];
        }
    }
}

#pragma mark - 确认支付

- (void)firmBtnEvent
{
//    if (zBtn.selected) {
    if (payType == 2) {
        NSLog(@"支付宝支付");
        
        [lhColor shareColor].payS = BUY_GOODS;
        [lhColor shareColor].tempViewC = self;
        
        payDic = [NSMutableDictionary dictionaryWithDictionary:orderDic];
        NSString * notify_url = [NSString stringWithFormat:@"%@",[orderDic objectForKey:@"notifyUrl"]];
        
        NSDictionary * pDic = [[NSDictionary alloc] initWithDictionary:orderDic];
        NSMutableDictionary * tempDi = [NSMutableDictionary dictionary];
        [tempDi setObject:[pDic objectForKey:@"outTradeNo"] forKey:@"id"];
        [tempDi setObject:[NSString stringWithFormat:@"%.0f",[[pDic objectForKey:@"totalFee"] doubleValue]] forKey:@"money"];
        [tempDi setObject:@"《优品学车》预约练车定金支付" forKey:@"productName"];
        [tempDi setObject:@"《优品学车》预约练车定金支付" forKey:@"productDescription"];
        [tempDi setObject:[pDic objectForKey:@"outTradeNo"] forKey:@"orderCode"];
        
        [lhColor shareColor].tempOrderDi = tempDi;
        saveDi = tempDi;
        payDic = @{@"partner":[payDic objectForKey:@"partner"],
                   @"seller_email":[payDic objectForKey:@"sellerEmail"],
                   @"private_key":[payDic objectForKey:@"privateKey"],
                   @"notify_url":notify_url
                   };
        [self payUseAlipayWithType];
        
    }
    else if (payType == 1){
        NSLog(@"微信支付");
        
        
        if (![WXApi isWXAppInstalled]) {//检查用户是否安装微信
            [lhColor showAlertWithMessage:@"请先安装微信客户端" withSuperView:self.view withHeih:DeviceMaxHeight/2];
            
            NSLog(@"fdfdfd");
            
            return;
        }
        
        NSLog(@"+++++");
        
        //微信支付充值
        [lhColor shareColor].payS = BUY_GOODS;
        [lhColor shareColor].tempViewC = self;
        
        NSLog(@"%@",orderDic);
        
        payDic = [NSMutableDictionary dictionaryWithDictionary:orderDic];
//        NSString * notify_url = [NSString stringWithFormat:@"%@",[orderDic objectForKey:@"notifyUrl"]];
        
        NSDictionary * pDic = [[NSDictionary alloc] initWithDictionary:orderDic];
        NSMutableDictionary * tempDi = [NSMutableDictionary dictionary];
        [tempDi setObject:[pDic objectForKey:@"prepayid"] forKey:@"id"];
        [tempDi setObject:[NSString stringWithFormat:@"%.0f",[[pDic objectForKey:@"deposit"] doubleValue]] forKey:@"money"];
        [tempDi setObject:@"《优品学车》预约练车定金支付" forKey:@"productName"];
        [tempDi setObject:@"《优品学车》预约练车定金支付" forKey:@"productDescription"];
        [tempDi setObject:[pDic objectForKey:@"prepayid"] forKey:@"orderCode"];
        
        [lhColor shareColor].tempOrderDi = tempDi;
        saveDi = tempDi;
        
        NSLog(@"%@",payDic);
        
//        NSDictionary * tempPayDic;
//        tempPayDic = @{@"app_id":[payDic objectForKey:@"appId"],
//                    @"mch_id":[payDic objectForKey:@"mchId"],
//                    @"api_key":[payDic objectForKey:@"apiKey"],
////                    @"notify_url":notify_url};
//                       };
        payDic = [NSMutableDictionary dictionaryWithDictionary:orderDic];
        
        //调用微信支付
        [[lhColor shareColor]wxPayWithPayDic:payDic OrderDic:saveDi];
    }

}


#pragma mark - 支付宝支付
- (void)payUseAlipayWithType
{
    [[lhColor shareColor]payInAliyPayWithDic:payDic withOrderDic:saveDi callback:^(NSDictionary *resultDic) {
        if([[resultDic objectForKey:@"resultStatus"]integerValue] == 9000){//支付成功
            [lhColor shareColor].noShowKaiChang = NO;
            [lhColor showAlertWithMessage:@"购买成功" withSuperView:self.view withHeih:DeviceMaxHeight/2];
            [self performSelector:@selector(toMyOrder) withObject:nil afterDelay:1.5];
            
        }
        else if([[resultDic objectForKey:@"resultStatus"]integerValue] == 6002){
            
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请求超时" message:@"请检查网络或稍后重试！" delegate:self cancelButtonTitle:@"取消支付" otherButtonTitles:@"重新支付", nil];
            alertView.tag = 4;
            [alertView show];
            
        }
        else{//支付失败
            
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"支付失败！请重新支付，或选择其他方式支付！" delegate:self cancelButtonTitle:@"取消支付" otherButtonTitles:@"重新支付", nil];
            alertView.tag = 4;
            [alertView show];
            
        }
    }];
    
}

- (void)toMyOrder
{
//    if ([@"" isEqualToString:telTextField.text]) {
//    
//        lhMyOrderViewController * moVC = [[lhMyOrderViewController alloc]init];
//        moVC.type = 2;
//        [self.navigationController pushViewController:moVC animated:YES];
//    }
//    else{//赠送好友
//
//        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"通知好友？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//        alertView.tag = 7;
//        [alertView show];
//
//    }
}

#pragma mark - 计时
- (void)moveTimerEvent
{
    counTime--;
    if (counTime > 0) {
        NSInteger mu = counTime/60;
        NSInteger se = counTime%60;
        NSString * tStr = [NSString stringWithFormat:@"%ld : %ld",(long)mu,(long)se];
        timeLabel.text = tStr;
    }
    else if(counTime == 0){//倒计时结束
        NSLog(@"取消订单");
        timeLabel.text = @"00 : 00";
    }
    else{
        timeLabel.text = @"00 : 00";
    }
}

#pragma mark - 删除订单
- (void)deleteOrderById:(NSString *)idStr
{
    NSString * midStr = [NSString stringWithFormat:@"%@",[[lhColor shareColor].userInfo objectForKey:@"id"]];
    NSDictionary *dic = @{@"id":midStr,
                          @"orderId":idStr};
    
    [FrankNetworkManager postReqeustWithURL:PATH(@"simulate/deleteOrder") params:dic successBlock:^(id returnData){
        if ([[returnData objectForKey:@"status"]integerValue] == 1) {
            FLLog(@"删除成功");
        }else{
            [FrankTools requestFailAlertShow:[returnData objectForKey:@"msg"]];
        }
    } failureBlock:^(NSError *error) {
        FLLog(@"%@",error.localizedDescription);
        [FrankTools wangluoAlertShow];
    } showHUD:NO];
    
    FLLog(@"%@",@{@"id":midStr,@"orderId":idStr});
}

- (void)toOrderView
{
    lhMyAppOrderViewController * maoVC = [[lhMyAppOrderViewController alloc]init];
    
    [self.navigationController pushViewController:maoVC animated:YES];
    
    NSMutableArray * deleA = [NSMutableArray array];
    for (UIViewController *controller in self.navigationController.viewControllers) {
        NSString * classStr = [NSString stringWithFormat:@"%@",[controller class]];
        if ([@"lhAppointSimuViewController" isEqualToString:classStr] ||
            [@"lhFirmOrderViewController" isEqualToString:classStr]) {
            [deleA addObject:controller];
        }
    }
    if (deleA.count > 0) {
        NSMutableArray * tempA = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
        [tempA removeObjectsInArray:deleA];
        self.navigationController.viewControllers = tempA;
    }
}

#pragma mark - view
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [lhColor assignmentForTempVC:self];
    
    if(moveTimer){
        [moveTimer invalidate];
        moveTimer = nil;
    }
    
    moveTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(moveTimerEvent) userInfo:nil repeats:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    if(moveTimer){
        [moveTimer invalidate];
        moveTimer = nil;
    }
}

@end

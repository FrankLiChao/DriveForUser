//
//  lhMyDrSchoolViewController.m
//  Drive
//
//  Created by bosheng on 15/7/30.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import "lhMyDrSchoolViewController.h"
#import "lhPersonFunTableViewCell.h"
#import "FrankAppointmentCarView.h"
//#import "FrankEvaluationView.h"
#import "FrankSchoolDetailView.h"
#import "lhDriverDetailViewController.h"

#define lineTagOriginal 150
#define circleTagOriginal 160
#define pButtonTagOriginal 170

@interface lhMyDrSchoolViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UITextViewDelegate>
{
    UIScrollView * maxScrollView;
    
    NSArray * funArray;
    NSArray * testA;
    
    UIImageView * headImgView;//头像
    UILabel * nameLabel;//名字
    UILabel * numLabel;//学员号
    UILabel *typeForLicense;  //驾照类型
    UILabel *timeForPractice;  //入学时间
    UILabel *dueTime;
    UITableView * funTableView;
    
    BOOL isDiscussing;//正在评价
    UIView * discussView;//评价view
    UIView * appView;//预约练车view
    UITextView * adviceTextView;//建议输入框
//    RatingBar * driveBar;//教练的评分
//    RatingBar * carBar;//车的评分
    
    UIImageView * carView;//进度条车
    
    NSMutableDictionary * mySchoolInfo;
    NSMutableDictionary *inforDic;    //保存我的驾校的信息
    
    BOOL hasComment;//有待评价
}

@end

@implementation lhMyDrSchoolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    mySchoolInfo = [NSMutableDictionary dictionary];
    [[lhColor shareColor]originalInit:self title:@"我的驾校" imageName:nil backButton:YES];
    
    [self requestInformation];
}

-(void)requestInformation{
    [lhColor addActivityView123:self.view];
    NSDictionary *dic = @{@"id":[[lhColor shareColor].userInfo objectForKey:@"id"]};
    
    [FrankNetworkManager postReqeustWithURL:PATH(@"driving/learningInfo") params:dic successBlock:^(id returnData){
        [lhColor disAppearActivitiView:self.view];
        if ([[returnData objectForKey:@"status"]integerValue] == 1) {
            inforDic = [[NSMutableDictionary alloc] initWithDictionary:[returnData objectForKey:@"data"]];
            
            [self firmInit];
            //临时设置学员学习进度
            nameLabel.text = [inforDic objectForKey:@"name"];
            numLabel.text = [NSString stringWithFormat:@"学员号: %@",[inforDic objectForKey:@"number"]];
            
            NSString * tStr = [NSString stringWithFormat:@"%@",[inforDic objectForKey:@"startTime"]];
            NSDate * date = [NSDate dateWithTimeIntervalSince1970:[tStr doubleValue]/1000];
            NSDateFormatter * df = [[NSDateFormatter alloc]init];
            [df setDateFormat:@"yyyy"];
            NSString * yStr = [df stringFromDate:date];
            [df setDateFormat:@"MM-dd"];
            timeForPractice.text = [NSString stringWithFormat:@"入学: %@-%@",yStr,[df stringFromDate:date]];
            dueTime.text = [NSString stringWithFormat:@"到期: %ld-%@",(long)[yStr integerValue]+3,[df stringFromDate:date]];
            
            typeForLicense.text = [NSString stringWithFormat:@"驾照类型: %@",[inforDic objectForKey:@"drivingLicenseType"]];
            
            NSString * proStr = [NSString stringWithFormat:@"%@",[inforDic objectForKey:@"progress"]];
            NSString * schoolStr = [NSString stringWithFormat:@"%@",[inforDic objectForKey:@"schoolName"]];
            NSString * coachNameStr = [NSString stringWithFormat:@"%@",[inforDic objectForKey:@"coachName"]];
            if (proStr && proStr.integerValue >= 1) {
                [self progress:proStr.integerValue];
            }
            else{
                [self progress:2];
            }
            waitCount = @"";
            testA = @[schoolStr,coachNameStr];
            
            [funTableView reloadData];
        }else{
            [FrankTools requestFailAlertShow:[returnData objectForKey:@"msg"]];
        }
    } failureBlock:^(NSError *error) {
        FLLog(@"%@",error.localizedDescription);
        [FrankTools wangluoAlertShow];
        [lhColor disAppearActivitiView:self.view];
    } showHUD:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)mySchoolInfoEvent:(NSNotification *)noti
{
    [lhColor disAppearActivitiView:self.view];
    NSLog(@"a == %@",noti.userInfo);
    [[NSNotificationCenter defaultCenter]removeObserver:self name:noti.name object:nil];
    if (!noti.userInfo || [noti.userInfo class] == [NSNull class]) {
        [lhColor wangluoAlertShow];
    }
    else if([[noti.userInfo objectForKey:@"status"]integerValue] == 1){
        
        mySchoolInfo = [NSMutableDictionary dictionaryWithDictionary:[[noti.userInfo objectForKey:@"dataList"]objectAtIndex:0]];
        NSString * picStr = [NSString stringWithFormat:@"%@",[mySchoolInfo objectForKey:@"photo"]];
        NSString * urlStr = [NSString stringWithFormat:@"%@%@",[lhColor shareColor].fileWebUrl,picStr];
        [lhColor checkImageWithName:picStr withUrlStr:urlStr withImgView:headImgView];
        
        NSString * nameStr = [NSString stringWithFormat:@"%@",[mySchoolInfo objectForKey:@"studentName"]];
        NSString * proStr = [NSString stringWithFormat:@"%@",[mySchoolInfo objectForKey:@"learnProgress"]];
        NSString * schoolStr = [NSString stringWithFormat:@"%@",[mySchoolInfo objectForKey:@"schoolName"]];
        NSString * coachNameStr = [NSString stringWithFormat:@"%@",[mySchoolInfo objectForKey:@"coatchName"]];
        nameLabel.text = nameStr;
        if (proStr) {
            [self progress:proStr.integerValue];
        }
        else{
            [self progress:1];
        }
        testA = @[schoolStr,coachNameStr,waitCount];
        
        [funTableView reloadData];
        
    }
    else{
        [lhColor requestFailAlertShow:noti];
    }
    
}

#pragma mark - firmInit
- (void)firmInit
{
//@{@"image":@"mySchFun3",@"name":@"评价"}
    funArray = @[@{@"image":@"mySchFun1",@"name":@"我的驾校"},
                 @{@"image":@"mySchFun2",@"name":@"我的教练"}];
    testA = @[@"交大驾校",@"杨小宝"];
    
    maxScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, DeviceMaxWidth, DeviceMaxHeight-64)];
    maxScrollView.backgroundColor = [UIColor whiteColor];
    maxScrollView.showsVerticalScrollIndicator = NO;
    maxScrollView.layer.cornerRadius = 6;
    maxScrollView.layer.masksToBounds = YES;
    [self.view addSubview:maxScrollView];
    
    headImgView = [[UIImageView alloc]initWithFrame:CGRectMake(20*widthRate, 20*widthRate, 60*widthRate, 60*widthRate)];
    headImgView.layer.masksToBounds = YES;
    headImgView.layer.cornerRadius = 30*widthRate;
    headImgView.layer.masksToBounds = YES;
    [headImgView setImage:imageWithName(@"defineSchoolPicture")];
    headImgView.layer.borderWidth = 0.5;
    headImgView.layer.borderColor = [lhColor colorFromHexRGB:viewColorStr].CGColor;
    [maxScrollView addSubview:headImgView];
    
    NSString * headStr = [NSString stringWithFormat:@"%@",[[lhColor shareColor].userInfo objectForKey:@"photo"]];
    if ([@"" isEqualToString:headStr]) {
        
    }else{
        NSString * allStr = [NSString stringWithFormat:@"%@%@",[lhColor shareColor].fileWebUrl,headStr];
        [lhColor checkImageWithName:headStr withUrlStr:allStr withImgView:headImgView withPlaceHolder:imageWithName(placeHolderImg)];
    }
    
    //学员名字
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(100*widthRate, 15*widthRate, 150*widthRate, 20*widthRate)];
    nameLabel.font = [UIFont systemFontOfSize:15];
    nameLabel.textColor = [lhColor colorFromHexRGB:lineColorStr];
    [maxScrollView addSubview:nameLabel];
    
    numLabel = [[UILabel alloc]initWithFrame:CGRectMake(100*widthRate, 38*widthRate, 100*widthRate, 20*widthRate)];
    numLabel.text = @"学员号: 001";
    numLabel.font = [UIFont systemFontOfSize:13];
    numLabel.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
    [maxScrollView addSubview:numLabel];
    
    timeForPractice = [[UILabel alloc] initWithFrame:CGRectMake(190*widthRate, 38*widthRate, 120*widthRate, 20*widthRate)];
    timeForPractice.text = @"入学: 2015-11-21";
    timeForPractice.font = [UIFont systemFontOfSize:13];
    timeForPractice.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
    [maxScrollView addSubview:timeForPractice];
    
    typeForLicense = [[UILabel alloc] initWithFrame:CGRectMake(100*widthRate, 60*widthRate, 100*widthRate, 20*widthRate)];
    typeForLicense.text = @"驾照类型: C1";
    typeForLicense.font = [UIFont systemFontOfSize:13];
    typeForLicense.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
    [maxScrollView addSubview:typeForLicense];
    
    dueTime = [[UILabel alloc] initWithFrame:CGRectMake(190*widthRate, 60*widthRate, 120*widthRate, 20*widthRate)];
    dueTime.text = @"到期: 2018-11-21";
    dueTime.font = [UIFont systemFontOfSize:13];
    dueTime.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
    [maxScrollView addSubview:dueTime];
    
//    dataForDriver = [[UILabel alloc] initWithFrame:CGRectMake(200*widthRate, 60*widthRate, DeviceMaxWidth-200*widthRate, 20*widthRate)];
//    dataForDriver.text = @"累计学车：80天";
//    dataForDriver.font = [UIFont fontWithName:fontName size:12];
//    dataForDriver.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
//    [maxScrollView addSubview:dataForDriver];
//    
//    dataForDriver = [[UILabel alloc] initWithFrame:CGRectMake(200*widthRate, 60*widthRate, DeviceMaxWidth-200*widthRate, 20*widthRate)];
    
    CGFloat heih = 100*widthRate;
    UIView * lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, heih, DeviceMaxWidth, 7*widthRate)];
    lineView1.backgroundColor = [lhColor colorFromHexRGB:viewColorStr];
    [maxScrollView addSubview:lineView1];
    
    heih += 7*widthRate;

    //进度
    UIView * lineV = [[UIView alloc]initWithFrame:CGRectMake(0, heih+42*widthRate, DeviceMaxWidth/5+4*widthRate, 1)];
    lineV.tag = lineTagOriginal;
    lineV.backgroundColor = [lhColor colorFromHexRGB:buttonColorStr];
    [maxScrollView addSubview:lineV];
    for (int i = 0; i < 4; i++) {
        UIView * lineV = [[UIView alloc]initWithFrame:CGRectMake(DeviceMaxWidth/5*(i+1)+4*widthRate, heih+42*widthRate, DeviceMaxWidth/5, 1)];
        lineV.tag = lineTagOriginal+i+1;
        lineV.backgroundColor = [lhColor colorFromHexRGB:buttonColorStr];
        [maxScrollView addSubview:lineV];
        
        UIView * circle = [[UIView alloc]initWithFrame:CGRectMake(DeviceMaxWidth/5*(i+1)-4*widthRate, heih+38*widthRate, 8*widthRate, 8*widthRate)];
        circle.tag = circleTagOriginal+i;
        circle.backgroundColor = [UIColor whiteColor];
        circle.layer.cornerRadius = 4*widthRate;
        circle.layer.masksToBounds = YES;
        circle.layer.borderColor = [lhColor colorFromHexRGB:buttonColorStr].CGColor;
        circle.layer.borderWidth = 1.0f;
        [maxScrollView addSubview:circle];

        NSString * nStr = [NSString stringWithFormat:@"mySchoolProgress%d",i];
        UIImage * pBtnN = imageWithName(nStr);
        NSString * sStr = [NSString stringWithFormat:@"mySchoolProgress%d_S",i];
        UIImage * pBtnS = imageWithName(sStr);
        UIButton * pButton = [UIButton buttonWithType:UIButtonTypeCustom];
        pButton.tag = pButtonTagOriginal+i;
        pButton.frame = CGRectMake(circle.frame.origin.x-26*widthRate, heih+50*widthRate, 28*widthRate, 28*widthRate);
        [pButton setBackgroundImage:pBtnN forState:UIControlStateNormal];
        [pButton setBackgroundImage:pBtnS forState:UIControlStateSelected];
        [maxScrollView addSubview:pButton];
    }
    
    carView = [[UIImageView alloc]initWithFrame:CGRectMake(0, heih+30*widthRate, 39*widthRate, 12*widthRate)];
    carView.image = imageWithName(@"mySchoolProgressCar");
    [maxScrollView addSubview:carView];
    
    [self progress:2];
    
    heih += 100*widthRate;
    UIView * lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0, heih, DeviceMaxWidth, 7*widthRate)];
    lineView2.backgroundColor = [lhColor colorFromHexRGB:viewColorStr];
    [maxScrollView addSubview:lineView2];
    
    heih += 7*widthRate;
    funTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, heih, DeviceMaxWidth, 80*widthRate) style:UITableViewStylePlain];
    funTableView.delegate = self;
    funTableView.dataSource = self;
    funTableView.backgroundColor = [UIColor clearColor];
    funTableView.separatorColor = [UIColor clearColor];
    funTableView.scrollEnabled = NO;
    [maxScrollView addSubview:funTableView];
    
    heih += funTableView.frame.size.height + 30*widthRate;
/*
    heih += 80*widthRate;
    
//    UIView * lineView3 = [[UIView alloc]initWithFrame:CGRectMake(0, heih, DeviceMaxWidth, 7*widthRate)];
//    lineView3.backgroundColor = [lhColor colorFromHexRGB:viewColorStr];
//    [maxScrollView addSubview:lineView3];
//    heih += 20*widthRate;
//    
//    UITapGestureRecognizer * tapG = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGEvent)];
//    discussView = [[UIView alloc]initWithFrame:CGRectMake(0, heih, DeviceMaxWidth, 170*widthRate)];
//    [discussView addGestureRecognizer:tapG];
//    discussView.backgroundColor = [UIColor whiteColor];
//    [maxScrollView addSubview:discussView];
//    
//    UILabel * ttLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(62*widthRate, 5*widthRate, 108*widthRate, 20*widthRate)];
//    ttLabel1.font = [UIFont fontWithName:fontName size:12];
//    ttLabel1.text = @"来给教练评个分吧";
//    ttLabel1.textColor = [UIColor blackColor];
//    [discussView addSubview:ttLabel1];
//    
//    driveBar = [[RatingBar alloc] initWithFrame:CGRectMake(170*widthRate, 0, 100*widthRate, 30*widthRate)];
//    [discussView addSubview:driveBar];
//    driveBar.starNumber = 5;
////    表示不能进行评价打分
////    driveBar.enable
////    driveBar.userInteractionEnabled
//    
//    UILabel * ttLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(62*widthRate, 35*widthRate, 108*widthRate, 20*widthRate)];
//    ttLabel2.font = [UIFont fontWithName:fontName size:12];
//    ttLabel2.text = @"来给教练车评个分吧";
//    ttLabel2.textColor = [UIColor blackColor];
//    [discussView addSubview:ttLabel2];
//    
//    carBar = [[RatingBar alloc] initWithFrame:CGRectMake(170*widthRate, 30*widthRate, 100*widthRate, 30*widthRate)];
//    [discussView addSubview:carBar];
//    carBar.starNumber = 5;
//    
//    UILabel * ttLabel = [[UILabel alloc]initWithFrame:CGRectMake(62*widthRate, 65*widthRate, 180*widthRate, 20*widthRate)];
//    ttLabel.font = [UIFont fontWithName:fontName size:12];
//    ttLabel.text = @"留下您的意见或建议吧";
//    ttLabel.textColor = [UIColor blackColor];
//    [discussView addSubview:ttLabel];
//    
//    adviceTextView = [[UITextView alloc]initWithFrame:CGRectMake(62*widthRate, 85*widthRate, 180*widthRate, 100*widthRate)];
//    adviceTextView.layer.borderColor = [UIColor colorWithRed:242.0/255 green:115.0/255 blue:105.0/255 alpha:1].CGColor;
//    adviceTextView.layer.borderWidth = 0.5;
//    adviceTextView.layer.cornerRadius = 4;
//    adviceTextView.delegate = self;
//    adviceTextView.layer.masksToBounds = YES;
//    adviceTextView.font = [UIFont fontWithName:fontName size:14];
//    [discussView addSubview:adviceTextView];
    
//    UITapGestureRecognizer * tapG1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGEvent)];
//    appView = [[UIView alloc]initWithFrame:CGRectMake(0, heih, DeviceMaxWidth, 200*widthRate)];
//    [appView addGestureRecognizer:tapG1];
//    appView.backgroundColor = [UIColor whiteColor];
//    [maxScrollView addSubview:appView];
  */
    
    UIButton * contactBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    contactBtn.frame = CGRectMake(10*widthRate, heih+20*widthRate, DeviceMaxWidth-20*widthRate, 40*widthRate);
    contactBtn.titleLabel.font = [UIFont fontWithName:fontName size:15];
    [contactBtn setTitle:@"预约练车" forState:UIControlStateNormal];
    [contactBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [contactBtn setBackgroundImage:imageWithName(@"contactDraiver") forState:UIControlStateNormal];
    contactBtn.layer.cornerRadius = 4;
    contactBtn.layer.masksToBounds = YES;
    [contactBtn addTarget:self action:@selector(contactBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    [maxScrollView addSubview:contactBtn];

    heih += 60*widthRate;
 
    maxScrollView.contentSize = CGSizeMake(0, heih+20*widthRate);
}

#pragma mark - 进度
- (void)progress:(NSInteger)progress
{
    [self clearProgress];
    
    for (int i = 0; i < progress; i++) {
        UIView * view = (UIView *)[self.view viewWithTag:lineTagOriginal+i];
        view.backgroundColor = [lhColor colorFromHexRGB:lineColorStr];
        UIView * view1 = (UIView *)[self.view viewWithTag:circleTagOriginal+i];
        view1.layer.borderColor = [lhColor colorFromHexRGB:lineColorStr].CGColor;
        if (i == progress-1) {
            view1.hidden = YES;
        }
        UIButton * btn = (UIButton *)[self.view viewWithTag:pButtonTagOriginal+i];
        btn.selected = YES;
    }
    
    CGRect carRect = carView.frame;
    carRect.origin.x = progress*DeviceMaxWidth/5-19*widthRate;
    carView.frame = carRect;
    
}

- (void)clearProgress
{
    for (int i = 0; i < 8; i++) {
        UIView * view = (UIView *)[self.view viewWithTag:lineTagOriginal+i];
        view.backgroundColor = [lhColor colorFromHexRGB:buttonColorStr];
        UIView * view1 = (UIView *)[self.view viewWithTag:circleTagOriginal+i];
        view1.layer.borderColor = [lhColor colorFromHexRGB:buttonColorStr].CGColor;
        view1.hidden = NO;
        
        UIButton * btn = (UIButton *)[self.view viewWithTag:pButtonTagOriginal+i];
        btn.selected = NO;
        
        CGRect carRect = carView.frame;
        carRect.origin.x = 0;
        carView.frame = carRect;
        
    }
}

#pragma mark - touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [adviceTextView resignFirstResponder];
    
    CGRect wRe = maxScrollView.frame;
    
    wRe.origin.y = 64+8*widthRate;
    [UIView animateWithDuration:0.2 animations:^{
        maxScrollView.frame = wRe;
    }];
    
}

- (void)tapGEvent
{
    [adviceTextView resignFirstResponder];
    
    CGRect wRe = maxScrollView.frame;
    
    wRe.origin.y = 64+8*widthRate;
    [UIView animateWithDuration:0.2 animations:^{
        maxScrollView.frame = wRe;
    }];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    CGRect wRe = maxScrollView.frame;
    
    wRe.origin.y = 64+8*widthRate-252;
    [UIView animateWithDuration:0.2 animations:^{
        maxScrollView.frame = wRe;
    }];
}

#pragma makr - 预约练车
- (void)contactBtnEvent
{
    FrankAppointmentCarView *appointment = [[FrankAppointmentCarView alloc] init];
    appointment.coachName = [inforDic objectForKey:@"coachName"];
    [self.navigationController pushViewController:appointment animated:YES];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 2&&buttonIndex == 1) {
        NSLog(@"写评价");
    }
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        NSString *schId = [inforDic objectForKey:@"schoolId"];
        if ([schId isEqualToString:@""] || schId == nil) {
            UIAlertView *AlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"暂无驾校信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [AlertView show];
        }else{
            FrankSchoolDetailView * fsdVC = [[FrankSchoolDetailView alloc]init];
            fsdVC.schoolID = [NSString stringWithFormat:@"%@",[inforDic objectForKey:@"schoolId"]];
            [self.navigationController pushViewController:fsdVC animated:YES];
        }
    }
    else if(indexPath.row == 1){
        NSString *coachId = [inforDic objectForKey:@"coachId"];
        if ([coachId isEqualToString:@""] || coachId == nil) {
            UIAlertView *AlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"暂无教练信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [AlertView show];
        }else{
            lhDriverDetailViewController * ddVC = [[lhDriverDetailViewController alloc]init];
            ddVC.coachID = [NSString stringWithFormat:@"%@",[inforDic objectForKey:@"coachId"]];
            [self.navigationController pushViewController:ddVC animated:YES];
        }
    }
}

#pragma mark - UITableDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40*widthRate;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return funArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * indetifier = @"funCell";
    lhPersonFunTableViewCell * funCell = [tableView dequeueReusableCellWithIdentifier:indetifier];
    if (funCell == nil) {
        funCell = [[lhPersonFunTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indetifier];
    }
    
    if (indexPath.row == 0) {
        funCell.topline.hidden = NO;
    }
    if (indexPath.row == funArray.count-1) {
        funCell.lowline.hidden = NO;
//        funCell.contentLabel.font = [UIFont boldSystemFontOfSize:13];
//        
//        funCell.contentLabel.textColor = [lhColor colorFromHexRGB:@"e77e23"];
    }
    else{
        funCell.lowline0.hidden = NO;
    }
    
    funCell.headImgView.image = imageWithName([[funArray objectAtIndex:indexPath.row] objectForKey:@"image"]);
    funCell.titLabel.text = [[funArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    
    funCell.contentLabel.text = [testA objectAtIndex:indexPath.row];
    
    return funCell;
}

#pragma mark - view
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [lhColor assignmentForTempVC:self];
    /*
    [self requestWaitEvaluatedCount];
    if (funTableView) {
        [funTableView reloadData];
    }
     */
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

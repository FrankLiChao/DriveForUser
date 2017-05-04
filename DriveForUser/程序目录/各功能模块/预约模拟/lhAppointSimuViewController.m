//
//  lhAppointSimuViewController.m
//  Drive
//
//  Created by bosheng on 15/7/30.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import "lhAppointSimuViewController.h"
#import "MMLocationManager.h"
#import "lhSchListTableViewCell.h"
#import "lhSelectCityViewController.h"
#import "lhAppointTableViewCell.h"
#import "lhFirmOrderViewController.h"
#import "lhMyAppOrderViewController.h"

#import "MJRefresh.h"
#define maxTime 60
#define lineTagOriginal 200
#define circleTagOriginal 210
#define progressBtnTagOriginal 220
#define selectedViewTagOriginal 230

#define SchTableNotiName @"reSchoolInfo"
#define typeTableNotiName @"reTypeInfo"
#define DateTableNotiName @"reDateInfo"
#define CarTableNotiName @"reCarInfo"
#define pHaoTableNotiName @"repHaoInfo"


@interface lhAppointSimuViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIScrollViewDelegate,UIAlertViewDelegate,UITextViewDelegate>
{
    UILabel * rightLabel;//地址
    UIButton * rightBtn;
    UIImageView * rImgView;
    
    UIView * whiteView;
    
    UITextField * searchTextField;//搜索考场
    
    UITableView * schTableView;//考场显示
    NSMutableArray * schArray;//考场信息
    
    UIView * typeView;
    UITableView * typeTableView;//科目类型
    NSArray * typeArray;//科目类型
    
    UIView * dateView;
    UITableView * dateTableView;//选日期
    NSArray * dateArray;//日期信息
    
    UIView * carView;
    UITableView * carTableView;//车辆显示
    NSArray * carArray;//车辆信息
    
    UIView * pHaoView;
    UITableView * pHaoTableView;//排号显示
    NSArray * pHaoArray;//排号信息
    
    UIScrollView * personView;//个人信息页面
    UIView * writePerView;//输入个人信息
    UITextField * nameTextField;//姓名
    UITextField * cardTextField;//身份证号
    UITextField * telTextField;//手机号
    UITextField * verificatField;//验证码
    UIButton    * verificatBtn;      //获取验证码按钮
    NSString * lastTelStr;//发验证码时的电话号码
    NSString * validateStr;
    
    CGFloat nowPerViewOrignalY;
    
    UIView * firmOrderView;//确认下单页面
    UIView * successView;//预约成功页面
    
    NSString * schStr;//考场
    NSString * dateStr;//日期
    NSString * carStr;//车辆
    
    NSMutableArray * selectArray;
    NSMutableArray * selectStrArray;
    
    UIScrollView * maxScrollView;
    
    BOOL isRequestSchoolInfo;
    BOOL isSelectType;//选择科目类型
    
    NSTimer *stuTimer; //验证码定时器
    long countTimeS;
    
    BOOL payMark;
    BOOL valiTag;
    NSString *examAddress;  //考场地址
}

@end

@implementation lhAppointSimuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    validateStr = @"";
//    payMark = YES;
    selectArray = [NSMutableArray array];
    selectStrArray = [NSMutableArray array];
    
    schArray = [NSMutableArray array];
    dateArray = [NSArray array];
    typeArray = [NSArray array];
    if (self.appointType == 5) {
//        carArray = @[@"01号车(川A58947)",@"02号车(川A58947)",@"03号车(川A58947)",@"04号车(川A58947)",@"05号车(川A58947)",@"06号车(川A58947)",@"07号车(川A58947)"];
        carArray = [NSArray array];
    }
    else{
//        carArray = @[@"川A58947（杨小宝教练）",@"川A58947（陈春阳教练）",@"川A58947（杨树教练）",@"川A58947（杨树教练）",@"川A58947（杨树教练）",@"川A58947（杨树教练）",@"川A58947（杨树教练）"];
        carArray = [NSArray array];
    }
    pHaoArray = [NSArray array];
    
    [self firmInit];
    
    [[lhColor shareColor]originalInit:self title:@"预约模拟考试考场" imageName:nil backButton:NO];
    
    UIButton * backBg = [[UIButton alloc]initWithFrame:CGRectMake(2, 20, 40, 44)];
    [backBg setBackgroundImage:imageWithName(@"back") forState:UIControlStateNormal];
    [self.view addSubview:backBg];
    
    [backBg addTarget:self action:@selector(backButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage * img = imageWithName(@"newluzhou1.png");
    rImgView = [[UIImageView alloc]initWithFrame:CGRectMake(DeviceMaxWidth-19, 44, 14, 7)];
    rImgView.image = img;
    [self.view addSubview:rImgView];
    
    rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(DeviceMaxWidth-120, 28, 100, 16)];
    rightLabel.text = [lhColor shareColor].nowCityStr;
    rightLabel.textAlignment = NSTextAlignmentCenter;
    rightLabel.font = [UIFont fontWithName:fontName size:15];
    rightLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:rightLabel];
    
    rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(DeviceMaxWidth-120, 20, 120, 44);
    [rightBtn addTarget:self action:@selector(rightBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightBtn];
    
    isRequestSchoolInfo = NO;
    
    [schTableView headerBeginRefreshing];
    
//    [[lhColor shareColor] refreshPersonInfo];
//    [self refreshPerson:1];
}

-(void)refreshPerson:(NSInteger)type{
    NSDictionary *dic = @{@"id":[[lhColor shareColor].userInfo objectForKey:@"id"],
                          @"type":[NSString stringWithFormat:@"%ld",type]};
    
    [FrankNetworkManager postReqeustWithURL:PATH(@"user/queryInfo") params:dic successBlock:^(id returnData){
        if ([[returnData objectForKey:@"status"]integerValue] == 1) {
            [lhColor shareColor].userName = [NSString stringWithFormat:@"%@",[[returnData objectForKey:@"data"] objectForKey:@"name"]];
            [lhColor shareColor].idCard = [NSString stringWithFormat:@"%@",[[returnData objectForKey:@"data"] objectForKey:@"idCard"]];
            [lhColor shareColor].phone = [NSString stringWithFormat:@"%@",[[returnData objectForKey:@"data"] objectForKey:@"phone"]];
        }else{
            [FrankTools requestFailAlertShow:[returnData objectForKey:@"msg"]];
        }
    } failureBlock:^(NSError *error) {
        FLLog(@"%@",error.localizedDescription);
        [FrankTools wangluoAlertShow];
    } showHUD:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 返回
- (void)backButtonEvent
{
    if (maxScrollView.contentOffset.x > 0) {
        
        [UIView animateWithDuration:0.3 animations:^{
            maxScrollView.contentOffset = CGPointMake(maxScrollView.contentOffset.x-DeviceMaxWidth, 0);
            NSInteger index = maxScrollView.contentOffset.x/DeviceMaxWidth+1;
            [self progress:index];
            if (index == 4) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
        [self tapGEvent];
//        [selectArray removeLastObject];
//        [selectStrArray removeLastObject];
        
    }
    else if(maxScrollView.contentOffset.x == 0){
        if (isSelectType) {
            isSelectType = NO;
            typeView.hidden = YES;
            
            rightLabel.hidden = NO;
            rImgView.hidden = NO;
            rightBtn.hidden = NO;
        }
        else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - 预约模拟考试
- (void)firmInit
{
    whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, DeviceMaxWidth, DeviceMaxHeight-64)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteView];
    
    CGFloat wid;
    if (self.appointType == 5) {
        wid = 34*widthRate;
    }
    else if(self.appointType == 6){
        wid = 70*widthRate;
    }
    UIView * lineView0 = [[UIView alloc]initWithFrame:CGRectMake(0, 72*widthRate, wid, 0.5)];
    lineView0.tag = lineTagOriginal;
    lineView0.backgroundColor = [lhColor colorFromHexRGB:buttonColorStr];
    [whiteView addSubview:lineView0];
    NSArray * pArray;
    NSArray * pArrayS;
    if (self.appointType == 5) {
        pArray = @[@"appProgress1",@"appProgress2",@"appProgress3",
                   @"appProgress4",@"appProgress5",@"appProgress6",@"appProgress7"];
        pArrayS = @[@"appProgress1_S",@"appProgress2_S",@"appProgress3_S",
                    @"appProgress4_S",@"appProgress5_S",@"appProgress6_S",@"appProgress7_S"];
    }
    else if(self.appointType == 6){
        pArray = @[@"appProgress1",@"appProgress2",
                   @"appProgress3",@"appProgress8",@"appProgress7"];
        pArrayS = @[@"appProgress1_S",@"appProgress2_S",
                    @"appProgress3_S",@"appProgress8_S",@"appProgress7_S"];
    }
    
    for (int i = 1; i < pArray.count+1; i++) {
        NSString * imgStr = [pArray objectAtIndex:i-1];
        NSString * imgStrS = [pArrayS objectAtIndex:i-1];
        UIImage * pImg = [UIImage imageNamed:imgStr];
        UIImage * pImgS = [UIImage imageNamed:imgStrS];
        UIButton * pBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        pBtn.tag = progressBtnTagOriginal+i-1;
        pBtn.frame = CGRectMake(wid+36*widthRate*(i-1), 22*widthRate, 36*widthRate, 37*widthRate);
        [pBtn setBackgroundImage:pImg forState:UIControlStateNormal];
        [pBtn setBackgroundImage:pImgS forState:UIControlStateSelected];
        pBtn.userInteractionEnabled = NO;
        [whiteView addSubview:pBtn];
        
        if (i < pArray.count) {
            UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(wid+36*widthRate*(i-1), 72*widthRate, 36*widthRate, 0.5)];
            lineView.tag = lineTagOriginal+i;
            lineView.backgroundColor = [lhColor colorFromHexRGB:buttonColorStr];
            [whiteView addSubview:lineView];
        }
        else{
            UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(DeviceMaxWidth-34*widthRate-wid, 72*widthRate, 34*widthRate+wid, 0.5)];
            lineView.tag = lineTagOriginal+pArray.count;
            lineView.backgroundColor = [lhColor colorFromHexRGB:buttonColorStr];
            [whiteView addSubview:lineView];
        }
        
        UIView * cView = [[UIView alloc]initWithFrame:CGRectMake(wid+36*widthRate*(i-1), 67.5*widthRate, 9*widthRate, 9*widthRate)];
        cView.tag = circleTagOriginal+i-1;
        cView.backgroundColor = [lhColor colorFromHexRGB:buttonColorStr];
        cView.layer.cornerRadius = 4.5*widthRate;
        cView.layer.masksToBounds = YES;
        [whiteView addSubview:cView];
    }
    
    [self progress:1];
    
    maxScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 90*widthRate, DeviceMaxWidth, CGRectGetHeight(whiteView.frame)-90*widthRate)];
    maxScrollView.showsHorizontalScrollIndicator = NO;
    maxScrollView.scrollEnabled = NO;
    maxScrollView.delegate = self;
    maxScrollView.pagingEnabled = YES;
    maxScrollView.contentSize = CGSizeMake(DeviceMaxWidth*self.appointType, 0);
    [whiteView addSubview:maxScrollView];
    
    searchTextField = [[UITextField alloc]initWithFrame:CGRectMake(25*widthRate, 0, 244*widthRate, 40*widthRate)];
    searchTextField.delegate = self;
    searchTextField.clearButtonMode = UITextFieldViewModeAlways;
    searchTextField.returnKeyType = UIReturnKeySearch;
    searchTextField.layer.borderColor = [lhColor colorFromHexRGB:lineColorStr].CGColor;
    searchTextField.layer.borderWidth = 0.8;
    searchTextField.textAlignment = NSTextAlignmentCenter;
    searchTextField.placeholder = @"输入考场名称查找";
    searchTextField.font = [UIFont systemFontOfSize:15];
    [maxScrollView addSubview:searchTextField];
    
    UIImage * searchImg = imageWithName(@"appSearchIcon");
    UIButton * searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setBackgroundImage:searchImg forState:UIControlStateNormal];
    searchBtn.frame = CGRectMake(265*widthRate, 0, 40*widthRate, 40*widthRate);
    [searchBtn setBackgroundImage:searchImg forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    [maxScrollView addSubview:searchBtn];
    
    schTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 60*widthRate, DeviceMaxWidth, CGRectGetHeight(maxScrollView.frame)-50*widthRate) style:UITableViewStylePlain];
    schTableView.showsVerticalScrollIndicator = NO;
    schTableView.separatorColor = [UIColor clearColor];
    schTableView.backgroundColor = [UIColor clearColor];
    schTableView.delegate = self;
    schTableView.dataSource = self;
    [maxScrollView addSubview:schTableView];
    
    [schTableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    
    //选择科目类型
    typeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, CGRectGetHeight(maxScrollView.frame))];
    typeView.backgroundColor = [UIColor whiteColor];
    [maxScrollView addSubview:typeView];
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceMaxWidth*5, 7*widthRate)];
    lineView.backgroundColor = [lhColor colorFromHexRGB:viewColorStr];
    [typeView addSubview:lineView];
    
    typeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 7*widthRate, DeviceMaxWidth, CGRectGetHeight(maxScrollView.frame)-7*widthRate) style:UITableViewStylePlain];
    typeTableView.showsVerticalScrollIndicator = NO;
    typeTableView.separatorColor = [UIColor clearColor];
    typeTableView.backgroundColor = [UIColor clearColor];
    typeTableView.delegate = self;
    typeTableView.dataSource = self;
    [typeView addSubview:typeTableView];
    [typeTableView addHeaderWithTarget:self action:@selector(headerRefresh1)];
    [self selectedViewWithSuperView:typeView withTableView:typeTableView withIndex:0];
    typeView.hidden = YES;
    
    //选择日期
    dateView = [[UIView alloc]initWithFrame:CGRectMake(DeviceMaxWidth, 0, DeviceMaxWidth, CGRectGetHeight(maxScrollView.frame))];
    [maxScrollView addSubview:dateView];
    
//    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceMaxWidth*4, 7*widthRate)];
//    lineView.backgroundColor = [lhColor colorFromHexRGB:viewColorStr];
//    [dateView addSubview:lineView];
    
    dateTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 7*widthRate, DeviceMaxWidth, CGRectGetHeight(maxScrollView.frame)-7*widthRate) style:UITableViewStylePlain];
    dateTableView.showsVerticalScrollIndicator = NO;
    dateTableView.separatorColor = [UIColor clearColor];
    dateTableView.backgroundColor = [UIColor clearColor];
    dateTableView.delegate = self;
    dateTableView.dataSource = self;
    [dateView addSubview:dateTableView];
    
    [self selectedViewWithSuperView:dateView withTableView:dateTableView withIndex:1];
    [dateTableView addHeaderWithTarget:self action:@selector(headerRefresh2)];
    
    //选择车辆
    carView = [[UIView alloc]initWithFrame:CGRectMake(DeviceMaxWidth*2, 0, DeviceMaxWidth, CGRectGetHeight(maxScrollView.frame))];
    [maxScrollView addSubview:carView];
    
    carTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 7*widthRate, DeviceMaxWidth, CGRectGetHeight(maxScrollView.frame)-7*widthRate) style:UITableViewStylePlain];
    carTableView.showsVerticalScrollIndicator = NO;
    carTableView.separatorColor = [UIColor clearColor];
    carTableView.backgroundColor = [UIColor clearColor];
    carTableView.delegate = self;
    carTableView.dataSource = self;
    [carView addSubview:carTableView];
    [self selectedViewWithSuperView:carView withTableView:carTableView withIndex:2];
    [carTableView addHeaderWithTarget:self action:@selector(headerRefresh3)];
    
    if (self.appointType == 5) {
        //预约排号
        pHaoView = [[UIView alloc]initWithFrame:CGRectMake(DeviceMaxWidth*3, 0, DeviceMaxWidth, CGRectGetHeight(maxScrollView.frame))];
        [maxScrollView addSubview:pHaoView];
        
        pHaoTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 7*widthRate, DeviceMaxWidth, CGRectGetHeight(maxScrollView.frame)-7*widthRate) style:UITableViewStylePlain];
        pHaoTableView.showsVerticalScrollIndicator = NO;
        pHaoTableView.separatorColor = [UIColor clearColor];
        pHaoTableView.backgroundColor = [UIColor clearColor];
        pHaoTableView.delegate = self;
        pHaoTableView.dataSource = self;
        [pHaoView addSubview:pHaoTableView];
        [self selectedViewWithSuperView:pHaoView withTableView:pHaoTableView withIndex:3];
        [pHaoTableView addHeaderWithTarget:self action:@selector(headerRefresh4)];
        
        //个人信息
        personView = [[UIScrollView alloc]initWithFrame:CGRectMake(DeviceMaxWidth*4, 7*widthRate, DeviceMaxWidth, CGRectGetHeight(maxScrollView.frame)-7*widthRate)];
        personView.showsVerticalScrollIndicator = NO;
        [maxScrollView addSubview:personView];
        
        UITapGestureRecognizer * tapG = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGEvent)];
        writePerView = [[UIView alloc]initWithFrame:CGRectMake(0, 7*widthRate, DeviceMaxWidth, CGRectGetHeight(maxScrollView.frame)-7*widthRate)];
        [writePerView addGestureRecognizer:tapG];
        [personView addSubview:writePerView];
        
        CGFloat pHeih = 10*widthRate;
//        NSArray * tA = @[@"学员姓名",@"学员身份证号",@"学员手机号"];
//        NSArray *leftImage = @[@"studentImage",@"idCardImage",@"phoneNumberImage"];
        
        for (int i = 0; i < 3; i++) {
            /*
            UILabel * nLabel = [[UILabel alloc]initWithFrame:CGRectMake(20*widthRate, pHeih, DeviceMaxWidth-60*widthRate, 25*widthRate)];
            nLabel.text = [tA objectAtIndex:i];
            nLabel.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
            nLabel.font = [UIFont fontWithName:fontName size:12];
            [writePerView addSubview:nLabel];
            
            pHeih += 25*widthRate;
            */
            
            UIView * tfView = [[UIView alloc]initWithFrame:CGRectMake(15*widthRate, pHeih, DeviceMaxWidth-30*widthRate, 40*widthRate)];
            tfView.backgroundColor = [UIColor whiteColor];
            tfView.layer.masksToBounds = YES;
            tfView.layer.cornerRadius = 4;
            [writePerView addSubview:tfView];
            
            UIView *lineF = [[UIView alloc] initWithFrame:CGRectMake(15*widthRate, pHeih+35*widthRate, DeviceMaxWidth-30*widthRate, 0.5)];
            lineF.tag = i+500;
            lineF.backgroundColor = [lhColor colorFromHexRGB:contentTitleColorStr1];
            [writePerView addSubview:lineF];
            
            if (i == 0) {
                UIImageView *leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(5*widthRate, 8*widthRate, 24*widthRate, 24*widthRate)];
                [leftImage setImage:imageWithName(@"studentImage")];
                [tfView addSubview:leftImage];
                
                nameTextField = [[UITextField alloc]initWithFrame:CGRectMake(10*widthRate, 0, DeviceMaxWidth-60*widthRate, 40*widthRate)];
                nameTextField.font = [UIFont systemFontOfSize:15];
                nameTextField.textColor = [lhColor colorFromHexRGB:contentTitleColorStr1];
                nameTextField.clearButtonMode = UITextFieldViewModeAlways;
                nameTextField.delegate = self;
                nameTextField.placeholder = @"学员姓名";
                nameTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40*widthRate, 40*widthRate)];
                nameTextField.leftViewMode = UITextFieldViewModeAlways;
                nameTextField.returnKeyType = UIReturnKeyNext;
                [tfView addSubview:nameTextField];
            }
            else if(i == 1){
                UIImageView *leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(5*widthRate, 9*widthRate, 24*widthRate, 24*widthRate)];
                [leftImage setImage:imageWithName(@"idCardImage")];
                [tfView addSubview:leftImage];
                
                cardTextField = [[UITextField alloc]initWithFrame:CGRectMake(10*widthRate, 0, DeviceMaxWidth-60*widthRate, 40*widthRate)];
                cardTextField.clearButtonMode = UITextFieldViewModeAlways;
                cardTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                cardTextField.font = [UIFont systemFontOfSize:15];
                cardTextField.textColor = [lhColor colorFromHexRGB:contentTitleColorStr1];
                cardTextField.delegate = self;
                cardTextField.placeholder = @"学员身份证";
                cardTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40*widthRate, 40*widthRate)];
                cardTextField.leftViewMode = UITextFieldViewModeAlways;
                cardTextField.returnKeyType = UIReturnKeyNext;
                [tfView addSubview:cardTextField];
                
            }
            else if(i == 2){
                UIImageView *leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(5*widthRate, 6*widthRate, 24*widthRate, 24*widthRate)];
                [leftImage setImage:imageWithName(@"phoneNumberImage")];
                [tfView addSubview:leftImage];
                
                telTextField = [[UITextField alloc]initWithFrame:CGRectMake(10*widthRate, 0, DeviceMaxWidth-60*widthRate, 40*widthRate)];
                telTextField.delegate = self;
                telTextField.clearButtonMode = UITextFieldViewModeAlways;
                telTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                telTextField.returnKeyType = UIReturnKeyDone;
                telTextField.placeholder = @"学员手机号";
                telTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40*widthRate, 40*widthRate)];
                telTextField.leftViewMode = UITextFieldViewModeAlways;
                telTextField.font = [UIFont systemFontOfSize:15];
                telTextField.textColor = [lhColor colorFromHexRGB:contentTitleColorStr1];
                [tfView addSubview:telTextField];
                
            }
            pHeih += 48*widthRate;
        }
        if (payMark == 1) {
            pHeih += 30*widthRate;
        }else{
            UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, pHeih, DeviceMaxWidth, DeviceMaxHeight)];
            bgView.backgroundColor = [UIColor whiteColor];
            bgView.tag = 2018;
            [writePerView addSubview:bgView];
            
            verificatField = [[UITextField alloc]initWithFrame:CGRectMake(15*widthRate, 0, 210*widthRate, 40*widthRate)];
            verificatField.delegate = self;
            verificatField.layer.cornerRadius = 4;
            verificatField.clearButtonMode = UITextFieldViewModeAlways;
            verificatField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            verificatField.returnKeyType = UIReturnKeyDone;
            verificatField.font = [UIFont systemFontOfSize:15];
            verificatField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50*widthRate, 40*widthRate)];
            verificatField.leftViewMode = UITextFieldViewModeAlways;
            verificatField.placeholder = @"验证码";
            verificatField.textColor = [lhColor colorFromHexRGB:contentTitleColorStr1];
            [bgView addSubview:verificatField];
            
            UIImageView *leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(20*widthRate, 8*widthRate, 24*widthRate, 24*widthRate)];
            [leftImage setImage:imageWithName(@"verificationID")];
            [bgView addSubview:leftImage];
            
            countTimeS = maxTime-1;
            stuTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(verificatTimeEvent) userInfo:nil repeats:YES];
            verificatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            verificatBtn.frame = CGRectMake(225*widthRate+2, 0, 80*widthRate-2, 40*widthRate);
            [verificatBtn setTitleColor:[lhColor colorFromHexRGB:mainColorStr] forState:UIControlStateNormal];
            verificatBtn.layer.cornerRadius = 4;
            verificatBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            [verificatBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
            [verificatBtn setTitle:@"已发送(60)" forState:UIControlStateSelected];
            [verificatBtn addTarget:self action:@selector(clickVerificatEvent:) forControlEvents:UIControlEventTouchUpInside];
            [bgView addSubview:verificatBtn];
            
            UIView *lineGG = [[UIView alloc] initWithFrame:CGRectMake(15*widthRate, 35*widthRate, DeviceMaxWidth-30*widthRate, 0.5)];
            lineGG.tag = 800;
            lineGG.backgroundColor = [lhColor colorFromHexRGB:contentTitleColorStr1];
            [bgView addSubview:lineGG];
            pHeih += 50*widthRate;
        }
        
        UIImage * img1 = imageWithName(@"mainBtnBg");
        img1 = [img1 resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        UIButton * appButton = [UIButton buttonWithType:UIButtonTypeCustom];
        appButton.frame = CGRectMake(15*widthRate, pHeih, DeviceMaxWidth-30*widthRate, 40*widthRate);
        [appButton setBackgroundImage:img1 forState:UIControlStateNormal];
        [appButton setTitle:@"确认身份信息" forState:UIControlStateNormal];
        [appButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [appButton addTarget:self action:@selector(firmBtnEvent) forControlEvents:UIControlEventTouchUpInside];
        appButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [writePerView addSubview:appButton];
        
        pHeih += 45*widthRate + 40*widthRate;
        
        CGRect re = writePerView.frame;
        re.size.height = pHeih;
        writePerView.frame = re;
        
        [self selectedViewWithSuperView:personView withTableView:writePerView withIndex:4];
        personView.contentSize = CGSizeMake(DeviceMaxWidth, writePerView.frame.origin.y + pHeih + 40*widthRate);
    }
    
    if (self.appointType == 5) {
        //确认下单
        firmOrderView = [[UIView alloc]initWithFrame:CGRectMake(DeviceMaxWidth*5, 0, DeviceMaxWidth, CGRectGetHeight(maxScrollView.frame))];
        [maxScrollView addSubview:firmOrderView];
        
        //预约成功
        successView = [[UIView alloc]initWithFrame:CGRectMake(DeviceMaxWidth*6, 0, DeviceMaxWidth, CGRectGetHeight(maxScrollView.frame))];
        [maxScrollView addSubview:successView];
    }
    else if(self.appointType == 6){
        //确认下单
        firmOrderView = [[UIView alloc]initWithFrame:CGRectMake(DeviceMaxWidth*3, 0, DeviceMaxWidth, CGRectGetHeight(maxScrollView.frame))];
        [maxScrollView addSubview:firmOrderView];
        
        //预约成功
        successView = [[UIView alloc]initWithFrame:CGRectMake(DeviceMaxWidth*4, 0, DeviceMaxWidth, CGRectGetHeight(maxScrollView.frame))];
        [maxScrollView addSubview:successView];
    }
    
}

-(void)clickVerificatEvent:(UIButton *)button_{
    if (button_.selected == NO) {
        if ([@"" isEqualToString:telTextField.text]) {
            [lhColor showAlertWithMessage:@"请输入手机号" withSuperView:self.view withHeih:DeviceMaxHeight/2];
            return;
        }
        else if(![[lhColor shareColor] isValidateMobile:telTextField.text]){//验证失败
            [lhColor showAlertWithMessage:@"手机号格式不正确" withSuperView:self.view withHeih:DeviceMaxHeight/2];
            
            return;
        }
    }
    if (valiTag) {
        
    }else{
        [lhColor addActivityView:self.view];
        NSDictionary *dic = @{@"mobile":telTextField.text};
        
        [FrankNetworkManager postReqeustWithURL:PATH(@"getVerificationCode") params:dic successBlock:^(id returnData){
            [lhColor disAppearActivitiView:self.view];
            if ([[returnData objectForKey:@"status"]integerValue] == 1) {
                lastTelStr = telTextField.text;
                validateStr = [NSString stringWithFormat:@"%@",[[returnData objectForKey:@"data"] objectForKey:@"verCode"]];
#warning 验证码
                //        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"验证码（仅测试阶段会弹出）" message:validateStr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                //        [alertView show];
                [lhColor showAlertWithMessage:@"发送验证码成功" withSuperView:self.view withHeih:DeviceMaxHeight/2];
                verificatBtn.selected = YES;
            }else{
                [FrankTools requestFailAlertShow:[returnData objectForKey:@"msg"]];
            }
        } failureBlock:^(NSError *error) {
            FLLog(@"%@",error.localizedDescription);
            [FrankTools wangluoAlertShow];
            [lhColor disAppearActivitiView:self.view];
        } showHUD:NO];
    }
}

#pragma mark - 定时器方法
- (void)verificatTimeEvent
{
    if (verificatBtn.selected == NO){
        return;
    }
    
    if (countTimeS <= 0) {
        verificatBtn.selected = NO;
        valiTag = NO;
//        verificatBtn.backgroundColor = [lhColor colorFromHexRGB:mainColorStr];
        verificatBtn.enabled = YES;
        [verificatBtn setTitle:@"重新发送" forState:UIControlStateNormal];
        [verificatBtn setTitle:@"已发送(60)" forState:UIControlStateSelected];
        countTimeS = maxTime-1;
    }
    else{
        NSString * str = [NSString stringWithFormat:@"已发送(%ld)",countTimeS];
        [verificatBtn setTitle:str forState:UIControlStateSelected];
        countTimeS--;
        valiTag = YES;
    }
}

#pragma mark - 确认预约初始化
- (void)firmAppointInit
{
    if (firmOrderView) {
        for (UIView * vi in firmOrderView.subviews){
            [vi removeFromSuperview];
        }
        
        [self iii:firmOrderView];
        
        if (successView) {
            for (UIView * vi in successView.subviews){
                [vi removeFromSuperview];
            }
            
            [self iii:successView];
            
            for (UIView *fView in successView.subviews) {
                if ([fView isKindOfClass:[UIButton class]]) {
                    [fView removeFromSuperview];
                }
            }
        }
    }
    
    
}

- (void)iii:(UIView *)sView
{
    UIView * aView = [[UIView alloc]initWithFrame:CGRectMake(20*widthRate, 30*widthRate, DeviceMaxWidth-40*widthRate, 95*widthRate)];
    aView.layer.borderWidth = 0.5;
    aView.layer.borderColor = [lhColor colorFromHexRGB:contentTitleColorStr1].CGColor;
    aView.layer.cornerRadius = 4;
    aView.layer.masksToBounds = YES;
    [sView addSubview:aView];
    
    CGFloat heih = 5*widthRate;
    NSArray * tAr = @[@"预约考场：",@"预约时间：",@"预约教练："];
    NSMutableArray * tempA = [NSMutableArray array];
    
    NSString * schStr1 = [NSString stringWithFormat:@"%@(%@)",[[selectStrArray objectAtIndex:0] objectForKey:@"name"],[selectArray objectAtIndex:1]];
    NSString * dStr = [NSString stringWithFormat:@"%@",[[selectStrArray objectAtIndex:2] objectForKey:@"date"]];
    NSDateFormatter * df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * nowD = [df dateFromString:dStr];
    [df setDateFormat:@"yyyy 年 MM 月 dd 日"];
    NSString * ndStr = [df stringFromDate:nowD];
   
    NSString * nStr = [NSString stringWithFormat:@"%@(%@)",[[selectStrArray objectAtIndex:3] objectForKey:@"name"],[[selectStrArray objectAtIndex:3] objectForKey:@"plateNumber"]];
    [tempA addObject:schStr1];
    [tempA addObject:ndStr];
    [tempA addObject:nStr];
    
    for (int i = 0; i < tAr.count; i++) {
        NSString * str = [NSString stringWithFormat:@"%@%@",[tAr objectAtIndex:i],[tempA objectAtIndex:i]];
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10*widthRate, heih, DeviceMaxWidth-45*widthRate, 25*widthRate)];
        label.text = str;
        label.font = [UIFont fontWithName:fontName size:14];
        label.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
        [aView addSubview:label];
        
        if (i == 2) {
            NSMutableAttributedString * as = [[NSMutableAttributedString alloc] initWithString:str];
            [as addAttribute:NSForegroundColorAttributeName value:[lhColor colorFromHexRGB:otherColorStr] range:NSMakeRange(9, str.length-9)];
            label.attributedText = as;
        }
        heih += 30*widthRate;
    }
    
    heih += 60*widthRate;
    
    UIImage * img1 = imageWithName(@"mainBtnBg");
    img1 = [img1 resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    UIButton * appButton = [UIButton buttonWithType:UIButtonTypeCustom];
    appButton.frame = CGRectMake(10*widthRate, heih, DeviceMaxWidth-20*widthRate, 35*widthRate);
    appButton.tag = 545;
    [appButton setBackgroundImage:img1 forState:UIControlStateNormal];
    [appButton setTitle:@"确认预约" forState:UIControlStateNormal];
    [appButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [appButton addTarget:self action:@selector(firmBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    appButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [sView addSubview:appButton];
    
}

#pragma mark - 预约成功初始化
- (void)appointSuccessInit
{
    
}

#pragma mark - 已选择显示
//初始化选择页面
- (UIView *)selectedViewWithSuperView:(UIView *)sView withTableView:(UIView *)tableView withIndex:(NSInteger)tag
{
    UIView * oneGi = (UIView *)[maxScrollView viewWithTag:selectedViewTagOriginal+tag];
    if (oneGi) {
        for (UIView * vie in oneGi.subviews){
            [vie removeFromSuperview];
        }
    }
    else{
        oneGi = [[UIView alloc]initWithFrame:CGRectMake(0, 7*widthRate, DeviceMaxWidth, 200)];
        oneGi.tag = selectedViewTagOriginal+tag;
        [sView addSubview:oneGi];
    }
    
    CGFloat hh = 10*widthRate;
    
    UILabel * gName = [[UILabel alloc]initWithFrame:CGRectMake(15*widthRate, hh, DeviceMaxWidth-40*widthRate, 20*widthRate)];
    gName.text = @"您当前已选择";
    gName.textColor = [lhColor colorFromHexRGB:lineColorStr];
    gName.font = [UIFont fontWithName:fontName size:16];
    gName.font = [UIFont systemFontOfSize:16];
    [oneGi addSubview:gName];
    
    hh += 22*widthRate;
    
    UIImageView * lineView = [[UIImageView alloc]initWithFrame:CGRectMake(0, hh, DeviceMaxWidth, 6*widthRate)];
    lineView.image = imageWithName(@"appointXian");
    [oneGi addSubview:lineView];
    
    hh += 18*widthRate;
    
    UIButton * tempBtn;
    NSInteger c = maxScrollView.contentOffset.x/DeviceMaxWidth;
    if (isSelectType) {
        c += 1;
    }
    for (int i = 0; i < c; i++) {
        UIButton * eleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        eleBtn.titleLabel.font = [UIFont fontWithName:fontName size:15];
        [eleBtn setTitleColor:[lhColor colorFromHexRGB:contentTitleColorStr] forState:UIControlStateNormal];
        [eleBtn setTitle:[selectArray objectAtIndex:i] forState:UIControlStateNormal];
        [eleBtn setBackgroundColor:[lhColor colorFromHexRGB:viewColorStr]];
        eleBtn.layer.cornerRadius = 5;
        eleBtn.layer.masksToBounds = YES;
        
        if (i == 0) {
            [eleBtn setFrame:CGRectMake(18*widthRate, hh, 100*widthRate, 30*widthRate)];
            [eleBtn sizeToFit];
            
            CGRect re = eleBtn.frame;
            re.size.width += 20*widthRate;
            eleBtn.frame = re;
            
            tempBtn = eleBtn;
        }
        else{
            [eleBtn setFrame:CGRectMake(tempBtn.frame.origin.x+tempBtn.frame.size.width+10*widthRate, hh, 100*widthRate, 30*widthRate)];
            [eleBtn sizeToFit];
            
            CGRect re = eleBtn.frame;
            re.size.width += 20*widthRate;
            eleBtn.frame = re;
            
            if (eleBtn.frame.origin.x+eleBtn.frame.size.width+10*widthRate > DeviceMaxWidth) {
                hh += 40*widthRate;
                
                [eleBtn setFrame:CGRectMake(18*widthRate, hh, 100*widthRate, 30*widthRate)];
                [eleBtn sizeToFit];
                
                CGRect re = eleBtn.frame;
                re.size.width += 20*widthRate;
                eleBtn.frame = re;
            }
            
            tempBtn = eleBtn;
        }
        
        [oneGi addSubview:eleBtn];

    }
    
    hh += 40*widthRate;
    
    UIView * lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, hh-0.5, DeviceMaxWidth, 0.5)];
    lineView1.backgroundColor = [lhColor colorFromHexRGB:viewColorStr];
    [oneGi addSubview:lineView1];
    
    UIView * lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0, hh, DeviceMaxWidth, 7*widthRate)];
    lineView2.backgroundColor = [lhColor colorFromHexRGB:viewColorStr];
    [oneGi addSubview:lineView2];
    
    hh += 7*widthRate;
    
    CGRect red = oneGi.frame;
    red.size.height = hh;
    oneGi.frame = red;
    
    CGRect rec = tableView.frame;
    rec.origin.y = red.origin.y+red.size.height;
    if (tag < 4) {
        rec.size.height = CGRectGetHeight(sView.frame)-rec.origin.y;
    }
    tableView.frame = rec;
    
    return oneGi;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField == cardTextField){
        if (cardTextField.text.length < 18) {
            return YES;
        }
        else{
            return NO;
        }
    }
    if(textField == telTextField){
        if (telTextField.text.length < 11) {
            return YES;
        }
        else{
            return NO;
        }
    }
    if (textField == verificatField) {
        if (verificatField.text.length < 6) {
            return YES;
        }
        else{
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if (textField == searchTextField) {//搜索
        [self searchBtnEvent];
    }
    else if (textField == nameTextField) {//输入姓名
        [cardTextField becomeFirstResponder];
    }
    else if(textField == cardTextField){//身份证号
        [telTextField becomeFirstResponder];
    }
    else if(textField == telTextField){
        [telTextField resignFirstResponder];
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField != searchTextField) {
        CGRect rec = whiteView.frame;
        rec.origin.y = 64-240;
        [UIView animateWithDuration:0.25 animations:^{
            whiteView.frame = rec;
        }];
    }
    if (textField == nameTextField) {
        UIView *line = [self.view viewWithTag:500];
        line.backgroundColor = [lhColor colorFromHexRGB:mainColorStr];
    }else if (textField == cardTextField){
        UIView *line = [self.view viewWithTag:501];
        line.backgroundColor = [lhColor colorFromHexRGB:mainColorStr];
    }else if (textField == telTextField){
        UIView *line = [self.view viewWithTag:502];
        line.backgroundColor = [lhColor colorFromHexRGB:mainColorStr];
    }else if (textField == verificatField){
        UIView *line = [self.view viewWithTag:800];
        line.backgroundColor = [lhColor colorFromHexRGB:mainColorStr];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField != searchTextField) {
        [self keyBoardDisAppear];
    }
    if (textField == nameTextField) {
        UIView *line = [self.view viewWithTag:500];
        line.backgroundColor = [lhColor colorFromHexRGB:contentTitleColorStr1];
    }else if (textField == cardTextField){
        UIView *line = [self.view viewWithTag:501];
        line.backgroundColor = [lhColor colorFromHexRGB:contentTitleColorStr1];
    }else if (textField == telTextField){
        UIView *line = [self.view viewWithTag:502];
        line.backgroundColor = [lhColor colorFromHexRGB:contentTitleColorStr1];
    }else if (textField == verificatField){
        UIView *line = [self.view viewWithTag:800];
        line.backgroundColor = [lhColor colorFromHexRGB:contentTitleColorStr1];
    }
}

- (void)keyBoardDisAppear
{
    CGRect rec = whiteView.frame;
    rec.origin.y = 64;
    [UIView animateWithDuration:0.25 animations:^{
        whiteView.frame = rec;
    }];
    
}

- (void)tapGEvent
{
    if (nameTextField) {
        [nameTextField resignFirstResponder];
        [cardTextField resignFirstResponder];
        [telTextField resignFirstResponder];
    }
    
}

#pragma mark - 确认身份信息
- (void)firmBtnEvent
{
    if (self.appointType == 6 && maxScrollView.contentOffset.x/DeviceMaxWidth == 3) {
        //确认预约

        [lhColor addActivityView123:self.view];
        NSString * idStr = [NSString stringWithFormat:@"%@",[[lhColor shareColor].userInfo objectForKey:@"id"]];
        NSString * schId = [NSString stringWithFormat:@"%@",[[selectStrArray objectAtIndex:0] objectForKey:@"examId"]];
        NSString * dateStr11 = [NSString stringWithFormat:@"%@",[[selectStrArray objectAtIndex:2] objectForKey:@"date"]];
        NSString * numberId = [NSString stringWithFormat:@"%@",[[selectStrArray objectAtIndex:3] objectForKey:@"id"]];
        //提交预约教练车
        NSDictionary * dic = @{@"id":idStr,
                               @"examId":schId,
                               @"coachId":numberId,
                               @"date":dateStr11};
        NSLog(@"a = %@ b = %@",selectArray,selectStrArray);
        
        [FrankNetworkManager postReqeustWithURL:PATH(@"simulate/buildCoachCarOrder") params:dic successBlock:^(id returnData){
            [lhColor disAppearActivitiView:self.view];
            if ([[returnData objectForKey:@"status"]integerValue] == 1) {
                if (selectArray && selectArray.count > 5) {
                    [selectArray removeObjectAtIndex:5];
                    [selectArray insertObject:@"" atIndex:5];
                    
                    [selectStrArray removeObjectAtIndex:5];
                    [selectStrArray insertObject:@"" atIndex:5];
                }
                else{
                    [selectArray addObject:@""];
                    [selectStrArray addObject:@""];
                }
                
                [UIView animateWithDuration:0.3 animations:^{
                    maxScrollView.contentOffset = CGPointMake(maxScrollView.contentOffset.x+DeviceMaxWidth, 0);
                }completion:^(BOOL finished) {
                    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"预约成功" message:@"请耐心等候教练确认信息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    alertView.tag = 2;
                    [alertView show];
                }];
            }else{
                [FrankTools requestFailAlertShow:[returnData objectForKey:@"msg"]];
            }
        } failureBlock:^(NSError *error) {
            FLLog(@"%@",error.localizedDescription);
            [FrankTools wangluoAlertShow];
            [lhColor disAppearActivitiView:self.view];
        } showHUD:NO];
        return;
    }
    else if(self.appointType == 6){
        return;
    }
    [self tapGEvent];
    if ([@"" isEqualToString:nameTextField.text] || [@"" isEqualToString:cardTextField.text] || [@"" isEqualToString:telTextField.text]) {
        
        [lhColor showAlertWithMessage:@"信息未填写完整" withSuperView:self.view withHeih:DeviceMaxHeight/3];
        return;
    }
    if (![lhColor validateIdentityCard:cardTextField.text]) {
        [lhColor showAlertWithMessage:@"身份证号码不合法" withSuperView:self.view withHeih:DeviceMaxHeight/3];
        return;
    }
    if (![[lhColor shareColor]isValidateMobile:telTextField.text]) {
        [lhColor showAlertWithMessage:@"电话号码不合法" withSuperView:self.view withHeih:DeviceMaxHeight/3];
        return;
    }
    if (payMark){ //表示需要支付
        
    }else{ //不需要支付
        if (![validateStr isEqualToString:verificatField.text]) {
            [lhColor showAlertWithMessage:@"验证码错误" withSuperView:self.view withHeih:DeviceMaxHeight/3];
            return;
        }
    }
    
    [self createOrder];
}

#pragma mark - 创建订单
- (void)createOrder
{
    //请求我的驾校数据
    [lhColor addActivityView:self.view];
    NSString * idStr = [NSString stringWithFormat:@"%@",[[lhColor shareColor].userInfo objectForKey:@"id"]];
    NSString * schId = [NSString stringWithFormat:@"%@",[[selectStrArray objectAtIndex:0] objectForKey:@"examId"]];
    NSString * numberId = [NSString stringWithFormat:@"%@",[[selectStrArray objectAtIndex:4] objectForKey:@"numberId"]];
    NSDictionary * dic = @{@"id":idStr,
                           @"examId":schId,
                           @"numberId":numberId,
                           @"name":nameTextField.text,
                           @"idCard":cardTextField.text,
                           @"phone":telTextField.text};
    
    [FrankNetworkManager postReqeustWithURL:PATH(@"") params:dic successBlock:^(id returnData){
        [lhColor disAppearActivitiView:self.view];
        if ([[returnData objectForKey:@"status"]integerValue] == 1) {
            NSDictionary *dic = [[NSMutableDictionary dictionaryWithDictionary:returnData] objectForKey:@"data"];
            lhFirmOrderViewController * foVC = [[lhFirmOrderViewController alloc]init];
            foVC.userDic = dic;
            foVC.examAddress = examAddress;
            if (payMark == 1) {
                foVC.orderType = 1;
            }else{
                foVC.orderType = 0;
            }
            [self.navigationController pushViewController:foVC animated:YES];
            //销毁定时器
            if (stuTimer) {
                [stuTimer invalidate];
                stuTimer = nil;
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

#pragma mark - UIScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView != maxScrollView) {
        return;
    }
//    if (maxScrollView.contentOffset.x <= 0) {
//        [UIView animateWithDuration:0.1 animations:^{
//            maxScrollView.contentOffset = CGPointMake(0, 0);
//        }];
//        
//        rightLabel.hidden = NO;
//        rImgView.hidden = NO;
//        rightBtn.hidden = NO;
//
//        return;
//    }
//    else if(maxScrollView.contentOffset.x >= DeviceMaxWidth*selectArray.count){
//        [UIView animateWithDuration:0.1 animations:^{
//            maxScrollView.contentOffset = CGPointMake(DeviceMaxWidth*selectArray.count, 0);
//        }];
//    }
    
    rightLabel.hidden = YES;
    rImgView.hidden = YES;
    rightBtn.hidden = YES;
    
    switch ((int)(maxScrollView.contentOffset.x/DeviceMaxWidth)) {
        case 0:{
            
            if (isSelectType) {
                [self selectedViewWithSuperView:typeView withTableView:typeTableView withIndex:0];
            }
            else{
                rightLabel.hidden = NO;
                rImgView.hidden = NO;
                rightBtn.hidden = NO;
            }
            break;
        }
        case 1:{
            
            [searchTextField resignFirstResponder];
            
            [self selectedViewWithSuperView:dateView withTableView:dateTableView withIndex:1];
            
            break;
        }
        case 2:{
            
            [self selectedViewWithSuperView:carView withTableView:carTableView withIndex:2];
            
            break;
        }
        case 3:{
            
            if (self.appointType == 5) {
                [self selectedViewWithSuperView:pHaoView withTableView:pHaoTableView withIndex:3];
            }
            else if(self.appointType == 6){
                //初始化确认预约界面
                [self firmAppointInit];
            }
            
            break;
        }
        case 4:{
            if (self.appointType == 5) {
                if (payMark) {
                    UIView *hidView = [self.view viewWithTag:2018];
                    [hidView removeFromSuperview];
                    hidView = nil;
                }
                [self selectedViewWithSuperView:personView withTableView:writePerView withIndex:4];
            }
            else if(self.appointType == 6){
                //初始化预约成功界面
                [self appointSuccessInit];
            }
            
            break;
        }
        case 5:{
            
            
            break;
        }
        case 6:{
            
            
            break;
        }
        default:
            break;
    }
    
    NSInteger index = maxScrollView.contentOffset.x/DeviceMaxWidth+1;

    [self progress:index];
}

#pragma mark - 进度
- (void)progress:(NSInteger)progress
{
    [self clearProgress];
    for (int i = 0; i < progress; i++) {
        UIView * view = (UIView *)[self.view viewWithTag:lineTagOriginal+i];
        view.backgroundColor = [lhColor colorFromHexRGB:lineColorStr];
        UIView * view1 = (UIView *)[self.view viewWithTag:circleTagOriginal+i];
        view1.backgroundColor = [lhColor colorFromHexRGB:lineColorStr];
        
        UIButton * btn = (UIButton *)[self.view viewWithTag:progressBtnTagOriginal+i];
        btn.selected = YES;
    }
}

- (void)clearProgress
{
    for (int i = 0; i < 8; i++) {
        UIView * view = (UIView *)[self.view viewWithTag:lineTagOriginal+i];
        view.backgroundColor = [lhColor colorFromHexRGB:buttonColorStr];
        UIView * view1 = (UIView *)[self.view viewWithTag:circleTagOriginal+i];
        view1.backgroundColor = [lhColor colorFromHexRGB:buttonColorStr];
        
        UIButton * btn = (UIButton *)[self.view viewWithTag:progressBtnTagOriginal+i];
        btn.selected = NO;
    }
}

#pragma mark - rightBtnEvent
- (void)rightBtnEvent
{
    NSLog(@"切换地址");
    isRequestSchoolInfo = YES;
    
    lhSelectCityViewController * scVC = [[lhSelectCityViewController alloc]init];
    [self.navigationController pushViewController:scVC animated:YES];
    
}

#pragma mark - 搜索
- (void)searchBtnEvent
{
    [searchTextField resignFirstResponder];
    
    NSLog(@"搜索");
    [schTableView headerBeginRefreshing];
    
}

#pragma mark - UITabelViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == schTableView) {
        return 40*widthRate;
    }
    else{
        return 40*widthRate;
    }
    
    return 40*widthRate;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == dateTableView || tableView == carTableView || tableView == pHaoTableView || tableView == typeTableView) {
        return 46*widthRate;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == dateTableView || tableView == carTableView || tableView == pHaoTableView || tableView == typeTableView) {
        
        NSString * str;
        if (tableView == typeTableView) {
            str = @"请选择科目";
        }
        else if (tableView == dateTableView) {
            str = @"请选择预约日期";
        }
        else if(tableView == carTableView){
            if(self.appointType == 5){
                str = @"请选择车辆";
            }
            else{
                str = @"请选择教练";
            }
        }
        else if(tableView == pHaoTableView){
            str = @"请排号";
        }
        
        UIView * oneGi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 46*widthRate)];
        oneGi.backgroundColor = [UIColor whiteColor];
        CGFloat hh = 10*widthRate;
        
        UILabel * gName = [[UILabel alloc]initWithFrame:CGRectMake(15*widthRate, hh, DeviceMaxWidth-40*widthRate, 20*widthRate)];
        gName.text = str;
        gName.textColor = [lhColor colorFromHexRGB:lineColorStr];
        gName.font = [UIFont fontWithName:fontName size:16];
        gName.font = [UIFont systemFontOfSize:16];
        [oneGi addSubview:gName];
        
        hh += 25*widthRate;
        
        UIImageView * lineView = [[UIImageView alloc]initWithFrame:CGRectMake(0, hh, DeviceMaxWidth, 6*widthRate)];
        lineView.image = imageWithName(@"appointXian");
        [oneGi addSubview:lineView];
        
        return oneGi;
    }
    
    return [[UIView alloc]init];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == schTableView) {
        return schArray.count;
    }
    else if(tableView == dateTableView){
        return dateArray.count;
    }
    else if(tableView == carTableView){
        return carArray.count;
    }
    else if(tableView == pHaoTableView){
        return pHaoArray.count;
    }
    else if(tableView == typeTableView){
        return typeArray.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == schTableView) {
        static NSString * tifier = @"schCell";
        lhSchListTableViewCell * schCell = [tableView dequeueReusableCellWithIdentifier:tifier];
        if (schCell == nil) {
            schCell = [[lhSchListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tifier];
        }
        
        if (indexPath.row == 0) {
            schCell.topView.hidden = NO;
        }
        
        NSDictionary * oneD = [schArray objectAtIndex:indexPath.row];
        schCell.nameLabel.text = [NSString stringWithFormat:@"%@",[oneD objectForKey:@"name"]];
        schCell.appButton.tag = indexPath.row;
        examAddress = [oneD objectForKey:@"address"];
        
        if (0 >= [[oneD objectForKey:@"count"]integerValue]) {
            schCell.appButton.selected = YES;
            schCell.appButton.userInteractionEnabled = NO;
        }
        
        if(indexPath.row == 2 || indexPath.row == 5){
            schCell.appButton.selected = YES;
            schCell.appButton.userInteractionEnabled = NO;
        }
        else{
            schCell.appButton.selected = NO;
            schCell.appButton.userInteractionEnabled = YES;
        }
        
        [schCell.appButton addTarget:self action:@selector(appButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        
        return schCell;
    }
    else if(tableView == dateTableView || tableView == carTableView || tableView == pHaoTableView || tableView == typeTableView){
        static NSString * tifier = @"sCell";
        lhAppointTableViewCell * schCell = [tableView dequeueReusableCellWithIdentifier:tifier];
        if (schCell == nil) {
            schCell = [[lhAppointTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tifier];
        }
        
        NSInteger countY;
        if (tableView == typeTableView) {

            NSDictionary * oneD = [typeArray objectAtIndex:indexPath.row];
            NSString * s;
            if ([[oneD objectForKey:@"subjectType"] integerValue] == 1) {
                s = @"一";
            }
            else if ([[oneD objectForKey:@"subjectType"] integerValue] == 2) {
                s = @"二";
            }
            else if ([[oneD objectForKey:@"subjectType"] integerValue] == 3) {
                s = @"三";
            }
            else if ([[oneD objectForKey:@"subjectType"] integerValue] == 4) {
                s = @"四";
            }
            NSString * str = [NSString stringWithFormat:@"科目%@（%@）",s,[oneD objectForKey:@"drivingType"]];
            [schCell.appButton setTitle:@"不能预约" forState:UIControlStateSelected];
            schCell.nameLabel.text = str;

//            countY = [[oneD objectForKey:@"count"]integerValue];
            
        }
        else if (tableView == dateTableView) {
            NSDictionary * oneD = [dateArray objectAtIndex:indexPath.row];
            countY = [[oneD objectForKey:@"count"]integerValue];
            [schCell.appButton setTitle:@"已约满" forState:UIControlStateSelected];
            
//            NSString * dStr = [NSString stringWithFormat:@"%@",[oneD objectForKey:@"date"]];
//            NSDateFormatter * df = [[NSDateFormatter alloc]init];
//            [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//            NSDate * nowD = [df dateFromString:dStr];
//            [df setDateFormat:@"MM 月 dd 日"];
//            NSString * ndStr = [df stringFromDate:nowD];
            
            NSDate * date = [NSDate dateWithTimeIntervalSince1970:[[oneD objectForKey:@"date"] doubleValue]/1000];
            NSDateFormatter * df = [[NSDateFormatter alloc]init];
            [df setDateFormat:@"yyyy-MM-dd"];
            schCell.nameLabel.text = [NSString stringWithFormat:@"%@",[df stringFromDate:date]];
            
        }
        else if(tableView == carTableView){
            NSDictionary * oneD = [carArray objectAtIndex:indexPath.row];
            if (self.appointType == 5) {
                
                countY = [[oneD objectForKey:@"count"]integerValue];
                
                [schCell.appButton setTitle:@"已约满" forState:UIControlStateSelected];
                
                NSInteger sy = [[oneD objectForKey:@"totalCount"]integerValue]-[[oneD objectForKey:@"count"]integerValue];
                NSString * str = [NSString stringWithFormat:@"%ld/%@",(long)sy,[oneD objectForKey:@"totalCount"]];
                
//                NSString * nStr = [NSString stringWithFormat:@"%@号车(%@)",[oneD objectForKey:@"vehicleNumber"],[oneD objectForKey:@"plateNumber"]];
                NSString * nStr = [NSString stringWithFormat:@"%@号车",[oneD objectForKey:@"vehicleNumber"]];
                schCell.nameLabel.text = nStr;
                schCell.numLabel.text = str;
            }
            else{
            
                NSString * nStr = [NSString stringWithFormat:@"%@(%@)",[oneD objectForKey:@"name"],[oneD objectForKey:@"plateNumber"]];
                
                NSMutableAttributedString * as = [[NSMutableAttributedString alloc]initWithString:nStr];
                [as addAttribute:NSFontAttributeName value:[UIFont fontWithName:fontName size:14] range:NSMakeRange(nStr.length-9, 9)];
                [as addAttribute:NSForegroundColorAttributeName value:[lhColor colorFromHexRGB:lineColorStr] range:NSMakeRange(nStr.length-9, 9)];
                
                schCell.nameLabel.attributedText = as;
                schCell.numLabel.hidden = YES;
                
                
                
            }
            
        }
        else if(tableView == pHaoTableView){
            
            [schCell.appButton setTitle:@"已预约" forState:UIControlStateSelected];
            NSDictionary * oneD = [pHaoArray objectAtIndex:indexPath.row];
            
            if ([oneD objectForKey:@"isReserver"]) {
                countY = 1;
            }
            else{
                countY = 0;
            }
            
            NSString * t;
            NSInteger n = [[oneD objectForKey:@"number"] integerValue];
//            if (n < 10) {
//                t = [NSString stringWithFormat:@"0%ld号(预计%ld:00-%ld:00)",(long)n,(long)7+n,(long)7+n+1];
//            }
//            else{
//                t = [NSString stringWithFormat:@"%ld号(预计%ld:00-%ld:00)",(long)n,(long)7+n,(long)7+n+1];
//            }
            if (n<10){
                t = [NSString stringWithFormat:@"0%ld号",(long)n];
            }else{
                t = [NSString stringWithFormat:@"%ld号",(long)n];
            }
            schCell.nameLabel.text = t;
//            NSMutableAttributedString * as = [[NSMutableAttributedString alloc]initWithString:t];
//            [as addAttribute:NSForegroundColorAttributeName value:[lhColor colorFromHexRGB:otherColorStr] range:NSMakeRange(6, t.length-7)];
//            schCell.nameLabel.attributedText = as;
        }
        /*
        if (0 >= countY) {
            schCell.appButton.selected = YES;
            schCell.appButton.userInteractionEnabled = NO;
        }
        else{
            schCell.appButton.selected = NO;
            schCell.appButton.userInteractionEnabled = YES;
        }*/
        schCell.appButton.tag = indexPath.row;
        [schCell.appButton addTarget:self action:@selector(appButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        
        return schCell;
    }
    
    return nil;
}

- (NSString *)dateStr
{
    NSLog(@"dataStr = %@",[[selectStrArray objectAtIndex:2] objectForKey:@"date"]);
    NSString * dStr = [NSString stringWithFormat:@"%@",[[selectStrArray objectAtIndex:2] objectForKey:@"date"]];
    
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:[dStr doubleValue]/1000];
    NSDateFormatter * df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM-dd"];
    dStr = [NSString stringWithFormat:@"%@",[df stringFromDate:date]];
    NSLog(@"dStr = %@",dStr);
    if (dStr && dStr.length >= 10) {
        return [dStr substringToIndex:10];
    }
    return @"";
}

#pragma mark - 预约
- (void)appButtonEvent:(UIButton *)button_
{
    NSLog(@"预约 %ld",(long)button_.tag);
    
    if (button_.selected) {
        return;
    }
    
    NSArray * tempA;
    NSInteger nowIndex = maxScrollView.contentOffset.x/DeviceMaxWidth;
    if (nowIndex == 0) {
        
        if (!isSelectType) {
            [self selectedViewWithSuperView:typeView withTableView:typeTableView withIndex:0];
            typeView.hidden = NO;
            
            rightBtn.hidden = YES;
            rightLabel.hidden = YES;
            rImgView.hidden = YES;
            
            tempA = schArray;
            
            schStr = [NSString stringWithFormat:@"%@",[[tempA objectAtIndex:button_.tag] objectForKey:@"name"]];
        }
        else{
            tempA = typeArray;
            NSDictionary * oneD = [tempA objectAtIndex:button_.tag];
            NSString * s;
            if ([[oneD objectForKey:@"subjectType"] integerValue] == 1) {
                s = @"一";
            }
            else if ([[oneD objectForKey:@"subjectType"] integerValue] == 2) {
                s = @"二";
            }
            else if ([[oneD objectForKey:@"subjectType"] integerValue] == 3) {
                s = @"三";
            }
            else if ([[oneD objectForKey:@"subjectType"] integerValue] == 4) {
                s = @"四";
            }
            
            schStr = [NSString stringWithFormat:@"科目%@",s];
        }
    }
    else if(nowIndex == 1){
        tempA = dateArray;
        NSDictionary * oneD = [tempA objectAtIndex:button_.tag];
//        NSString * dStr = [NSString stringWithFormat:@"%@",[oneD objectForKey:@"date"]];
//        NSDateFormatter * df = [[NSDateFormatter alloc]init];
//        [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//        NSDate * nowD = [df dateFromString:dStr];
//        [df setDateFormat:@"MM 月 dd 日"];
//        schStr = [df stringFromDate:nowD];
        NSDate * date = [NSDate dateWithTimeIntervalSince1970:[[oneD objectForKey:@"date"] doubleValue]/1000];
        NSDateFormatter * df = [[NSDateFormatter alloc]init];
        [df setDateFormat:@"yyyy-MM-dd"];
        schStr = [NSString stringWithFormat:@"%@",[df stringFromDate:date]];
    }
    else if(nowIndex == 2){
        tempA = carArray;
        schStr = [NSString stringWithFormat:@"%ld号车",(long)button_.tag+1];
    }
    else if(nowIndex == 3){
        tempA = pHaoArray;
        schStr = [NSString stringWithFormat:@"%ld号",(long)button_.tag+1];
    }
    if (nowIndex == 0 && !isSelectType) {
        if (selectArray && selectArray.count > nowIndex) {
            [selectArray removeObjectAtIndex:nowIndex];
            [selectArray insertObject:schStr atIndex:nowIndex];
            
            [selectStrArray removeObjectAtIndex:nowIndex];
            [selectStrArray insertObject:[tempA objectAtIndex:button_.tag] atIndex:nowIndex];
        }
        else{
            [selectArray addObject:schStr];
            [selectStrArray addObject:[tempA objectAtIndex:button_.tag]];
        }
    }
    else{
        if (selectArray && selectArray.count > nowIndex+1) {
            [selectArray removeObjectAtIndex:nowIndex+1];
            [selectArray insertObject:schStr atIndex:nowIndex+1];
            
            [selectStrArray removeObjectAtIndex:nowIndex+1];
            [selectStrArray insertObject:[tempA objectAtIndex:button_.tag] atIndex:nowIndex+1];
        }
        else{
            [selectArray addObject:schStr];
            [selectStrArray addObject:[tempA objectAtIndex:button_.tag]];
        }
    }
    
    if (isSelectType) {
        switch (nowIndex) {
            case 0:{
                
                [dateTableView headerBeginRefreshing];
                break;
            }
            case 1:{
                
                [carTableView headerBeginRefreshing];
                break;
            }
            case 2:{
                
                [pHaoTableView headerBeginRefreshing];
                break;
            }
            case 3:{
                nameTextField.text = [lhColor shareColor].userName;
                cardTextField.text = [lhColor shareColor].idCard;
                telTextField.text = [lhColor shareColor].phone;
                break;
            }
            case 4:{
                
                break;
            }
            case 5:{
                
                break;
            }
            default:
                break;
        }
        
        
        [UIView animateWithDuration:0.3 animations:^{
            maxScrollView.contentOffset = CGPointMake(maxScrollView.contentOffset.x+DeviceMaxWidth, 0);
        }];
    }
    else{
        isSelectType = YES;
        [self selectedViewWithSuperView:typeView withTableView:typeTableView withIndex:0];
        [typeTableView headerBeginRefreshing];
    }
}

#pragma mark - 下拉刷新
- (void)headerRefresh //考场预约“typeTableNotiName”
{
    NSString * idStr = [NSString stringWithFormat:@"%@",[[lhColor shareColor].userInfo objectForKey:@"id"]];
//    NSDictionary * dic = @{@"id":idStr,@"areaName":[lhColor shareColor].nowCityStr,@"examName":searchTextField.text};
    NSDictionary * dic = @{@"id":idStr,@"areaName":@"万州",@"examName":searchTextField.text};
    NSString * str = @"simulate/chooseExamSpace";
    NSLog(@"xuexiao ");
    [self requestSimulateDate:dic withStr:str withName:SchTableNotiName];
}

- (void)headerRefresh1 //科目预约 “DateTableNotiName”
{
    NSString * idStr = [NSString stringWithFormat:@"%@",[[lhColor shareColor].userInfo objectForKey:@"id"]];
    NSDictionary * dic = @{@"id":idStr,@"examId":[[selectStrArray objectAtIndex:0] objectForKey:@"examId"]};
    NSString * str = @"simulate/chooseSubject";
    
    [self requestSimulateDate:dic withStr:str withName:typeTableNotiName];
}

- (void)headerRefresh2
{
    NSString * idStr = [NSString stringWithFormat:@"%@",[[lhColor shareColor].userInfo objectForKey:@"id"]];
    NSDictionary * dic = @{@"id":idStr,
                           @"examId":[[selectStrArray objectAtIndex:0] objectForKey:@"examId"],
                           @"drivingType":[[selectStrArray objectAtIndex:1] objectForKey:@"drivingType"],
                           @"subjectType":[[selectStrArray objectAtIndex:1] objectForKey:@"subjectType"]};
    NSString * str = @"simulate/chooseDate";
    [self requestSimulateDate:dic withStr:str withName:DateTableNotiName];
}

- (void)headerRefresh3
{
    NSDictionary * dic;
    NSString * str;
    if (self.appointType == 5) {
        NSString * idStr = [NSString stringWithFormat:@"%@",[[lhColor shareColor].userInfo objectForKey:@"id"]];
        dic = @{@"id":idStr,
                               @"examId":[[selectStrArray objectAtIndex:0] objectForKey:@"examId"],
                               @"drivingType":[[selectStrArray objectAtIndex:1] objectForKey:@"drivingType"],
                               @"subjectType":[[selectStrArray objectAtIndex:1] objectForKey:@"subjectType"],
                               @"date":[self dateStr]};
        str = @"simulate/chooseVehicle";
    }
    else{
        //请求教练
        NSString * idStr = [NSString stringWithFormat:@"%@",[[lhColor shareColor].userInfo objectForKey:@"id"]];
        dic = @{@"id":idStr};
        str = @"simulate/chooseCoach";
    }
    
    [self requestSimulateDate:dic withStr:str withName:CarTableNotiName];
}

- (void)headerRefresh4
{
    NSString * idStr = [NSString stringWithFormat:@"%@",[[lhColor shareColor].userInfo objectForKey:@"id"]];
    NSDictionary * dic = @{@"id":idStr,
                           @"examId":[[selectStrArray objectAtIndex:0] objectForKey:@"examId"],
                           @"drivingType":[[selectStrArray objectAtIndex:1] objectForKey:@"drivingType"],
                           @"subjectType":[[selectStrArray objectAtIndex:1] objectForKey:@"subjectType"],
                           @"date":[self dateStr],
                           @"vehicleId":[[selectStrArray objectAtIndex:3] objectForKey:@"vehicleId"]};
    NSString * str = @"simulate/chooseNumber";

    [self requestSimulateDate:dic withStr:str withName:pHaoTableNotiName];
}


#pragma mark - 请求驾校及需要选择的数据
- (void)requestSimulateDate:(NSDictionary *)dic withStr:(NSString *)str withName:(NSString *)nName
{
    //请求我的驾校数据
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(requestSchoolEvent:) name:nName object:nil];
//    [[lhWeb alloc]HTTPPOSTNormalRequestForURL:str parameters:[NSMutableDictionary dictionaryWithDictionary:dic] method:@"POST" name:nName type:OUR_REQUEST];
    NSLog(@"%@ ",dic);
    [lhColor addActivityView1OnlyActivityView:self.view];
    if ([SchTableNotiName isEqualToString:nName]) {
        if (!schTableView.headerHidden) {
            [schTableView headerEndRefreshing];
        }
        [FrankNetworkManager postReqeustWithURL:PATH(str) params:dic successBlock:^(id returnData){
            [lhColor disAppearActivitiViewOnlyActivityView:self.view];
            if ([[returnData objectForKey:@"status"]integerValue] == 1) {
                schArray = [NSMutableArray arrayWithArray:[returnData objectForKey:@"data"]];
                if (schArray && schArray.count > 0) {
                    [lhColor removeNullLabelWithSuperView:schTableView];
                    [schTableView reloadData];
                }
                else{
                    [schTableView reloadData];
                    [lhColor addANullLabelWithSuperView:schTableView withFrame:CGRectMake(10*widthRate, 70*widthRate, 300*widthRate, 20*widthRate) withText:@"暂无数据，换个城市试试？"];
                }
            }else{
                [FrankTools requestFailAlertShow:[returnData objectForKey:@"msg"]];
            }
        } failureBlock:^(NSError *error) {
            FLLog(@"%@",error.localizedDescription);
            [FrankTools wangluoAlertShow];
            [lhColor disAppearActivitiViewOnlyActivityView:self.view];
        } showHUD:NO];
    }
    else if([typeTableNotiName isEqualToString:nName]){
        if (!typeTableView.headerHidden) {
            [typeTableView headerEndRefreshing];
        }
        [FrankNetworkManager postReqeustWithURL:PATH(str) params:dic successBlock:^(id returnData){
            [lhColor disAppearActivitiViewOnlyActivityView:self.view];
            if ([[returnData objectForKey:@"status"]integerValue] == 1) {
                typeArray = [NSMutableArray arrayWithArray:[[returnData objectForKey:@"data"] objectForKey:@"subjects"]];
                
                NSString *needPayStr = [[returnData objectForKey:@"data"] objectForKey:@"needPay"];
                payMark = [needPayStr integerValue];
                NSLog(@"payMark = %d",payMark);
                if (typeArray && typeArray.count > 0) {
                    [lhColor removeNullLabelWithSuperView:typeTableView];
                    [typeTableView reloadData];
                }
                else{
                    [typeTableView reloadData];
                    [lhColor addANullLabelWithSuperView:typeTableView withFrame:CGRectMake(10*widthRate, 70*widthRate, 300*widthRate, 20*widthRate) withText:@"暂无数据"];
                }
            }else{
                [FrankTools requestFailAlertShow:[returnData objectForKey:@"msg"]];
            }
        } failureBlock:^(NSError *error) {
            FLLog(@"%@",error.localizedDescription);
            [FrankTools wangluoAlertShow];
            [lhColor disAppearActivitiViewOnlyActivityView:self.view];
        } showHUD:NO];
    }
    else if([DateTableNotiName isEqualToString:nName]){
        if (!dateTableView.headerHidden) {
            [dateTableView headerEndRefreshing];
        }
        [FrankNetworkManager postReqeustWithURL:PATH(str) params:dic successBlock:^(id returnData){
            [lhColor disAppearActivitiViewOnlyActivityView:self.view];
            if ([[returnData objectForKey:@"status"]integerValue] == 1) {
                dateArray = [NSMutableArray arrayWithArray:[returnData objectForKey:@"data"]];
                NSLog(@"dateArray = %@",dateArray);
                if (dateArray && dateArray.count > 0) {
                    [lhColor removeNullLabelWithSuperView:dateTableView];
                    [dateTableView reloadData];
                }
                else{
                    [dateTableView reloadData];
                    [lhColor addANullLabelWithSuperView:dateTableView withFrame:CGRectMake(10*widthRate, 70*widthRate, 300*widthRate, 20*widthRate) withText:@"暂无数据"];
                }
            }else{
                [FrankTools requestFailAlertShow:[returnData objectForKey:@"msg"]];
            }
        } failureBlock:^(NSError *error) {
            FLLog(@"%@",error.localizedDescription);
            [FrankTools wangluoAlertShow];
            [lhColor disAppearActivitiViewOnlyActivityView:self.view];
        } showHUD:NO];
    }
    else if([CarTableNotiName isEqualToString:nName]){
        if (!carTableView.headerHidden) {
            [carTableView headerEndRefreshing];
        }
        [FrankNetworkManager postReqeustWithURL:PATH(str) params:dic successBlock:^(id returnData){
            [lhColor disAppearActivitiViewOnlyActivityView:self.view];
            if ([[returnData objectForKey:@"status"]integerValue] == 1) {
                carArray = [NSMutableArray arrayWithArray:[returnData objectForKey:@"data"]];
                
                if (carArray && carArray.count > 0) {
                    [lhColor removeNullLabelWithSuperView:carTableView];
                    [carTableView reloadData];
                }
                else{
                    [carTableView reloadData];
                    [lhColor addANullLabelWithSuperView:carTableView withFrame:CGRectMake(10*widthRate, 70*widthRate, 300*widthRate, 20*widthRate) withText:@"暂无数据"];
                }
            }else{
                [FrankTools requestFailAlertShow:[returnData objectForKey:@"msg"]];
            }
        } failureBlock:^(NSError *error) {
            FLLog(@"%@",error.localizedDescription);
            [FrankTools wangluoAlertShow];
            [lhColor disAppearActivitiViewOnlyActivityView:self.view];
        } showHUD:NO];
    }
    else if([pHaoTableNotiName isEqualToString:nName]){
        if (!pHaoTableView.headerHidden) {
            [pHaoTableView headerEndRefreshing];
        }
        [FrankNetworkManager postReqeustWithURL:PATH(str) params:dic successBlock:^(id returnData){
            [lhColor disAppearActivitiViewOnlyActivityView:self.view];
            if ([[returnData objectForKey:@"status"]integerValue] == 1) {
                pHaoArray = [NSMutableArray arrayWithArray:[returnData objectForKey:@"data"]];
                
                if (pHaoArray && pHaoArray.count > 0) {
                    [lhColor removeNullLabelWithSuperView:pHaoTableView];
                    [pHaoTableView reloadData];
                }
                else{
                    [pHaoTableView reloadData];
                    [lhColor addANullLabelWithSuperView:pHaoTableView withFrame:CGRectMake(10*widthRate, 70*widthRate, 300*widthRate, 20*widthRate) withText:@"暂无数据"];
                }
            }else{
                [FrankTools requestFailAlertShow:[returnData objectForKey:@"msg"]];
            }
        } failureBlock:^(NSError *error) {
            FLLog(@"%@",error.localizedDescription);
            [FrankTools wangluoAlertShow];
            [lhColor disAppearActivitiViewOnlyActivityView:self.view];
        } showHUD:NO];
    }
}

/*
- (void)requestSchoolEvent:(NSNotification *)noti
{
    NSLog(@"考场 = %@",noti.userInfo);
    if ([SchTableNotiName isEqualToString:noti.name]) {
        if (!schTableView.headerHidden) {
            [schTableView headerEndRefreshing];
        }
    }
    else if([typeTableNotiName isEqualToString:noti.name]){
        if (!typeTableView.headerHidden) {
            [typeTableView headerEndRefreshing];
        }
    }
    else if([DateTableNotiName isEqualToString:noti.name]){
        if (!dateTableView.headerHidden) {
            [dateTableView headerEndRefreshing];
        }
    }
    else if([CarTableNotiName isEqualToString:noti.name]){
        if (!carTableView.headerHidden) {
            [carTableView headerEndRefreshing];
        }
    }
    else if([pHaoTableNotiName isEqualToString:noti.name]){
        if (!pHaoTableView.headerHidden) {
            [pHaoTableView headerEndRefreshing];
        }
    }
    
    NSLog(@"aa %@",noti.userInfo);
    [[NSNotificationCenter defaultCenter]removeObserver:self name:noti.name object:nil];
    if (!noti.userInfo || [noti.userInfo class] == [NSNull class]) {
        [lhColor wangluoAlertShow];
    }
    else if([[noti.userInfo objectForKey:@"status"]integerValue] == 1){
        if ([SchTableNotiName isEqualToString:noti.name]) {
            schArray = [NSMutableArray arrayWithArray:[noti.userInfo objectForKey:@"data"]];
            if (schArray && schArray.count > 0) {
                [lhColor removeNullLabelWithSuperView:schTableView];
                [schTableView reloadData];
            }
            else{
                [schTableView reloadData];
                [lhColor addANullLabelWithSuperView:schTableView withFrame:CGRectMake(10*widthRate, 70*widthRate, 300*widthRate, 20*widthRate) withText:@"暂无数据，换个城市试试？"];
            }
        }
        else if([typeTableNotiName isEqualToString:noti.name]){
            typeArray = [NSMutableArray arrayWithArray:[[noti.userInfo objectForKey:@"data"] objectForKey:@"subjects"]];
            
            NSString *needPayStr = [[noti.userInfo objectForKey:@"data"] objectForKey:@"needPay"];
            payMark = [needPayStr integerValue];
            NSLog(@"payMark = %d",payMark);
            if (typeArray && typeArray.count > 0) {
                [lhColor removeNullLabelWithSuperView:typeTableView];
                [typeTableView reloadData];
            }
            else{
                [typeTableView reloadData];
                [lhColor addANullLabelWithSuperView:typeTableView withFrame:CGRectMake(10*widthRate, 70*widthRate, 300*widthRate, 20*widthRate) withText:@"暂无数据"];
            }
        }
        else if([DateTableNotiName isEqualToString:noti.name]){
            dateArray = [NSMutableArray arrayWithArray:[noti.userInfo objectForKey:@"data"]];
            NSLog(@"dateArray = %@",dateArray);
            if (dateArray && dateArray.count > 0) {
                [lhColor removeNullLabelWithSuperView:dateTableView];
                [dateTableView reloadData];
            }
            else{
                [dateTableView reloadData];
                [lhColor addANullLabelWithSuperView:dateTableView withFrame:CGRectMake(10*widthRate, 70*widthRate, 300*widthRate, 20*widthRate) withText:@"暂无数据"];
            }
        }
        else if([CarTableNotiName isEqualToString:noti.name]){
            
            carArray = [NSMutableArray arrayWithArray:[noti.userInfo objectForKey:@"data"]];
            
            if (carArray && carArray.count > 0) {
                [lhColor removeNullLabelWithSuperView:carTableView];
                [carTableView reloadData];
            }
            else{
                [carTableView reloadData];
                [lhColor addANullLabelWithSuperView:carTableView withFrame:CGRectMake(10*widthRate, 70*widthRate, 300*widthRate, 20*widthRate) withText:@"暂无数据"];
            }
        }
        else if([pHaoTableNotiName isEqualToString:noti.name]){
            pHaoArray = [NSMutableArray arrayWithArray:[noti.userInfo objectForKey:@"data"]];
            
            if (pHaoArray && pHaoArray.count > 0) {
                [lhColor removeNullLabelWithSuperView:pHaoTableView];
                [pHaoTableView reloadData];
            }
            else{
                [pHaoTableView reloadData];
                [lhColor addANullLabelWithSuperView:pHaoTableView withFrame:CGRectMake(10*widthRate, 70*widthRate, 300*widthRate, 20*widthRate) withText:@"暂无数据"];
            }
        }
    }
    else{
        [lhColor requestFailAlertShow:noti];
    }
}
*/

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 2) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    /*
    if (alertView.tag == 2) {
        lhMyAppOrderViewController * maoVC = [[lhMyAppOrderViewController alloc]init];
        [self.navigationController pushViewController:maoVC animated:YES];
        
        UIViewController * tempVC;
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[lhAppointSimuViewController class]]) {
                tempVC = controller;
                break;
            }
        }
        if (tempVC) {
            NSMutableArray * tempA = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
            [tempA removeObject:tempVC];
            self.navigationController.viewControllers = tempA;
        }
    }*/
}

#pragma mark - 刷新城市显示
- (void)refreshCity
{
    NSString * str = [NSString stringWithFormat:@"%@",[lhColor shareColor].nowCityStr];
    str = [str stringByReplacingOccurrencesOfString:@"市" withString:@""];
    rightLabel.text = str;
    [rightLabel sizeToFit];
    
    CGRect re = rightLabel.frame;
    re.size.height = 16;
    if (re.size.width > 70) {
        re.size.width = 70;
    }
    re.origin.y = 40;
    re.origin.x = DeviceMaxWidth-20-re.size.width;
    
    rightLabel.frame = re;
}

#pragma mark - view
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [lhColor assignmentForTempVC:self];
    
    [self refreshCity];
    
    if (isRequestSchoolInfo) {

        [schTableView headerBeginRefreshing];
        
        isRequestSchoolInfo = NO;
    }
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

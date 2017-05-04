//
//  lhStudyGuideViewController.m
//  Drive
//
//  Created by bosheng on 15/7/29.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import "lhStudyGuideViewController.h"
#import "FrankExaminationView.h"
#import "FrankHospitalCell.h"
#import "lhGPS.h"

@interface lhStudyGuideViewController ()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate,UIScrollViewDelegate>{
    UIScrollView *myScrollView;
    UIScrollView * sub1ScrollView;
    UIScrollView * sub2ScrollView;
    UIScrollView * sub3ScrollView;
    
    UIView * listLookView;
    UIButton *lastBtn;
    UIImageView * symbImgView;//排序标识箭头
    UIView * symbLeftLine;//左边线条
    UIView * symbRightLine;//右边线条
    UIView *bgView; //背景View
    UITableView *myTableView;
    
    UIView *mainLine;
    NSArray *hospitalArray;
}

@end

@implementation lhStudyGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[lhColor shareColor]originalInit:self title:@"学车指南" imageName:nil backButton:YES];
    [self createHeadFrame];
    [self initFrameView];
    [self requstHospitalData];
}

-(void)requstHospitalData
{
    [lhColor addActivityView123:self.view];
    NSString *longitude = [NSString stringWithFormat:@"%.6f",[lhColor shareColor].nowLocation.longitude];
    NSString *latitude = [NSString stringWithFormat:@"%.6f",[lhColor shareColor].nowLocation.latitude];
    NSDictionary * dic = @{@"longitude":longitude,
                           @"latitude":latitude};
    
    [FrankNetworkManager postReqeustWithURL:PATH(@"guide/hospital") params:dic successBlock:^(id returnData){
        [lhColor disAppearActivitiView:self.view];
        if ([[returnData objectForKey:@"status"]integerValue] == 1) {
            hospitalArray = [returnData objectForKey:@"data"];
            NSLog(@"hospitalArray = %@",hospitalArray);
            [myTableView reloadData];
        }else{
            [FrankTools requestFailAlertShow:[returnData objectForKey:@"msg"]];
        }
    } failureBlock:^(NSError *error) {
        FLLog(@"%@",error.localizedDescription);
        [FrankTools wangluoAlertShow];
        [lhColor disAppearActivitiView:self.view];
    } showHUD:NO];
}

//创建头
-(void)createHeadFrame{
    
    NSArray * tArray = @[@"报名须知",@"学车须知",@"体检医院"];
    for (int i = 0; i < 3; i++) {
        UIButton * titleBtn = [[UIButton alloc]initWithFrame:CGRectMake(DeviceMaxWidth/3*i, 64, DeviceMaxWidth/3, 49)];
        titleBtn.backgroundColor = [UIColor whiteColor];
        titleBtn.titleLabel.font = [UIFont fontWithName:fontName size:15];
        [titleBtn setTitle:[tArray objectAtIndex:i] forState:UIControlStateNormal];
        [titleBtn setTitleColor:[lhColor colorFromHexRGB:mainColorStr] forState:UIControlStateSelected];
        [titleBtn setTitleColor:[lhColor colorFromHexRGB:contentTitleColorStr1] forState:UIControlStateNormal];
        if (i == 0) {
            titleBtn.selected = YES;
            lastBtn = titleBtn;
        }
        titleBtn.tag = i+500;
        [titleBtn addTarget:self action:@selector(titleBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:titleBtn];
    }
    
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 112.5, DeviceMaxWidth, 0.5)];
    lineView.backgroundColor = [lhColor colorFromHexRGB:contentTitleColorStr1];
    [self.view addSubview:lineView];
    
    mainLine = [[UIView alloc]initWithFrame:CGRectMake(30*widthRate, 112, 50*widthRate, 1)];
    mainLine.backgroundColor = [lhColor colorFromHexRGB:mainColorStr];
    [self.view addSubview:mainLine];
}

-(void)initFrameView{
    myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 113, DeviceMaxWidth, DeviceMaxHeight-113)];
    myScrollView.pagingEnabled = YES;
    myScrollView.showsHorizontalScrollIndicator = NO;
    myScrollView.showsVerticalScrollIndicator = NO;
    myScrollView.delegate = self;
    myScrollView.pagingEnabled = YES;
    [self.view addSubview:myScrollView];
    
    myScrollView.contentSize = CGSizeMake(DeviceMaxWidth*3, CGRectGetHeight(myScrollView.frame));
    
    sub1ScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, CGRectGetHeight(myScrollView.frame))];
    sub1ScrollView.showsVerticalScrollIndicator = NO;
    sub1ScrollView.showsHorizontalScrollIndicator = NO;
    [myScrollView addSubview:sub1ScrollView];
    
    sub2ScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(DeviceMaxWidth, 0, DeviceMaxWidth, CGRectGetHeight(myScrollView.frame))];
    sub2ScrollView.showsVerticalScrollIndicator = NO;
    sub2ScrollView.showsHorizontalScrollIndicator = NO;
    [myScrollView addSubview:sub2ScrollView];
    
    sub3ScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(DeviceMaxWidth*2, 0, DeviceMaxWidth, CGRectGetHeight(myScrollView.frame))];
    sub3ScrollView.showsVerticalScrollIndicator = NO;
    sub3ScrollView.showsHorizontalScrollIndicator = NO;
    [myScrollView addSubview:sub3ScrollView];
    
    [self sub1Init];
    [self sub2Init];
    [self sub3Init];
}
//mainScrollView.contentSize = CGSizeMake(DeviceMaxWidth, hight+20*frank);
-(void)sub1Init{
    UIWebView *myWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, myScrollView.frame.size.height)];
    myWebView.delegate = self;
    
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"baomingliucheng" ofType:@"html"]]];
    [myWebView loadRequest:urlRequest];
    
    myWebView.scalesPageToFit = YES;        //自动对页面进行缩放以适应屏幕
    [sub1ScrollView addSubview:myWebView];
}

-(void)sub2Init{
    UIWebView *myWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, myScrollView.frame.size.height)];
    myWebView.delegate = self;
    
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"xuecheliucheng" ofType:@"html"]]];
    [myWebView loadRequest:urlRequest];
    myWebView.scalesPageToFit = YES;        //自动对页面进行缩放以适应屏幕
    [sub2ScrollView addSubview:myWebView];
}

-(void)sub3Init{
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, myScrollView.frame.size.height) style:UITableViewStylePlain];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.showsVerticalScrollIndicator = NO;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [sub3ScrollView addSubview:myTableView];
}

- (void)titleBtnEvent:(UIButton *)btn_
{
    if (btn_.selected) {
        return;
    }
    lastBtn.selected = NO;
    
    [UIView animateWithDuration:0.1 animations:^{
        btn_.selected = YES;
        
        myScrollView.contentOffset = CGPointMake(DeviceMaxWidth*(btn_.tag-500), 0);
        
        mainLine.frame = CGRectMake(30*widthRate+DeviceMaxWidth/3*(btn_.tag-500), 112, 50*widthRate, 1);
    }completion:^(BOOL finished) {
        lastBtn = btn_;
        
    }];
}

#pragma mark - UIScollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == myScrollView) {
        NSInteger inde = (NSInteger)scrollView.contentOffset.x/DeviceMaxWidth;
        UIButton * nowBtn = (UIButton *)[self.view viewWithTag:inde+500];
        
        mainLine.frame = CGRectMake(30*widthRate+scrollView.contentOffset.x/3, 112, 50*widthRate, 1);
        lastBtn.selected = NO;
        nowBtn.selected = YES;
        lastBtn = nowBtn;
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return hospitalArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70*widthRate;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * tifier = @"cellName";
    
    FrankHospitalCell *cell = [tableView dequeueReusableCellWithIdentifier:tifier];
    if (cell == nil) {
        cell = [[FrankHospitalCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dic = [hospitalArray objectAtIndex:indexPath.row];
    
    NSString *picture = [dic objectForKey:@"picture"];
    if (![picture isEqualToString:@""]) {
        [lhColor checkImageWithName:picture withUrlStr:[NSString stringWithFormat:@"%@%@",[lhColor shareColor].fileWebUrl,picture] withImgView:cell.headImageV];
    }
    cell.hospitalName.text = [dic objectForKey:@"name"];
    cell.addressName.text = [dic objectForKey:@"location"];
    cell.distance.text = [NSString stringWithFormat:@"%.2fKm",[[dic objectForKey:@"distance"] floatValue]/1000];
//    cell.distance.text = @"1.5Km";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"到这里去");
    NSDictionary *dic = [hospitalArray objectAtIndex:indexPath.row];
    NSString * latiStr = [dic objectForKey:@"latitude"];
    NSString * lotiStr = [dic objectForKey:@"longitude"];
    CLLocationCoordinate2D endLocation = CLLocationCoordinate2DMake([latiStr doubleValue], [lotiStr doubleValue]);
    [lhColor addActivityView123:self.view];
    __weak typeof(self) ws = self;
    [[lhColor shareColor]locationAddress:^(CLLocationCoordinate2D locationCorrrdinate) {
        if (locationCorrrdinate.latitude == DefaultCoordnate.latitude) {
            [lhColor disAppearActivitiView:ws.view];
            [lhColor showAlertWithMessage:@"获取位置失败~" withSuperView:ws.view withHeih:DeviceMaxHeight/2];
            
        }
        else{
            CLLocationCoordinate2D nowLocation = locationCorrrdinate;
            if (nowLocation.longitude != 0) {
                [[lhGPS sharedInstanceGPS]prepareData:ws startLocation:nowLocation endLocation:endLocation];//准备数据
                
                [[lhGPS sharedInstanceGPS]startNaviGPS];//开始导航
            }
            else{
                [lhColor showAlertWithMessage:@"获取定位有误~" withSuperView:ws.view withHeih:DeviceMaxHeight/2];
            }
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - view
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [lhColor assignmentForTempVC:self];
}

@end

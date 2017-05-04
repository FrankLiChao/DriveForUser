//
//  lhPersonalViewController.m
//  Drive
//
//  Created by bosheng on 15/7/27.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import "lhPersonalViewController.h"
#import "lhPCenterFunTableViewCell.h"
#import "lhManagePersonInfoViewController.h"
#import "lhPersonFunDriverTableViewCell.h"
#import "UIImage+ImageEffects.h"

#import "UIImageView+WebCache.h"
#import "FrankMyOrderDetailView.h"
#import "FrankUserSetView.h"
#import "lhAboutUsViewController.h"
//#import "FrankEvaluationView.h"
#import "FrankSchoolDetailView.h"  //驾校详情页面
#import "lhDriverDetailViewController.h"   //教练详情页面
#import "FrankReleasePeiLianView.h"     //发布陪练信息页面
#import "FrankNewsNotice.h"
#import "FrankAppointmentCarView.h"

@interface lhPersonalViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIScrollView * maxScrollView;
    UITableView * pFunTableView;
    NSArray * funArray;//功能
    
    UIImageView * headImgView;
    
    UIImageView * topImgView;
    NSDictionary *personInforDic;
}

@end

@implementation lhPersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    maxScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 100*widthRate+64-DeviceMaxWidth, DeviceMaxWidth, DeviceMaxHeight+DeviceMaxWidth-100*widthRate-64)];
    maxScrollView.backgroundColor = [UIColor whiteColor];
    maxScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:maxScrollView];
    
    personInforDic = [[NSDictionary alloc] init];
    [self firmInit];
    
    [[lhColor shareColor]originalInit:self title:@"个人中心" imageName:nil backButton:YES];
    [self requestPersonInfor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - firmInit
- (void)firmInit
{
    if (self.type == USER_DRIVER) {
        
        funArray =  @[@[@{@"image":@"myStudentImage",@"name":@"我的学员"}],
//                      @[@{@"image":@"studentApoint",@"name":@"学员练车预约"},
//                        @{@"image":@"SimulationField",@"name":@"模拟场地预约"}],
                      @[@{@"image":@"publishMessage",@"name":@"我发布的陪练信息"},
                        @{@"image":@"Admissions",@"name":@"我发布的招生信息"}
                        ],
                      @[@{@"image":@"personalfunImg3",@"name":@"设置"},
//                        @{@"image":@"personalfunImg4",@"name":@"关于我们"}
                        ]];
         /*
        funArray =  @[@{@"image":@"myStudentImage",@"name":@"我的学员"},
                      @{@"image":@"personalfunImg1",@"name":@"学员练车预约"},
                      @{@"image":@"personalfunImg2",@"name":@"模拟场地预约"},
                      @{@"image":@"personalfunImg3",@"name":@"我发布的陪练信息"},
                      @{@"image":@"personalfunImg4",@"name":@"我发布的招生信息"},
                      @{@"image":@"personalfunImg4",@"name":@"我发布的团购信息"},
                      @{@"image":@"personalfunImg3",@"name":@"设置"},
                      @{@"image":@"personalfunImg4",@"name":@"关于我们"}];
            */
    }
    else{
        funArray =  @[@[@{@"image":@"appointForTest",@"name":@"预约练车"},
                        @{@"image":@"timeForPractice",@"name":@"计时学车"},
                        @{@"image":@"practiceTogether",@"name":@"预约陪练"}],
                      @[@{@"image":@"personalfunImg1",@"name":@"我的驾校"},
                        @{@"image":@"personalfunImg2",@"name":@"我的教练"}],
                      @[@{@"image":@"personalfunImg3",@"name":@"设置"},
//                        @{@"image":@"personalfunImg4",@"name":@"关于我们"}
                        ]];
    }
    
    topImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, DeviceMaxWidth)];
    topImgView.image = imageWithName(@"personalCenter");
    [maxScrollView addSubview:topImgView];
    
    if (IOS8) {
        //  创建需要的毛玻璃特效类型
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        //  毛玻璃view 视图
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        //添加到要有毛玻璃特效的控件中
        effectView.frame = topImgView.frame;
        [topImgView addSubview:effectView];
        //设置模糊透明度
    }
    
    CGFloat heih = DeviceMaxWidth;
    UITapGestureRecognizer * tapG = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGEvent)];
    headImgView = [[UIImageView alloc]initWithFrame:CGRectMake(18*widthRate, heih-34*widthRate, 68*widthRate, 68*widthRate)];
    headImgView.image = imageWithName(@"defaultHead");
    headImgView.userInteractionEnabled = YES;
    [headImgView addGestureRecognizer:tapG];
//    headImgView.backgroundColor = [UIColor whiteColor];
    headImgView.layer.cornerRadius = 34*widthRate;
    headImgView.layer.masksToBounds = YES;
    [maxScrollView addSubview:headImgView];
    
    NSString * headStr = [NSString stringWithFormat:@"%@",[[lhColor shareColor].userInfo objectForKey:@"photo"]];
    NSString * headUrlStr = [NSString stringWithFormat:@"%@%@",[lhColor shareColor].fileWebUrl,headStr];
    headStr = [headStr stringByReplacingOccurrencesOfString:@"" withString:@""];
    NSLog(@"headStr = %@",headStr);
    
    if ([[lhColor shareColor] isImageWithName:headStr]) {//图片存在
        headImgView.image = [[lhColor shareColor] readImageWithNameOther:headStr];
        if(headStr && headStr.length > 0){
            topImgView.image = [self effectImage:headImgView.image];
        }
        else{
            headImgView.image = imageWithName(@"defaultHead");
            topImgView.image = [self effectImage:imageWithName(@"personalCenter")];
        }
    }
    else{
        __block UIImageView * tempTopImg = topImgView;
        __block UIImageView * tempheadImg = headImgView;
        __block lhPersonalViewController * tempS = self;
        [headImgView setImageWithURL:[NSURL URLWithString:headUrlStr]completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            if (image) {
                if(headStr && headStr.length > 0){
                    tempTopImg.image = [tempS effectImage:image];
                }
                else{
                    tempTopImg.image = [tempS effectImage:imageWithName(@"personalCenter")];
                    tempheadImg.image = imageWithName(@"defaultHead"); //morenhead
                }
                [[lhColor shareColor]saveImagesOther:image withName:headStr];
            }
        }];
    }
//    if (![headStr isEqualToString:@""]) {
//        [lhColor checkImageWithName:headStr withUrlStr:headUrlStr withImgView:headImgView withPlaceHolder:imageWithName(@"defaultHead")];
//        topImgView.image = [self effectImage:headImgView.image];
//    }else{
//        headImgView.image = imageWithName(@"defaultHead");
//        topImgView.image = [self effectImage:imageWithName(@"personalCenter")];
//    }
    UILabel * nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(100*widthRate, heih-30*widthRate, DeviceMaxWidth-130*widthRate, 25*widthRate)];
    nameLabel.text = [NSString stringWithFormat:@"%@",[[lhColor shareColor].userInfo objectForKey:@"name"]];
    nameLabel.font = [UIFont fontWithName:fontName size:15];
    nameLabel.font = [UIFont boldSystemFontOfSize:15];
    nameLabel.textColor = [UIColor whiteColor];
    [maxScrollView addSubview:nameLabel];
    
    UIImageView * myOrderImg = [[UIImageView alloc]initWithFrame:CGRectMake(132.5*widthRate, heih+7*widthRate, 24*widthRate, 24*widthRate)];
    myOrderImg.image = imageWithName(@"personalMyOrder");
    [maxScrollView addSubview:myOrderImg];
    
    NSString * myOrderStr = @"我的订单";
    UILabel * myOrderLabel = [[UILabel alloc]initWithFrame:CGRectMake(86*widthRate, heih+30*widthRate , 234*widthRate/2, 25*widthRate)];
    myOrderLabel.textAlignment = NSTextAlignmentCenter;
    myOrderLabel.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
    myOrderLabel.text = myOrderStr;
    myOrderLabel.font = [UIFont fontWithName:fontName size:15];
    [maxScrollView addSubview:myOrderLabel];
    
    UIButton *myOrder = [UIButton buttonWithType:UIButtonTypeCustom];
    myOrder.frame = CGRectMake(86*widthRate, heih+7*widthRate, 234*widthRate/2-10*widthRate, 45*widthRate);
    [myOrder addTarget:self action:@selector(clickMyOrderBtn) forControlEvents:UIControlEventTouchUpInside];
    [maxScrollView addSubview:myOrder];
    
    
    UIView * lineV = [[UIView alloc]initWithFrame:CGRectMake(86*widthRate+234*widthRate/2-0.25, heih+8*widthRate, 0.5, 44*widthRate)];
    lineV.backgroundColor = [lhColor colorFromHexRGB:viewColorStr];
    [maxScrollView addSubview:lineV];
    
    UIImageView * myOrderImg1 = [[UIImageView alloc]initWithFrame:CGRectMake(249.5*widthRate, heih+7*widthRate, 24*widthRate, 24*widthRate)];
    myOrderImg1.image = imageWithName(@"personalNoti");
    [maxScrollView addSubview:myOrderImg1];
    
    NSString * numStr = @"36";
    CGRect rec = myOrderImg1.frame;
    rec.origin.x += rec.size.width-7*widthRate;

    rec.size.height = 16;
    rec.size.width = 16;
    if (numStr.integerValue >= 10) {
        rec.size.width = 24;
        if (numStr.integerValue >= 100) {
            numStr = @"99+";
        }
    }
    UILabel * redPoint = [[UILabel alloc]initWithFrame:rec];
    redPoint.layer.masksToBounds = YES;
    redPoint.textColor = [UIColor whiteColor];
    redPoint.textAlignment = NSTextAlignmentCenter;
//    redPoint.backgroundColor = [UIColor colorWithRed:202.0/255 green:32.0/255 blue:38.0/255 alpha:1];
    redPoint.backgroundColor = [UIColor redColor];
    redPoint.layer.cornerRadius = 8;
    redPoint.font = [UIFont boldSystemFontOfSize:10];
    redPoint.text = numStr;
//    [maxScrollView addSubview:redPoint];
    
    UILabel * myOrderLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(203*widthRate, heih+30*widthRate , 234*widthRate/2, 25*widthRate)];
    myOrderLabel1.text = @"消息通知";
    myOrderLabel1.textAlignment = NSTextAlignmentCenter;
    myOrderLabel1.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
    myOrderLabel1.font = [UIFont fontWithName:fontName size:15];
    [maxScrollView addSubview:myOrderLabel1];
    
    UIButton *myNewNotice = [UIButton buttonWithType:UIButtonTypeCustom];
    myNewNotice.frame = CGRectMake(203*widthRate, heih, 234*widthRate/2, 60*widthRate);
    [myNewNotice addTarget:self action:@selector(clickmyNewNotice) forControlEvents:UIControlEventTouchUpInside];
    [maxScrollView addSubview:myNewNotice];
    
    heih += 60*widthRate;
    
    pFunTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, heih, DeviceMaxWidth, self.type==USER_DRIVER?340*widthRate:295*widthRate)];
    pFunTableView.scrollEnabled = NO;
    pFunTableView.backgroundColor = [UIColor clearColor];
    pFunTableView.separatorColor = [UIColor clearColor];
    pFunTableView.delegate = self;
    pFunTableView.dataSource = self;
    [maxScrollView addSubview:pFunTableView];
    
    heih += 10*widthRate+pFunTableView.frame.size.height;
    
    if (heih > maxScrollView.frame.size.height+5) {
        maxScrollView.contentSize = CGSizeMake(DeviceMaxWidth, heih);
    }
    else{
        maxScrollView.contentSize = CGSizeMake(DeviceMaxWidth, maxScrollView.frame.size.height+5);
    }
    
}

#pragma mark - 请求个人信息
-(void)requestPersonInfor
{
    NSString * idStr = [NSString stringWithFormat:@"%@",[[lhColor shareColor].userInfo objectForKey:@"id"]];
    NSDictionary * dic = @{@"id":idStr};
    
    [FrankNetworkManager postReqeustWithURL:PATH(@"user/studentIndex") params:dic successBlock:^(id returnData){
        if ([[returnData objectForKey:@"status"]integerValue] == 1) {
            personInforDic = [returnData objectForKey:@"data"];
            if ([personInforDic count]) {
                [pFunTableView reloadData];
            }
        }else{
            [FrankTools requestFailAlertShow:[returnData objectForKey:@"msg"]];
        }
    } failureBlock:^(NSError *error) {
        FLLog(@"%@",error.localizedDescription);
        [FrankTools wangluoAlertShow];
    } showHUD:NO];
}

-(void)clickmyNewNotice{
    FrankNewsNotice *newsNotice = [[FrankNewsNotice alloc] init];
    [self.navigationController pushViewController:newsNotice animated:YES];
}

//模糊图片
- (UIImage *)effectImage:(UIImage *)image
{
    UIImage * tempImg = nil;
    if (IOS8) {
        tempImg = image;
        topImgView.image = tempImg;
    }else{
        UIImage * maxImg = [lhColor imageWithImage:image scaledToSize:topImgView.frame.size];
        tempImg = [maxImg blurredImageWithRadius:50 iterations:1 tintColor:nil convertSize:topImgView.frame.size];
    }
    
    return tempImg;
}

#pragma mark - 
- (void)tapGEvent
{
    NSLog(@"点击个人管理");
    
    lhManagePersonInfoViewController * mpiVC = [[lhManagePersonInfoViewController alloc]init];
    mpiVC.headImg = headImgView.image;
    [self.navigationController pushViewController:mpiVC animated:YES];
    
}

-(void)clickMyOrderBtn{
    FrankMyOrderDetailView *myOrderDetail = [[FrankMyOrderDetailView alloc] init];
    [self.navigationController pushViewController:myOrderDetail animated:YES];
}

#pragma mark - UITabelViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:{
            if (indexPath.row == 0) {
                FrankAppointmentCarView *appointment = [[FrankAppointmentCarView alloc] init];
                appointment.coachName = [personInforDic objectForKey:@"coachName"];
                [self.navigationController pushViewController:appointment animated:YES];
            }else{
                UIAlertView *AlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"开发中，敬请期待~" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [AlertView show];
            }
            break;
        }
        case 1:{
            if (indexPath.row == 0){
                NSString *schId = [personInforDic objectForKey:@"schoolId"];
                NSLog(@"schId = %@",schId);
                if ([schId isEqualToString:@""] || schId == nil) {
                    UIAlertView *AlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"暂无驾校信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [AlertView show];
                }else{
                    FrankSchoolDetailView *schoolDetail = [[FrankSchoolDetailView alloc] init];
                    schoolDetail.schoolID = [personInforDic objectForKey:@"schoolId"];
                    [self.navigationController pushViewController:schoolDetail animated:YES];
                }
            }else if (indexPath.row == 1){
                NSString *coachId = [personInforDic objectForKey:@"coachId"];
                if ([coachId isEqualToString:@""] || coachId == nil) {
                    UIAlertView *AlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"暂无教练信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [AlertView show];
                }else{
                    lhDriverDetailViewController *coachDetail = [[lhDriverDetailViewController alloc] init];
                    coachDetail.coachID = [personInforDic objectForKey:@"coachId"];
                    [self.navigationController pushViewController:coachDetail animated:YES];
                }
            }
            break;
        }
        case 2:{
            if (indexPath.row == 0) {
                FrankUserSetView *userSet = [[FrankUserSetView alloc] init];
                [self.navigationController pushViewController:userSet animated:YES];
            }
            //                else if(indexPath.row == 1){
            //                    NSLog(@"点击关于我们");
            //                    lhAboutUsViewController *aboutUs = [[lhAboutUsViewController alloc] init];
            //                    [self.navigationController pushViewController:aboutUs animated:YES];
            //                }
            else if(indexPath.row == 2){
                
            }
            
            break;
        }
        case 3:{
            
            break;
        }
        default:
            break;
    }
    
    
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40*widthRate;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.type == USER_DRIVER) {
        if (section == 0) {
            return 1;
        }
//        else if(section == 1){
//            return 0;
//        }
        else if(section == 1){
            return 2;
        }
        else if(section == 2){
            return 1;
        }
        
    }
    else{
        if (section == 0) {
            return 3;
        }
        else if(section == 1){
            return 2;
        }
        else if(section == 2){
            return 1;
        }

    }
    
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.type == USER_DRIVER) {
        
        return 3;
    }
    else{
        return 3;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return 5*widthRate;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * hView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 5*widthRate)];
    hView.backgroundColor = [lhColor colorFromHexRGB:viewColorStr];
    return hView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type == USER_DRIVER) {
        static NSString * indentifier = @"dFunCell";
        lhPCenterFunTableViewCell * funCell = [tableView dequeueReusableCellWithIdentifier:indentifier];
        if (funCell == nil) {
            funCell = [[lhPCenterFunTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        }
        
        funCell.titLabel.text = [[[funArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"name"];
        funCell.headImgView.image = imageWithName([[[funArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"image"]);
        funCell.lowline.hidden = NO;
        return funCell;
    }
    else{
        static NSString * indentifier = @"funCell";
        lhPCenterFunTableViewCell * funCell = [tableView dequeueReusableCellWithIdentifier:indentifier];
        if (funCell == nil) {
            funCell = [[lhPCenterFunTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        }
        
        if (indexPath.section == 0) {
            funCell.titLabel.text = [[[funArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"name"];
            funCell.headImgView.image = imageWithName([[[funArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"image"]);
            if (indexPath.row == 0) {
                UIView *rowLine = [[UIView alloc] initWithFrame:CGRectMake(20*widthRate, 425*widthRate, DeviceMaxWidth-40*widthRate, 0.5)];
                rowLine.backgroundColor = [lhColor colorFromHexRGB:viewColorStr];
                [maxScrollView addSubview:rowLine];
            }else if (indexPath.row == 1){
                UIView *rowLine = [[UIView alloc] initWithFrame:CGRectMake(20*widthRate, 465*widthRate, DeviceMaxWidth-40*widthRate, 0.5)];
                rowLine.backgroundColor = [lhColor colorFromHexRGB:viewColorStr];
                [maxScrollView addSubview:rowLine];
            }
        }
        if (indexPath.section == 1) {
            funCell.titLabel.text = [[[funArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"name"];
            funCell.headImgView.image = imageWithName([[[funArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"image"]);
            if (indexPath.row == 0) {
                funCell.lowline0.hidden = NO;
                funCell.contentLabel.text = @"交大驾校";
                if ([personInforDic count]) {
                    funCell.contentLabel.text = [personInforDic objectForKey:@"schoolName"];
                }
            }
            else{
                funCell.contentLabel.text = @"杨小宝";
                if ([personInforDic count]) {
                    funCell.contentLabel.text = [personInforDic objectForKey:@"coachName"];
                }
            }
        }
        else if(indexPath.section == 2){
            funCell.titLabel.text = [[[funArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"name"];
            funCell.headImgView.image = imageWithName([[[funArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"image"]);
            if (indexPath.row == 0) {
                funCell.lowline0.hidden = NO;
            }
            else{
                funCell.lowline.hidden = NO;
            }
        }
        
        return funCell;
    }
    
    return nil;
}

#pragma mark - view
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [lhColor assignmentForTempVC:self];
    
    if(maxScrollView){
        for (UIView * view in maxScrollView.subviews) {
            [view removeFromSuperview];
        }
    }
    
    [self firmInit];
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

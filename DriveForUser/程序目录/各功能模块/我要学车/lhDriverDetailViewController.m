//
//  lhDriverDetailViewController.m
//  Drive
//
//  Created by bosheng on 15/7/28.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import "lhDriverDetailViewController.h"
#import "lhDiscussTableViewCell.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "FrankGradeCell.h"

@interface lhDriverDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * discussTableView; //评价列表
    NSArray *nameArray;             //评价的学员名字
    NSArray *contentArray;          //评价的内容
    UITableView *classTypeTab;  //班型表格
    NSArray *classTypeArray;    //表示班型的数据
}
@end

@implementation lhDriverDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[lhColor shareColor]originalInit:self title:@"教练详情" imageName:nil backButton:YES];
    
    [self requestDataForCoach];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)requestDataForCoach{
    [lhColor addActivityView123:self.view];
    NSDictionary *dic = @{@"id":self.coachID};
    
    [FrankNetworkManager postReqeustWithURL:PATH(@"driving/coach") params:dic successBlock:^(id returnData){
        [lhColor disAppearActivitiView:self.view];
        if ([[returnData objectForKey:@"status"]integerValue] == 1) {
            dicData = [returnData objectForKey:@"data"];
            classTypeArray = [dicData objectForKey:@"requirements"];
            if (!dicData || dicData.count == 0) {
                return;
            }
            [self firmInit];
            NSString *string1 = [NSString stringWithFormat:@"%@%@",[lhColor shareColor].fileWebUrl, [dicData objectForKey:@"photo"]];
            [lhColor checkImageWithName:[dicData objectForKey:@"photo"] withUrlStr:string1 withImgView:pictureForCar withPlaceHolder:imageWithName(placeHolderImg)];
            NSArray  * array= [[dicData objectForKey:@"spacePicture"] componentsSeparatedByString:@"|"];
            NSInteger count = [array count];
            if (count>3) {
                count = 3;
            }
            NSArray *viewWithArry = @[pictureForSite1,pictureForSite2,pictureForSite3];
            for (int i=0; i<count; i++) {
                NSString *str = [NSString stringWithFormat:@"%@%@",[lhColor shareColor].fileWebUrl, array[i]];
                NSLog(@"str = %@",str);
                [lhColor checkImageWithName:array[i] withUrlStr:str withImgView:viewWithArry[i]];
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

- (void)firmInit
{
    UIScrollView *myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, DeviceMaxWidth, DeviceMaxHeight-64)];
    myScrollView.showsHorizontalScrollIndicator = NO;
    myScrollView.showsVerticalScrollIndicator = NO;
    myScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:myScrollView];
    
    CGFloat hight = 0;
    
    UIView * topWhiteView = [[UIView alloc]initWithFrame:CGRectMake(0, hight, DeviceMaxWidth, 102*widthRate)];
    topWhiteView.backgroundColor = [UIColor whiteColor];
    [myScrollView addSubview:topWhiteView];
    
    hight += 14*widthRate;
    
    hImgView = [[UIImageView alloc]initWithFrame:CGRectMake(20*widthRate, hight, 66*widthRate, 66*widthRate)];
    hImgView.image = imageWithName(@"default_header_icon");
    [topWhiteView addSubview:hImgView];
    
    NSString *photoStr = [NSString stringWithFormat:@"%@%@",[lhColor shareColor].fileWebUrl, [dicData objectForKey:@"photo"]];
    if (![[dicData objectForKey:@"photo"] isEqualToString:@""]) {
        [lhColor checkImageWithName:[dicData objectForKey:@"photo"] withUrlStr:photoStr withImgView:hImgView];
    }
    
    lineView = [[UIView alloc]initWithFrame:CGRectMake(106*widthRate, hight, 0.5, 66*widthRate)];
    lineView.backgroundColor = [lhColor colorFromHexRGB:viewColorStr];
    [topWhiteView addSubview:lineView];
    
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(119*widthRate, hight, 50*widthRate, 17*widthRate)];
    nameLabel.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
    nameLabel.font = [UIFont fontWithName:fontName size:15];
    nameLabel.text = [dicData objectForKey:@"coachName"];
    [topWhiteView addSubview:nameLabel];
    
    starImgView = [[TQStarRatingView alloc]initWithFrame:CGRectMake(185*widthRate, hight, 100*widthRate, 16*widthRate) numberOfStar:5 distance:5*widthRate HeiDistance:0];
    starImgView.number = 5;
    starImgView.userInteractionEnabled = NO;
    if ([[dicData objectForKey:@"score"] isEqualToString:@""]) {
        starImgView.number = 5;
    }else{
        starImgView.number = [[dicData objectForKey:@"score"] doubleValue];
    }
    
    [topWhiteView addSubview:starImgView];
    
    hight += 26*widthRate;
    
    schoolName = [[UILabel alloc] initWithFrame:CGRectMake(119*widthRate, hight, 180*widthRate, 17*widthRate)];
    schoolName.textColor = [lhColor colorFromHexRGB:contentTitleColorStr1];
    schoolName.font = [UIFont fontWithName:fontName size:13];
    schoolName.text = [NSString stringWithFormat:@"驾校 : %@",[dicData objectForKey:@"schoolName"]];
    [topWhiteView addSubview:schoolName];
    
    hight += 23*widthRate;
    
    alLabel = [[UILabel alloc]initWithFrame:CGRectMake(208*widthRate, hight, 89*widthRate, 17*widthRate)];
    alLabel.textColor = [lhColor colorFromHexRGB:contentTitleColorStr1];
    alLabel.font = [UIFont fontWithName:fontName size:13];
    alLabel.text = [NSString stringWithFormat:@"学员数量 : %@",[dicData objectForKey:@"studentCount"]];
    [topWhiteView addSubview:alLabel];
    
    dAgeLabel = [[UILabel alloc]initWithFrame:CGRectMake(119*widthRate, hight, 89*widthRate, 17*widthRate)];
    dAgeLabel.textColor = [lhColor colorFromHexRGB:contentTitleColorStr1];
    dAgeLabel.font = [UIFont fontWithName:fontName size:13];
    dAgeLabel.text = [NSString stringWithFormat:@"教龄 : %@",[dicData objectForKey:@"teachAge"]];
    [topWhiteView addSubview:dAgeLabel];

    hight = 95*widthRate+7*widthRate;
    
    UIView *lineG = [[UIView alloc] initWithFrame:CGRectMake(0, hight-7*widthRate, DeviceMaxWidth, 7*widthRate)];
    lineG.backgroundColor = [lhColor colorFromHexRGB:viewColorStr];
    [myScrollView addSubview:lineG];
    
    UIView *backgroundViewOne = [[UIView alloc] initWithFrame:CGRectMake(0, hight, DeviceMaxWidth, 40*widthRate)];
    backgroundViewOne.backgroundColor = [UIColor whiteColor];
    [myScrollView addSubview:backgroundViewOne];
    
    UIImageView *phoneView = [[UIImageView alloc] initWithFrame:CGRectMake(10*widthRate, 9*widthRate, 20*widthRate, 20*widthRate)];
    [phoneView setImage:[UIImage imageNamed:@"contactUs"]];
    [backgroundViewOne addSubview:phoneView];
    
    UILabel * schoolPhone = [[UILabel alloc] initWithFrame:CGRectMake(35*widthRate, 10*widthRate, 100*widthRate, 20*widthRate)];
    schoolPhone.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
    schoolPhone.text = [NSString stringWithFormat:@"%@",[dicData objectForKey:@"phone"]];
    schoolPhone.font = [UIFont systemFontOfSize:14];
    [backgroundViewOne addSubview:schoolPhone];
    
    UIButton *contactSch = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    contactSch.tag = 1;
    contactSch.frame = CGRectMake(DeviceMaxWidth-80*widthRate, 8*widthRate, 70*widthRate, 24*widthRate);
    contactSch.titleLabel.font = [UIFont fontWithName:fontName size:14];
    [contactSch setTitle:@"联系教练" forState:UIControlStateNormal];
    [contactSch setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [contactSch setBackgroundImage:imageWithName(@"contactDraiver") forState:UIControlStateNormal];
    contactSch.backgroundColor = [lhColor colorFromHexRGB:mainColorStr];
    contactSch.layer.cornerRadius = 12*widthRate;
    contactSch.layer.masksToBounds = YES;
    [contactSch addTarget:self action:@selector(contactBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    [backgroundViewOne addSubview:contactSch];
    
    hight += 47*widthRate;
    
    UIView *lineG1 = [[UIView alloc] initWithFrame:CGRectMake(0, hight-7*widthRate, DeviceMaxWidth, 7*widthRate)];
    lineG1.backgroundColor = [lhColor colorFromHexRGB:viewColorStr];
    [myScrollView addSubview:lineG1];
    
    classTypeTab = [[UITableView alloc] initWithFrame:CGRectMake(0, hight, DeviceMaxWidth, 40*widthRate*[classTypeArray count]+30*widthRate) style:UITableViewStylePlain];
    classTypeTab.delegate = self;
    classTypeTab.dataSource = self;
    classTypeTab.showsHorizontalScrollIndicator = NO;
    classTypeTab.showsVerticalScrollIndicator = NO;
    classTypeTab.scrollEnabled = NO;
    classTypeTab.separatorStyle = UITableViewCellSeparatorStyleNone;
    [myScrollView addSubview:classTypeTab];
    
    hight += classTypeTab.frame.size.height;
    
    UIView *lineGd = [[UIView alloc] initWithFrame:CGRectMake(0, hight, DeviceMaxWidth, 7*widthRate)];
    lineGd.backgroundColor = [lhColor colorFromHexRGB:viewColorStr];
    [myScrollView addSubview:lineGd];
    
    hight += 7*widthRate;
    
    UIView * inView = [[UIView alloc]initWithFrame:CGRectMake(0, hight, DeviceMaxWidth, 100)];
    inView.backgroundColor = [UIColor whiteColor];
    [myScrollView addSubview:inView];
    
    UILabel * inTLabel = [[UILabel alloc]initWithFrame:CGRectMake(10*widthRate, 8*widthRate, DeviceMaxWidth-20*widthRate, 20*widthRate)];
    inTLabel.text = @"教练简介";
    inTLabel.font = [UIFont boldSystemFontOfSize:15];
    inTLabel.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
    [inView addSubview:inTLabel];
    
    UIView * lineView11 = [[UIView alloc]initWithFrame:CGRectMake(0, 30*widthRate-0.5, DeviceMaxWidth, 0.5)];
    lineView11.backgroundColor = [lhColor colorFromHexRGB:viewColorStr];
    [inView addSubview:lineView11];
    
    NSString * str = [NSString stringWithFormat:@"%@",[dicData objectForKey:@"remark"]];
    if ([str isEqualToString:@""]) {
        str = @"暂无简介";
    }
    NSMutableAttributedString * as = [[NSMutableAttributedString alloc]initWithString:str];
    NSMutableParagraphStyle * ps = [[NSMutableParagraphStyle alloc]init];
    [ps setLineSpacing:6];
    [as addAttribute:NSParagraphStyleAttributeName value:ps range:NSMakeRange(0, str.length)];
    UILabel * inCLabel = [[UILabel alloc]initWithFrame:CGRectMake(10*widthRate, 30*widthRate, DeviceMaxWidth-20*widthRate, 20*widthRate)];
    inCLabel.attributedText = as;
    inCLabel.font = [UIFont fontWithName:fontName size:14];
    inCLabel.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
    [inCLabel sizeToFit];
    [inView addSubview:inCLabel];
    
    CGRect cRec = inCLabel.frame;
    cRec.size.height += 10*widthRate;
    inCLabel.frame = cRec;
    
    CGRect rec = inView.frame;
    rec.size.height = 30*widthRate+CGRectGetHeight(inCLabel.frame);
    inView.frame = rec;
    
    hight += rec.size.height+7*widthRate;
    
    UIView *lineG0 = [[UIView alloc] initWithFrame:CGRectMake(0, hight-7*widthRate, DeviceMaxWidth, 7*widthRate)];
    lineG0.backgroundColor = [lhColor colorFromHexRGB:viewColorStr];
    [myScrollView addSubview:lineG0];
    
    UIView *pictureView = [[UIView alloc] initWithFrame:CGRectMake(0, hight, DeviceMaxWidth, 120*widthRate)];
    pictureView.backgroundColor = [UIColor whiteColor];
    [myScrollView addSubview:pictureView];
    
    UILabel * inTLabel00 = [[UILabel alloc]initWithFrame:CGRectMake(10*widthRate, 8*widthRate, DeviceMaxWidth-20*widthRate, 20*widthRate)];
    inTLabel00.text = @"训练场地";
    inTLabel00.font = [UIFont boldSystemFontOfSize:15];
    inTLabel00.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
    [pictureView addSubview:inTLabel00];
    
    UIView * lineView12 = [[UIView alloc]initWithFrame:CGRectMake(0, 30*widthRate-0.5, DeviceMaxWidth, 0.5)];
    lineView12.backgroundColor = [lhColor colorFromHexRGB:viewColorStr];
    [pictureView addSubview:lineView12];
    
    pictureForSite1 = [[UIImageView alloc] initWithFrame:CGRectMake(10*widthRate, 40*widthRate, 280*widthRate/3, 80*widthRate)];
//    pictureForSite1.backgroundColor = [UIColor grayColor];
    [pictureView addSubview:pictureForSite1];
    
    pictureForSite2 = [[UIImageView alloc] initWithFrame:CGRectMake(280*widthRate/3+20*widthRate, 40*widthRate, 280*widthRate/3, 80*widthRate)];
//    pictureForSite2.backgroundColor = [UIColor grayColor];
    [pictureView addSubview:pictureForSite2];

    pictureForSite3 = [[UIImageView alloc] initWithFrame:CGRectMake(280*widthRate/3*2+30*widthRate, 40*widthRate, 280*widthRate/3, 80*widthRate)];
//    pictureForSite3.backgroundColor = [UIColor grayColor];
    [pictureView addSubview:pictureForSite3];
    
    hight += 130*widthRate;
    
    UIView *lineH = [[UIView alloc] initWithFrame:CGRectMake(0, hight, DeviceMaxWidth, 7*widthRate)];
    lineH.backgroundColor = [lhColor colorFromHexRGB:viewColorStr];
    [myScrollView addSubview:lineH];
    
    hight += 7*widthRate;
    
//    UIView *lineK = [[UIView alloc] initWithFrame:CGRectMake(0, hight+10*widthRate, DeviceMaxWidth, 5*widthRate)];
//    lineK.backgroundColor = [lhColor colorFromHexRGB:viewColorStr];
//    [myScrollView addSubview:lineK];
    
    UIView * tView = [[UIView alloc]initWithFrame:CGRectMake(0, hight, DeviceMaxWidth, DeviceMaxHeight-hight)];
    tView.backgroundColor = [UIColor whiteColor];
    [myScrollView addSubview:tView];
    
    UILabel * tLabel = [[UILabel alloc]initWithFrame:CGRectMake(10*widthRate, 8*widthRate, DeviceMaxWidth-20*widthRate, 30*widthRate)];
    tLabel.text = @"详情评价";
    tLabel.font = [UIFont systemFontOfSize:15];
    tLabel.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
    [tView addSubview:tLabel];
    
    UIView * lineV = [[UIView alloc]initWithFrame:CGRectMake(0, 35*widthRate, DeviceMaxWidth, 0.5)];
    lineV.backgroundColor = [lhColor colorFromHexRGB:viewColorStr];
    [tView addSubview:lineV];
    
    CGFloat heih2 = 35*widthRate+0.5;
    hight += heih2;
    
    discussTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, heih2, DeviceMaxWidth, 80*widthRate*2) style:UITableViewStylePlain];
    discussTableView.delegate = self;
    discussTableView.dataSource = self;
    discussTableView.scrollEnabled = NO;
    discussTableView.separatorColor = [UIColor clearColor];
    discussTableView.backgroundColor = [UIColor clearColor];
    [tView addSubview:discussTableView];
    
    nameArray = @[@"一点通",@"优品学车"];
    contentArray = @[@"教学时间长，经验丰富，认真负责，让学员轻松拿到证",@"有着丰富的驾训经验，教学细致耐心，学员满意度高"];
    
    hight += 160*widthRate + 30*widthRate;
    
    [discussTableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    
//    UIButton * contactBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    contactBtn.frame = CGRectMake(20*widthRate, hight, DeviceMaxWidth-40*widthRate, 30*widthRate);
//    contactBtn.titleLabel.font = [UIFont fontWithName:fontName size:15];
//    [contactBtn setTitle:@"我要报名" forState:UIControlStateNormal];
//    [contactBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [contactBtn setBackgroundImage:imageWithName(@"contactDraiver") forState:UIControlStateNormal];
//    contactBtn.layer.cornerRadius = 4;
//    contactBtn.layer.masksToBounds = YES;
//    [contactBtn addTarget:self action:@selector(contactBtnEvent) forControlEvents:UIControlEventTouchUpInside];
//    [myScrollView addSubview:contactBtn];
    
    hight+= 20*widthRate;
    
    myScrollView.contentSize = CGSizeMake(DeviceMaxWidth, hight);
}

#pragma mark - 联系教练
- (void)contactBtnEvent
{
    NSLog(@"联系教练拨打电话");
    if (dicData && dicData.count) {
        [[lhColor shareColor]detailPhone:[dicData objectForKey:@"phone"]];
    }
    
}

#pragma mark - 
- (void)headerRefresh
{
    [discussTableView headerEndRefreshing];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == classTypeTab) {
        return 30*widthRate;
    }else{
        return 0;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == classTypeTab) {
        UIView * hdView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 30*widthRate)];
        UILabel *headLable = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, 8*widthRate, 100*widthRate, 20*widthRate)];
        headLable.text = @"班型";
        headLable.font = [UIFont boldSystemFontOfSize:15];
        headLable.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
        [hdView addSubview:headLable];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 30*widthRate, DeviceMaxWidth, 0.5)];
        line.backgroundColor = [lhColor colorFromHexRGB:viewColorStr];
        [hdView addSubview:line];
        return hdView;
    }else{
        return nil;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == discussTableView) {
        return 2;
    }else if (tableView == classTypeTab){
        return [classTypeArray count];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == discussTableView) {
        return 80.0*widthRate;
    }else if (tableView == classTypeTab){
        return 40*widthRate;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == discussTableView) {
        static NSString * indentifier = @"disCell";
        lhDiscussTableViewCell * dtvCell = [tableView dequeueReusableCellWithIdentifier:indentifier];
        if (dtvCell == nil) {
            dtvCell = [[lhDiscussTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        }
        dtvCell.idLabel.text = nameArray[indexPath.row];
        dtvCell.contentLabel.text = contentArray[indexPath.row];
        return dtvCell;
    }else if (tableView == classTypeTab){
        static NSString * indentifier = @"fCell";
        FrankGradeCell * fCell = [tableView dequeueReusableCellWithIdentifier:indentifier];
        if (fCell == nil) {
            fCell = [[FrankGradeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        }
        fCell.selectionStyle = UITableViewCellSelectionStyleNone;
        fCell.nameLable.text = [NSString stringWithFormat:@"%@: %@",[classTypeArray[indexPath.row] objectForKey:@"drivingLicenseType"],[classTypeArray[indexPath.row] objectForKey:@"classType"]];
        fCell.priceLable.text = [NSString stringWithFormat:@"￥ %@",[classTypeArray[indexPath.row] objectForKey:@"price"]];
        return fCell;
    }
    return nil;
}

#pragma mark - view
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [lhColor assignmentForTempVC:self];
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

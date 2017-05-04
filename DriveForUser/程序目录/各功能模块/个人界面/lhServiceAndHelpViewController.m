//
//  lhServiceAndHelpViewController.m
//  GasStation
//
//  Created by bosheng on 16/2/3.
//  Copyright © 2016年 bosheng. All rights reserved.
//

#import "lhServiceAndHelpViewController.h"
#import "lhSettingTableViewCell.h"
#import "lhQuestionTypeTableViewCell.h"
#import "lhQuestionListViewController.h"
#import "lhQuestionDetailViewController.h"

@interface lhServiceAndHelpViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIScrollView * maxScrollView;
    
    UITableView * qTableView;
    NSArray * qArray;
    
    UITableView * typeTableView;
    NSArray * typeArray;
}

@end

@implementation lhServiceAndHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[lhColor shareColor]originalInit:self title:@"客服与帮助" imageName:nil backButton:YES];
    [lhColor addActivityView123:self.view];
    NSDictionary * dic = @{@"id":[[lhColor shareColor].userInfo objectForKey:@"id"]};
    
    [FrankNetworkManager postReqeustWithURL:PATH(@"help") params:dic successBlock:^(id returnData){
        [lhColor disAppearActivitiView:self.view];
        if ([[returnData objectForKey:@"status"]integerValue] == 1) {
            qArray = [[returnData objectForKey:@"data"]objectForKey:@"hotspots"];
            typeArray = [[returnData objectForKey:@"data"]objectForKey:@"categories"];
            [self firmInit];
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
}

#pragma mark - firmInit
- (void)firmInit
{
    maxScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, DeviceMaxWidth, DeviceMaxHeight-64)];
    maxScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:maxScrollView];
    
    qTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 30*widthRate+40*widthRate*qArray.count) style:UITableViewStylePlain];
    qTableView.scrollEnabled = NO;
    qTableView.delegate = self;
    qTableView.dataSource = self;
    qTableView.separatorColor = [UIColor clearColor];
    qTableView.backgroundColor = [UIColor clearColor];
    [maxScrollView addSubview:qTableView];
    
    UIView * hView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 30*widthRate)];
    hView.backgroundColor = [lhColor colorFromHexRGB:viewColorStr];
    UILabel * qTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15*widthRate, 0, 200*widthRate, 30*widthRate)];
    qTitleLabel.text = @"热门咨询";
    qTitleLabel.font = [UIFont fontWithName:fontName size:14];
    qTitleLabel.textColor = [lhColor colorFromHexRGB:contentTitleColorStr1];
    [hView addSubview:qTitleLabel];
    
    qTableView.tableHeaderView = hView;
    
    CGFloat heih = 30*widthRate+40*widthRate*qArray.count;
    
    NSInteger count = typeArray.count/3;
    if (typeArray.count % 3 != 0) {
        count = typeArray.count/3+1;
    }
    typeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, heih, DeviceMaxWidth, 30*widthRate+92*widthRate*count) style:UITableViewStylePlain];
    typeTableView.scrollEnabled = NO;
    typeTableView.delegate = self;
    typeTableView.dataSource = self;
    typeTableView.separatorColor = [UIColor clearColor];
    typeTableView.backgroundColor = [UIColor clearColor];
    [maxScrollView addSubview:typeTableView];
    
    UIView * typeHView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 30*widthRate)];
    typeHView.backgroundColor = [lhColor colorFromHexRGB:viewColorStr];
    UILabel * typeTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15*widthRate, 0, 200*widthRate, 30*widthRate)];
    typeTitleLabel.text = @"问题分类";
    typeTitleLabel.font = [UIFont fontWithName:fontName size:14];
    typeTitleLabel.textColor = [lhColor colorFromHexRGB:contentTitleColorStr1];
    [typeHView addSubview:typeTitleLabel];
    typeTableView.tableHeaderView = typeHView;
    
    heih += 37*widthRate+92*widthRate*count;
    
    UITapGestureRecognizer * tapG = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGEvent)];
    UIView * whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, heih, DeviceMaxWidth, 60*widthRate)];
    [whiteView addGestureRecognizer:tapG];
    whiteView.backgroundColor = [UIColor whiteColor];
    [maxScrollView addSubview:whiteView];

    UIImageView * phoneImgView = [[UIImageView alloc]initWithFrame:CGRectMake(100*widthRate, 15*widthRate, 30*widthRate, 30*widthRate)];
    phoneImgView.image = imageWithName(@"shphoneIconGray");
    [whiteView addSubview:phoneImgView];
    
    UILabel * phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(145*widthRate, 15*widthRate, 100*widthRate, 30*widthRate)];
    phoneLabel.text = @"电话客服";
    phoneLabel.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
    phoneLabel.font = [UIFont fontWithName:fontName size:16];
    [whiteView addSubview:phoneLabel];
    
    heih += 80*widthRate;
    
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake((DeviceMaxWidth-60*widthRate)/2, heih, 60*widthRate, 18*widthRate)];
    logo.image = imageWithName(@"refreshLogo");
    [maxScrollView addSubview:logo];
    
    if (heih > DeviceMaxHeight-64-25*widthRate) {//高度超过屏幕
        heih += 25*widthRate;
        maxScrollView.contentSize = CGSizeMake(DeviceMaxWidth, heih);
    }
    else{
        logo.frame = CGRectMake((DeviceMaxWidth-60*widthRate)/2, DeviceMaxHeight-64-25*widthRate, 60*widthRate, 18*widthRate);
    }
    
//    if (iPhone5 || iPhone6 || iPhone6plus) {
//        logo.frame = CGRectMake((DeviceMaxWidth-60*widthRate)/2, DeviceMaxHeight-64-25*widthRate, 60*widthRate, 18*widthRate);
//    }
//    else{
//        maxScrollView.contentSize = CGSizeMake(DeviceMaxWidth, heih);
//    }
}

#pragma mark - 拨打电话
- (void)tapGEvent
{
    [[lhColor shareColor]detailPhone:ourServicePhone];
}

#pragma mark - UITabelViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == qTableView) {
        NSDictionary * qDic = [qArray objectAtIndex:indexPath.row];
        lhQuestionDetailViewController * qdVC = [[lhQuestionDetailViewController alloc]init];
        qdVC.questionIdStr = [NSString stringWithFormat:@"%@",[qDic objectForKey:@"id"]];
        [self.navigationController pushViewController:qdVC animated:YES];
    }
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == qTableView) {
        return 40*widthRate;
    }
    else{
        return 92*widthRate;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == qTableView) {
        return qArray.count;
    }
    else{
        NSInteger count = typeArray.count/3;
        if (typeArray.count % 3 != 0) {
            count = typeArray.count/3+1;
        }
        return count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == qTableView) {
        static NSString * tifier = @"qCell";
        lhSettingTableViewCell * qCell = [tableView dequeueReusableCellWithIdentifier:tifier];
        if (qCell == nil) {
            qCell = [[lhSettingTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tifier];
        }
        NSDictionary * qDic = [qArray objectAtIndex:indexPath.row];
        qCell.titleLabel.frame = CGRectMake(15*widthRate, 0, 270*widthRate, 40*widthRate);
        qCell.titleLabel.text = [NSString stringWithFormat:@"%@",[qDic objectForKey:@"title"]];
        
        if (indexPath.row == 0) {
            qCell.topLine.hidden = NO;
        }
        else{
            qCell.topLine.hidden = YES;
        }
        if (indexPath.row == qArray.count-1) {
            qCell.lowLine.frame = CGRectMake(0, 40*widthRate-0.5, DeviceMaxWidth, 0.5);
        }
        else{
            qCell.lowLine.frame = CGRectMake(15*widthRate, 40*widthRate-0.5, DeviceMaxWidth-15*widthRate, 0.5);
        }
        
        return qCell;
    }
    else{
        static NSString * tifier = @"typeCell";
        lhQuestionTypeTableViewCell * tCell = [tableView dequeueReusableCellWithIdentifier:tifier];
        if (tCell == nil) {
            tCell = [[lhQuestionTypeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tifier];
        }
        
        NSDictionary * dic = [typeArray objectAtIndex:indexPath.row*3];
        NSString * str = [NSString stringWithFormat:@"%@",[dic objectForKey:@"icon"]];
        NSString * allStr = [NSString stringWithFormat:@"%@%@",[lhColor shareColor].fileWebUrl,str];
        [lhColor checkImageWithImageView:tCell.hImgView1 withImage:str withImageUrl:allStr withPlaceHolderImage:nil];
        tCell.hView1.tag = indexPath.row*3;
        UITapGestureRecognizer * tapG = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTypeBtnEvent:)];
        [tCell.hView1 addGestureRecognizer:tapG];
        tCell.tLabel1.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"title"]];
        tCell.tLabel1.font = [UIFont fontWithName:fontName size:14];
        
        if (indexPath.row*3+1 < typeArray.count) {
            NSDictionary * dic1 = [typeArray objectAtIndex:indexPath.row*3+1];
            NSString * str1 = [NSString stringWithFormat:@"%@",[dic1 objectForKey:@"icon"]];
            NSString * allStr1 = [NSString stringWithFormat:@"%@%@",[lhColor shareColor].fileWebUrl,str1];
            [lhColor checkImageWithImageView:tCell.hImgView2 withImage:str1 withImageUrl:allStr1 withPlaceHolderImage:nil];
            tCell.hView2.tag = indexPath.row*3+1;
            UITapGestureRecognizer * tapG1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTypeBtnEvent:)];
            [tCell.hView2 addGestureRecognizer:tapG1];
            tCell.tLabel2.text = [NSString stringWithFormat:@"%@",[dic1 objectForKey:@"title"]];
            tCell.tLabel2.font = [UIFont fontWithName:fontName size:14];
            
            if (indexPath.row*3+2 < typeArray.count) {
                NSDictionary * dic2 = [typeArray objectAtIndex:indexPath.row*3+2];
                NSString * str2 = [NSString stringWithFormat:@"%@",[dic2 objectForKey:@"icon"]];
                NSString * allStr2 = [NSString stringWithFormat:@"%@%@",[lhColor shareColor].fileWebUrl,str2];
                [lhColor checkImageWithImageView:tCell.hImgView3 withImage:str2 withImageUrl:allStr2 withPlaceHolderImage:nil];
                tCell.hView3.tag = indexPath.row*3+2;
                UITapGestureRecognizer * tapG2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTypeBtnEvent:)];
                [tCell.hView3 addGestureRecognizer:tapG2];
                tCell.tLabel3.text = [NSString stringWithFormat:@"%@",[dic2 objectForKey:@"title"]];
                tCell.tLabel3.font = [UIFont fontWithName:fontName size:14];
            }
        }
        
        return tCell;
    }
    
}

#pragma mark -
- (void)tapTypeBtnEvent:(UITapGestureRecognizer *)tapG
{

    NSDictionary * qDic = [typeArray objectAtIndex:tapG.view.tag];
    lhQuestionListViewController * qlVC = [[lhQuestionListViewController alloc]init];
    qlVC.typeIdStr = [NSString stringWithFormat:@"%@",[qDic objectForKey:@"id"]];
    qlVC.titleStr = @"问题列表";
    [self.navigationController pushViewController:qlVC animated:YES];
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

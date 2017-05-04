//
//  FrankApointStudentView.m
//  Drive
//
//  Created by lichao on 15/8/11.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import "FrankApointStudentView.h"
#import "MJRefresh.h"
#import "lhMyStudentsListTableViewCell.h"

@interface FrankApointStudentView ()

@end

@implementation FrankApointStudentView

- (void)viewDidLoad {
    [super viewDidLoad];
    [[lhColor shareColor]originalInit:self title:@"预约的学员" imageName:nil backButton:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    pNo = 1;
    [self firmInit];
    
    [self headerRefresh];
}

#pragma mark - firmInit
- (void)firmInit
{
//    myStuArray = [NSMutableArray array];
    
    pNo = 1;
    totalPNo = 10;
    
    myStudentTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, DeviceMaxWidth, DeviceMaxHeight-64) style:UITableViewStylePlain];
    myStudentTab.delegate = self;
    myStudentTab.dataSource = self;
    myStudentTab.separatorColor = [UIColor clearColor];
    myStudentTab.backgroundColor = [UIColor clearColor];
    [self.view addSubview:myStudentTab];
    
    [myStudentTab addHeaderWithTarget:self action:@selector(headerRefresh)];
    [myStudentTab addFooterWithTarget:self action:@selector(footerRefresh)];
    
}

//3.4.4.预约学员详细查询bookingCar/appointDetail
-(void)requestAppointStuDetail:(NSString *)appointId{
    NSDictionary *dic = @{@"id":[[lhColor shareColor].userInfo objectForKey:@"id"],
                          @"appointId":appointId};
    [FrankNetworkManager postReqeustWithURL:PATH(@"bookingCar/appointDetail") params:dic successBlock:^(id returnData){
        if ([[returnData objectForKey:@"status"]integerValue] == 1) {
            FLLog(@"预约学员详细查询 = %@",returnData);
            myStuArray = [NSMutableArray arrayWithArray:[returnData objectForKey:@"dataList"]];
            NSLog(@"myStuArray = %@",myStuArray);
            if (myStuArray && myStuArray.count > 0) {
                [lhColor removeNullLabelWithSuperView:myStudentTab];
                [myStudentTab reloadData];
            }
            else{
                [myStudentTab reloadData];
                [lhColor addANullLabelWithSuperView:myStudentTab withFrame:CGRectMake(10*widthRate, 70*widthRate, 300*widthRate, 20*widthRate) withText:@"暂无数据"];
            }
        }else{
            [lhColor requestFailAlertShow:[returnData objectForKey:@"msg"]];
        }
    } failureBlock:^(NSError *error) {
        FLLog(@"%@",error.localizedDescription);
        [lhColor wangluoAlertShow];
    } showHUD:NO];
}

#pragma mark - 下拉刷新
- (void)headerRefresh
{
    pNo = 1;
//    [self requestData];
    [self requestAppointStuDetail:_appointId];
}

#pragma mark - 下拉加载
- (void)footerRefresh
{
    pNo++;
}

#pragma mark - UITabelViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80*widthRate;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return myStuArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * sCellStr = @"sCell";
    
    lhMyStudentsListTableViewCell * sCell = [tableView dequeueReusableCellWithIdentifier:sCellStr];
    if (sCell == nil) {
        sCell = [[lhMyStudentsListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sCellStr];
    }
    
    NSDictionary * oneDic = [myStuArray objectAtIndex:indexPath.row];
    
    NSString * picStr = [oneDic objectForKey:@"photo"];
    if (![picStr isEqualToString:@""]) {
        NSString * urlStr = [NSString stringWithFormat:@"%@%@",[lhColor shareColor].fileWebUrl,picStr];
        [lhColor checkImageWithName:picStr withUrlStr:urlStr withImgView:sCell.hImgView];
    }else{
        [sCell.hImgView setImage:imageWithName(@"default_header_icon")];
    }
    
    
    sCell.nameLabel.text = [oneDic objectForKey:@"name"];
    sCell.stuNumLabel.text = [oneDic objectForKey:@"number"];
    NSString * pStr = [oneDic objectForKey:@"learningProgress"];//进度
    
    sCell.tag = indexPath.row;
    [sCell.telBtn addTarget:self action:@selector(telBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString * progressStr;
    switch (pStr.integerValue) {
        case 1:{
            progressStr = @"科目一进行中";
            break;
        }
        case 2:{
            progressStr = @"科目二进行中";
            break;
        }
        case 3:{
            progressStr = @"科目三进行中";
            break;
        }
        case 4:{
            progressStr = @"科目四进行中";
            break;
        }
        case 5:{
            progressStr = @"已拿证";
            break;
        }
        default:
            break;
    }
    sCell.statusLabel.text = progressStr;
    
    
    return sCell;
}

#pragma mark - 打电话
- (void)telBtnEvent:(UIButton *)tBtn
{
    NSString * phoneStr = [NSString stringWithFormat:@"%@",[[myStuArray objectAtIndex:tBtn.superview.tag] objectForKey:@"phone"]];
    
    [[lhColor shareColor]detailPhone:phoneStr];
    
}

#pragma mark - 调用微信
- (void)wxBtnEvent:(UIButton *)btn
{
    NSLog(@"微信");
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [lhColor assignmentForTempVC:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

//
//  lhQuestionListViewController.m
//  GasStation
//
//  Created by bosheng on 16/2/22.
//  Copyright © 2016年 bosheng. All rights reserved.
//

#import "lhQuestionListViewController.h"
#import "lhSettingTableViewCell.h"
#import "lhQuestionDetailViewController.h"
#import "MJRefresh.h"

@interface lhQuestionListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * qTableView;
    NSArray * qArray;
    
    NSInteger pNo;
    NSInteger totalPno;
}

@end

@implementation lhQuestionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[lhColor shareColor]originalInit:self title:self.titleStr imageName:nil backButton:YES];
    
    totalPno = 1;
    pNo = 1;
    
    qArray = [NSArray array];
    [self firmInit];
    
    [lhColor addActivityView123:self.view];
    [self requestData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestData
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:
                         @{@"userId":[[lhColor shareColor].userInfo objectForKey:@"id"],
                           @"pm.pageSize":@"16",
                           @"pm.pageNo":[NSString stringWithFormat:@"%ld",(long)pNo]}];
    if (self.type != 5) {
        [dic setObject:self.typeIdStr forKey:@"catId"];
    }
    
    [FrankNetworkManager postReqeustWithURL:PATH(@"help/questions") params:dic successBlock:^(id returnData){
        [lhColor disAppearActivitiView:self.view];
        if (pNo == 1) {
            [qTableView headerEndRefreshing];
        }
        else{
            [qTableView footerEndRefreshing];
        }
        if ([[returnData objectForKey:@"status"]integerValue] == 1) {
            if (pNo == 1) {
                totalPno = [[[returnData objectForKey:@"data"] objectForKey:@"totalPages"]integerValue];
                qArray = [[returnData objectForKey:@"data"] objectForKey:@"data"];
            }
            else{
                NSArray * tempA = [[returnData objectForKey:@"data"] objectForKey:@"data"];
                if (tempA && tempA.count > 0) {
                    NSMutableArray * tArray = [NSMutableArray arrayWithArray:qArray];
                    [tArray addObjectsFromArray:tempA];
                    qArray = tArray;
                }
            }
        }else{
            [FrankTools requestFailAlertShow:[returnData objectForKey:@"msg"]];
        }
        if (qArray && qArray.count > 0) {
            [lhColor removeNullLabelWithSuperView:qTableView];
        }
        else{
            [lhColor addANullLabelWithSuperView:qTableView withFrame:CGRectMake(0, 50*widthRate, DeviceMaxWidth, 100*widthRate) withText:@"暂无问题信息~"];
        }
        [qTableView reloadData];
    } failureBlock:^(NSError *error) {
        FLLog(@"%@",error.localizedDescription);
        [FrankTools wangluoAlertShow];
        [lhColor disAppearActivitiView:self.view];
    } showHUD:NO];
}

#pragma mark - firmInit
- (void)firmInit
{
    qTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, DeviceMaxWidth, DeviceMaxHeight-64) style:UITableViewStylePlain];
    qTableView.showsVerticalScrollIndicator = NO;
    qTableView.delegate = self;
    qTableView.dataSource = self;
    qTableView.separatorColor = [UIColor clearColor];
    qTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:qTableView];
    
    [qTableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    [qTableView addFooterWithTarget:self action:@selector(footerRefresh)];
    
    UIView * hView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 30*widthRate)];
    hView.backgroundColor = [lhColor colorFromHexRGB:viewColorStr];
    UILabel * qTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15*widthRate, 0, 200*widthRate, 30*widthRate)];
    qTitleLabel.text = @"热门咨询";
    qTitleLabel.font = [UIFont fontWithName:fontName size:14];
    qTitleLabel.textColor = [lhColor colorFromHexRGB:contentTitleColorStr1];
    [hView addSubview:qTitleLabel];
    
    qTableView.tableHeaderView = hView;
}

//下拉刷新
- (void)headerRefresh
{
    pNo = 1;
    [self requestData];
}

//上拉加载
- (void)footerRefresh
{
    if (pNo >= totalPno) {
        [lhColor showAlertWithMessage:@"没有更多数据了~" withSuperView:self.view withHeih:DeviceMaxHeight-80];
        [qTableView footerEndRefreshing];
        return;
    }
    
    pNo++;
    [self requestData];
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
    
    return 40*widthRate;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return qArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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

#pragma mark - view
- (void)viewWillAppear:(BOOL)animated
{
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

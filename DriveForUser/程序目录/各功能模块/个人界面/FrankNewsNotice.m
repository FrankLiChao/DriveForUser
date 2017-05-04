//
//  FrankNewsNotice.m
//  Drive
//
//  Created by lichao on 15/10/26.
//  Copyright © 2015年 bosheng. All rights reserved.
//

#import "FrankNewsNotice.h"
#import "FrankMessageCell.h"
#import "MJRefresh.h"

@interface FrankNewsNotice ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * myTabView;//消息显示
    NSInteger pNo;//消息当前页数
    NSInteger allPno;//消息总页数
    NSMutableArray *dataArray;//消息数据
}

@end

@implementation FrankNewsNotice

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[lhColor shareColor]originalInit:self title:@"消息中心" imageName:nil backButton:YES];
    dataArray = [NSMutableArray array];
    pNo = 1;
    allPno = 1;
    [self initFrameView];
    
    [lhColor addActivityView123:self.view];
    [self requestData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initFrameView
{
    myTabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, DeviceMaxWidth, DeviceMaxHeight-64) style:UITableViewStylePlain];
    myTabView.showsVerticalScrollIndicator = NO;
    myTabView.delegate = self;
    myTabView.dataSource = self;
    myTabView.backgroundColor = [UIColor whiteColor];
    myTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:myTabView];
    
    [myTabView addHeaderWithTarget:self action:@selector(headerRefresh)];
    [myTabView addFooterWithTarget:self action:@selector(footerRefresh)];
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
    if (pNo >= allPno) {
        [lhColor showAlertWithMessage:@"没有更多数据了~" withSuperView:self.view withHeih:DeviceMaxHeight-80];
        [myTabView footerEndRefreshing];
        return;
    }
    
    pNo++;
    [self requestData];
}

//请求数据
- (void)requestData
{
    NSDictionary * dic = @{@"id":[[lhColor shareColor].userInfo objectForKey:@"id"],
                           @"pageSize":@"15",
                           @"pageNo":[NSString stringWithFormat:@"%ld",(long)pNo]};
    NSLog(@"dic = %@",dic);
    
    [FrankNetworkManager postReqeustWithURL:PATH(@"msg/notification") params:dic successBlock:^(id returnData){
        [lhColor disAppearActivitiView:self.view];
        if (pNo == 1) {
            [myTabView headerEndRefreshing];
        }
        else{
            [myTabView footerEndRefreshing];
        }
        if ([[returnData objectForKey:@"status"]integerValue] == 1) {
            NSString * nowMessageStr = [NSString stringWithFormat:@"%@",[[lhColor shareColor].userInfo objectForKey:@"messageCount"]];
            [[NSUserDefaults standardUserDefaults]setObject:nowMessageStr forKey:saveAllMessageFile];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            if (pNo == 1) {
                allPno = [[[returnData objectForKey:@"data"] objectForKey:@"totalPages"]integerValue];
                dataArray = [[returnData objectForKey:@"data"] objectForKey:@"data"];
            }
            else{
                NSArray * tempA = [[returnData objectForKey:@"data"] objectForKey:@"data"];
                if (tempA && tempA.count > 0) {
                    NSMutableArray * tArray = [NSMutableArray arrayWithArray:dataArray];
                    [tArray addObjectsFromArray:tempA];
                    dataArray = tArray;
                }
            }
            if (dataArray && dataArray.count > 0) {
                [lhColor removeNullLabelWithSuperView:myTabView];
            }
            else{
                [lhColor addANullLabelWithSuperView:myTabView withFrame:CGRectMake(0, 100*widthRate, DeviceMaxWidth, 100*widthRate) withText:@"空空如也，没有收到任何消息~"];
            }
            [myTabView reloadData];
        }else{
            [FrankTools requestFailAlertShow:[returnData objectForKey:@"msg"]];
        }
    } failureBlock:^(NSError *error) {
        FLLog(@"%@",error.localizedDescription);
        [FrankTools wangluoAlertShow];
        [lhColor disAppearActivitiView:self.view];
    } showHUD:NO];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * oneD = [dataArray objectAtIndex:indexPath.section];
    NSString * str = [NSString stringWithFormat:@"%@",[oneD objectForKey:@"target"]];
    if ([@"" isEqualToString:str] && [str rangeOfString:@"null"].length) {
        return;
    }
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:str]];
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * oned = [dataArray objectAtIndex:indexPath.section];
    NSString * str = [NSString stringWithFormat:@"%@",[oned objectForKey:@"content"]];
    //    CGSize size = [self sizeWithString:str font:[UIFont fontWithName:nowFontName size:13]];
    
    UILabel * labe = [[UILabel alloc] initWithFrame:CGRectMake(70*widthRate, 40*widthRate, DeviceMaxWidth-90*widthRate, 100)];
    labe.numberOfLines = 0;
    labe.font = [UIFont systemFontOfSize:13];
    labe.text = str;
    [labe sizeToFit];
    
    if (labe.frame.size.height > 40*widthRate) {
        return labe.frame.size.height+55*widthRate;
    }
    
    return 95*widthRate;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5*widthRate;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return dataArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView * hView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 5*widthRate)];
    hView.backgroundColor = [lhColor colorFromHexRGB:viewColorStr];
    
//    NSDictionary * oned = [dataArray objectAtIndex:section];
//    UILabel *dataLab = [[UILabel alloc] initWithFrame:CGRectMake(15*widthRate, 5*widthRate, DeviceMaxWidth-20*widthRate, 20*widthRate)];
//    dataLab.text = [oned objectForKey:@"createTime"];
//    dataLab.font = [UIFont systemFontOfSize:15];
////    dataLab.backgroundColor = [UIColor whiteColor];
//    [hView addSubview:dataLab];
    
    return hView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * tifier = @"myTeamCell";
    FrankMessageCell * cell = [tableView dequeueReusableCellWithIdentifier:tifier];
    if (cell == nil) {
        cell = [[FrankMessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary * oned = [dataArray objectAtIndex:indexPath.section];
    
    NSString * pStr = [NSString stringWithFormat:@"%@",[oned objectForKey:@"img"]];
    NSString * allPstr = [NSString stringWithFormat:@"%@%@",[lhColor shareColor].fileWebUrl,pStr];
    if (![pStr isEqualToString:@""]) {
        [lhColor checkImageWithName:pStr withUrlStr:allPstr withImgView:cell.hdImage];
    }else{
        [cell.hdImage setImage:imageWithName(@"messageDefault")];
    }
    
    
    NSString * str = [NSString stringWithFormat:@"%@",[oned objectForKey:@"content"]];
    //    CGSize size = [self sizeWithString:str font:[UIFont fontWithName:nowFontName size:13]];
    cell.contentLab.text = str;
    [cell.contentLab sizeToFit];
    cell.contentLab.frame = CGRectMake(70*widthRate, 40*widthRate, DeviceMaxWidth-90*widthRate, cell.contentLab.frame.size.height);
    
    cell.tLab.text = [NSString stringWithFormat:@"%@",[oned objectForKey:@"title"]];
    
    CGRect rec = cell.bgLab.frame;
    if (CGRectGetHeight(cell.contentLab.frame) > 40*widthRate) {
        rec.size.height = CGRectGetHeight(cell.contentLab.frame)+50*widthRate;
    }
    else{
        rec.size.height = 90*widthRate;
    }
    cell.bgLab.frame = rec;
    
    return cell;
}

// 获取字符串长度
- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(DeviceMaxWidth-90*widthRate, MAXFLOAT)//限制最大的宽度和高度
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                    attributes:@{NSFontAttributeName: font}//传人的字体字典
                                       context:nil];
    return rect.size;
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

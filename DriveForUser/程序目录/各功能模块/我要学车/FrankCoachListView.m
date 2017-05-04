//
//  FrankCoachListView.m
//  Drive
//
//  Created by lichao on 15/11/26.
//  Copyright © 2015年 bosheng. All rights reserved.
//

#import "FrankCoachListView.h"
#import "lhDriverListTableViewCell.h"
#import "MJRefresh.h"
#import "FrankSchoolDetailView.h"
#import "UIImageView+WebCache.h"
#import "lhDriverDetailViewController.h"

@interface FrankCoachListView ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *myTableView;
    NSArray *coachListArray;
    UIButton *selectBtn;
    NSMutableArray *tempArray;
}

@end

@implementation FrankCoachListView

- (void)viewDidLoad {
    [super viewDidLoad];
    [[lhColor shareColor]originalInit:self title:@"教练列表" imageName:nil backButton:YES];
    tempArray = [[NSMutableArray alloc] initWithArray:self.coachArray];
    [self initFrameView];
}

-(void)initFrameView{
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, DeviceMaxWidth, DeviceMaxHeight-64) style:UITableViewStylePlain];
    myTableView.dataSource = self;
    myTableView.delegate = self;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:myTableView];
    
    UIImageView * rImgView = [[UIImageView alloc]initWithFrame:CGRectMake(DeviceMaxWidth-19, 41, 14, 7)];
    rImgView.image = imageWithName(@"newluzhou1.png");
    [self.view addSubview:rImgView];
    
    selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectBtn.frame = CGRectMake(DeviceMaxWidth-65, 25, 50, 40);
    [selectBtn setTitle:@"筛选" forState:UIControlStateNormal];
    selectBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [selectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [selectBtn addTarget:self action:@selector(clickSelectBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectBtn];

}

#pragma mark - 点击筛选
-(void)clickSelectBtn:(UIButton *)button_
{
    NSLog(@"点击筛选");
    if (button_.selected) {
        UIView *bgView = [self.view viewWithTag:124];
        UIButton *bgButton = (UIButton *)[self.view viewWithTag:123];
        [UIView animateWithDuration:0.4 animations:^{
            bgView.frame = CGRectMake(DeviceMaxWidth-80*widthRate, 0, 80*widthRate, 0);
        }completion:^(BOOL finished) {
            [bgView removeFromSuperview];
            [bgButton removeFromSuperview];
        }];
        button_.selected = NO;
    }else{
        [self initPopView];
        UIView *bgView = [self.view viewWithTag:124];
        [UIView animateWithDuration:0.4 animations:^{
            bgView.frame = CGRectMake(DeviceMaxWidth-80*widthRate, 0, 80*widthRate, 120*widthRate);
        }completion:^(BOOL finished) {
            
        }];
        button_.selected = YES;
    }
    
}

-(void)initPopView
{
    UIButton *bgButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bgButton.frame = CGRectMake(0, 64, DeviceMaxWidth, DeviceMaxHeight);
    bgButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    bgButton.tag = 123;
    [bgButton addTarget:self action:@selector(bgButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bgButton];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(DeviceMaxWidth-80*widthRate, 0, 80*widthRate, 0*widthRate)];
    bgView.clipsToBounds = YES;
    bgView.alpha = 1;
    bgView.layer.cornerRadius = 4;
    bgView.tag = 124;
    bgView.backgroundColor = [UIColor whiteColor];
    [bgButton addSubview:bgView];
    
    NSArray * btnArray = @[@"距离排序",@"价格排序",@"评分排序"];
    for (int i = 0; i<btnArray.count; i++) {
        UIButton * tBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        tBtn.frame = CGRectMake(0, 40*widthRate*i, 80*widthRate, 40*widthRate);
        tBtn.tag = i;
        [tBtn setTitle:btnArray[i] forState:UIControlStateNormal];
        tBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [tBtn setTitleColor:[lhColor colorFromHexRGB:contentTitleColorStr] forState:UIControlStateNormal];
        tBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [tBtn addTarget:self action:@selector(tBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:tBtn];
        
        if (i < btnArray.count-1) {
            UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 40*widthRate*(i+1), 80*widthRate, 0.5)];
            lineView.backgroundColor = [lhColor colorFromHexRGB:viewColorStr];
            [bgView addSubview:lineView];
        }
    }
    
    [UIView animateWithDuration:0.4 animations:^{
        bgButton.alpha = 1;
        bgView.frame = CGRectMake(DeviceMaxWidth-80*widthRate, 0, 80*widthRate, 0*widthRate);
    }completion:^(BOOL finished) {
    }];
}

-(void)tBtnEvent:(UIButton *)button_{
    if (button_.tag == 0) {
        NSLog(@"按距离排序");
        UIButton *bgButton = (UIButton *)[self.view viewWithTag:123];
        UIView *bgView = [self.view viewWithTag:124];
        [UIView animateWithDuration:0.4 animations:^{
            bgView.frame = CGRectMake(DeviceMaxWidth-80*widthRate, 0, 80*widthRate, 0);
        }completion:^(BOOL finished) {
            [bgButton removeFromSuperview];
            [bgView removeFromSuperview];
        }];
        selectBtn.selected = NO;
        [self requstCoachDataWithDistance];
    }else if (button_.tag == 1){
        UIButton *bgButton = (UIButton *)[self.view viewWithTag:123];
        UIView *bgView = [self.view viewWithTag:124];
        [UIView animateWithDuration:0.4 animations:^{
            bgView.frame = CGRectMake(DeviceMaxWidth-80*widthRate, 0, 80*widthRate, 0);
        }completion:^(BOOL finished) {
            [bgButton removeFromSuperview];
            [bgView removeFromSuperview];
        }];
        selectBtn.selected = NO;
        [self requstCoachDataWithPrice];
    }else if (button_.tag == 2){
        NSLog(@"按评分排序");
        UIButton *bgButton = [self.view viewWithTag:123];
        UIView *bgView = [self.view viewWithTag:124];
        [UIView animateWithDuration:0.4 animations:^{
            bgView.frame = CGRectMake(DeviceMaxWidth-80*widthRate, 0, 80*widthRate, 0);
        }completion:^(BOOL finished) {
            [bgButton removeFromSuperview];
            [bgView removeFromSuperview];
        }];
        selectBtn.selected = NO;
        [self requstCoachDataWithScore];
    }
}

-(void)bgButtonEvent{
    __block UIButton * bgButton = (UIButton *)[self.view viewWithTag:123];
    __block UIView * bgView = (UIView *)[self.view viewWithTag:124];
    
    CGRect re = bgView.frame;
    re.size.height = 0;
    
    [UIView animateWithDuration:0.4 animations:^{
        bgButton.alpha = 0;
        bgView.frame = re;
    }completion:^(BOOL finished) {
        [bgView removeFromSuperview];
        [bgButton removeFromSuperview];
        
        bgView = nil;
        bgButton = nil;
        selectBtn.selected = NO;
    }];
    
}

#pragma mark - 请求教练数据
-(void)requstCoachDataWithDistance
{
    tempArray = [[NSMutableArray alloc] initWithArray:self.coachArray];
    [myTableView reloadData];
}

-(void)getCoachData:(NSNotification *)infor{
    [lhColor disAppearActivitiView:self.view];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:infor.name object:nil];
    if (!infor.userInfo || [infor.userInfo class] == [[NSNull alloc]class]) {
        NSLog(@"请求失败");
    }
    if ([[infor.userInfo objectForKey:@"status"]integerValue] == 1) {
        coachListArray = [NSArray arrayWithArray:[infor.userInfo objectForKey:@"data"]];
        NSLog(@"coachArray = %@",coachListArray);
        [myTableView reloadData];
    }
    else{
        [lhColor requestFailAlertShow:infor];
    }
}

-(void)requstCoachDataWithPrice
{
    tempArray = [[NSMutableArray alloc] initWithArray:self.coachArray];
    NSComparator cmptr = ^(id obj1, id obj2){
        if ([obj1 objectForKey:@"coachFee"] > [obj2 objectForKey:@"coachFee"]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 objectForKey:@"coachFee"] < [obj2 objectForKey:@"coachFee"]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    };
    NSArray *array = [tempArray sortedArrayUsingComparator:cmptr];
    tempArray = [[NSMutableArray alloc] initWithArray:array];
    [myTableView reloadData];
}

-(void)requstCoachDataWithScore
{
    tempArray = [[NSMutableArray alloc] initWithArray:self.coachArray];
    NSComparator cmptr = ^(id obj1, id obj2){
        if ([[obj1 objectForKey:@"coachScore"] floatValue] < [[obj2 objectForKey:@"coachScore"] floatValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([[obj1 objectForKey:@"coachScore"] floatValue] > [[obj2 objectForKey:@"coachScore"] floatValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    };
    NSArray *array = [tempArray sortedArrayUsingComparator:cmptr];
    tempArray = [[NSMutableArray alloc] initWithArray:array];
    [myTableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    lhDriverDetailViewController * ddVC = [[lhDriverDetailViewController alloc]init];
    [self.navigationController pushViewController:ddVC animated:YES];
    NSDictionary *coachDic1 = [NSDictionary dictionaryWithDictionary:[coachListArray objectAtIndex:indexPath.row]];
    ddVC.coachID = [coachDic1 objectForKey:@"id"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tempArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80*widthRate;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * indentifier = @"dltCell";
    lhDriverListTableViewCell * dltCell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    NSDictionary * coachDic = [NSDictionary dictionaryWithDictionary:[tempArray objectAtIndex:indexPath.row]];
    if (dltCell == nil) {
        dltCell = [[lhDriverListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    dltCell.numLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row+1];
    if ([coachDic count]) {
        dltCell.nameLabel.text = [coachDic objectForKey:@"_name"];
        
        
        NSString *string = [NSString stringWithFormat:@"%@%@",[lhColor shareColor].fileWebUrl, [coachDic objectForKey:@"photoUrl"]];
        [dltCell.hImgView setImageWithURL:[NSURL URLWithString:string] placeholderImage:imageWithName(@"default_header_icon")];
        
        dltCell.dAgeLabel.text = [NSString stringWithFormat:@"教龄：%@",[coachDic objectForKey:@"coachTeachAge"]];
        dltCell.priceLabel.text = [NSString stringWithFormat:@"￥ %@ 起",[coachDic objectForKey:@"coachFee"]];
        dltCell.starImgView.number = [[coachDic objectForKey:@"coachScore"] doubleValue];
        dltCell.distanceLabel.text = [NSString stringWithFormat:@"%.2f Km",[[coachDic objectForKey:@"_distance"]floatValue]/1000.0];
        
        /* 暂时先注释
        if ([[coachDic objectForKey:@"gender"] integerValue] == 0) {
            dltCell.genderLabel.text = @"男";
        }else{
            dltCell.genderLabel.text = @"女";
        }
        dltCell.ageLabel.text = [NSString stringWithFormat:@"%@ 岁",[coachDic objectForKey:@"age"]];
         */
    }
    return dltCell;
}

- (void)viewWillAppear:(BOOL)animated
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

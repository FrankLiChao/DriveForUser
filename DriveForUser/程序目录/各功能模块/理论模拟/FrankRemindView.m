//
//  FrankRemindView.m
//  Drive
//
//  Created by lichao on 15/8/26.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import "FrankRemindView.h"
#import "FrankPracticeView.h"

@interface FrankRemindView ()

@end

@implementation FrankRemindView

- (void)viewDidLoad {
    [super viewDidLoad];
    [[lhColor shareColor]originalInit:self title:@"模拟考试" imageName:nil backButton:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createTableView];
    [self initFrameView];
}

-(void)createTableView{
    UITableView *myTableView = [[UITableView alloc] initWithFrame:CGRectMake(50*widthRate, 64+160*widthRate, DeviceMaxWidth-100*widthRate, 160*widthRate) style:UITableViewStylePlain];
    myTableView.dataSource = self;
    myTableView.delegate = self;
    myTableView.scrollEnabled = NO;
    myTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:myTableView];
}

-(void)initFrameView{
    nameForTab = @[@"考试科目",@"考试车型",@"考试标准",@"合格标准"];
    contentForTab = @[@"科目一理论考试",@"小车（C1,C2,C3）",@"100题,45分",@"满分100分,90分及格"];
    headImage = [[UIImageView alloc] initWithFrame:CGRectMake((DeviceMaxWidth-60*widthRate)/2, 64+40*widthRate, 60*widthRate, 60*widthRate)];
    [headImage setImage:[UIImage imageNamed:@""]];
    headImage.layer.borderWidth = 0.8;
    headImage.layer.cornerRadius = 30*widthRate;
    headImage.layer.borderColor = [[UIColor clearColor] CGColor];
    headImage.backgroundColor = [UIColor grayColor];
    [self.view addSubview:headImage];
    
    nameLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 64+110*widthRate, DeviceMaxWidth, 20*widthRate)];
    nameLable.font = [UIFont systemFontOfSize:15];
    nameLable.text = @"鹰";
    nameLable.textColor = [UIColor blackColor];
    nameLable.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:nameLable];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 64+130*widthRate, DeviceMaxWidth, 20*widthRate)];
    lab.text = @"您可以登录个人中心更新个人资料哦";
    lab.font = [UIFont systemFontOfSize:12];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
    [self.view addSubview:lab];
    
    for (int i=0; i<5; i++) {
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(50*widthRate, 64+160*widthRate+40*widthRate*i, DeviceMaxWidth-100*widthRate, 0.5)];
        line.backgroundColor = [lhColor colorFromHexRGB:viewColorStr];
        [self.view addSubview:line];
    }
    
    UIButton *btnForBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    btnForBtn.frame = CGRectMake(40*widthRate, 64+360*widthRate, 100*widthRate, 30*widthRate);
    btnForBtn.layer.cornerRadius = 20*widthRate;
    btnForBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [btnForBtn setTitle:@"全真模拟考试" forState:UIControlStateNormal];
    [btnForBtn setBackgroundImage:[UIImage imageNamed:@"testBtn"] forState:UIControlStateNormal];
    [btnForBtn addTarget:self action:@selector(testForSimulation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnForBtn];
    
    UIButton *btnForBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btnForBtn1.frame = CGRectMake(DeviceMaxWidth-140*widthRate, 64+360*widthRate, 100*widthRate, 30*widthRate);
    btnForBtn1.layer.cornerRadius = 20*widthRate;
    btnForBtn1.titleLabel.font = [UIFont systemFontOfSize:13];
    [btnForBtn1 setTitle:@"先考未做题" forState:UIControlStateNormal];
    [btnForBtn1 setBackgroundImage:[UIImage imageNamed:@"testBtn"] forState:UIControlStateNormal];
    [btnForBtn1 addTarget:self action:@selector(clickBtnForBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnForBtn1];
}

-(void)clickBtnForBtn{
    FrankPracticeView *practiceView = [[FrankPracticeView alloc] init];
    practiceView.recordJump = SIMULATION_TEST;
    practiceView.titleStr = @"模拟考试";
    NSMutableArray *simulationTestArray = [[NSMutableArray alloc] init];
    if (self.subType == 0) {
        simulationTestArray = [NSMutableArray arrayWithArray:[ManageSqlite findRandomData]];
    }else if (self.subType == 1){
        simulationTestArray = [NSMutableArray arrayWithArray:[ManageSqlite findRandomData4]];
    }
    practiceView.sqliteArray = simulationTestArray;
    practiceView.datacount = 100;
    practiceView.subType = self.subType;
    [self.navigationController pushViewController:practiceView animated:YES];
}

-(void)testForSimulation{
    FrankPracticeView *practiceView = [[FrankPracticeView alloc] init];
    practiceView.recordJump = SIMULATION_TEST;
    practiceView.titleStr = @"模拟考试";
    NSMutableArray *simulationTestArray = [[NSMutableArray alloc] init];
    if (self.subType == 0) {
        simulationTestArray = [NSMutableArray arrayWithArray:[ManageSqlite findRandomData]];
    }else if (self.subType == 1){
        simulationTestArray = [NSMutableArray arrayWithArray:[ManageSqlite findRandomData4]];
    }
    practiceView.sqliteArray = simulationTestArray;
    practiceView.datacount = 100;
    practiceView.subType = self.subType;
    [self.navigationController pushViewController:practiceView animated:YES];
    
    [self removeThisVC];
}

#pragma mark - 移除当前页面
- (void)removeThisVC
{
    NSMutableArray * tempVC = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    
    for (UIViewController * vc in tempVC) {
        if ([vc class] == [self class]) {
            [tempVC removeObject:vc];
            break;
        }
    }
    
    self.navigationController.viewControllers = tempVC;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    cell.textLabel.text = [nameForTab objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
    
    cell.detailTextLabel.text = [contentForTab objectAtIndex:indexPath.row];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.textColor = [UIColor blackColor];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40*widthRate;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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

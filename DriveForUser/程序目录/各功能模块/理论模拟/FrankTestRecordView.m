//
//  FrankTestRecordView.m
//  Drive
//
//  Created by lichao on 15/8/3.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import "FrankTestRecordView.h"
#import "FrankPracticeView.h"

@interface FrankTestRecordView ()

@end

@implementation FrankTestRecordView

- (void)viewDidLoad {
    [super viewDidLoad];
    [[lhColor shareColor]originalInit:self title:@"考试记录" imageName:nil backButton:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initData];
    [self createTableView];
    // Do any additional setup after loading the view.
}

-(void)initData{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *filename = nil;
    if (self.subType == 0) {
        filename=[path stringByAppendingPathComponent:@"subject1.plist"];
    }else if (self.subType == 1){
        filename=[path stringByAppendingPathComponent:@"subject4.plist"];
    }
    rootArray = [[NSMutableArray alloc] initWithContentsOfFile:filename];
    cellCount = [rootArray count];
}

-(void)createTableView{
    UITableView *testRecord = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, DeviceMaxWidth, DeviceMaxHeight-64) style:UITableViewStylePlain];
    testRecord.delegate = self;
    testRecord.dataSource = self;
    testRecord.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:testRecord];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    FrankTestRecordViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[FrankTestRecordViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if ([rootArray count]) {
        cell.recordIndex.text = [NSString stringWithFormat:@"%ld",[rootArray count]-(indexPath.row)];
        cell.recordScore.text = [NSString stringWithFormat:@"%@分",[rootArray[[rootArray count]-(indexPath.row+1)] objectForKey:@"score"]];
        cell.recordTime.text = [NSString stringWithFormat:@"用时%@  %@",[rootArray[[rootArray count]-(indexPath.row+1)] objectForKey:@"time"],[rootArray[[rootArray count]-(indexPath.row+1)] objectForKey:@"data"]];
    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FrankPracticeView *practiceView = [[FrankPracticeView alloc] init];
    practiceView.recordJump = TEST_HISTORY;
    practiceView.titleStr = @"考试记录";
    practiceView.subType = self.subType;
    practiceView.datacount = 100;
    practiceView.recordIndex = indexPath.row;
    [self.navigationController pushViewController:practiceView animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return cellCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50*widthRate;
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

@implementation FrankTestRecordViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier

{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        _checkWrong = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        _checkWrong.frame = CGRectMake(DeviceMaxWidth-60*widthRate, 15*widthRate, 50*widthRate, 20*widthRate);
//        _checkWrong.titleLabel.font = [UIFont systemFontOfSize:12.0f];
//        [_checkWrong setTitle:@"查看错题" forState:UIControlStateNormal];
//        [self addSubview:_checkWrong];
        
        _recordIndex = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, 10*widthRate, 30*widthRate, 30*widthRate)];
        _recordIndex.layer.cornerRadius = 15.0f*widthRate;
        _recordIndex.layer.borderWidth = 0.5f;
        _recordIndex.text = @"1";
        _recordIndex.textAlignment = NSTextAlignmentCenter;
        _recordIndex.textColor = [UIColor whiteColor];
        _recordIndex.layer.borderColor = [[UIColor orangeColor]CGColor];
        _recordIndex.layer.backgroundColor = [[UIColor orangeColor] CGColor];
        [self addSubview:_recordIndex];
        
        _recordScore = [[UILabel alloc] initWithFrame:CGRectMake(50*widthRate, 5*widthRate, DeviceMaxWidth-100*widthRate, 20*widthRate)];
        _recordScore.font = [UIFont systemFontOfSize:15];
        _recordScore.text = @"100分";
        [self addSubview:_recordScore];
        
        _recordTime = [[UILabel alloc] initWithFrame:CGRectMake(50*widthRate, 25*widthRate, DeviceMaxWidth-100*widthRate, 20*widthRate)];
        _recordTime.font = [UIFont systemFontOfSize:12.0f];
        _recordTime.text = @"用时4:25  2015.08.04";
        [self addSubview:_recordTime];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10*widthRate, 49.5*widthRate, DeviceMaxWidth-20*widthRate, 0.5)];
        lineView.backgroundColor = [lhColor colorFromHexRGB:contentTitleColorStr1];
        [self addSubview:lineView];
    }
    return self;
}

@end

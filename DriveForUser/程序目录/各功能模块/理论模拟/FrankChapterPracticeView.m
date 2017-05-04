//
//  FrankChapterPracticeView.m
//  Drive
//
//  Created by lichao on 15/7/30.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import "FrankChapterPracticeView.h"
#import "FrankPracticeView.h"

@interface FrankChapterPracticeView (){
    NSArray *contentArray;
}

@end

@implementation FrankChapterPracticeView

- (void)viewDidLoad {
    [super viewDidLoad];
    [[lhColor shareColor]originalInit:self title:@"专项练习" imageName:nil backButton:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initData];
    [self createTabviewForChapter];
    
    
    // Do any additional setup after loading the view.
}

-(void)initData{
    if (_subject == 0) {
        contentArray = @[@"第一章：道路交通安全法律、法规和规章",@"第二章：道路交通信号",@"第三章：安全行车、文明驾驶基础知识",@"第四章：机动车驾驶操作相关基础知识"];
    }else if (_subject == 1){
        contentArray = @[@"第一章：违法行为综合判断与案例分析",@"第二章：安全行车常识",@"第三章：常见交通标识、标线和交警手势信号辨识",@"第四章：驾驶职业道德和文明驾驶常识",@"第五章：恶劣气候和复杂道路条件下驾驶常识",@"第六章：紧急情况下避险常识",@"第七章：交通事故救护及常见危化品处置常识"];
    }
}

-(void) createTabviewForChapter{
    chapterView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, DeviceMaxWidth, 45*widthRate*[contentArray count]) style:UITableViewStylePlain];
    chapterView.delegate = self;
    chapterView.dataSource = self;
    [self.view addSubview:chapterView];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = contentArray[indexPath.row];
    cell.textLabel.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FrankPracticeView *practiceView = [[FrankPracticeView alloc] init];
    practiceView.recordJump = SPECIFIC_PRACTICE;
    practiceView.titleStr = @"专项练习";
    if (_subject == 0) {
        practiceView.subType = 0;
        _chapterArray = [ManageSqlite findDataFormChapter:(int)indexPath.row+1];
    }else if (_subject == 1){
        practiceView.subType = 1;
        _chapterArray = [ManageSqlite findData4FormChapter:(int)indexPath.row+1];
    }

    practiceView.datacount = [_chapterArray count];
    practiceView.sqliteArray = [ManageSqlite findDataFormChapter:(int)indexPath.row+1];
    [self.navigationController pushViewController:practiceView animated:YES];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [contentArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45*widthRate;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

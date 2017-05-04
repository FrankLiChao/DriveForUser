//
//  FrankTestskillView.m
//  Drive
//
//  Created by lichao on 15/7/31.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import "FrankTestskillView.h"
#import "FrankSkillView.h"

@interface FrankTestskillView ()

@end

@implementation FrankTestskillView

- (void)viewDidLoad {
    [super viewDidLoad];
    [[lhColor shareColor]originalInit:self title:@"答题技巧" imageName:nil backButton:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createTableView];
    // Do any additional setup after loading the view.
}

-(void)createTableView{
    UITableView *testSkill = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, DeviceMaxWidth, 5*50) style:UITableViewStylePlain];
    testSkill.delegate = self;
    testSkill.dataSource = self;
    [self.view addSubview:testSkill];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    FrankTestskillViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[FrankTestskillViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    switch (indexPath.row) {
        case 0:
            cell.indexLabel.text = @"1";
            cell.skillTitle.text = @"考试技巧";
            cell.skillintroduce.text = @"100%通过理论考试技巧";
            break;
        case 1:
            cell.indexLabel.text = @"2";
            cell.skillTitle.text = @"交规巧计";
            cell.skillintroduce.text = @"交通安全规范要点巧计";
            break;
        case 2:
            cell.indexLabel.text = @"3";
            cell.skillTitle.text = @"处罚相关题巧计";
            cell.skillintroduce.text = @"处罚题目要点快速巧计";
            break;
        case 3:
            cell.indexLabel.text = @"4";
            cell.skillTitle.text = @"处罚金额题巧计";
            cell.skillintroduce.text = @"处罚题目要点快速巧计";
            break;
        case 4:
            cell.indexLabel.text = @"5";
            cell.skillTitle.text = @"最低、最高时速题巧计";
            cell.skillintroduce.text = @"最低、最高时速题目巧计";
            break;
        default:
            break;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FrankSkillView *skillView = [[FrankSkillView alloc] init];
    [self.navigationController pushViewController:skillView animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
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

@end

@implementation FrankTestskillViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier

{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _indexLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 20, 20)];
        _indexLabel.layer.borderWidth = 1.0;
        _indexLabel.layer.cornerRadius = 10.0f;
        _indexLabel.text = @"1";
        _indexLabel.textAlignment = NSTextAlignmentCenter;
        _indexLabel.layer.backgroundColor = [[UIColor orangeColor] CGColor];
        _indexLabel.layer.borderColor = [[UIColor orangeColor] CGColor];
        _indexLabel.textColor = [UIColor redColor];
        [self addSubview:_indexLabel];
        
        _skillTitle = [[UILabel alloc] initWithFrame:CGRectMake(60, 5, DeviceMaxWidth-100, 20)];
        _skillTitle.text = @"合格标准";
        _skillTitle.font = [UIFont systemFontOfSize:14.0f];
        _skillTitle.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
        [self addSubview:_skillTitle];
        
        _skillintroduce = [[UILabel alloc] initWithFrame:CGRectMake(60, 25, DeviceMaxWidth-100, 20)];
        _skillintroduce.text = @"考试内容及合格标准";
        _skillintroduce.font = [UIFont systemFontOfSize:12.0f];
        _skillintroduce.textColor = [lhColor colorFromHexRGB:contentTitleColorStr1];
        [self addSubview:_skillintroduce];
    }
    return self;
}

@end

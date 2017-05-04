//
//  FrankTestpointsView.m
//  Drive
//
//  Created by lichao on 15/8/3.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import "FrankTestpointsView.h"
#import "FrankPointView.h"

@interface FrankTestpointsView ()

@end

@implementation FrankTestpointsView

- (void)viewDidLoad {
    [super viewDidLoad];
    [[lhColor shareColor]originalInit:self title:@"考试要点" imageName:nil backButton:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createTableView];
    // Do any additional setup after loading the view.
}

-(void)createTableView{
    UITableView *testPoint = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, DeviceMaxWidth, 5*50) style:UITableViewStylePlain];
    testPoint.delegate = self;
    testPoint.dataSource = self;
    [self.view addSubview:testPoint];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    FrankTestpointsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[FrankTestpointsViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    switch (indexPath.row) {
        case 0:
            cell.lableForIndex.text = @"1";
            cell.lableForPointsName.text = @"合格标准";
            cell.lableForPointIntroduce.text = @"考试内容及合格标准";
            break;
        case 1:
            cell.lableForIndex.text = @"2";
            cell.lableForPointsName.text = @"扣分细则";
            cell.lableForPointIntroduce.text = @"2015交规扣分标准";
            break;
        case 2:
            cell.lableForIndex.text = @"3";
            cell.lableForPointsName.text = @"手势口诀";
            cell.lableForPointIntroduce.text = @"8种交警手势信号口诀";
            break;
        case 3:
            cell.lableForIndex.text = @"4";
            cell.lableForPointsName.text = @"酒驾要点";
            cell.lableForPointIntroduce.text = @"最新酒驾知识要点总结";
            break;
        case 4:
            cell.lableForIndex.text = @"5";
            cell.lableForPointsName.text = @"易混淆知识点";
            cell.lableForPointIntroduce.text = @"各类容易混淆的知识点巧计";
            break;
        default:
            break;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FrankPointView *pointView = [[FrankPointView alloc] init];
    pointView.pointForIndex = indexPath.row;
    [self.navigationController pushViewController:pointView animated:YES];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

@implementation FrankTestpointsViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier

{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _lableForIndex = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 20, 20)];
        _lableForIndex.layer.borderWidth = 1.0;
        _lableForIndex.layer.cornerRadius = 10.0f;
        _lableForIndex.text = @"1";
        _lableForIndex.textAlignment = NSTextAlignmentCenter;
        _lableForIndex.layer.backgroundColor = [[UIColor orangeColor] CGColor];
        _lableForIndex.layer.borderColor = [[UIColor orangeColor] CGColor];
        _lableForIndex.textColor = [UIColor redColor];
        [self addSubview:_lableForIndex];
        
        _lableForPointsName = [[UILabel alloc] initWithFrame:CGRectMake(60, 5, DeviceMaxWidth-200, 20)];
        _lableForPointsName.text = @"合格标准";
        _lableForPointsName.font = [UIFont systemFontOfSize:14.0f];
        _lableForPointsName.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
        [self addSubview:_lableForPointsName];
        
        _lableForPointIntroduce = [[UILabel alloc] initWithFrame:CGRectMake(60, 25, DeviceMaxWidth-200, 20)];
        _lableForPointIntroduce.text = @"考试内容及合格标准";
        _lableForPointIntroduce.font = [UIFont systemFontOfSize:12.0f];
        _lableForPointIntroduce.textColor = [lhColor colorFromHexRGB:contentTitleColorStr1];
        [self addSubview:_lableForPointIntroduce];
    }
    return self;
}

@end


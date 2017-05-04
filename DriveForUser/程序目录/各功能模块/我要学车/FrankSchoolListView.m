//
//  FrankSchoolListView.m
//  Drive
//
//  Created by lichao on 15/11/26.
//  Copyright © 2015年 bosheng. All rights reserved.
//

#import "FrankSchoolListView.h"
#import "FrankSchoolListTableViewCell.h"
#import "MJRefresh.h"
#import "FrankSchoolDetailView.h"
#import "UIImageView+WebCache.h"

@interface FrankSchoolListView ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *myTableView;
//    NSArray *schListArray;
}

@end

@implementation FrankSchoolListView

- (void)viewDidLoad {
    [super viewDidLoad];
    [[lhColor shareColor]originalInit:self title:@"驾校列表" imageName:nil backButton:YES];
    [self initFrameView];
//    [self requestSchoolInformation];
}

-(void)initFrameView
{
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, DeviceMaxWidth, DeviceMaxHeight-64) style:UITableViewStylePlain];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:myTableView];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FrankSchoolDetailView *sdView = [[FrankSchoolDetailView alloc] init];
    [self.navigationController pushViewController:sdView animated:YES];
//    sdView.schDic = [NSDictionary dictionaryWithDictionary:[schListArray objectAtIndex:indexPath.row]];
    sdView.schoolID = [NSString stringWithFormat:@"%@",[[self.schoolListAy objectAtIndex:indexPath.row] objectForKey:@"driving_id"]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.schoolListAy count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70*widthRate;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * indentifier = @"schoolCell";
    FrankSchoolListTableViewCell * schoolCell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (schoolCell == nil) {
        schoolCell = [[FrankSchoolListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    NSDictionary * schoolDic = [NSDictionary dictionaryWithDictionary:[self.schoolListAy objectAtIndex:indexPath.row]];
    NSString *string = [NSString stringWithFormat:@"%@%@",[lhColor shareColor].fileWebUrl, [schoolDic objectForKey:@"photoUrl"]];
    [schoolCell.sImgView setImageWithURL:[NSURL URLWithString:string] placeholderImage:nil];
    schoolCell.sNumLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row+1];
    schoolCell.sNameLabel.text = [schoolDic objectForKey:@"_name"];
    schoolCell.sNameLabel.numberOfLines = 0;
    schoolCell.priceLabel.text = [NSString stringWithFormat:@"￥ %@",[schoolDic objectForKey:@"schoolFee"]];
    schoolCell.starImgView.number = [[schoolDic objectForKey:@"schoolScore"] doubleValue];
    schoolCell.stuNumber.text = [NSString stringWithFormat:@"学员：%@",[schoolDic objectForKey:@"stuCount"] ];
    schoolCell.distanceLabel.text = [NSString stringWithFormat:@"%.2f Km",[[schoolDic objectForKey:@"_distance"] floatValue]/1000.0];
    return schoolCell;
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

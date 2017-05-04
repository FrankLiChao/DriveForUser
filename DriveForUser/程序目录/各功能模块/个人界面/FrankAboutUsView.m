//
//  FrankAboutUsView.m
//  Drive
//
//  Created by lichao on 15/8/20.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import "FrankAboutUsView.h"

@interface FrankAboutUsView ()

@end

@implementation FrankAboutUsView

- (void)viewDidLoad {
    [super viewDidLoad];
    [[lhColor shareColor]originalInit:self title:@"关于我们" imageName:nil backButton:YES];
    [self initFrameView];
}

-(void) initFrameView{
    myArray = @[@"新版本检测",@"给我评分",@"技术支持"];
    UIView *bgView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 64, DeviceMaxWidth, (DeviceMaxHeight-64)/2)];
    bgView1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView1];
    
    UIImageView *logView = [[UIImageView alloc] initWithFrame:CGRectMake((DeviceMaxWidth-80*widthRate)/2, ((DeviceMaxHeight-64)/2-80*widthRate)/2, 80*widthRate, 80*widthRate)];
    logView.layer.borderWidth = 0.8;
    logView.layer.cornerRadius = 4.0;
    [logView setImage:[UIImage imageNamed:@"iconImg"]];
    [bgView1 addSubview:logView];
    
    UILabel *log = [[UILabel alloc] initWithFrame:CGRectMake((DeviceMaxWidth-50)/2, ((DeviceMaxHeight-64)/2-80*widthRate)/2+100*widthRate, 50*widthRate, 20*widthRate)];
    log.text = @"logo";
    log.font = [UIFont systemFontOfSize:15];
    log.textAlignment = NSTextAlignmentCenter;
    [bgView1 addSubview:log];
    
    UITableView *myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (DeviceMaxHeight-64)/2+64+10*widthRate, DeviceMaxWidth, 120*widthRate) style:UITableViewStylePlain];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:myTableView];
    
    UIView *noView = [[UIView alloc] initWithFrame:CGRectMake(0, (DeviceMaxHeight-64)/2+64+10*widthRate+120*widthRate, DeviceMaxWidth, DeviceMaxHeight-((DeviceMaxHeight-64)/2+64+10*widthRate+120*widthRate))];
    noView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:noView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40*widthRate;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * indentifier = @"mySetCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:indentifier];
    }
    if (indexPath.row == 0) {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }else{
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.text = [myArray objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
    if (indexPath.row == 0) {
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
        cell.detailTextLabel.text = @"当前版本：V1.0.0";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            break;
        case 1:
            NSLog(@"点击给我评分");
            break;
        case 2:
            NSLog(@"点击技术支持");
            break;
        default:
            break;
    }
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

//
//  lhAboutUsViewController.m
//  GasStation
//
//  Created by bosheng on 15/11/9.
//  Copyright © 2015年 bosheng. All rights reserved.
//

#import "lhAboutUsViewController.h"
#import "lhZFPayTableViewCell.h"
#import "lhFeedBackViewController.h"
#import "lhUserProtocolViewController.h"
#import "lhWelcomPageViewController.h"
#import "lhContactUsViewController.h"

@interface lhAboutUsViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray * tArray;
}
@end

@implementation lhAboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[lhColor shareColor]originalInit:self title:@"关于" imageName:nil backButton:YES];
    
//    tArray = @[@"用户协议",@"意见反馈",@"欢迎页",@"联系电话"];
    tArray = @[@[@"用户协议",@"欢迎页",@"联系我们"],
               @[@"关注微信公众号",@"关注微博"]];
    
    [self firmInit];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - firmInit
- (void)firmInit
{
    UIImageView * imgView = [[UIImageView alloc]initWithFrame:CGRectMake(130*widthRate, 64+20*widthRate, 60*widthRate, 60*widthRate)];
    imgView.image = imageWithName(@"defaultIcon");
    [self.view addSubview:imgView];
    
    NSDictionary * infoDict = [[NSBundle mainBundle]infoDictionary];
    NSString * nowVersion = [NSString stringWithFormat:@"优品学车V%@",[infoDict objectForKey:@"CFBundleShortVersionString"]];
    UILabel * versionLabel = [[UILabel alloc]initWithFrame:CGRectMake(10*widthRate, 64+90*widthRate, DeviceMaxWidth-20*widthRate, 20*widthRate)];
    versionLabel.text = nowVersion;
    versionLabel.textColor = [lhColor colorFromHexRGB:mainColorStr];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.font = [UIFont fontWithName:nowVersion size:14];
    [self.view addSubview:versionLabel];
    
    UITableView * fTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64+115*widthRate, DeviceMaxWidth, 230*widthRate) style:UITableViewStylePlain];
    fTableView.scrollEnabled = NO;
    fTableView.delegate = self;
    fTableView.dataSource = self;
    fTableView.separatorColor = [UIColor clearColor];
    fTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:fTableView];
    
    NSString * str = @"Copyright ©2015-2016\n成都博晟创信科技有限公司";
    NSMutableAttributedString * as = [[NSMutableAttributedString alloc]initWithString:str];
    NSMutableParagraphStyle * ps = [[NSMutableParagraphStyle alloc]init];
    [ps setLineSpacing:6];
    [as addAttribute:NSParagraphStyleAttributeName value:ps range:NSMakeRange(0, str.length)];
    UILabel * bqLabel = [[UILabel alloc]initWithFrame:CGRectMake(10*widthRate, DeviceMaxHeight-60*widthRate, DeviceMaxWidth-20*widthRate, 60*widthRate)];
    bqLabel.numberOfLines = 2;
    bqLabel.font = [UIFont fontWithName:fontName size:12];
    bqLabel.text = str;
    bqLabel.attributedText = as;
    bqLabel.textColor = [lhColor colorFromHexRGB:contentTitleColorStr1];
    bqLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:bqLabel];
}


#pragma mark - UITabelViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        switch (indexPath.row) {
            case 0:{
                NSLog(@"用户协议");
                lhUserProtocolViewController * upVC = [[lhUserProtocolViewController alloc]init];
                [self.navigationController pushViewController:upVC animated:YES];
                break;
            }
            case 1:{
                lhWelcomPageViewController * wpVC = [[lhWelcomPageViewController alloc]init];
                [self.navigationController pushViewController:wpVC animated:YES];
                break;
            }
            case 2:{
                lhContactUsViewController * cuVC = [[lhContactUsViewController alloc]init];
                [self.navigationController pushViewController:cuVC animated:YES];
                break;
            }
            default:
                break;
        }
        
    }
    else{
        if (indexPath.row == 0) {//关注微信公众号
            NSString * str = @"weixin://dl/officialaccounts";
            //    http://weixin.qq.com/r/g3WHn2XETzgwrSH89yCR
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:str]];
        }
        else{//关注微博
            NSString * str = @"weibo://dl/search";
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:str]];
        }
    }
    
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40*widthRate;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section
{
    return 15*widthRate;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * hView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 15*widthRate)];
    hView.backgroundColor = [lhColor colorFromHexRGB:viewColorStr];
    
    return hView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return tArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray * arr = [tArray objectAtIndex:section];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * tifier = @"fCell";
    lhZFPayTableViewCell * fCell = [tableView dequeueReusableCellWithIdentifier:tifier];
    if (fCell == nil) {
        fCell = [[lhZFPayTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tifier];
    }
    
    NSArray * arr = [tArray objectAtIndex:indexPath.section];
    
    fCell.titleLabel.text = [arr objectAtIndex:indexPath.row];
    
    if (indexPath.row == 0) {
        fCell.topLine.hidden = NO;
    }
    else{
        fCell.topLine.hidden = YES;
    }
    CGRect rec = fCell.lowLine.frame;
    if (indexPath.row < arr.count-1) {
        rec.origin.x = 20*widthRate;
    }
    else{
        rec.origin.x = 0;
    }
    fCell.lowLine.frame = rec;
    
    fCell.conBtn.hidden = YES;
    fCell.yjtImgView.hidden = NO;
    
    if (indexPath.section == 1) {
        CGRect rec = fCell.titleLabel.frame;
        rec.origin.x = 45*widthRate;
        fCell.titleLabel.frame = rec;
        
        UIImageView * hImgView = [[UIImageView alloc]initWithFrame:CGRectMake(20*widthRate, 10*widthRate, 20*widthRate, 20*widthRate)];
        [fCell addSubview:hImgView];
        
        UILabel * conLabel = [[UILabel alloc] initWithFrame:CGRectMake(150*widthRate, 0, DeviceMaxWidth-180*widthRate, 40*widthRate)];
        conLabel.textAlignment = NSTextAlignmentRight;
        conLabel.textColor = [lhColor colorFromHexRGB:contentTitleColorStr1];
        conLabel.font = [UIFont systemFontOfSize:12];
        [fCell addSubview:conLabel];
        
        if (indexPath.row == 0) {
            hImgView.image = imageWithName(@"aboutWeChatIcon");
            conLabel.text = @"优品学车家族";
        }
        else{
            hImgView.image = imageWithName(@"aboutSinaIcon");
            conLabel.text = @"优品学车";
        }
    }
    
    return fCell;
}

- (void)conBtnEvent
{
    NSLog(@"a");
    [[lhColor shareColor]detailPhone:ourServicePhone];
}

#pragma mark - view
- (void)viewWillAppear:(BOOL)animated
{
    [lhColor assignmentForTempVC:self];
}

@end

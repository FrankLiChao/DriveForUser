//
//  FrankUserSetView.m
//  Drive
//
//  Created by lichao on 15/8/20.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import "FrankUserSetView.h"
#import "FrankSetView.h"
#import "UIImageView+WebCache.h"
#import "FrankEditAccountView.h"
#import "FrankLoginView.h"
#import "lhServiceAndHelpViewController.h"
#import "lhAboutUsViewController.h"
#import "lhFeedBackViewController.h"

@interface FrankUserSetView (){
    UIScrollView * maxScrollView;
    NSArray     *tabArray;//表格数据
    NSString    * urlStr;//给我评分URL
}

@end

@implementation FrankUserSetView

- (void)viewDidLoad {
    [super viewDidLoad];
    [[lhColor shareColor]originalInit:self title:@"设置" imageName:nil backButton:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    urlStr = @"";
    [self initFrameView];
}

-(void)initFrameView{
//    tabArray = @[@[@"修改绑定账号",@"清除缓存",@"给我评分"],
//                          @[@"退出登录"]];
//待修改模块
    tabArray = @[@[@"修改绑定账号"],
                 @[@"意见反馈",@"客服与帮助",@"清除缓存"],
                 @[@"给我好评",@"关于我们"]];
    maxScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, DeviceMaxWidth, DeviceMaxHeight-64)];
    maxScrollView.showsVerticalScrollIndicator = NO;
    maxScrollView.backgroundColor = [lhColor colorFromHexRGB:viewColorStr];
    [self.view addSubview:maxScrollView];
    
    CGFloat heih = 0;
    
    UITableView * sTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, heih, DeviceMaxWidth, 380*widthRate) style:UITableViewStylePlain];
    sTableView.scrollEnabled = NO;
    sTableView.delegate = self;
    sTableView.dataSource = self;
    sTableView.separatorColor = [UIColor clearColor];
    sTableView.backgroundColor = [UIColor clearColor];
    [maxScrollView addSubview:sTableView];
    
    heih += 300*widthRate;
    
    UIButton * exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    exitBtn.frame = CGRectMake(0, heih, DeviceMaxWidth, 40*widthRate);
    exitBtn.backgroundColor = [UIColor whiteColor];
    [exitBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    exitBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [exitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [exitBtn setTitleColor:[lhColor colorFromHexRGB:lineColorStr] forState:UIControlStateNormal];
    [exitBtn addTarget:self action:@selector(exitBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    [maxScrollView addSubview:exitBtn];
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 0.5)];
    lineView.backgroundColor = tableDefSepLineColor;
    [exitBtn addSubview:lineView];
    
    UIView * lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 40*widthRate-0.5, DeviceMaxWidth, 0.5)];
    lineView1.backgroundColor = tableDefSepLineColor;
    [exitBtn addSubview:lineView1];
    
    heih += 60*widthRate;
    
    NSString * str = @"Copyright ©2015-2016\n成都博晟创信科技有限公司";
    NSMutableAttributedString * as = [[NSMutableAttributedString alloc]initWithString:str];
    NSMutableParagraphStyle * ps = [[NSMutableParagraphStyle alloc]init];
    [ps setLineSpacing:6];
    [as addAttribute:NSParagraphStyleAttributeName value:ps range:NSMakeRange(0, str.length)];
    UILabel * bqLabel = [[UILabel alloc]initWithFrame:CGRectMake(10*widthRate, heih+95*widthRate, DeviceMaxWidth-20*widthRate, 60*widthRate)];
    bqLabel.numberOfLines = 2;
    bqLabel.font = [UIFont fontWithName:fontName size:12];
    bqLabel.text = str;
    bqLabel.attributedText = as;
    bqLabel.textColor = [lhColor colorFromHexRGB:contentTitleColorStr1];
    bqLabel.textAlignment = NSTextAlignmentCenter;
    [maxScrollView addSubview:bqLabel];
    
    heih += 60*widthRate;
    
    maxScrollView.contentSize = CGSizeMake(DeviceMaxWidth, heih);
}

#pragma mark - 退出登录
- (void)exitBtnEvent
{
    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定退出登录吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

#pragma mark - 清除缓存
- (void)clearTmpPics
{
    [[lhColor shareColor]removeAllImage];
    
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];
    
    [lhColor disAppearActivitiView:self.view];
    [lhColor showAlertWithMessage:@"清除缓存成功~" withSuperView:self.view withHeih:DeviceMaxHeight/2];
//    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - UITabelViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:{
            FrankEditAccountView * lVC = [[FrankEditAccountView alloc]init];
            [self.navigationController pushViewController:lVC animated:YES];
//            UINavigationController * nlVC = [[UINavigationController alloc] initWithRootViewController:lVC];
//            [self.navigationController presentViewController:nlVC animated:YES completion:^{
//                
//            }];
            break;
        }
        case 1:{
            if (indexPath.row == 0) {
                NSLog(@"意见反馈");
                lhFeedBackViewController * fbVC = [[lhFeedBackViewController alloc]init];
                [self.navigationController pushViewController:fbVC animated:YES];
            }else if (indexPath.row == 1){
                lhServiceAndHelpViewController * sahVC = [[lhServiceAndHelpViewController alloc]init];
                [self.navigationController pushViewController:sahVC animated:YES];
            }else{
                NSLog(@"清除缓存");
                [self clearTmpPics];
            }
            break;
        }
        case 2:{
            if (indexPath.row == 0) {
                urlStr = @"https://itunes.apple.com/cn/app/you-pin-xue-che/id1074223742?mt=8";
                NSLog(@"给我评分 %@",urlStr);
                if (!urlStr || [@"" isEqualToString:urlStr] || [urlStr rangeOfString:@"null"].length) {
                    [lhColor showAlertWithMessage:@"暂无链接" withSuperView:self.view withHeih:DeviceMaxHeight/2];
                }
                else if ([@"0" isEqualToString:urlStr]) {
                    [lhColor showAlertWithMessage:@"获取链接失败" withSuperView:self.view withHeih:DeviceMaxHeight/2];
                }
                else{
                    
                    [lhColor shareColor].noShowKaiChang = YES;
                    
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
                }
            }else{
                NSLog(@"关于我们");
                lhAboutUsViewController *aboutUs = [[lhAboutUsViewController alloc] init];
                [self.navigationController pushViewController:aboutUs animated:YES];
            }
            
            break;
        }
        
        default:
            break;
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    FrankLoginView *loginV = [[FrankLoginView alloc] init];
    if (buttonIndex == 1) {
        if ([lhColor shareColor].isOnLine == NO) {
//            [self.navigationController popToRootViewControllerAnimated:YES];
            [self.navigationController pushViewController:loginV animated:YES];
            return;
        }
        
        [lhColor shareColor].isOnLine = NO;
//        [self.navigationController popToRootViewControllerAnimated:YES];
        [self.navigationController pushViewController:loginV animated:YES];
        
//#warning set
        //退出登录后将自动登录时间改为当前时间
        double tim = (double)[[NSDate date]timeIntervalSince1970];
        [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithDouble:tim] forKey:autoLoginTimeFile];
        [[NSUserDefaults standardUserDefaults]synchronize];
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
    
    return tabArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray * arr = [tabArray objectAtIndex:section];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * tifier = @"sCell";
    FrankSetView * sCell = [tableView dequeueReusableCellWithIdentifier:tifier];
    if (sCell == nil) {
        sCell = [[FrankSetView alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tifier];
    }
    
    NSArray * arr = [tabArray objectAtIndex:indexPath.section];
    sCell.titleLabel.text = [arr objectAtIndex:indexPath.row];
    
    sCell.topLine.hidden = YES;
    sCell.lowLine.hidden = NO;
    
    if (indexPath.row == 0) {
        sCell.topLine.hidden = NO;
    }
    else{
        sCell.topLine.hidden = YES;
    }
    CGRect rec = sCell.lowLine.frame;
    if (indexPath.row < arr.count-1 && arr.count > 1) {
        rec.origin.x = 15*widthRate;
    }
    else{
        rec.origin.x = 0;
    }
    sCell.lowLine.frame = rec;
    
    return sCell;
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

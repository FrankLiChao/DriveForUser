//
//  lhContactUsViewController.m
//  GasStation
//
//  Created by bosheng on 16/2/3.
//  Copyright © 2016年 bosheng. All rights reserved.
//

#import "lhContactUsViewController.h"

@interface lhContactUsViewController ()

@end

@implementation lhContactUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[lhColor shareColor]originalInit:self title:@"联系我们" imageName:nil backButton:YES];
    [self firmInit];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)firmInit
{
    CGFloat heih = 64+20*widthRate;
    UILabel * companyLabel = [[UILabel alloc]initWithFrame:CGRectMake(20*widthRate, heih, DeviceMaxWidth-20*widthRate, 30*widthRate)];
    companyLabel.font = [UIFont fontWithName:fontName size:14];
    companyLabel.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
    companyLabel.text = @"成都博晟创信科技有限公司";
    [self.view addSubview:companyLabel];
    heih += 30*widthRate;
    NSArray * infoArray = @[[NSString stringWithFormat:@"电话：%@",ourServicePhone],
                            @"邮箱：bosheng@bs-innotech.com",
                            @"网址：www.up-oil.com",
                            @"地址：中国四川省成都市高新区天府三街\n地址：19号新希望国际A座21层",
                            @"商务合作：hezuo@bs-innotech.com",
                            @"简历投递：hr@bs-innotech.com"];
    for (int i = 0; i < 6; i++) {
        UILabel * infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(20*widthRate, heih, DeviceMaxWidth-20*widthRate, i==3?40*widthRate:30*widthRate)];
        
        NSString * str = [infoArray objectAtIndex:i];
        NSMutableAttributedString * as = [[NSMutableAttributedString alloc]initWithString:str];
        if (i < 4) {
            [as addAttribute:NSForegroundColorAttributeName value:[lhColor colorFromHexRGB:mainColorStr] range:NSMakeRange(3, str.length-3)];
            if (i == 3) {
                infoLabel.numberOfLines = 2;
                [as addAttribute:NSForegroundColorAttributeName value:[lhColor colorFromHexRGB:viewColorStr] range:NSMakeRange(str.length-16, 3)];
            }
            else if (i == 0){
                UITapGestureRecognizer * tapG = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureEvent:)];
                infoLabel.tag = i;
                infoLabel.userInteractionEnabled = YES;
                [infoLabel addGestureRecognizer:tapG];
            }
            else if(i == 2){
                UITapGestureRecognizer * tapG = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureEvent:)];
                infoLabel.tag = i;
                infoLabel.userInteractionEnabled = YES;
                [infoLabel addGestureRecognizer:tapG];
            }
        }
        else{
            [as addAttribute:NSForegroundColorAttributeName value:[lhColor colorFromHexRGB:mainColorStr] range:NSMakeRange(5, str.length-5)];
        }
        
        infoLabel.font = [UIFont fontWithName:fontName size:14];
        infoLabel.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
        infoLabel.attributedText = as;
        [self.view addSubview:infoLabel];
        
        heih += 30*widthRate;
        if (i == 3) {
            heih += 30*widthRate;
        }
    }
    
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake((DeviceMaxWidth-60*widthRate)/2, DeviceMaxHeight-25*widthRate, 60*widthRate, 18*widthRate)];
    logo.image = imageWithName(@"refreshLogo");
    [self.view addSubview:logo];
    
}

- (void)tapGestureEvent:(UITapGestureRecognizer *)tap_
{
    NSLog(@"adfdsaf");
    if (tap_.view.tag == 0) {
         [[lhColor shareColor]detailPhone:ourServicePhone];
    }
    else{
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://www.up-oil.com"]];
    }
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

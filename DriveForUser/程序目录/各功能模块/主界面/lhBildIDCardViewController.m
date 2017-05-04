//
//  lhBildIDCardViewController.m
//  Drive
//
//  Created by bosheng on 15/8/9.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import "lhBildIDCardViewController.h"

@interface lhBildIDCardViewController ()<UIAlertViewDelegate>
{
    UITextField * cardTextField;
}

@end

@implementation lhBildIDCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[lhColor shareColor]originalInit:self title:@"绑定身份信息" imageName:nil backButton:YES];
    
    UIImageView * inputView = [[UIImageView alloc]initWithFrame:CGRectMake(20*widthRate, 64+30*widthRate, DeviceMaxWidth-40*widthRate, 40*widthRate)];
    inputView.backgroundColor = [UIColor whiteColor];
    inputView.userInteractionEnabled = YES;
    inputView.layer.cornerRadius = 6;
    inputView.layer.masksToBounds = YES;
    [self.view addSubview:inputView];
    
    UIImageView * tellView = [[UIImageView alloc]initWithFrame:CGRectMake(10*widthRate, 12*widthRate, 20*widthRate, 16*widthRate)];
    tellView.image = imageWithName(@"bindIdCardTitle");
    [inputView addSubview:tellView];
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(40*widthRate, 2*widthRate, 0.5, 36*widthRate)];
    lineView.backgroundColor = [lhColor colorFromHexRGB:contentTitleColorStr1];
    [inputView addSubview:lineView];
    
    cardTextField = [[UITextField alloc]initWithFrame:CGRectMake(45*widthRate, 2*widthRate, 220*widthRate, 38*widthRate)];
    cardTextField.font = [UIFont fontWithName:fontName size:15];
    [cardTextField becomeFirstResponder];
    cardTextField.placeholder = @"输入身份证号进行绑定";
//    cardTextField.layer.borderColor = [UIColor blackColor].CGColor;
//    cardTextField.layer.borderWidth = 0.5;
    cardTextField.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
    [inputView addSubview:cardTextField];
    
    UIButton * nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.layer.cornerRadius = 4;
    nextButton.layer.masksToBounds = YES;
    nextButton.frame = CGRectMake(20*widthRate, 64+90*widthRate, DeviceMaxWidth-40*widthRate, 40*widthRate);
    nextButton.backgroundColor = [lhColor colorFromHexRGB:lineColorStr];
    [nextButton setTitle:@"绑定" forState:UIControlStateNormal];
    nextButton.titleLabel.font = [UIFont fontWithName:fontName size:17];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(nextButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)nextButtonEvent:(UIButton *)button_
{
    [cardTextField resignFirstResponder];
    
    if ([@"" isEqualToString:cardTextField.text]) {
        [lhColor showAlertWithMessage:@"请输入身份证号" withSuperView:self.view withHeih:DeviceMaxHeight/2];
        return;
    }
    [lhColor addActivityView:self.view];
    NSString * idStr = [NSString stringWithFormat:@"%@",[[lhColor shareColor].userInfo objectForKey:@"id"]];
    NSString * idCardNumber = cardTextField.text;
    NSDictionary * dic = @{@"id":idStr,
                           @"idCardNumber":idCardNumber};
    
    [FrankNetworkManager postReqeustWithURL:PATH(@"user/tiedIdCard") params:dic successBlock:^(id returnData){
        [lhColor disAppearActivitiView:self.view];
        if ([[returnData objectForKey:@"status"]integerValue] == 1) {
            [FrankTools showMessageWithString:@"提示" WithMessage:@"绑定成功"];
            [lhColor shareColor].userInfo = [returnData objectForKey:@"data"];
            [lhColor shareColor].isBind = YES;
        }else{
            [FrankTools requestFailAlertShow:[returnData objectForKey:@"msg"]];
        }
    } failureBlock:^(NSError *error) {
        FLLog(@"%@",error.localizedDescription);
        [FrankTools wangluoAlertShow];
        [lhColor disAppearActivitiView:self.view];
    } showHUD:NO];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.navigationController popViewControllerAnimated:YES];
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

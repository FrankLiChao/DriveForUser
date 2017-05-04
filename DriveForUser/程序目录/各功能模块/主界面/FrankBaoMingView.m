//
//  FrankBaoMingView.m
//  Drive
//
//  Created by lichao on 15/12/8.
//  Copyright © 2015年 bosheng. All rights reserved.
//

#import "FrankBaoMingView.h"
#import "lhSelectCityViewController.h"

@interface FrankBaoMingView ()<UITextFieldDelegate,UITextViewDelegate,UIAlertViewDelegate>{
    UIScrollView *myScrollView;
    
    UITextField *nameField;
    UITextField *phoneField;
    UITextField *addrField;
    
    UITextView  *contentView;
    UILabel     *cityLable;
}

@end

@implementation FrankBaoMingView

- (void)viewDidLoad {
    [super viewDidLoad];
    [[lhColor shareColor]originalInit:self title:@"报名" imageName:nil backButton:YES];
    [self initFrameView];
}

-(void)initFrameView{
    myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, DeviceMaxWidth, DeviceMaxHeight-64)];
    myScrollView.showsVerticalScrollIndicator = NO;
    myScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:myScrollView];
    
    UIView *bigView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 200*widthRate)];
    bigView.backgroundColor = [UIColor whiteColor];
    [myScrollView addSubview:bigView];
    
    CGFloat hight = 0;
    
    NSString *nameStr = @"姓名 *";
    NSMutableAttributedString * as = [[NSMutableAttributedString alloc]				  initWithString:nameStr];
    NSLog(@"nameStr.length = %ld",nameStr.length);
    [as addAttribute:NSForegroundColorAttributeName value:[lhColor colorFromHexRGB:lineColorStr] range:NSMakeRange(nameStr.length-1, 1)];
    UILabel *nameL = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, hight, 100*widthRate, 50*widthRate)];
    nameL.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
    nameL.font = [UIFont systemFontOfSize:15];
    nameL.attributedText = as;
    nameL.backgroundColor = [UIColor whiteColor];
    [bigView addSubview:nameL];
    
    nameField = [[UITextField alloc] initWithFrame:CGRectMake(150*widthRate, hight, DeviceMaxWidth-160*widthRate, 50*widthRate)];
    nameField.delegate = self;
    nameField.placeholder = @" 请输入";
    nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    nameField.font = [UIFont systemFontOfSize:15];
    nameField.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
    nameField.textAlignment = NSTextAlignmentRight;
    nameField.backgroundColor = [UIColor whiteColor];
    [bigView addSubview:nameField];
    
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, 50*widthRate-0.5, DeviceMaxWidth, 0.5)];
    lineV.backgroundColor = [lhColor colorFromHexRGB:viewColorStr];
    [bigView addSubview:lineV];
    
    hight += 50*widthRate;
    
    NSString *phoneStr = @"联系电话 *";
    NSMutableAttributedString * phoneAs = [[NSMutableAttributedString alloc]				  initWithString:phoneStr];
    [phoneAs addAttribute:NSForegroundColorAttributeName value:[lhColor colorFromHexRGB:lineColorStr] range:NSMakeRange(phoneStr.length-1, 1)];
    UILabel *phoneL = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, hight, 100*widthRate, 50*widthRate)];
    phoneL.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
    phoneL.font = [UIFont systemFontOfSize:15];
    phoneL.attributedText = phoneAs;
    phoneL.backgroundColor = [UIColor whiteColor];
    [bigView addSubview:phoneL];
    
    phoneField = [[UITextField alloc] initWithFrame:CGRectMake(150*widthRate, hight, DeviceMaxWidth-160*widthRate, 50*widthRate)];
    phoneField.delegate = self;
    phoneField.placeholder = @" 请输入";
    phoneField.clearButtonMode = UITextFieldViewModeWhileEditing;
    phoneField.font = [UIFont systemFontOfSize:15];
    phoneField.textAlignment = NSTextAlignmentRight;
    phoneField.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
    phoneField.backgroundColor = [UIColor whiteColor];
    [bigView addSubview:phoneField];
    
    UIView *lineV1 = [[UIView alloc] initWithFrame:CGRectMake(0, hight + 49.5*widthRate, DeviceMaxWidth, 0.5)];
    lineV1.backgroundColor = [lhColor colorFromHexRGB:viewColorStr];
    [bigView addSubview:lineV1];
    
    hight += 50*widthRate;
    
    NSString *cityStr = @"所在城市 *";
    NSMutableAttributedString * cityAs = [[NSMutableAttributedString alloc]				  initWithString:cityStr];
    [cityAs addAttribute:NSForegroundColorAttributeName value:[lhColor colorFromHexRGB:lineColorStr] range:NSMakeRange(cityStr.length-1, 1)];
    UILabel *cityL = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, hight, 100*widthRate, 50*widthRate)];
    cityL.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
    cityL.font = [UIFont systemFontOfSize:15];
    cityL.attributedText = cityAs;
    cityL.backgroundColor = [UIColor whiteColor];
    [bigView addSubview:cityL];
    
    cityLable = [[UILabel alloc] initWithFrame:CGRectMake(DeviceMaxWidth-100*widthRate, hight, 75*widthRate, 50*widthRate)];
    cityLable.text = @"成都";
    cityLable.font = [UIFont systemFontOfSize:15];
    cityLable.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
    cityLable.textAlignment = NSTextAlignmentRight;
    cityLable.backgroundColor = [UIColor whiteColor];
    [bigView addSubview:cityLable];
    
    UIButton *cityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cityBtn.frame = CGRectMake(0, hight, DeviceMaxWidth, 50*widthRate);
    [cityBtn addTarget:self action:@selector(citySelectEvent) forControlEvents:UIControlEventTouchUpInside];
    [bigView addSubview:cityBtn];
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(DeviceMaxWidth-20*widthRate, hight+17*widthRate, 10*widthRate, 15*widthRate)];
    [image setImage:imageWithName(@"youjiantou")];
    [myScrollView addSubview:image];
    
    UIView *lineV2 = [[UIView alloc] initWithFrame:CGRectMake(0, hight+49.5*widthRate, DeviceMaxWidth, 0.5)];
    lineV2.backgroundColor = [lhColor colorFromHexRGB:viewColorStr];
    [bigView addSubview:lineV2];
    
    hight += 50*widthRate;
    
    NSString *addrStr = @"联系地址 *";
    NSMutableAttributedString * addrAs = [[NSMutableAttributedString alloc]				  initWithString:addrStr];
    [addrAs addAttribute:NSForegroundColorAttributeName value:[lhColor colorFromHexRGB:lineColorStr] range:NSMakeRange(cityStr.length-1, 1)];
    UILabel *addrL = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, hight, 100*widthRate, 50*widthRate)];
    addrL.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
    addrL.font = [UIFont systemFontOfSize:15];
    addrL.attributedText = addrAs;
    addrL.backgroundColor = [UIColor whiteColor];
    [bigView addSubview:addrL];
    
    addrField = [[UITextField alloc] initWithFrame:CGRectMake(150*widthRate, hight, DeviceMaxWidth-160*widthRate, 50*widthRate)];
    addrField.delegate = self;
    addrField.placeholder = @" 请输入";
    addrField.clearButtonMode = UITextFieldViewModeWhileEditing;
    addrField.font = [UIFont systemFontOfSize:15];
    addrField.textAlignment = NSTextAlignmentRight;
    addrField.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
    addrField.backgroundColor = [UIColor whiteColor];
    [bigView addSubview:addrField];
    
    UIView *lineV3 = [[UIView alloc] initWithFrame:CGRectMake(0, hight+49.5*widthRate, DeviceMaxWidth, 0.5)];
    lineV3.backgroundColor = [lhColor colorFromHexRGB:viewColorStr];
    [bigView addSubview:lineV3];
    
    hight += 50*widthRate;
    
    UIView *linrV = [[UIView alloc] initWithFrame:CGRectMake(0, hight, DeviceMaxWidth, 10*widthRate)];
    linrV.backgroundColor = [lhColor colorFromHexRGB:viewColorStr];
    [bigView addSubview:linrV];
    
    hight += 30*widthRate;

//    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, hight, DeviceMaxWidth, 150*widthRate)];
//    bgView.backgroundColor = [UIColor whiteColor];
//    [bigView addSubview:bgView];
//    
//    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, 10*widthRate, 100*widthRate, 20*widthRate)];
//    lab.text = @"留言";
//    lab.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
//    lab.font = [UIFont systemFontOfSize:15];
//    [bgView addSubview:lab];
//    
//    contentView = [[UITextView alloc] initWithFrame:CGRectMake(0, 30*widthRate, DeviceMaxWidth, 120*widthRate)];
//    contentView.delegate = self;
//    contentView.text = @"想了解驾校什么内容？请输入...";
//    contentView.font = [UIFont systemFontOfSize:15];
//    contentView.textColor = [lhColor colorFromHexRGB:contentTitleColorStr1];
//    [bgView addSubview:contentView];
//    
//    hight += 150*widthRate;

    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(10*widthRate, hight, DeviceMaxWidth-20*widthRate, 40*widthRate);
    [confirmBtn setTitle:@"提交" forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirmBtn.backgroundColor = [lhColor colorFromHexRGB:lineColorStr];
    confirmBtn.layer.cornerRadius = 8;
    [confirmBtn addTarget:self action:@selector(confirmEvent) forControlEvents:UIControlEventTouchUpInside];
    [myScrollView addSubview:confirmBtn];
    
    myScrollView.contentSize = CGSizeMake(DeviceMaxWidth, hight+50*widthRate);
}

-(void)confirmEvent
{
    if ([@"" isEqualToString:nameField.text]) {
        [lhColor showAlertWithMessage:@"请输入姓名~" withSuperView:self.view withHeih:DeviceMaxHeight/2];
        return;
    }
    if ([@"" isEqualToString:phoneField.text]) {
        [lhColor showAlertWithMessage:@"请输入联系电话~" withSuperView:self.view withHeih:DeviceMaxHeight/2];
        return;
    }
    if (![[lhColor shareColor]isValidateMobile:phoneField.text]) {
        [lhColor showAlertWithMessage:@"电话号码不合法~" withSuperView:self.view withHeih:DeviceMaxHeight/2];
        return;
    }
    
    if ([@"" isEqualToString:cityLable.text]) {
        [lhColor showAlertWithMessage:@"请输入城市~" withSuperView:self.view withHeih:DeviceMaxHeight/2];
        return;
    }
    if ([@"" isEqualToString:addrField.text]) {
        [lhColor showAlertWithMessage:@"请输入联系地址~" withSuperView:self.view withHeih:DeviceMaxHeight/2];
        return;
    }
    
    [nameField resignFirstResponder];
    [phoneField resignFirstResponder];
    [addrField resignFirstResponder];
    NSDictionary * dic = @{@"accountId":[[lhColor shareColor].userInfo objectForKey:@"id"],
                           @"drivingId":[NSString stringWithFormat:@"%@",self.drivingId],
                           @"name":[NSString stringWithFormat:@"%@",nameField.text],
                           @"phone":[NSString stringWithFormat:@"%@",phoneField.text],
                           @"city":[NSString stringWithFormat:@"%@",cityLable.text],
                           @"location":[NSString stringWithFormat:@"%@",addrField.text],
                           @"question":@""};
    
    FLLog(@"%@",PATH(@"driving/application"));
    [FrankNetworkManager postReqeustWithURL:PATH(@"driving/application") params:dic successBlock:^(id returnData){
        NSLog(@"%@",returnData);
        if ([[returnData objectForKey:@"status"]integerValue] == 1) {
            [FrankTools showMessageWithString:@"提示" WithMessage:@"报名成功"];
        }else{
            [FrankTools requestFailAlertShow:[returnData objectForKey:@"msg"]];
        }
    } failureBlock:^(NSError *error) {
        FLLog(@"%@",error.localizedDescription);
        [FrankTools wangluoAlertShow];
    } showHUD:NO];
}

-(void)citySelectEvent
{
    lhSelectCityViewController * scVC = [[lhSelectCityViewController alloc]init];
    [self.navigationController pushViewController:scVC animated:YES];
}

#pragma mark -
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];    //主要是在哪调用就能把receiver对应的键盘往下收
    return YES;
}

-(void)nowCity{
    cityLable.text = [lhColor shareColor].nowCityStr;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [lhColor assignmentForTempVC:self];
    [self nowCity];
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

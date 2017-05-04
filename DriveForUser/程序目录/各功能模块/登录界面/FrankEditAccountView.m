//
//  FrankEditAccountView.m
//  Drive
//
//  Created by lichao on 16/1/15.
//  Copyright © 2016年 bosheng. All rights reserved.
//

#import "FrankEditAccountView.h"

#define maxTime 60

@interface FrankEditAccountView ()<UITextFieldDelegate>{
    BOOL isValidate;
    UITextField *nameField;
    UITextField *verifField;
    long countTimeS;
    UIButton *verifBtn;
    NSTimer *stuTimer;  //学员注册时的定时器
    NSInteger sendMark;
    NSString * lastTelStr;//发验证码时的电话号码
    NSString * validateStr;
}

@end

@implementation FrankEditAccountView

- (void)viewDidLoad {
    [super viewDidLoad];
    [[lhColor shareColor]originalInit:self title:@"修改绑定账号" imageName:nil backButton:YES];
    [self initFrameView];
}

-(void)initFrameView
{
    CGFloat hight = 0;
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, DeviceMaxWidth, DeviceMaxHeight-64)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    hight += 10*widthRate;
    
    UIImageView *nameImage = [[UIImageView alloc] initWithFrame:CGRectMake(30*widthRate, hight+10*widthRate, 20*widthRate, 20*widthRate)];
    [nameImage setImage:imageWithName(@"editName")];
    [bgView addSubview:nameImage];
    
    nameField = [[UITextField alloc]initWithFrame:CGRectMake(70*widthRate, hight, DeviceMaxWidth-100*widthRate, 40*widthRate)];
    //    [nameField becomeFirstResponder];
    nameField.keyboardType = UIKeyboardTypePhonePad;
    nameField.textColor = [lhColor colorFromHexRGB:blackForShow];
    nameField.placeholder = @"用户名为手机号码";
    nameField.delegate = self;
    nameField.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:nameField];
    
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(30*widthRate, hight + 40*widthRate, DeviceMaxWidth-60*widthRate, 0.5)];
    lineV.backgroundColor = [lhColor colorFromHexRGB:contentTitleColorStr1];
    lineV.tag = 3098;
    [bgView addSubview:lineV];
    
    hight += 60*widthRate;
    
    UIImageView *VerifImage = [[UIImageView alloc] initWithFrame:CGRectMake(30*widthRate, hight+15*widthRate, 20*widthRate, 20*widthRate)];
    [VerifImage setImage:imageWithName(@"editVacation")];
    [bgView addSubview:VerifImage];
    
    verifField = [[UITextField alloc]initWithFrame:CGRectMake(70*widthRate, hight, DeviceMaxWidth-100*widthRate, 40*widthRate)];
    //    [VerifField becomeFirstResponder];
    verifField.keyboardType = UIKeyboardTypePhonePad;
    verifField.textColor = [lhColor colorFromHexRGB:blackForShow];
    verifField.placeholder = @"输入验证码";
    verifField.delegate = self;
    verifField.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:verifField];
    
    countTimeS = maxTime-1;
    stuTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countTimeEvent) userInfo:nil repeats:YES];
    verifBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    verifBtn.frame = CGRectMake(DeviceMaxWidth-110*widthRate, hight, 80*widthRate, 40*widthRate);
    [verifBtn setTitleColor:[lhColor colorFromHexRGB:mainColorStr] forState:UIControlStateNormal];
    [verifBtn setTitleColor:[lhColor colorFromHexRGB:mainColorStr] forState:UIControlStateSelected];
    [verifBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [verifBtn setTitle:@"已发送(60)" forState:UIControlStateSelected];
    verifBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [verifBtn addTarget:self action:@selector(vaButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:verifBtn];
    
    UIView *lineVV = [[UIView alloc] initWithFrame:CGRectMake(30*widthRate, hight + 40*widthRate, DeviceMaxWidth-60*widthRate, 0.5)];
    lineVV.backgroundColor = [lhColor colorFromHexRGB:contentTitleColorStr1];
    lineVV.tag = 3099;
    [bgView addSubview:lineVV];
    
    hight += 80*widthRate;
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(30*widthRate, hight, DeviceMaxWidth-60*widthRate, 40*widthRate);
    loginBtn.backgroundColor = [lhColor colorFromHexRGB:mainColorStr];
    loginBtn.layer.cornerRadius = 20*widthRate;
    loginBtn.layer.masksToBounds = YES;
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [loginBtn setTitle:@"确认修改" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:loginBtn];
}

//登录
- (void)loginButtonEvent
{
    [self tapGEvent];
    if([@"" isEqualToString:nameField.text]) {
        [lhColor showAlertWithMessage:@"请输入电话号码" withSuperView:self.view withHeih:DeviceMaxHeight/2];
        
        return;
    }
    else if (!isValidate) {
        [lhColor showAlertWithMessage:@"请先发送验证码" withSuperView:self.view withHeih:DeviceMaxHeight/2];
        
        return;
    }
    else if([@"" isEqualToString:verifField.text]) {
        [lhColor showAlertWithMessage:@"请输入验证码" withSuperView:self.view withHeih:DeviceMaxHeight/2];
        
        return;
    }
    else if(![validateStr isEqualToString:verifField.text]){
        [lhColor showAlertWithMessage:@"验证码不正确" withSuperView:self.view withHeih:DeviceMaxHeight/2];
        
        return;
    }
    
    if (![lastTelStr isEqualToString:nameField.text]) {
        [lhColor showAlertWithMessage:@"当前手机号和发验证码的手机号不同~" withSuperView:self.view withHeih:DeviceMaxHeight/2];
        return;
    }
    
    [lhColor addActivityView:self.view];
    NSDictionary *dic = @{@"id":[[lhColor shareColor].userInfo objectForKey:@"id"],
                          @"phoneNo":nameField.text
                          };
    [FrankNetworkManager postReqeustWithURL:PATH(@"user/changePhoneNo") params:dic successBlock:^(id returnData){
        [lhColor disAppearActivitiView:self.view];
        if ([[returnData objectForKey:@"status"]integerValue] == 1) {
            [lhColor showAlertWithMessage:@"修改绑定号成功" withSuperView:self.view withHeih:DeviceMaxHeight/2];
            [self performSelector:@selector(backTo) withObject:nil afterDelay:1.5];
        }else{
            [FrankTools requestFailAlertShow:[returnData objectForKey:@"msg"]];
        }
    } failureBlock:^(NSError *error) {
        FLLog(@"%@",error.localizedDescription);
        [FrankTools wangluoAlertShow];
        [lhColor disAppearActivitiView:self.view];
    } showHUD:NO];
}

- (void)tapGEvent
{
    NSLog(@"键盘消失");
    [nameField resignFirstResponder];
    [verifField resignFirstResponder];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@""]) {
        return YES;
    }
    unichar ch = [string characterAtIndex:0];
    
    if(textField == nameField){
        if ((ch >= '0' && ch <= '9') && nameField.text.length < 11 && nameField.text.length < 11) {
            return YES;
        }
        else{
            return NO;
        }
    }
    if (textField == verifField) {
        if (verifField.text.length<6) {
            return YES;
        }else{
            return NO;
        }
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    UIView *nameLine = [self.view viewWithTag:3098];
    UIView *valiLine = [self.view viewWithTag:3099];
    if (textField == nameField) {
        nameLine.backgroundColor = [lhColor colorFromHexRGB:mainColorStr];
    }else if (textField == verifField){
        valiLine.backgroundColor = [lhColor colorFromHexRGB:mainColorStr];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    UIView *nameLine = [self.view viewWithTag:3098];
    UIView *valiLine = [self.view viewWithTag:3099];
    if (textField == nameField) {
        nameLine.backgroundColor = [lhColor colorFromHexRGB:contentTitleColorStr1];
    }else if (textField == verifField){
        valiLine.backgroundColor = [lhColor colorFromHexRGB:contentTitleColorStr1];
    }
}

- (void)backTo
{
    if (stuTimer) {
        [stuTimer invalidate];
        stuTimer = nil;
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)vaButtonEvent
{
    if (verifBtn.selected == NO) {
        
        if ([@"" isEqualToString:nameField.text]) {
            [lhColor showAlertWithMessage:@"请输入手机号" withSuperView:self.view withHeih:DeviceMaxHeight/2];
            return;
        }
        else if(![[lhColor shareColor] isValidateMobile:nameField.text]){//验证失败
            [lhColor showAlertWithMessage:@"手机号格式不正确" withSuperView:self.view withHeih:DeviceMaxHeight/2];
            
            return;
        }
    }
    
    if (sendMark == 0) {
        [lhColor addActivityView:self.view];
        NSDictionary *dic = @{@"mobile":nameField.text,
                              @"login":@"1"
                              };
        [FrankNetworkManager postReqeustWithURL:PATH(@"getVerificationCode") params:dic successBlock:^(id returnData){
            [lhColor disAppearActivitiView:self.view];
            if ([[returnData objectForKey:@"status"]integerValue] == 1) {
                lastTelStr = nameField.text;
                sendMark = 1;
                validateStr = [NSString stringWithFormat:@"%@",[[returnData objectForKey:@"data"] objectForKey:@"verCode"]];
#warning 验证码
                //        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"验证码（仅测试阶段会弹出）" message:validateStr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                //        [alertView show];
                [lhColor showAlertWithMessage:@"发送验证码成功" withSuperView:self.view withHeih:DeviceMaxHeight/2];
                isValidate = YES;
                verifBtn.selected = YES;
                [nameField resignFirstResponder];
                [verifField becomeFirstResponder];
            }else{
                [FrankTools requestFailAlertShow:[returnData objectForKey:@"msg"]];
            }
        } failureBlock:^(NSError *error) {
            FLLog(@"%@",error.localizedDescription);
            [FrankTools wangluoAlertShow];
            [lhColor disAppearActivitiView:self.view];
        } showHUD:NO];
    }
}

- (void)countTimeEvent
{
    if (verifBtn.selected == NO){
        return;
    }
    
    if (countTimeS <= 0) {
        sendMark = 0;
        verifBtn.selected = NO;
        [verifBtn setTitle:@"重新发送" forState:UIControlStateNormal];
        [verifBtn setTitle:@"已发送(60)" forState:UIControlStateSelected];
        countTimeS = maxTime-1;
    }
    else{
        sendMark = 1;
        NSString * str = [NSString stringWithFormat:@"已发送(%ld)",countTimeS];
        [verifBtn setTitle:str forState:UIControlStateSelected];
        countTimeS--;
    }
}

#pragma mark - view
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

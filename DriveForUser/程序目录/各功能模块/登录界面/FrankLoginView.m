//
//  FrankLoginView.m
//  Drive
//
//  Created by lichao on 16/1/14.
//  Copyright © 2016年 bosheng. All rights reserved.
//

#import "FrankLoginView.h"
#import "MainViewController.h"

#define maxTime 60
@interface FrankLoginView ()<UITextFieldDelegate,UIWebViewDelegate>{
    BOOL isValidate;
    NSString * validateStr;
    NSString * lastTelStr;//发验证码时的电话号码
    NSTimer *stuTimer;  //学员注册时的定时器
    
    UITextField *nameField;
    UITextField *VerifField;
    UIButton *verifBtn;
    long countTimeS;
    NSInteger roleType;
    
    NSInteger sendMark;
    
    UIView *selectV;
    BOOL   userTag;
}

@end

@implementation FrankLoginView

- (void)viewDidLoad {
    [super viewDidLoad];
//    [[lhColor shareColor]originalInit:self title:@"登录" imageName:nil backButton:YES];
    self.navigationController.navigationBar.hidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    self.view.backgroundColor = [UIColor whiteColor];
    userTag = 1;
    [self initFrameView];
}

-(void)initFrameView
{
    self.navigationController.navigationBar.hidden = YES;
    CGFloat hight = 0;
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, DeviceMaxHeight)];
    bgView.backgroundColor = [lhColor colorFromHexRGB:mainColorStr];
    [self.view addSubview:bgView];
    
    hight += 64+10*widthRate;
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake((DeviceMaxWidth-70*widthRate)/2, hight, 70*widthRate, 70*widthRate)];
    imageV.layer.cornerRadius = 35*widthRate;
    imageV.layer.masksToBounds = YES;
    [imageV setImage:imageWithName(@"defaultIcon")];
    imageV.layer.borderWidth = 0.5;
    imageV.layer.borderColor = [[UIColor whiteColor] CGColor];
    imageV.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:imageV];
    
    hight += 120*widthRate;
    
    UIImageView *nameImage = [[UIImageView alloc] initWithFrame:CGRectMake(30*widthRate, hight+12*widthRate, 20*widthRate, 20*widthRate)];
    [nameImage setImage:imageWithName(@"userNameImage")];
    [bgView addSubview:nameImage];
    
    nameField = [[UITextField alloc]initWithFrame:CGRectMake(70*widthRate, hight, DeviceMaxWidth-100*widthRate, 40*widthRate)];
    nameField.keyboardType = UIKeyboardTypePhonePad;
    nameField.textColor = [UIColor whiteColor];
    nameField.placeholder = @"用户名为手机号码";
    nameField.delegate = self;
    [nameField setValue:[lhColor colorFromHexRGB:@"8cbdf4"] forKeyPath:@"_placeholderLabel.textColor"];
    nameField.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:nameField];
    
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(30*widthRate, hight + 40*widthRate, DeviceMaxWidth-60*widthRate, 0.5)];
    lineV.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:lineV];
    
    hight += 60*widthRate;
    
    UIImageView *VerifImage = [[UIImageView alloc] initWithFrame:CGRectMake(30*widthRate, hight+12*widthRate, 20*widthRate, 20*widthRate)];
    [VerifImage setImage:imageWithName(@"telImage")];
    [bgView addSubview:VerifImage];
    
    VerifField = [[UITextField alloc]initWithFrame:CGRectMake(70*widthRate, hight, DeviceMaxWidth-100*widthRate, 40*widthRate)];
//    [VerifField becomeFirstResponder];
    VerifField.keyboardType = UIKeyboardTypePhonePad;
    VerifField.textColor = [UIColor whiteColor];
    VerifField.placeholder = @"输入验证码";
    [VerifField setValue:[lhColor colorFromHexRGB:@"8cbdf4"] forKeyPath:@"_placeholderLabel.textColor"];
    VerifField.delegate = self;
    VerifField.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:VerifField];
    
    countTimeS = maxTime-1;
    stuTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countTimeEvent) userInfo:nil repeats:YES];
    verifBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    verifBtn.frame = CGRectMake(DeviceMaxWidth-110*widthRate, hight, 80*widthRate, 40*widthRate);
    [verifBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [verifBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [verifBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [verifBtn setTitle:@"已发送(60)" forState:UIControlStateSelected];
    verifBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [verifBtn addTarget:self action:@selector(vaButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:verifBtn];
    
    UIView *lineVV = [[UIView alloc] initWithFrame:CGRectMake(30*widthRate, hight + 40*widthRate, DeviceMaxWidth-60*widthRate, 0.5)];
    lineVV.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:lineVV];
    
    hight += 60*widthRate;
    
    selectV = [[UIView alloc] initWithFrame:CGRectMake(0, hight, DeviceMaxWidth, 50*widthRate)];
    selectV.backgroundColor = [lhColor colorFromHexRGB:mainColorStr];
    selectV.hidden = YES;
    selectV.clipsToBounds = YES;
    [bgView addSubview:selectV];
    
    UILabel *selectL = [[UILabel alloc] initWithFrame:CGRectMake(40*widthRate, 0, DeviceMaxWidth-50*widthRate, 20*widthRate)];
    selectL.font = [UIFont systemFontOfSize:13];
    selectL.text = @"请问您是教练还是学员？";
    selectL.textColor = [UIColor whiteColor];
    [selectV addSubview:selectL];
    
    UIImageView *stuImage = [[UIImageView alloc] initWithFrame:CGRectMake(60*widthRate, 29*widthRate, 12*widthRate, 12*widthRate)];
    stuImage.tag = 2015;
    [stuImage setImage:imageWithName(@"coachOrNot_No")];
    [selectV addSubview:stuImage];
    
    UILabel *stuL = [[UILabel alloc] initWithFrame:CGRectMake(80*widthRate, 25*widthRate, 80*widthRate, 20*widthRate)];
    stuL.text = @"我是学员";
    stuL.font = [UIFont systemFontOfSize:15];
    stuL.textColor = [UIColor whiteColor];
    [selectV addSubview:stuL];
    
    UIButton *studentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    studentBtn.frame = CGRectMake(30*widthRate, 20*widthRate, 120*widthRate, 40*widthRate);
    [studentBtn addTarget:self action:@selector(clickSelectStudent:) forControlEvents:UIControlEventTouchUpInside];
    [selectV addSubview:studentBtn];
    
    UIImageView *coachImage = [[UIImageView alloc] initWithFrame:CGRectMake(180*widthRate, 29*widthRate, 12*widthRate, 12*widthRate)];
    coachImage.tag = 2016;
    [coachImage setImage:imageWithName(@"coachOrNot_No")];
    [selectV addSubview:coachImage];
    
    UILabel *coachL = [[UILabel alloc] initWithFrame:CGRectMake(200*widthRate, 25*widthRate, 80*widthRate, 20*widthRate)];
    coachL.text = @"我是教练";
    coachL.font = [UIFont systemFontOfSize:15];
    coachL.textColor = [UIColor whiteColor];
    [selectV addSubview:coachL];
    
    UIButton *coachBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    coachBtn.frame = CGRectMake(170*widthRate, 20*widthRate, 120*widthRate, 40*widthRate);
    [coachBtn addTarget:self action:@selector(clickSelectCoach:) forControlEvents:UIControlEventTouchUpInside];
    [selectV addSubview:coachBtn];
    
    hight += 80*widthRate;
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(30*widthRate, hight, DeviceMaxWidth-60*widthRate, 40*widthRate);
    loginBtn.backgroundColor = [UIColor whiteColor];
    loginBtn.layer.cornerRadius = 20*widthRate;
    loginBtn.layer.masksToBounds = YES;
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[lhColor colorFromHexRGB:mainColorStr] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:loginBtn];
    
    hight += 45*widthRate;
    
    UIButton * aReadLabel = [[UIButton alloc]initWithFrame:CGRectMake(40*widthRate, hight, 120, 30)];
    aReadLabel.userInteractionEnabled = NO;
    [aReadLabel setTitle:@"登录即表示您同意" forState:UIControlStateNormal];
    [aReadLabel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    aReadLabel.titleLabel.font = [UIFont fontWithName:fontName size:12];
    [aReadLabel sizeToFit];
    [bgView addSubview:aReadLabel];
    
    UIButton * btn1 = [[UIButton alloc]initWithFrame:CGRectMake(40*widthRate + aReadLabel.frame.size.width+1, hight, 150, 30)];
//    [btn1 setTitleColor:[lhColor colorFromHexRGB:@"4A708B"] forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn1.titleLabel.font = [UIFont fontWithName:fontName size:12];
    [btn1 setTitle:@"《使用规则与服务协议》" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(btn1Event) forControlEvents:UIControlEventTouchUpInside];
    [btn1 sizeToFit];
    [bgView addSubview:btn1];
}

#pragma mark - 服务条款及隐私政策
- (void)btn1Event
{
    
    for (UIView * view in self.view.subviews){
        view.userInteractionEnabled = NO;
    }
    
    UIView * webViewMax = [[UIView alloc]initWithFrame:CGRectMake(0, DeviceMaxHeight, DeviceMaxWidth, DeviceMaxHeight)];
    webViewMax.tag = 111;
    [self.view addSubview:webViewMax];
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 64)];
    imageView.userInteractionEnabled = YES;
    [webViewMax addSubview:imageView];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(2, 20, 60, 44);
    btn.titleLabel.font = [UIFont fontWithName:fontName size:14];
    [btn setTitle:@"取 消" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(cancelBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [webViewMax addSubview:btn];
    
    UIWebView * webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, DeviceMaxWidth, DeviceMaxHeight-64)];
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://up-driving.com/f/agreement"]];
    webView.delegate = self;
    [webView loadRequest:urlRequest];
    webView.scalesPageToFit = YES;
    [webViewMax addSubview:webView];
    
    [UIView animateWithDuration:0.3 animations:^{
        webViewMax.frame = CGRectMake(0, 0, DeviceMaxWidth, DeviceMaxHeight);
    }completion:^(BOOL finished) {
        imageView.backgroundColor = [lhColor colorFromHexRGB:mainColorStr];
    }];
}

- (void)cancelBtnEvent:(UIButton *)btn
{
    for (UIView * view in self.view.subviews){
        view.userInteractionEnabled = YES;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        btn.superview.frame = CGRectMake(0, DeviceMaxHeight, DeviceMaxWidth, DeviceMaxHeight);
    }completion:^(BOOL finished) {
        [btn.superview removeFromSuperview];
    }];
    
}

//登录
- (void)loginButtonEvent
{
    [self tapGEvent];
    if (roleType == 0 && userTag == 1) {
        [lhColor showAlertWithMessage:@"请选择登录角色" withSuperView:self.view withHeih:DeviceMaxHeight/2];
        return;
    }
    if([@"" isEqualToString:nameField.text]) {
        [lhColor showAlertWithMessage:@"请输入电话号码" withSuperView:self.view withHeih:DeviceMaxHeight/2];
        
        return;
    }
    else if (!isValidate) {
        [lhColor showAlertWithMessage:@"请先发送验证码" withSuperView:self.view withHeih:DeviceMaxHeight/2];
        
        return;
    }
    else if([@"" isEqualToString:VerifField.text]) {
        [lhColor showAlertWithMessage:@"请输入验证码" withSuperView:self.view withHeih:DeviceMaxHeight/2];
        
        return;
    }
    else if(![validateStr isEqualToString:VerifField.text]){
        [lhColor showAlertWithMessage:@"验证码不正确" withSuperView:self.view withHeih:DeviceMaxHeight/2];
        
        return;
    }
    
    if (![lastTelStr isEqualToString:nameField.text]) {
        [lhColor showAlertWithMessage:@"当前手机号和发验证码的手机号不同~" withSuperView:self.view withHeih:DeviceMaxHeight/2];
        return;
    }
    
    [lhColor addActivityView:self.view];
    NSDictionary *dic = @{@"loginId":nameField.text,
                          @"mark":@"apple",
                          @"token":[lhColor shareColor].realToken,
                          @"type":[NSString stringWithFormat:@"%ld",roleType]};
    
    [FrankNetworkManager postReqeustWithURL:PATH(@"login") params:dic successBlock:^(id returnData){
        [lhColor disAppearActivitiView:self.view];
        if ([[returnData objectForKey:@"status"]integerValue] == 1) {
            [lhColor showAlertWithMessage:@"登录成功" withSuperView:self.view withHeih:DeviceMaxHeight/2];
            [self performSelector:@selector(backTo) withObject:nil afterDelay:0.5];
            
            [lhColor shareColor].userInfo = [NSMutableDictionary dictionaryWithDictionary:[returnData objectForKey:@"data"]];
            [lhColor shareColor].isBind = [[[returnData objectForKey:@"data"] objectForKey:@"isBind"] integerValue];
            [lhColor shareColor].isOnLine = YES;
            [lhColor shareColor].mapId = [[returnData objectForKey:@"data"]  objectForKey:@"mapId"];
            //本地化登陆用户
            NSString * typeStr = [NSString stringWithFormat:@"%@",[[lhColor shareColor].userInfo objectForKey:@"type"]];
            [[NSUserDefaults standardUserDefaults]setObject:@{@"phone":[[lhColor shareColor].userInfo objectForKey:@"phone"],@"type":typeStr} forKey:saveLoginInfoFile];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            //登陆成功后延长自动登陆时间,30天
            double tim = (double)[[NSDate date]timeIntervalSince1970]+3600*24*30;
            [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithDouble:tim] forKey:autoLoginTimeFile];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }else{
            [FrankTools requestFailAlertShow:[returnData objectForKey:@"msg"]];
        }
    } failureBlock:^(NSError *error) {
        FLLog(@"%@",error.localizedDescription);
        [FrankTools wangluoAlertShow];
        [lhColor disAppearActivitiView:self.view];
    } showHUD:NO];
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

#pragma mark - 计时器
#pragma mark - 发送验证码
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
                userTag = [[[returnData objectForKey:@"data"] objectForKey:@"newUser"] integerValue];
                if (userTag) {
                    selectV.hidden = NO;
                }else{
                    selectV.hidden = YES;
                    [selectV removeFromSuperview];
                    selectV = nil;
                }
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
                [VerifField becomeFirstResponder];
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
    if (textField == VerifField) {
        if (VerifField.text.length<6) {
            return YES;
        }else{
            return NO;
        }
    }
    
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self tapGEvent];
}

- (void)tapGEvent
{
    NSLog(@"键盘消失");
    [nameField resignFirstResponder];
    [VerifField resignFirstResponder];
}

- (void)backTo
{
    if (stuTimer) {
        [stuTimer invalidate];
        stuTimer = nil;
    }
    MainViewController *rootV = [[MainViewController alloc] init];
    UINavigationController * nmVC = [[UINavigationController alloc] initWithRootViewController:rootV];
    [lhColor shareColor].delegateWindow.rootViewController = nmVC;
    [nmVC.navigationController pushViewController:rootV animated:YES];
}

-(void)clickSelectStudent:(UIButton *)button_{
    UIImageView *stuImage = (UIImageView *)[self.view viewWithTag:2015];
    UIImageView *coaImage = (UIImageView *)[self.view viewWithTag:2016];
    if (button_.selected) {
        button_.selected = NO;
        [stuImage setImage:imageWithName(@"coachOrNot_No")];
    }else{
        button_.selected = YES;
        roleType = 1;
        [stuImage setImage:imageWithName(@"coachOrNot_Yes")];
        [coaImage setImage:imageWithName(@"coachOrNot_No")];
    }
}

-(void)clickSelectCoach:(UIButton *)button_{
    UIImageView *stuImage = (UIImageView *)[self.view viewWithTag:2015];
    UIImageView *coachImage = (UIImageView *)[self.view viewWithTag:2016];
    if (button_.selected) {
        button_.selected = NO;
        [coachImage setImage:imageWithName(@"coachOrNot_No")];
    }else{
        button_.selected = YES;
        roleType = 2;
        [coachImage setImage:imageWithName(@"coachOrNot_Yes")];
        [stuImage setImage:imageWithName(@"coachOrNot_No")];
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

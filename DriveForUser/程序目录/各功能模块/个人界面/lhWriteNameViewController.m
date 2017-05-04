//
//  lhWriteNameViewController.m
//  GasStation
//
//  Created by bosheng on 15/11/9.
//  Copyright © 2015年 bosheng. All rights reserved.
//

#import "lhWriteNameViewController.h"

#define maxTextCount 12

@interface lhWriteNameViewController ()<UITextFieldDelegate>
{
    UITextField * nTextField;//写签名textView
    
//    UILabel * countLabel;//字数显示
}

@property (nonatomic,strong)NSString * oldNameStr;

@end

@implementation lhWriteNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[lhColor shareColor]originalInit:self title:@"昵称" imageName:nil backButton:YES];
    
    UIButton * saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveButton.titleLabel.font = [UIFont fontWithName:fontName size:15];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:15];
    saveButton.frame = CGRectMake(DeviceMaxWidth-62, 22, 60, 44);
    [saveButton addTarget:self action:@selector(saveButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveButton];
    
    [self firmInit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 保存
- (void)saveButtonEvent
{
    if (![nTextField.text isEqualToString:self.oldNameStr] && ![@"" isEqualToString:nTextField.text]) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"mergeNameEvent" object:nil userInfo:@{@"content":nTextField.text}];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [nTextField resignFirstResponder];
}

#pragma mark - 界面初始化
- (void)firmInit
{

    UIView * whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 64+20*widthRate, DeviceMaxWidth, 40*widthRate)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteView];
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 0.5)];
    lineView.backgroundColor = [lhColor colorFromHexRGB:contentTitleColorStr1];
    [whiteView addSubview:lineView];
    
    UIView * lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 40*widthRate, DeviceMaxWidth, 0.5)];
    lineView1.backgroundColor = [lhColor colorFromHexRGB:contentTitleColorStr1];
    [whiteView addSubview:lineView1];
    
    nTextField = [[UITextField alloc]initWithFrame:CGRectMake(5*widthRate, 0, DeviceMaxWidth-10*widthRate, 40*widthRate)];
    nTextField.clearButtonMode = UITextFieldViewModeAlways;
    nTextField.placeholder = @"请输入您的昵称";
    nTextField.returnKeyType = UIReturnKeyDone;
    nTextField.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
    nTextField.font = [UIFont fontWithName:fontName size:15];
    nTextField.returnKeyType = UIReturnKeyDone;
    nTextField.delegate = self;
    [whiteView addSubview:nTextField];
    
    NSString * birStr = [NSString stringWithFormat:@"%@",[[lhColor shareColor].userInfo objectForKey:@"nickname"]];
    if (birStr && birStr.length > 0 && ![@"(null)" isEqualToString:birStr]) {
        nTextField.text = birStr;
        
        self.oldNameStr = nTextField.text;
    }
    
//    NSString * stt = [NSString stringWithFormat:@"%ld",(long)maxTextCount-nTextField.text.length];
//    countLabel = [[UILabel alloc]initWithFrame:CGRectMake(2*widthRate, 64+65*widthRate, DeviceMaxWidth-24*widthRate, 20*widthRate)];
//    countLabel.textColor = [lhColor colorFromHexRGB:lineColorStr];
//    countLabel.text = stt;
//    countLabel.textAlignment = NSTextAlignmentRight;
//    countLabel.font = [UIFont fontWithName:nowFontName size:10];
//    [self.view addSubview:countLabel];
    
}

#pragma mark - UITextViewDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    [self performSelector:@selector(textFieldDidChange) withObject:nil afterDelay:0.1];
    
    return YES;
}

- (void)textFieldDidChange
{
    if (nTextField.text.length > maxTextCount) {
        nTextField.text = [nTextField.text substringToIndex:maxTextCount];
    }
    
//    NSString * str = [NSString stringWithFormat:@"%ld",(long)maxTextCount-nTextField.text.length];
//    countLabel.text = str;
}

#pragma mark - view
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [lhColor assignmentForTempVC:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    [nTextField becomeFirstResponder];
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

//
//  lhFeedBackViewController.m
//  AdsProduct
//
//  Created by 叶华英 on 15-3-31.
//  Copyright (c) 2015年 tangdizhu. All rights reserved.
//

#import "lhFeedBackViewController.h"
#import "UIImage+Cut.h"

//typedef NS_ENUM(NSInteger, addBtnType){
//    Btn_Add = 1,
//    Btn_Delete,
//};

@interface lhFeedBackViewController ()<UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>
{
    UITextView * feedTextView;
    UILabel * placeHolder;
    
//    UIButton * addBtn;
//    
//    NSInteger currentType_;
//    UIImage * tempImg;//选择的图片
//    BOOL hasAPic;//是否有图片
//    UIImageView * delBtn;//删除图片图标
}

@end

@implementation lhFeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [[lhColor shareColor]originalInit:self title:@"意见反馈" imageName:nil backButton:YES];
    
    [self firmInit];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - firmInit
- (void)firmInit
{
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 20, 70, 44);
    [backButton addTarget:self action:@selector(backButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    UIButton * sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendButton setTitle:@"提交" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sendButton.titleLabel.font = [UIFont fontWithName:fontName size:15];
    sendButton.titleLabel.font = [UIFont systemFontOfSize:15];
    sendButton.frame = CGRectMake(DeviceMaxWidth-62, 22, 60, 44);
    [sendButton addTarget:self action:@selector(sendButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendButton];
    
    CGFloat heih = 64+20*widthRate;
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10*widthRate, heih, 300*widthRate, 20*widthRate)];
    titleLabel.text = @"请输入您的宝贵意见:";
    titleLabel.font = [UIFont fontWithName:fontName size:14];
    titleLabel.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
    [self.view addSubview:titleLabel];
    
    heih += 25*widthRate;
    
    feedTextView = [[UITextView alloc]initWithFrame:CGRectMake(10*widthRate, heih, 300*widthRate, 80*widthRate)];
    feedTextView.delegate = self;
    feedTextView.font = [UIFont fontWithName:fontName size:14];
    feedTextView.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
    [self.view addSubview:feedTextView];
    
    placeHolder = [[UILabel alloc]initWithFrame:CGRectMake(10*widthRate, heih, 300*widthRate, 30*widthRate)];
    placeHolder.text = @"请输入";
    placeHolder.font = [UIFont fontWithName:fontName size:14];
    placeHolder.textColor = [UIColor colorWithRed:200.0/255 green:200.0/255 blue:200.0/255 alpha:1];
    [self.view addSubview:placeHolder];
    
//    heih += 85*widthRate;
//    
//    addBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//    addBtn.frame = CGRectMake(12.5*widthRate, heih, 95*widthRate, 95*widthRate);
//    [addBtn setBackgroundImage:imageWithName(@"fabushaidanaddonepic.png") forState:UIControlStateNormal];
//    addBtn.tag = Btn_Add;
//    [addBtn addTarget:self action:@selector(addBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:addBtn];
    
}

- (void)backButtonEvent
{

    if (![@"" isEqualToString:feedTextView.text]) {
        UIAlertView * alertV = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还没发送，返回该信息将不会保存！" delegate:self cancelButtonTitle:@"返回上一级" otherButtonTitles:@"继续编辑", nil];
        alertV.tag = 2;
        [alertV show];
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [feedTextView resignFirstResponder];
}


//- (void)addBtnEvent:(UIButton *)button_
//{
//    [feedTextView resignFirstResponder];
//    
//    if (button_.tag == Btn_Add) {//添加图片
//        UIActionSheet * actionSheet = [[UIActionSheet alloc]initWithTitle:@"选择图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照上传",@"相册选取", nil];
//        actionSheet.tag = 2;
//        [actionSheet showInView:self.view];
//    }
//    else if(button_.tag == Btn_Delete){//已选择图片
//        [delBtn removeFromSuperview];
//        delBtn = nil;
//        hasAPic = NO;
//        addBtn.tag = Btn_Add;
//        [addBtn setBackgroundImage:imageWithName(@"fabushaidanaddonepic.png") forState:UIControlStateNormal];
//    }
//}

//#pragma mark - UIActionSheetViewDelegate
//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    [self takePhotoAndVidoeWithIndex:buttonIndex];
//}
//
//#pragma mark - 上传头像
//- (void)takePhotoAndVidoeWithIndex:(NSInteger)index
//{
//    currentType_ = index;
//    
//    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) { //判断设备是否支持相册
//        
//        if (IOS8) {
//            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"未开启访问相册权限，现在去开启！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//            alert.tag = 4;
//            [alert show];
//        }
//        else{
//            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"设备不支持访问相册，请在设置->隐私->照片中进行设置！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert show];
//        }
//        
//        return;
//    }
//    
//    UIImagePickerController * mpic = [[UIImagePickerController alloc]init];
//    
//    switch (index) {
//        case 0:{
//            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该设备没有相机！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                [alert show];
//                
//                return;
//            }
//            mpic.sourceType = UIImagePickerControllerSourceTypeCamera;
//            break;
//        }
//            break;
//        case 1:{
//            mpic.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
//        }
//            break;
//            
//        default:
//            break;
//    }
//    if (index < 2) {
//        mpic.delegate = self;
//        mpic.allowsEditing = YES;//是否允许编辑照片
//        mpic.mediaTypes = [NSArray arrayWithObjects:@"public.image", nil];//只可看见相册中的照片
//        [self presentViewController:mpic animated:YES completion:^{
//        }];
//    }
//    
//}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 4 && buttonIndex == 1){
        [lhColor shareColor].noShowKaiChang = YES;
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
    else if(alertView.tag == 2 && buttonIndex == 0){
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if(alertView.tag == 5){
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

//#pragma mark - imagePickerDelegate
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info //选取成功
//{
//    
//    UIImage * img;
//    if (currentType_ == 1) {
//        img = [info objectForKey:UIImagePickerControllerEditedImage];
//    }
//    if (currentType_ == 0) {
//        img = [info objectForKey:UIImagePickerControllerEditedImage];
//        UIImageWriteToSavedPhotosAlbum([info objectForKey:UIImagePickerControllerEditedImage], self, @selector(image:didFinishSavingWithError:contextInfo:),@"finish");//把照片存储到相册中
//    }
//    
//    tempImg = img;
//    hasAPic = YES;
//    addBtn.tag = Btn_Delete;
//    [addBtn setBackgroundImage:[tempImg clipImageWithScaleWithsizeWithzheng:CGSizeMake(285*widthRate, 285*widthRate)] forState:UIControlStateNormal];
//    
//    delBtn = [[UIImageView alloc]initWithFrame:CGRectMake(70*widthRate, 0, 25*widthRate, 25*widthRate)];
//    delBtn.image = imageWithName(@"fabushaidandelete.png");
//    [addBtn addSubview:delBtn];
//    
//    [self dismissViewControllerAnimated:YES completion:^{
//        
//    }];
//}
//
////固定的视频存储完成之后调用的方法
//- (void)video: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo{
//    
//    //NSLog(@"视频存储完成");
//}
//
////固定的图片存储完成之后调用的方法
//- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo{
//    
//    //NSLog(@"图片存储完成");
//}
//
//- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker//选取图片失败或取消
//{
//    [self dismissViewControllerAnimated:YES completion:^{
//    }];
//}
//
//
//- (void)uploadPhotoEvent:(NSNotification *)noti
//{
//    //NSLog(@"上传头像结果 %@",noti.userInfo);
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:noti.name object:nil];
//    if (!noti.userInfo || [noti.userInfo class] == [[NSNull alloc]class]) {
//        
//        [lhColor disAppearActivitiView:self.view];
//        [lhColor wangluoAlertShow];
//    }
//    if ([[noti.userInfo objectForKey:@"flag"]integerValue] == 1) {
//        
//        NSString * picStr = [noti.userInfo objectForKey:@"data"];
//        
//        [self sendFeedBackContent:feedTextView.text withPicture:picStr];
//    }
//    
//}

#pragma mark - 发送意见反馈
- (void)sendButtonEvent
{
    if ([@"" isEqualToString:feedTextView.text]) {
        [lhColor showAlertWithMessage:@"请编辑反馈信息~" withSuperView:self.view withHeih:DeviceMaxHeight/2];
        
        return;
    }
    
//    if(hasAPic){//有图片
//        [lhColor addActivityView:self.view];
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(uploadPhotoEvent:) name:@"uploadPhoto" object:nil];
//        NSDictionary * _params = @{@"imgFile":@"aa.jpg"};
//        NSData * imgData = UIImageJPEGRepresentation(tempImg, 0.5);
//        [[lhWeb alloc]uploadPhoto:@"uploadApp/feedback.do" params:[NSMutableDictionary dictionaryWithDictionary:_params] serviceName:@"imgFile" NotiName:@"uploadPhoto" imageD:imgData];
//    }
//    else{
//        [lhColor addActivityView:self.view];
        [self sendFeedBackContent:feedTextView.text withPicture:@""];
//    }
    
}

//发送内容
- (void)sendFeedBackContent:(NSString *)contentStr withPicture:(NSString *)picStr
{

    [lhColor addActivityView123:self.view];
    NSDictionary * dic = @{@"id":[[lhColor shareColor].userInfo objectForKey:@"id"],
                           @"content":contentStr};
    NSLog(@"dic = %@",dic);
    
    [FrankNetworkManager postReqeustWithURL:PATH(@"system/feedback") params:dic successBlock:^(id returnData){
        [lhColor disAppearActivitiView:self.view];
        if ([[returnData objectForKey:@"status"]integerValue] == 1) {
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您的反馈我们已经收到~谢谢~" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            alertView.tag = 5;
            [alertView show];
            
            feedTextView.text = @"";
        }else{
            [FrankTools requestFailAlertShow:[returnData objectForKey:@"msg"]];
        }
    } failureBlock:^(NSError *error) {
        FLLog(@"%@",error.localizedDescription);
        [FrankTools wangluoAlertShow];
        [lhColor disAppearActivitiView:self.view];
    } showHUD:NO];
}

- (void)backTo
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    placeHolder.hidden = YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([@"" isEqualToString:textView.text]) {
        placeHolder.hidden = NO;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}

#pragma mark - view
- (void)viewWillAppear:(BOOL)animated
{
    [lhColor assignmentForTempVC:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    [feedTextView becomeFirstResponder];
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

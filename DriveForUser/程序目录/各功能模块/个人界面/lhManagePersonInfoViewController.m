//
//  lhManagePersonInfoViewController.m
//  GasStation
//
//  Created by bosheng on 15/9/2.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import "lhManagePersonInfoViewController.h"
#import "lhSelectCityViewController.h"
#import "lhWriteNameViewController.h"
#import "lhBildIDCardViewController.h"

#import "UIImageView+WebCache.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"

#define nameMaxNum 12

@interface lhManagePersonInfoViewController ()<UIActionSheetDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIScrollView * maxScrollView;
    
    UITextField * nTextField;//昵称
    UIButton * sexButton;//性别
    UIButton * qmButton;
    
    UITextField * myOilNum;//油号
    UITextField * myCarNum;//车牌
    UITextField * myFaPiaoTitle;//发票抬头
    
    //头像上传
    UIImageView * headImageView;//头像
    NSInteger currentType_;//上传头像类型
    UIImage * tempImg;//从相册选择的头像图片
    NSString * headStr;//头像连接
}

@end

@implementation lhManagePersonInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[lhColor shareColor]originalInit:self title:@"个人信息" imageName:nil backButton:YES];

//    UIButton * saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
//    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    saveButton.titleLabel.font = [UIFont fontWithName:nowFontName size:15];
//    saveButton.titleLabel.font = [UIFont systemFontOfSize:15];
//    saveButton.frame = CGRectMake(260*widthRate, 22, 60*widthRate, 40);
//    [saveButton addTarget:self action:@selector(saveButtonEvent) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:saveButton];
    
    maxScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, DeviceMaxWidth, DeviceMaxHeight-64)];
    maxScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:maxScrollView];
    
    //初始化
    [self firmLabel];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 初始化，不用刷新控件
- (void)firmLabel
{
    NSArray * tArray = nil;
    if ([[[lhColor shareColor].userInfo objectForKey:@"type"] integerValue]== 1) {
        tArray = @[@"头像",@"昵称",@"性别",@"区域",@"身份证号",@"用户编号",@"注册时间"];
    }else if ([[[lhColor shareColor].userInfo objectForKey:@"type"] integerValue]== 2){
        tArray = @[@"头像",@"姓名",@"性别",@"区域",@"身份证号",@"用户编号",@"注册时间"];
    }
    CGFloat heih = 0;
    for (int i = 0; i < tArray.count; i++) {
        UIView * wBgView = [[UIView alloc]initWithFrame:CGRectMake(0, heih, DeviceMaxWidth, i==0?87*widthRate:52*widthRate)];
        wBgView.backgroundColor = [UIColor whiteColor];
        [maxScrollView addSubview:wBgView];
        
        UIView * lineV = [[UIView alloc]initWithFrame:CGRectMake(0, wBgView.frame.size.height-0.5, DeviceMaxWidth, 0.5)];
        lineV.backgroundColor = glineColor;
        [wBgView addSubview:lineV];
        
        UILabel * tLabel = [[UILabel alloc]initWithFrame:CGRectMake(15*widthRate, 0, 100*widthRate, wBgView.frame.size.height)];
        tLabel.font = [UIFont fontWithName:fontName size:16];
        tLabel.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
        tLabel.text = [tArray objectAtIndex:i];
        [wBgView addSubview:tLabel];
        
        if (i == 0) {
            
            UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureEvent)];
            headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(245*widthRate, 14*widthRate, 60*widthRate, 60*widthRate)];
//            [headImageView setImage:imageWithName(@"defaultHead")];
            headImageView.layer.cornerRadius = 30*widthRate;
            headImageView.layer.allowsEdgeAntialiasing = YES;
            headImageView.layer.masksToBounds = YES;
            [headImageView addGestureRecognizer:tapGesture];
            headImageView.userInteractionEnabled = YES;
            headImageView.image = self.headImg;
            if (self.headImg == nil) {
                [headImageView setImage:imageWithName(@"defaultHead")];
            }
            NSLog(@"self.headImg = %@",self.headImg);
            
            
            [wBgView addSubview:headImageView];
        }
        else if(i == 1){
            
            NSString * userName = [NSString stringWithFormat:@"%@",[[lhColor shareColor].userInfo objectForKey:@"name"]];
            if (userName && userName.length > 0 && ![@"(null)" isEqualToString:userName]) {
                
            }
            else{
                userName = @"待完善";
            }
            
            nTextField = [[UITextField alloc]initWithFrame:CGRectMake(120*widthRate, 0, 190*widthRate, wBgView.frame.size.height)];
            nTextField.font = [UIFont fontWithName:fontName size:14];
            nTextField.textColor = [lhColor colorFromHexRGB:contentTitleColorStr1];
            nTextField.returnKeyType = UIReturnKeyDone;
            nTextField.delegate = self;
            nTextField.text = userName;
            nTextField.textAlignment = NSTextAlignmentRight;
            [wBgView addSubview:nTextField];
        }
        else if(i == 2){
            NSString * gender = [NSString stringWithFormat:@"%@",[[lhColor shareColor].userInfo objectForKey:@"gender"]];
            if (gender && gender.length > 0 && ![@"(null)" isEqualToString:gender]) {
                if ([@"0" isEqualToString:gender]) {
                    gender = @"男";
                }
                else{
                    gender = @"女";
                }
            }
            else{
                gender = @"待完善";
            }
            
            sexButton = [UIButton buttonWithType:UIButtonTypeCustom];
            sexButton.titleLabel.font = [UIFont fontWithName:fontName size:14];
            [sexButton setTitleColor:[lhColor colorFromHexRGB:contentTitleColorStr1] forState:UIControlStateNormal];
            [sexButton setTitle:gender forState:UIControlStateNormal];
            [sexButton sizeToFit];
            sexButton.frame = CGRectMake(DeviceMaxWidth-sexButton.frame.size.width-20*widthRate, 0, sexButton.frame.size.width+20*widthRate, wBgView.frame.size.height);
            [sexButton addTarget:self action:@selector(sexButtonEvent) forControlEvents:UIControlEventTouchUpInside];
            [wBgView addSubview:sexButton];
            
        }
        else if(i == 3){//区域
            NSString * birStr = [NSString stringWithFormat:@"%@",[lhColor shareColor].nowCityStr];
            if (birStr && birStr.length > 0 && ![@"(null)" isEqualToString:birStr]) {
                
            }
            else{
                birStr = @"定位失败";
            }
            qmButton = [UIButton buttonWithType:UIButtonTypeCustom];
            qmButton.titleLabel.font = [UIFont fontWithName:fontName size:14];
            [qmButton setTitleColor:[lhColor colorFromHexRGB:contentTitleColorStr1] forState:UIControlStateNormal];
            [qmButton setTitle:birStr forState:UIControlStateNormal];
            [qmButton sizeToFit];
            qmButton.frame = CGRectMake(DeviceMaxWidth-qmButton.frame.size.width-20*widthRate, 0, qmButton.frame.size.width+20*widthRate, wBgView.frame.size.height);
            if (qmButton.frame.size.width > 190*widthRate) {
                qmButton.frame = CGRectMake(120*widthRate, 0, 190*widthRate, 52*widthRate);
            }
            [qmButton addTarget:self action:@selector(qmButtonEvent) forControlEvents:UIControlEventTouchUpInside];
            [wBgView addSubview:qmButton];
            
        }
        else if(i == 4){//身份证号
            NSString * oilTypeStr = [NSString stringWithFormat:@"%@",[[lhColor shareColor].userInfo objectForKey:@"idCard"]];
            if (![@"" isEqualToString:oilTypeStr] && ![oilTypeStr rangeOfString:@"null"].length) {
            }
            else{
                oilTypeStr = @"尚未绑定";
            }
            
            myOilNum = [[UITextField alloc]initWithFrame:CGRectMake(120*widthRate, 0, 190*widthRate, wBgView.frame.size.height)];
            myOilNum.font = [UIFont fontWithName:fontName size:14];
            myOilNum.textColor = [lhColor colorFromHexRGB:contentTitleColorStr1];
            myOilNum.returnKeyType = UIReturnKeyDone;
            myOilNum.delegate = self;
            myOilNum.text = oilTypeStr;
            myOilNum.textAlignment = NSTextAlignmentRight;
            [wBgView addSubview:myOilNum];
            
        }
        else if(i == 5){//编号
            NSString * carStr = [NSString stringWithFormat:@"%@",[[lhColor shareColor].userInfo objectForKey:@"number"]];
            if (carStr && carStr.length > 0 && ![@"(null)" isEqualToString:carStr]) {
                
            }
            else{
                carStr = @"尚未绑定";
            }
            myCarNum = [[UITextField alloc]initWithFrame:CGRectMake(120*widthRate, 0, 190*widthRate, wBgView.frame.size.height)];
            myCarNum.font = [UIFont fontWithName:fontName size:14];
            myCarNum.textColor = [lhColor colorFromHexRGB:contentTitleColorStr1];
            myCarNum.returnKeyType = UIReturnKeyDone;
            myCarNum.delegate = self;
            myCarNum.text = carStr;
            myCarNum.textAlignment = NSTextAlignmentRight;
            [wBgView addSubview:myCarNum];
            
        }
        else if(i == 6){
            
            NSString * tStr = [NSString stringWithFormat:@"%@",[[lhColor shareColor].userInfo objectForKey:@"createTime"]];
            NSDate * lDate = [NSDate dateWithTimeIntervalSince1970:[tStr doubleValue]/1000];
            NSDateFormatter * df = [[NSDateFormatter alloc]init];
            [df setDateFormat:@"yyyy-MM-dd"];
            tStr = [df stringFromDate:lDate];
            if (tStr && tStr.length > 0 && ![@"(null)" isEqualToString:tStr]) {
                
            }
            else{
                tStr = @"";
            }
            
            myFaPiaoTitle = [[UITextField alloc]initWithFrame:CGRectMake(120*widthRate, 0, 190*widthRate, wBgView.frame.size.height)];
            myFaPiaoTitle.font = [UIFont fontWithName:fontName size:14];
            myFaPiaoTitle.textColor = [lhColor colorFromHexRGB:contentTitleColorStr1];
            myFaPiaoTitle.returnKeyType = UIReturnKeyDone;
            myFaPiaoTitle.delegate = self;
            myFaPiaoTitle.text = tStr;
            myFaPiaoTitle.textAlignment = NSTextAlignmentRight;
            [wBgView addSubview:myFaPiaoTitle];
            
        }
        
        heih += wBgView.frame.size.height;
        
        if (i == 1 || i == 3) {
            heih += 7*widthRate;
        }
    }
    
    maxScrollView.contentSize = CGSizeMake(DeviceMaxWidth, heih);
}

#pragma mark - 保存
- (void)saveButtonEvent
{
    [nTextField resignFirstResponder];
    
    NSString * s = [[lhColor shareColor].userInfo objectForKey:@"id"];
    NSMutableDictionary * dic0 = [NSMutableDictionary dictionary];
    [dic0 setObject:s forKey:@"id"];
    if ([@"" isEqualToString:nTextField.text]||[@"待完善" isEqualToString:nTextField.text]) {
        
    }
    else{
        [dic0 setObject:nTextField.text forKey:@"name"];
    }
    if ([@"" isEqualToString:sexButton.titleLabel.text]||[@"待完善" isEqualToString:sexButton.titleLabel.text]) {
    }
    else{
        NSString * sexS;
        if ([@"男" isEqualToString:sexButton.titleLabel.text]) {
            sexS = @"0";
        }
        else{
            sexS = @"1";
        }
        [dic0 setObject:sexS forKey:@"gender"];
    }
    if (headStr && headStr.length) {
        [dic0 setObject:headStr forKey:@"photo"];
    }

    [lhColor addActivityView123:self.view];
    
    [FrankNetworkManager postReqeustWithURL:PATH(@"user/updateInfo") params:dic0 successBlock:^(id returnData){
        [lhColor disAppearActivitiView:self.view];
        if ([[returnData objectForKey:@"status"]integerValue] == 1) {
            [lhColor shareColor].userInfo = [returnData objectForKey:@"data"];
        }else{
            [FrankTools requestFailAlertShow:[returnData objectForKey:@"msg"]];
        }
    } failureBlock:^(NSError *error) {
        FLLog(@"%@",error.localizedDescription);
        [FrankTools wangluoAlertShow];
        [lhColor disAppearActivitiView:self.view];
    } showHUD:NO];
}

#pragma mark - 签名
- (void)qmButtonEvent
{
    NSLog(@"选择区域");
    
    lhSelectCityViewController * scVC = [[lhSelectCityViewController alloc]init];
    [self.navigationController pushViewController:scVC animated:YES];
    
}

#pragma mark - 性别
- (void)sexButtonEvent
{
    if ([@"待完善" isEqualToString:sexButton.titleLabel.text]) {
        [sexButton setTitle:@"" forState:UIControlStateNormal];
    }
    
    [nTextField resignFirstResponder];
    
    UIActionSheet * acSheet = [[UIActionSheet alloc]initWithTitle:@"性别" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"女",@"男", nil];
    acSheet.tag = 1;
    [acSheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 1) {//性别点击
        if(buttonIndex == 0){
            if ([@"女" isEqualToString:sexButton.titleLabel.text]) {
                return;
            }
            
            [sexButton setTitle:@"女" forState:UIControlStateNormal];
            [self saveButtonEvent];
        }
        else if(buttonIndex == 1){
            if ([@"男" isEqualToString:sexButton.titleLabel.text]) {
                return;
            }
            
            [sexButton setTitle:@"男" forState:UIControlStateNormal];
            [self saveButtonEvent];
        }
        else if([@"" isEqualToString:sexButton.titleLabel.text]){
            [sexButton setTitle:@"待完善" forState:UIControlStateNormal];
        }
        
        [sexButton sizeToFit];
        sexButton.frame = CGRectMake(DeviceMaxWidth-sexButton.frame.size.width-20*widthRate, 0, sexButton.frame.size.width+20*widthRate, 52*widthRate);
        
    }
    else if(actionSheet.tag == 2){//头像点击
        if (buttonIndex == 0) {
            [self performSelector:@selector(tap) withObject:nil afterDelay:0.45];
        }
        else{
            [self takePhotoAndVidoeWithIndex:buttonIndex];
        }
    }
}

//放大头像
- (void)tap
{

    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray array];
    
    MJPhoto *photo = [[MJPhoto alloc] init];
    photo.image = headImageView.image; //图片
    photo.srcImageView = headImageView;
    [photos addObject:photo];
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = 0; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
    
}

#pragma mark - 上传头像
- (void)takePhotoAndVidoeWithIndex:(NSInteger)index
{
    currentType_ = index;
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) { //判断设备是否支持相册
        
        if (IOS8) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"未开启访问相册权限，现在去开启！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 4;
            [alert show];
        }
        else{
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"设备不支持访问相册，请在设置->隐私->照片中进行设置！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
        return;
    }
    
    UIImagePickerController * mpic = [[UIImagePickerController alloc]init];
    
    switch (index) {
        case 1:{
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该设备没有相机！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                
                return;
            }
            mpic.sourceType = UIImagePickerControllerSourceTypeCamera;
            break;
        }
            break;
        case 2:{
            mpic.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        }
            break;
            
        default:
            break;
    }
    if (index < 3) {
        mpic.delegate = self;
        mpic.allowsEditing = YES;//是否允许编辑照片
        mpic.mediaTypes = [NSArray arrayWithObjects:@"public.image", nil];//只可看见相册中的照片
        [self presentViewController:mpic animated:YES completion:^{
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        }];
    }
    
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    ////NSLog(@"开始上传头像 %ld",(long)buttonIndex);
    
    if (alertView.tag == 2) {
        
        if (buttonIndex == 0) {
            [self dismissViewControllerAnimated:YES completion:^{
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
            }];
        }
        else{
            NSData * imData = UIImageJPEGRepresentation(tempImg, 0.5);
            
            [self dismissViewControllerAnimated:YES completion:^{
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
                [lhColor addActivityView123:self.view];
                [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(uploadPhotoEvent:) name:@"uploadPhoto" object:nil];
//                NSString * idStr = [NSString stringWithFormat:@"%@",[[lhColor shareColor].userInfo objectForKey:@"id"]];
                NSDictionary * _params = @{};
                [[lhWeb alloc]uploadPhoto:@"a/fileServer/upload?type=1" params:[NSMutableDictionary dictionaryWithDictionary:_params] serviceName:@"image" NotiName:@"uploadPhoto" imageD:imData];
            }];
        }
    }
    else if(alertView.tag == 4 && buttonIndex == 1){
        [lhColor shareColor].noShowKaiChang = YES;
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]]; 
    }
    
}

#pragma mark - imagePickerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info //选取成功
{
    
    UIAlertView * alse = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定上传该图片作为头像？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alse.tag = 2;
    [alse show];
    
    UIImage * img;
    if (currentType_ == 2) {
        img = [info objectForKey:UIImagePickerControllerEditedImage];
    }
    if (currentType_ == 1) {
        img = [info objectForKey:UIImagePickerControllerEditedImage];
        UIImageWriteToSavedPhotosAlbum([info objectForKey:UIImagePickerControllerEditedImage], self, @selector(image:didFinishSavingWithError:contextInfo:),@"finish");//把照片存储到相册中
    }
    
    tempImg = img;
    
}

//固定的视频存储完成之后调用的方法
- (void)video: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo{
    
    ////NSLog(@"视频存储完成");
}

//固定的图片存储完成之后调用的方法
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo{
    
    ////NSLog(@"图片存储完成");
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker//选取图片失败或取消
{

    [picker dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    }];
        

}

//上传头像结果
- (void)uploadPhotoEvent:(NSNotification *)noti
{
    NSLog(@"上传头像结果 %@",noti.userInfo);
    [lhColor disAppearActivitiView:self.view];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:noti.name object:nil];
    if (!noti.userInfo || [noti.userInfo class] == [[NSNull alloc]class]) {
        
        [lhColor wangluoAlertShow];
        
    }
    if ([[noti.userInfo objectForKey:@"status"]integerValue] == 1) {
        
        headImageView.image = tempImg;
        
        headStr = [noti.userInfo objectForKey:@"data"];
        
        NSMutableDictionary * tempD = [NSMutableDictionary dictionaryWithDictionary:[lhColor shareColor].userInfo];
        [tempD setObject:headStr forKey:@"headURL"];
        [lhColor shareColor].userInfo = tempD;
        
        [self saveButtonEvent];
    }
    else{
        [lhColor requestFailAlertShow:noti];
    }
    
}

#pragma mark - 点击头像
- (void)tapGestureEvent
{
    [nTextField resignFirstResponder];
    
    ////NSLog(@"点击头像");
    
    UIActionSheet * actionSheet = [[UIActionSheet alloc]initWithTitle:@"选择图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"查看大图",@"拍照上传",@"相册选取", nil];
    actionSheet.tag = 2;
    [actionSheet showInView:self.view];
    
}

#pragma mark - 修改名字
- (void)mergeNameEvent:(NSNotification *)noti
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:noti.name object:nil];
    
    nTextField.text = [noti.userInfo objectForKey:@"content"];
    
    [self saveButtonEvent];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([@"待完善" isEqualToString:textField.text]) {
        textField.text = @"";
    }
    
    if (textField == nTextField && [[[lhColor shareColor].userInfo objectForKey:@"type"] integerValue] == 1) {
        [textField resignFirstResponder];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(mergeNameEvent:) name:@"mergeNameEvent" object:nil];
        lhWriteNameViewController * wqmVC = [[lhWriteNameViewController alloc]init];
        [self.navigationController pushViewController:wqmVC animated:YES];
    }
    else if (textField == myOilNum) {
        [textField resignFirstResponder];
        
        if ([@"尚未绑定" isEqualToString:myOilNum.text]) {
            lhBildIDCardViewController * bidcVC = [[lhBildIDCardViewController alloc]init];
            [self.navigationController pushViewController:bidcVC animated:YES];
        }
        
        
    }
    else if(textField == myCarNum){
        [textField resignFirstResponder];
        
        if ([@"尚未绑定" isEqualToString:myOilNum.text]) {
            lhBildIDCardViewController * bidcVC = [[lhBildIDCardViewController alloc]init];
            [self.navigationController pushViewController:bidcVC animated:YES];
        }
        
    }
    else if(textField == myFaPiaoTitle){
        [textField resignFirstResponder];

    }
    else{
        [textField resignFirstResponder];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([@"" isEqualToString:textField.text]) {
        textField.text = @"待完善";
    }
    else{
        
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField == nTextField){
        if (textField.text.length > nameMaxNum) {
            [textField.text substringToIndex:nameMaxNum];
        }
    }
    
    return YES;
}

#pragma mark - view 
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [lhColor assignmentForTempVC:self];
    
    NSString * birStr = [NSString stringWithFormat:@"%@",[lhColor shareColor].nowCityStr];
    if (birStr && birStr.length > 0 && ![@"(null)" isEqualToString:birStr]) {
        
    }
    else{
        birStr = @"定位失败";
    }
    [qmButton setTitle:birStr forState:UIControlStateNormal];
    [qmButton sizeToFit];
    qmButton.frame = CGRectMake(DeviceMaxWidth-qmButton.frame.size.width-20*widthRate, 0, qmButton.frame.size.width+20*widthRate, 52*widthRate);
    
    if (qmButton.frame.size.width > 190*widthRate) {
        qmButton.frame = CGRectMake(120*widthRate, 0, 190*widthRate, 52*widthRate);
    }
    
    NSString * oilTypeStr = [NSString stringWithFormat:@"%@",[[lhColor shareColor].userInfo objectForKey:@"idCard"]];
    NSLog(@"");
    if (![@"" isEqualToString:oilTypeStr] && ![oilTypeStr rangeOfString:@"null"].length) {
        oilTypeStr = [oilTypeStr substringToIndex:oilTypeStr.length-6];
        oilTypeStr = [NSString stringWithFormat:@"%@******",oilTypeStr];
    }
    else{
        oilTypeStr = @"尚未绑定";
    }
    //身份证号
    myOilNum.text = oilTypeStr;
    
    NSString * carStr = [NSString stringWithFormat:@"%@",[[lhColor shareColor].userInfo objectForKey:@"number"]];
    if (carStr && carStr.length > 0 && ![@"(null)" isEqualToString:carStr]) {
        
    }
    else{
        carStr = @"尚未绑定";
    }
    //用户编号
    myCarNum.text = carStr;
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

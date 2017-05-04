//
//  lhScanQRViewController.m
//  GasStation
//
//  Created by bosheng on 15/10/19.
//  Copyright © 2015年 bosheng. All rights reserved.
//

#import "lhScanQRViewController.h"
#import "QRCodeReaderView.h"

#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface lhScanQRViewController ()<QRCodeReaderViewDelegate,AVCaptureMetadataOutputObjectsDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate>
{
    QRCodeReaderView * readview;//二维码扫描对象

    BOOL isFirst;//第一次进入该页面
    BOOL isPush;//跳转到下一级页面
}

@property (strong, nonatomic) CIDetector *detector;

@end

@implementation lhScanQRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[lhColor shareColor]originalInit:self title:@"扫描" imageName:nil backButton:NO];
    
    isFirst = YES;
    isPush = NO;
    
    [self InitScan];
    
    [[lhColor shareColor]originalInit:self title:@"扫描" imageName:nil backButton:YES];
    UIButton * ablumbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [ablumbtn setTitleColor:[lhColor lessBlackColor] forState:UIControlStateNormal];
    ablumbtn.frame = CGRectMake(DeviceMaxWidth-62, 20, 60, 44);
    ablumbtn.titleLabel.font = [UIFont fontWithName:fontName size:15];
    [ablumbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [ablumbtn setTitle:@"相册" forState:UIControlStateNormal];
    [ablumbtn addTarget:self action:@selector(alumbBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:ablumbtn];
    
    [lhColor addActivityView:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 初始化扫描
- (void)InitScan
{
    if (readview) {
        [readview removeFromSuperview];
        readview = nil;
    }
    
    //扫描界面
    readview = [[QRCodeReaderView alloc]initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, DeviceMaxHeight)];
    readview.is_AnmotionFinished = YES;
    readview.backgroundColor = [UIColor clearColor];
    readview.delegate = self;
    readview.alpha = 0;

    [self.view addSubview:readview];
    
    [UIView animateWithDuration:0.5 animations:^{
        readview.alpha = 1;
    }completion:^(BOOL finished) {
        [lhColor disAppearActivitiView:self.view];
    }];
    
}

//对扫描结果进行处理
- (void)accordingQcode:(NSString *)str
{
//    isCameraAndDone = NO;
    NSString * twoDimString = [NSString stringWithFormat:@"%@",str];
    NSLog(@"twoDimString = %@",twoDimString);
    if (twoDimString.length == 18) {
        if (![twoDimString isEqualToString:[[lhColor shareColor].userInfo objectForKey:@"idCard" ]]) {
            [lhColor disAppearActivitiView:self.view];
            [lhColor showAlertWithMessage:@"请扫描自己的条形码" withSuperView:self.view withHeih:DeviceMaxHeight/2];
            readview.is_Anmotion = NO;
            [readview start];
            return;
        }
//        NSRange range = [twoDimString rangeOfString:@"="];
//        if (range.length == 0) {
//            [lhColor disAppearActivitiView:self.view];
//            [lhColor showAlertWithMessage:@"请扫描优品学车进度条形码~" withSuperView:self.view withHeih:DeviceMaxHeight/2];
//            readview.is_Anmotion = NO;
//            [readview start];
//            
//            return;
//        }
        
        NSDictionary * dic = @{@"id":[[lhColor shareColor].userInfo objectForKey:@"id"],
                               @"idCard":twoDimString};
        [FrankNetworkManager postReqeustWithURL:PATH(@"scan/barcode") params:dic successBlock:^(id returnData){
            [lhColor disAppearActivitiView:self.view];
            if ([[returnData objectForKey:@"status"]integerValue] == 1) {
                isPush = YES;
                NSLog(@"结果= %@",returnData);
                NSString *progress = [[returnData objectForKey:@"data"] objectForKey:@"currentProgress"];
                
                [[NSUserDefaults standardUserDefaults]setObject:progress forKey:saveStudyProgress];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                NSString *str = [NSString stringWithFormat:@"学习进度更新成功！当前进度%@",progress];
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
                
                [lhColor disAppearActivitiView:self.view];
            }else{
                [FrankTools wangluoAlertShow];
                readview.is_Anmotion = NO;
                [readview start];
            }
        } failureBlock:^(NSError *error) {
            readview.is_Anmotion = NO;
            [readview start];
            FLLog(@"%@",error.localizedDescription);
            [FrankTools wangluoAlertShow];
            [lhColor disAppearActivitiView:self.view];
        } showHUD:NO];
    }
    else{
        [lhColor disAppearActivitiView:self.view];
        [lhColor showAlertWithMessage:@"请扫描优品学车进度条形码~" withSuperView:self.view withHeih:DeviceMaxHeight/2];
        readview.is_Anmotion = NO;
        [readview start];
    }
}

#pragma mark - 相册
- (void)alumbBtnEvent
{
    self.detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
//    isAlumb = YES;
    [lhColor addActivityView:self.view];
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
        
        [lhColor disAppearActivitiView:self.view];
        return;
    }
    
    isPush = YES;
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    mediaUI.mediaTypes = [UIImagePickerController         availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    mediaUI.allowsEditing = YES;
    mediaUI.delegate = self;
    [self presentViewController:mediaUI animated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        [lhColor disAppearActivitiView:self.view];
    }];
}

//获取相册图片扫描
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (!image){
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    readview.is_Anmotion = YES;
    
    NSArray *features = [self.detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    if (features.count >=1) {
        
        [picker dismissViewControllerAnimated:YES completion:^{
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
            [lhColor addActivityView:self.view];
            CIQRCodeFeature *feature = [features objectAtIndex:0];
            NSString *scannedResult = feature.messageString;
            //播放扫描二维码的声音
            SystemSoundID soundID;
            NSString *strSoundFile = [[NSBundle mainBundle] pathForResource:@"noticeMusic" ofType:@"wav"];
            AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:strSoundFile],&soundID);
            AudioServicesPlaySystemSound(soundID);
            
            [self accordingQcode:scannedResult];
        }];
        
    }
    else{
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该图片没有包含一个二维码！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        
        [picker dismissViewControllerAnimated:YES completion:^{
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
            
            readview.is_Anmotion = NO;
            [readview start];
        }];
    }
}

//相册选图片，取消
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    }];
    
}

#pragma mark - 相机扫描，获取扫描结果
- (void)readerScanResult:(NSString *)result
{
//    isAlumb = NO;
    [lhColor addActivityView:self.view];
    readview.is_Anmotion = YES;
    [readview stop];
    
    //播放扫描二维码的声音
    SystemSoundID soundID;
    NSString *strSoundFile = [[NSBundle mainBundle] pathForResource:@"noticeMusic" ofType:@"wav"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:strSoundFile],&soundID);
    AudioServicesPlaySystemSound(soundID);
    
    [self accordingQcode:result];
    
}

//重新开启扫描
- (void)reStartScan
{
    readview.is_Anmotion = NO;
    
    if (readview.is_AnmotionFinished) {
        [readview loopDrawLine];
    }
    
    [readview start];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 4 && buttonIndex == 1){
        [lhColor shareColor].noShowKaiChang = YES;
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
    
}

#pragma mark - view
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [lhColor assignmentForTempVC:self];
    
    if (isFirst || isPush) {
        if (readview) {
            [self reStartScan];
        }
    }
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

    if (readview) {
        [readview stop];
        readview.is_Anmotion = YES;
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
 
    if (isFirst) {
        isFirst = NO;
    }
    if (isPush) {
        isPush = NO;
    }
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

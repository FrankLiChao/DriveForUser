//
//  lhColor.m
//  WSTechApp
//
//  Created by 刘欢 on 14-3-28.
//  Copyright (c) 2014年 liuhuan. All rights reserved.
//

#import "lhColor.h"
#import "WeChatPayManager.h"

#import "UIImageView+WebCache.h"
//#import "lhLoginViewController.h"
#import "FrankLoginView.h"

#import <ShareSDK/ShareSDK.h>

#import "UIImage+Cut.h"
#import "PinYin4Objc.h"
#import "lhSymbolCustumButton.h"
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "MyMD5.h"

#define paths [NSString stringWithFormat:@"%@/DriveWealthed",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]]

#define pathsLunBo [NSString stringWithFormat:@"%@/DriveWealthed/LunBo",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]]

#define pathsOther [NSString stringWithFormat:@"%@/DriveWealthedOther",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]]

#define maxDiscountTime 60//秒为单位

#define nullLabelTag 299
#define activityTag 199
#define activityImgTag 198

#define fxBgViewTag 8300
#define fxLowViewTag 8301

#define backBtnTag 302


static lhColor * onlyColor;


static UIViewController * tempVC;
static UILabel * tempLabel;
//分享图片和描述
static NSString * fxConStr;
static UIImage * fxImg;
static NSString * fxUrlStr;

@implementation lhColor
{
    UITabBarController * tempTabBarController;
    NSInteger lastTag;
    
    CGRect lastRect;
    UIImageView * sousuoBg;
    UIView * souSuoView;
    UITextField * sousuoF;
    UIImageView * sousuoTitle;
    CGFloat lasthh;
    
    //搜索商品table
    UITableView * searchTableView;
    NSMutableArray * sousuoRecord;
    UIButton * but;
    
    //选择搜索类别
    UIView * tapView;//点击搜索类别消失
    UIView * seleView;//选择类别view
    UILabel * typeLabel;//显示type
    
    UIWebView * phoneCallWebView;//拨打电话View
    
    NSInteger countTime;
}

//单例
+ (instancetype)shareColor
{
    
    if (onlyColor) {
        return onlyColor;
    }
    onlyColor = [[lhColor alloc]init];
    
    return onlyColor;
}

+ (NSDictionary *)headPicDic
{
    if ([lhColor shareColor].headPic && [lhColor shareColor].headPic.count > 0) {
        return [lhColor shareColor].headPic;
    }
    
    return [lhColor shareColor].headPic = [[NSUserDefaults standardUserDefaults] objectForKey:saveHeadPicfile];
}

#pragma mark - 正在加载仅显示一个activity
+ (void)addActivityView1OnlyActivityView:(UIView *)view
{
    UIActivityIndicatorView *waitActivity = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(10, 10, 60, 60)];
    waitActivity.tag = 199;
    waitActivity.center = view.center;
    waitActivity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [view addSubview:waitActivity];
    [waitActivity startAnimating];
    [lhColor closeUserEnable:view];
}

+ (void)disAppearActivitiViewOnlyActivityView:(UIView *)view
{
    UIView * aView = (UIView *)[view viewWithTag:199];
    if (aView) {
        [aView removeFromSuperview];
        aView = nil;
    }
    [lhColor openUserEnable:view];
}

#pragma mark - 正在加载
//正在连接
+ (void)addActivityView:(UIView *)view
{
//    UIView * aView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 120, 120)];
    UIView * aView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
//    aView.alpha = 0.3;
    aView.layer.cornerRadius = 10;
    aView.layer.masksToBounds = YES;
    aView.tag = 199;
    aView.center = view.center;
//    aView.backgroundColor = [lhColor colorFromHexRGB:@"C7C7C7"];
    aView.backgroundColor = [UIColor blackColor];
    [view addSubview:aView];
    
//    UIActivityIndicatorView *waitActivity = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(30, 10, 60, 60)];
    UIActivityIndicatorView *waitActivity = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(10, 10, 60, 60)];
    waitActivity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [aView addSubview:waitActivity];
    [waitActivity startAnimating];
    
//    UILabel * la = [[UILabel alloc]initWithFrame:CGRectMake(0, 80, 120, 20)];
//    la.textAlignment = NSTextAlignmentCenter;
//    la.textColor = [UIColor whiteColor];
//    la.font = [UIFont fontWithName:fontName size:15];
//    la.text = @"正在连接...";
//    [aView addSubview:la];
    
    [lhColor closeUserEnable:view];
}

+ (void)addActivityView123:(UIView *)view
{
    [self disAppearActivitiView:view];
    
//    UIView * aView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60*widthRate, 88*widthRate)];
    UIView * aView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 140*widthRate, 105*widthRate)];
    //    aView.layer.cornerRadius = 10;
    //    aView.layer.allowsEdgeAntialiasing = YES;
    //    aView.layer.masksToBounds = YES;
    aView.tag = activityTag;
    aView.center = view.center;
    aView.backgroundColor = [UIColor clearColor];
    [view addSubview:aView];
    
    NSMutableArray * imgA = [NSMutableArray array];
//    for (int i = 11; i >= 0; i--) {
//        NSString * imgStr = [NSString stringWithFormat:@"activityImage%d",i];
//        [imgA addObject:imageWithName(imgStr)];
//    }
    for (int i = 0; i < 21; i++) {
        NSString * imgStr = [NSString stringWithFormat:@"activityImage%d",i];
        [imgA addObject:imageWithName(imgStr)];
    }
    
//    UIImageView * actImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 60*widthRate, 88*widthRate)];
    UIImageView * actImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 140*widthRate, 105*widthRate)];
    actImgView.tag = activityImgTag;
    actImgView.animationImages = imgA;
    actImgView.animationRepeatCount = 100000;
//    actImgView.animationDuration = 0.15;
    actImgView.animationDuration = 1.5;
    [aView addSubview:actImgView];
    [actImgView startAnimating];
    
    [lhColor closeUserEnable:view];
}

+ (void)disAppearActivitiView:(UIView *)view
{
    UIView * aView = (UIView *)[view viewWithTag:activityTag];
    UIImageView * imgView = (UIImageView *)[view viewWithTag:activityImgTag];
    if (aView) {
        if (imgView) {
            [imgView stopAnimating];
        }
        [aView removeFromSuperview];
        aView = nil;
    }
    [lhColor openUserEnable:view];
}

+ (void)closeUserEnable:(UIView *)viw
{
    for (UIView * v in viw.subviews) {
        if (v.tag != backBtnTag) {
            v.userInteractionEnabled = NO;
        }
    }
}

+ (void)openUserEnable:(UIView *)vie
{
    for (UIView * v in vie.subviews) {
        v.userInteractionEnabled = YES;
    }
}

//获取颜色
+ (UIColor *) colorFromHexRGB:(NSString *) inColorString
{
    UIColor *result = nil;
    unsigned int colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    if (nil != inColorString)
    {
        NSScanner *scanner = [NSScanner scannerWithString:inColorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char) (colorCode >> 16);
    greenByte = (unsigned char) (colorCode >> 8);
    blueByte = (unsigned char) (colorCode); // masks off high bits
    result = [UIColor
              colorWithRed: (float)redByte / 0xff
              green: (float)greenByte/ 0xff
              blue: (float)blueByte / 0xff
              alpha:1.0];
    
    return result;
}

#pragma mark - 签名算法
//高德云图
+ (NSString *)signStrGaoDe:(NSDictionary *)dic
{
    NSMutableArray * keyArray = [NSMutableArray arrayWithArray:[dic allKeys]];
    [keyArray sortUsingSelector:@selector(compare:)];
    NSMutableString * keyStr = [NSMutableString string];
    for (int i=0;i<keyArray.count;i++){
        NSString * s = [keyArray objectAtIndex:i];
        [keyStr appendFormat:@"%@=%@",s,[dic objectForKey:s]];
        if (i < keyArray.count-1) {
            [keyStr appendString:@"&"];
        }
        
    }
    [keyStr appendString:GDSignStr];
    
    return [MyMD5 md5:keyStr];
}

//服务器
+ (NSString *)signStrOur:(NSDictionary *)dic
{
    NSMutableArray * keyArray = [NSMutableArray arrayWithArray:[dic allKeys]];
    [keyArray sortUsingSelector:@selector(compare:)];
    NSMutableString * keyStr = [NSMutableString string];
    for (int i=0;i<keyArray.count;i++){
        NSString * s = [keyArray objectAtIndex:i];
        [keyStr appendFormat:@"%@=%@",s,[dic objectForKey:s]];
        
        if (i < keyArray.count-1) {
            [keyStr appendString:@"&"];
        }
        
    }
    
    return [MyMD5 md5:keyStr];
}

//导航底图
+ (UIImageView *)topImageView:(NSString *)imageName
{
    UIImageView * topIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 64)];
    topIV.backgroundColor = [lhColor colorFromHexRGB:mainColorStr];
    topIV.image = imageWithName(imageName);

    return topIV;
}


//导航栏标题
+ (UILabel *)titleLabel:(NSString *)str
{
    UILabel * tLabel = [[UILabel alloc]init];
    tLabel.frame = CGRectMake(46, 20, DeviceMaxWidth-46-65, 44);
//    tLabel.frame = CGRectMake(0, 20, DeviceMaxWidth, 44);
    tLabel.text = str;
//    tLabel.textAlignment = NSTextAlignmentCenter;
    tLabel.font = [UIFont fontWithName:fontName size:17];
    tLabel.font = [UIFont boldSystemFontOfSize:17];
    tLabel.textColor = [lhColor colorFromHexRGB:titleColorStr];
    tLabel.tag = 1999;
//    tLabel.textAlignment = NSTextAlignmentCenter;
    
    return tLabel;
}

+ (void)mergeTitle:(NSString *)titleStr
{
    UILabel * tLabel = (UILabel *)[tempVC.view viewWithTag:1999];
    tLabel.text = titleStr;
}

//添加返回键
+ (UIButton *)backButton
{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(5, 20, 60, 44);
    btn.showsTouchWhenHighlighted = YES;
    [btn addTarget:onlyColor action:@selector(backButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

- (void)originalInit:(UIViewController *)temp title:(NSString *)str imageName:(NSString *)imageStr backButton:(BOOL)isBack
{
    [lhColor shareColor].NowViewC = tempVC = temp;
    tempVC.view.backgroundColor = [lhColor colorFromHexRGB:viewColorStr];
    [tempVC.view addSubview:[lhColor topImageView:imageStr]];
    [tempVC.view addSubview:[lhColor titleLabel:str]];
    
    if (isBack) {
        
        UIButton * backBg = [[UIButton alloc]initWithFrame:CGRectMake(2, 20, 40, 44)];
        backBg.tag = backBtnTag;
        [backBg setBackgroundImage:imageWithName(@"back") forState:UIControlStateNormal];
        [tempVC.view addSubview:backBg];
        
        [backBg addTarget:onlyColor action:@selector(backButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)originalInitView:(UIView *)temp title:(NSString *)str imageName:(NSString *)imageStr backButton:(BOOL)isBack
{
    temp.backgroundColor = [UIColor whiteColor];
    [temp addSubview:[lhColor topImageView:imageStr]];
    [temp addSubview:[lhColor titleLabel:str]];
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 63.5, DeviceMaxWidth, 0.5)];
    lineView.alpha = 0.1;
    lineView.backgroundColor = [UIColor blackColor];
    [temp addSubview:lineView];
    
    if (isBack) {
        UIButton * backBg = [UIButton buttonWithType:UIButtonTypeSystem];
        backBg.tag = backBtnTag;
        backBg.frame = CGRectMake(0, 20, 60, 44);
        [backBg setBackgroundImage:imageWithName(@"back") forState:UIControlStateNormal];
        [temp addSubview:backBg];
        
        [backBg addTarget:onlyColor action:@selector(backButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    }
}

//返回按钮事件
- (void)backButtonEvent
{
    //NSLog(@"返回上一页");
    NSString * str = [NSString stringWithFormat:@"%@",[tempVC class]];
    if ([@"lhLoginViewController" isEqualToString:str]) {
        [tempVC dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
    else{
        [tempVC.navigationController popViewControllerAnimated:YES];
    }
    
}

#pragma mark - 给tempVC赋值
+ (void)assignmentForTempVC:(UIViewController *)temp
{
    [lhColor shareColor].NowViewC = tempVC = temp;
}

+ (NSInteger)levelWithExperience:(CGFloat)exp
{
    if (exp < 100) {
        return 0;
    }
    else if (exp < 300){
        return 1;
    }
    else if (exp < 500){
        return 2;
    }
    else if (exp < 1000){
        return 3;
    }
    else if (exp < 2000){
        return 4;
    }
    else if (exp < 3000){
        return 5;
    }
    else if (exp < 5000){
        return 6;
    }
    else if (exp < 7000){
        return 7;
    }
    else if (exp < 10000){
        return 8;
    }
    else if (exp < 15000){
        return 9;
    }
    else if (exp < 20000){
        return 10;
    }
    else if (exp < 40000){
        return 11;
    }
    else if (exp < 80000){
        return 12;
    }
    else if (exp < 15000){
        return 13;
    }
    else{
        return 14;
    }
}

+ (NSString *)distanceTimeWithBeforeTime:(double)beTime
{
    NSTimeInterval now = [[NSDate date]timeIntervalSince1970];
    double distanceTime = now - beTime/1000;
    NSString * distanceStr;
    
    NSDate * beDate = [NSDate dateWithTimeIntervalSince1970:beTime/1000];
    NSDateFormatter * df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"HH:mm"];
    NSString * timeStr = [df stringFromDate:beDate];
    
    [df setDateFormat:@"dd"];
    NSString * nowDay = [df stringFromDate:[NSDate date]];
    NSString * lastDay = [df stringFromDate:beDate];
    
    if (distanceTime < 60) {//小于一分钟
        distanceStr = @"刚刚";
    }
    else if (distanceTime < 60*60) {//时间小于一个小时
        distanceStr = [NSString stringWithFormat:@"%ld分钟前",(long)distanceTime/60];
    }
    else if(distanceTime < 24*60*60 && [nowDay integerValue] == [lastDay integerValue]){//时间小于一天
        distanceStr = [NSString stringWithFormat:@"今天 %@",timeStr];
    }
    else if(distanceTime< 24*60*60*2 && [nowDay integerValue] != [lastDay integerValue]){
        
        if ([nowDay integerValue] - [lastDay integerValue] == 1 || ([lastDay integerValue] - [nowDay integerValue] > 10 && [nowDay integerValue] == 1)) {
            distanceStr = [NSString stringWithFormat:@"昨天 %@",timeStr];
        }
        else{
            [df setDateFormat:@"MM-dd HH:mm"];
            distanceStr = [df stringFromDate:beDate];
        }
        
    }
    else if(distanceTime < 24*60*60*365){
        [df setDateFormat:@"MM-dd HH:mm"];
        distanceStr = [df stringFromDate:beDate];
    }
    else{
        [df setDateFormat:@"yyyy-MM-dd HH:mm"];
        distanceStr = [df stringFromDate:beDate];
    }
    
    return distanceStr;
}


#pragma mark - 裁剪一张图片
- (UIImage *)croppedImageToRect2:(UIImage *)image withWidth:(CGFloat)width withHeight:(CGFloat)height
{
    CGRect rect;
    if (image.size.height < image.size.width) {
        rect.size.height = image.size.height;
        rect.size.width = image.size.height;
        rect.origin.y = 0;
        rect.origin.x = (image.size.width - image.size.height)/2;
    }
    else{
        rect.size.height = image.size.width;
        rect.size.width = image.size.width;
        rect.origin.x = 0;
        rect.origin.y = (image.size.height - image.size.width)/2;
    }
    
    if (image)
    {
        CGRect rectMAX = rect;
        CGImageRef subImageRef = CGImageCreateWithImageInRect(image.CGImage, rectMAX);
        UIGraphicsBeginImageContext(rectMAX.size);
        UIImage *viewImage = [UIImage imageWithCGImage:subImageRef];
        UIGraphicsEndImageContext();
        CGImageRelease(subImageRef);
        return viewImage;
    }
    
    return nil;
}


//- (UIImage *)croppedImageToRect3:(UIImage *)image
//{
//    CGRect rect;
//    
//    image = [self fixOrientation:image];
//    
//    if (image.size.width/image.size.height > 1) {
//        rect.size.width = image.size.width;
//        rect.size.height = image.size.width/(width/height);
//        rect.origin.x = 0;
//        rect.origin.y = (image.size.height-rect.size.height)/2;
//    }
//    else{
//        rect.size.height = image.size.height;
//        rect.size.width = image.size.height*(width/height);
//        rect.origin.y = 0;
//        rect.origin.x = (image.size.width-rect.size.width)/2;
//    }
//    
//    if (image)
//    {
//        
//        CGRect rectMAX = rect;
//        CGImageRef subImageRef = CGImageCreateWithImageInRect(image.CGImage, rectMAX);
//        UIGraphicsBeginImageContext(rectMAX.size);
//        UIImage *viewImage = [UIImage imageWithCGImage:subImageRef];
//        UIGraphicsEndImageContext();
//        CGImageRelease(subImageRef);
//        
//        return viewImage;
//    }
//    
//    return nil;
//}

//长方形
- (UIImage *)croppedImageToRect:(UIImage *)image withWidth:(CGFloat)width withHeight:(CGFloat)height
{
    CGRect rect;
    
    image = [self fixOrientation:image];
    
    if (width/height > image.size.width/image.size.height) {
        rect.size.width = image.size.width;
        rect.size.height = image.size.width/(width/height);
        rect.origin.x = 0;
        rect.origin.y = (image.size.height-rect.size.height)/2;
    }
    else{
        rect.size.height = image.size.height;
        rect.size.width = image.size.height*(width/height);
        rect.origin.y = 0;
        rect.origin.x = (image.size.width-rect.size.width)/2;
    }

    if (image)
    {
        CGRect rectMAX = rect;
//        UIGraphicsBeginImageContext(rectMAX.size);
//        CGContextRef context = UIGraphicsGetCurrentContext();
//        CGContextClipToRect(context, CGRectMake(0, 0, rectMAX.size.width, rectMAX.size.height));
//        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
//        UIRectFill(CGRectMake(0, 0, rectMAX.size.width, rectMAX.size.height));//clear background
//        [image drawInRect:rectMAX];
//        UIImage * viewImage = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
        
        CGImageRef subImageRef = CGImageCreateWithImageInRect(image.CGImage, rectMAX);
        UIGraphicsBeginImageContext(rectMAX.size);
        UIImage *viewImage = [UIImage imageWithCGImage:subImageRef];
        UIGraphicsEndImageContext();
        CGImageRelease(subImageRef);
        
        return viewImage;
    }
    
    return nil;
}

- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

//正方形
- (UIImage *)croppedImage:(UIImage *)image
{
    CGRect rect;
    if (image.size.height < image.size.width) {
        rect.size.height = image.size.height;
        rect.size.width = image.size.height;
        rect.origin.y = 0;
        rect.origin.x = (image.size.width - image.size.height)/2;
    }
    else{
        rect.size.height = image.size.width;
        rect.size.width = image.size.width;
        rect.origin.x = 0;
        rect.origin.y = (image.size.height - image.size.width)/2;
    }
    
    if (image)
    {
        CGRect rectMAX = rect;
        CGImageRef subImageRef = CGImageCreateWithImageInRect(image.CGImage, rectMAX);
        UIGraphicsBeginImageContext(rectMAX.size);
        UIImage *viewImage = [UIImage imageWithCGImage:subImageRef];
        UIGraphicsEndImageContext();
        CGImageRelease(subImageRef);
        return viewImage;
    }
    
    return nil;
    
}

#pragma mark - 定位当前位置
- (void)locationAddress:(LocationBlock)locaiontBlock
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status) {//未开启定位
        
        [[MMLocationManager shareLocation]getLocationCoordina:^(CLLocationCoordinate2D locationCorrrdinate){
            locaiontBlock(locationCorrrdinate);
        }];
        
        if (IOS8){
            UIAlertView *tempA = [[UIAlertView alloc]initWithTitle:@"提示" message:@"未开启定位服务，现在开启！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [tempA show];
        }
        else{
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"定位服务未开启" message:@"请在设置－>隐私－>定位服务开启定位服务！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
        
        return;
    }
    
    [[MMLocationManager shareLocation]getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
        locaiontBlock(locationCorrrdinate);
    }];
}

- (void)locationCity:(LocationCityBlock)locationCity
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status) {//未开启定位
        
        [[MMLocationManager shareLocation]getCity:^(NSString *addressString) {
            locationCity(@"成都");
        }error:^(NSError *error) {
            locationCity(@"成都");
        }];
        
        if (IOS8){
            UIAlertView *tempA = [[UIAlertView alloc]initWithTitle:@"提示" message:@"未开启定位服务，现在开启！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [tempA show];
        }
        else{
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"定位服务未开启" message:@"请在设置－>隐私－>定位服务开启定位服务！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
        
        return;
    }
    [[MMLocationManager shareLocation]getCity:^(NSString *addressString) {
        locationCity(addressString);
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }

}

#pragma mark - 点赞或评论之后发推送
- (void)zanSendPushWithUserCode:(NSString *)userCode withAlert:(NSString *)alert
{
    NSDictionary * dic = @{@"userCode":userCode,
                           @"badge":@"1",
                           @"sound":@"default",
                           @"theme":@"Apple:留言提醒",
                           @"alert":alert,
                           @"sendCount":@"true",
                           @"recerverType":@"3"};
    
    [FrankNetworkManager postReqeustWithURL:PATH(@"push/prompt") params:dic successBlock:^(id returnData){
        if ([[returnData objectForKey:@"status"]integerValue] == 1) {
            
        }else{
            [FrankTools requestFailAlertShow:[returnData objectForKey:@"msg"]];
        }
    } failureBlock:^(NSError *error) {
        FLLog(@"%@",error.localizedDescription);
        [FrankTools wangluoAlertShow];
    } showHUD:NO];
 
}

#pragma mark - 检测，存储图片
//获取图片名字
- (NSString *)imageStr:(NSString *)iStr
{
    NSRange ra = [iStr rangeOfString:@"-"];
    
    if (ra.length > 0) {
        iStr = [iStr substringFromIndex:ra.location+1];
    }
    
    return iStr;
}

+ (void)checkImageWithImageView:(UIImageView *)tempImg withImage:(NSString *)tempImgName withImageUrl:(NSString *)imageUrl withPlaceHolderImage:(UIImage *)placeholderImage
{
    tempImgName = [tempImgName stringByReplacingOccurrencesOfString:@"/" withString:@""];
    
    if ([tempImgName rangeOfString:@"null>"].length || [@"" isEqualToString:tempImgName]) {
        tempImg.image = placeholderImage;
        return;
    }
    
    if ([[lhColor shareColor]isImageWithName:tempImgName]) {//图片存在
        //NSLog(@"存在");
        tempImg.image = [[lhColor shareColor] readImageWithNameOther:tempImgName];
    }
    else{
        __weak UIImageView * imgView = tempImg;
        [tempImg setImageWithURL:[NSURL URLWithString:imageUrl]completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            if (image) {
                [[lhColor shareColor]saveImagesOther:image withName:tempImgName];
            }
            else{
                imgView.image = placeholderImage;
            }
        }];
    }
}


- (void)checkImageWithImageView:(UIImageView *)tempImg withImage:(NSString *)tempImgName withImageUrl:(NSURL *)imageUrl withPlaceHolderImage:(UIImage *)placeholderImage
{
    if ([[lhColor shareColor]isImageWithName:tempImgName]) {
        tempImg.image = [[lhColor shareColor] readImageWithNameOther:tempImgName];
    }
    else{
        [tempImg setImageWithURL:imageUrl placeholderImage:placeholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            if (image) {
                [[lhColor shareColor] saveImagesOther:image withName:tempImgName];
            }
            
        }];
    }
}

#pragma mark - 可清空图片，存储.读取.删除图片
- (void)removeAllImage
{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:pathsOther]) {

        [fileManager removeItemAtPath:pathsOther error:nil];
    }
}

//判断图片是否存在
- (BOOL)isImageWithName:(NSString *)name
{
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSString * pathStr = [NSString stringWithFormat:@"%@/%@",pathsOther,name];
    
    if (![fileManager fileExistsAtPath:pathStr]) {
        return NO;
    }
    
    return YES;
}

- (void)saveImagesOther:(UIImage *)tempImg withName:(NSString *)name
{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:pathsOther]) {
        //NSLog(@"该文件不存在");
        [fileManager createDirectoryAtPath:pathsOther withIntermediateDirectories:YES attributes:[NSDictionary dictionary] error:nil];
    }
    
    NSData * imgData;
    imgData = UIImageJPEGRepresentation(tempImg, 0.5);
    
    NSString * pathStr = [NSString stringWithFormat:@"%@/%@",pathsOther,name];
    [fileManager createFileAtPath:pathStr contents:imgData attributes:[NSDictionary dictionary]];
    
}

- (UIImage *)readImageWithNameOther:(NSString *)name
{
    
    NSString * pathStr = [NSString stringWithFormat:@"%@/%@",pathsOther,name];
    NSData * readData = [NSData dataWithContentsOfFile:pathStr];
    UIImage * tempImg = [UIImage imageWithData:readData scale:2.0];
    
    return tempImg;
}

+ (void)checkImageWithName:(NSString *)name withUrlStr:(NSString *)urlStr withImgView:(UIImageView *)tempImgView
{
    name = [name stringByReplacingOccurrencesOfString:@"/" withString:@""];
    
    if ([[lhColor shareColor]isImageWithName:name]) {//图片存在
        tempImgView.image = [[lhColor shareColor] readImageWithNameOther:name];
    }
    else{
        __weak UIImageView * imgView = tempImgView;
        [tempImgView setImageWithURL:[NSURL URLWithString:urlStr]completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            if (image) {
                [[lhColor shareColor]saveImagesOther:image withName:name];
            }
            else{
                
                NSLog(@"没图片");
                
                imgView.image = imageWithName(@"requstIsRun");
            }
        }];
    }
}

+ (void)checkImageWithName:(NSString *)name withUrlStr:(NSString *)urlStr withImgView:(UIImageView *)tempImgView withPlaceHolder:(UIImage *)placeImage
{
    name = [name stringByReplacingOccurrencesOfString:@"/" withString:@""];
    
    if ([[lhColor shareColor]isImageWithName:name]) {//图片存在
        tempImgView.image = [[lhColor shareColor] readImageWithNameOther:name];
    }
    else{
        __weak UIImageView * imgView = tempImgView;
        [tempImgView setImageWithURL:[NSURL URLWithString:urlStr]completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            if (image) {
                [[lhColor shareColor]saveImagesOther:image withName:name];
            }
            else{
                
                imgView.image = placeImage;
            }
        }];
    }
}

+ (void)checkImageWithNameCut:(NSString *)name withUrlStr:(NSString *)urlStr withImgView:(UIImageView *)tempImgView withPlaceHolder:(UIImage *)placeImage withSize:(CGSize)size
{
    name = [name stringByReplacingOccurrencesOfString:@"/" withString:@""];
    
    if ([[lhColor shareColor]isImageWithName:name]) {//图片存在
        tempImgView.image = [[lhColor shareColor] readImageWithNameOther:name];
    }
    else{
        __weak UIImageView * imgView = tempImgView;
        [tempImgView setImageWithURL:[NSURL URLWithString:urlStr]completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            if (image) {
                image = [image clipImageWithScaleWithsize:size];
                [[lhColor shareColor]saveImagesOther:image withName:name];
                imgView.image = image;
            }
            else{
                imgView.image = placeImage;
            }
        }];
    }
}

#pragma mark - 不可清空图片存储及处理
- (void)saveImages:(UIImage *)tempImg withName:(NSString *)name
{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:paths]) {
        //NSLog(@"该文件不存在");
        [fileManager createDirectoryAtPath:paths withIntermediateDirectories:YES attributes:[NSDictionary dictionary] error:nil];
    }
    
    NSData * imgData;
    imgData = UIImageJPEGRepresentation(tempImg, 0.5);

    NSString * pathStr = [NSString stringWithFormat:@"%@/%@.png",paths,name];
    [fileManager createFileAtPath:pathStr contents:imgData attributes:[NSDictionary dictionary]];
    
}

- (UIImage *)readImageWithName:(NSString *)name
{

    NSString * pathStr = [NSString stringWithFormat:@"%@/%@.png",paths,name];
    NSData * readData = [NSData dataWithContentsOfFile:pathStr];
    UIImage * tempImg = [UIImage imageWithData:readData scale:2.0];

    return tempImg;
}

- (void)removeImageFile:(NSString *)name
{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSString * pathStr = [NSString stringWithFormat:@"%@/%@.png",paths,name];
    if ([fileManager fileExistsAtPath:pathStr]) {
        [fileManager removeItemAtPath:pathStr error:nil];
    }
}

//轮播
//存储轮播图片
- (void)saveLunBoImg:(UIImage *)img withI:(int)i
{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:paths]) {

        [fileManager createDirectoryAtPath:paths withIntermediateDirectories:YES attributes:[NSDictionary dictionary] error:nil];
    }
    
    if (![fileManager fileExistsAtPath:pathsLunBo]) {
        [fileManager createDirectoryAtPath:pathsLunBo withIntermediateDirectories:YES attributes:[NSDictionary dictionary] error:nil];
    }
    
    NSData * imgData = UIImageJPEGRepresentation(img, 0.5);
    NSString * pathStr = [NSString stringWithFormat:@"%@/%d.png",pathsLunBo,i];
    [fileManager createFileAtPath:pathStr contents:imgData attributes:[NSDictionary dictionary]];
    
}

- (UIImage *)readImageWithNameLunBo:(NSString *)name
{
    NSString * pathStr = [NSString stringWithFormat:@"%@/%@",pathsLunBo,name];
    NSData * readData = [NSData dataWithContentsOfFile:pathStr];
    UIImage * tempImg = [UIImage imageWithData:readData scale:2.0];
    
    return tempImg;
}

- (void)removeLunBo
{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:pathsLunBo]) {
        [fileManager removeItemAtPath:pathsLunBo error:nil];
    }
}


#pragma mark-将数字转成字符串
- (NSString *)stringWithFloat:(CGFloat)floatNumber
{
    NSInteger tempN;
    NSString * tempStr;
    int i = 6;
    while (1) {
        if ((long)(floatNumber/[self numberWithSome:i]) != 0) {
            tempN = (long)(floatNumber/[self numberWithSome:i]);
            tempStr = [self unicharWithNumber:(long)(floatNumber/[self numberWithSome:i])];
            
            break;
        }
        
        i--;
    }
    
    NSMutableString * str;
    
    if (floatNumber < 1) {
        str = [NSMutableString stringWithString:@"0."];
        [str appendString:tempStr];
    }
    else{
        str = [NSMutableString stringWithString:tempStr];
    }
    
    for (int j = i; j >= -1;) {
        if (j == 0) {
            [str appendString:@"."];
        }
        floatNumber -= tempN*[self numberWithSome:j];
        j--;
        tempN = (long)(floatNumber/[self numberWithSome:j]);
        CGFloat num = [self numberWithSome:j];
        tempStr = [self unicharWithNumber:(long)(floatNumber/(num))];
        
        [str appendString:tempStr];
    }
    
    return str;
    
}

- (NSString *)unicharWithNumber:(NSInteger)number
{
    switch (number) {
        case 0:{
            return @"0";
            break;
        }
        case 1:{
            return @"1";
            break;
        }
        case 2:{
            return @"2";
            break;
        }
        case 3:{
            return @"3";
            break;
        }
        case 4:{
            return @"4";
            break;
        }
        case 5:{
            return @"5";
            break;
        }
        case 6:{
            return @"6";
            break;
        }
        case 7:{
            return @"7";
            break;
        }
        case 8:{
            return @"8";
            break;
        }
        case 9:{
            return @"9";
            break;
        }
        default:
            break;
    }
    
    return @"";
}

- (CGFloat)numberWithSome:(NSInteger)i
{
    CGFloat num = 1;
    
    if (i > 0) {
        for (int j = 0; j < i; j++) {
            num *= 10;
        }
    }
    else if(i == 0){
        return num;
    }
    else{
        for (int j = 0; j < -i; j++) {
            num = num/10;
        }
    }
    
    return num;
}

+ (UIColor *)lessBlackColor
{
    return [UIColor colorWithRed:59.0f/255 green:59.0f/255 blue:59.0f/255 alpha:1];
}

//将内容字符串转成数组
+ (NSArray *)arrayWithConStrI:(NSString *)conStr
{
    if(!conStr || [conStr class] == [[NSNull alloc]class] || [conStr isEqualToString:@""]){
        return [NSArray array];
    }
    
    NSMutableArray * picArray = [NSMutableArray array];
    
    if ([conStr isEqualToString:@""]) {
        return picArray;
    }
    else{
        NSRange c = [conStr rangeOfString:@"#"];
        while(c.length > 0) {
            NSString * picS = [conStr substringToIndex:c.location];
            NSString * str = [NSString stringWithString:picS];
            NSMutableString * nnStr = [NSMutableString stringWithString:@""];
            [nnStr appendString:str];
            [picArray addObject:nnStr];
            if (c.location+1 < conStr.length) {
                conStr = [conStr substringFromIndex:c.location+1];
                c = [conStr rangeOfString:@"#"];
            }
            else{
                break;
            }
        }
        if ([conStr characterAtIndex:conStr.length-1] != '#') {
            NSMutableString * nnStr = [NSMutableString stringWithString:@""];
            [nnStr appendString:conStr];
            [picArray addObject:nnStr];
        }
        
    }
    
    return picArray;
    
}

//将内容字符串转成数组
+ (NSArray *)arrayWithConStr:(NSString *)conStr
{
    if(!conStr || [conStr class] == [[NSNull alloc]class] || [conStr isEqualToString:@""]){
        return [NSArray array];
    }
    
    NSMutableArray * picArray = [NSMutableArray array];
//    NSMutableString * tempStr = [NSMutableString stringWithString:conStr];
//    conStr = [tempStr stringByReplacingOccurrencesOfString:@"#\n" withString:@""];
    
    if ([conStr isEqualToString:@""]) {
        return picArray;
    }
    else{
        NSRange c = [conStr rangeOfString:@"#"];
        while(c.length > 0) {
            NSString * picS = [conStr substringToIndex:c.location];
            NSString * str = [NSString stringWithString:picS];
            NSMutableString * nnStr = [NSMutableString stringWithString:@""];
            [nnStr appendString:str];
            [picArray addObject:nnStr];
            if (c.location+1 < conStr.length) {
                conStr = [conStr substringFromIndex:c.location+1];
                c = [conStr rangeOfString:@"#"];
            }
            else{
                break;
            }
        }
        if ([conStr characterAtIndex:conStr.length-1] != '#') {
            NSMutableString * nnStr = [NSMutableString stringWithString:@""];
            [nnStr appendString:conStr];
            [picArray addObject:nnStr];
        }
        
    }
    
    return picArray;
    
}

//将图片字符串转成数组food
+ (NSArray *)arrayWithPicStrFood:(NSString *)picStr
{
    if(!picStr || [picStr class] == [[NSNull alloc]class] || [picStr isEqualToString:@""]){
        return [NSArray array];
    }
    
    
    NSMutableArray * picArray = [NSMutableArray array];
    
    if ([picStr isEqualToString:@""]) {
        return picArray;
    }
    else{
        NSRange c = [picStr rangeOfString:@";"];
        while(c.length > 0) {
            NSString * picS = [picStr substringToIndex:c.location];
            [picArray addObject:picS];
            if (c.location+1 < picStr.length) {
                picStr = [picStr substringFromIndex:c.location+1];
                c = [picStr rangeOfString:@";"];
            }
            else{
                break;
            }
        }
    }
    
    return picArray;
}

//将图片字符串转成数组message
+ (NSArray *)arrayWithPicStr:(NSString *)picStr
{
    if(!picStr || [picStr class] == [[NSNull alloc]class] || [picStr isEqualToString:@""]){
        return [NSArray array];
    }
    
    NSMutableArray * picArray = [NSMutableArray array];
    
    if ([picStr isEqualToString:@""]) {
        return picArray;
    }
    else{
        NSRange c = [picStr rangeOfString:@";"];
        while(c.length > 0) {
            NSString * picS = [picStr substringToIndex:c.location];
            NSString * str = [NSString stringWithFormat:@"%@%@",[[lhColor shareColor].headPic objectForKey:@"message"],picS];
            [picArray addObject:str];
            if (c.location+1 < picStr.length) {
                picStr = [picStr substringFromIndex:c.location+1];
                c = [picStr rangeOfString:@";"];
            }
            else{
                break;
            }
        }
    }
    
    return picArray;
}

//拆分规格字符串
+ (NSArray *)arrayWithGuiGeStr:(NSString *)guigeStr
{
    if(!guigeStr || [guigeStr class] == [[NSNull alloc]class] || [guigeStr isEqualToString:@""] || [@"无" isEqualToString:guigeStr]){
        return [NSArray array];
    }
    
    
    NSMutableArray * picArray = [NSMutableArray array];
    
    if ([guigeStr isEqualToString:@""]) {
        return picArray;
    }
    else{
        NSRange c = [guigeStr rangeOfString:@";"];
        while(c.length > 0) {
            NSString * picS = [guigeStr substringToIndex:c.location];
            
            NSRange dc = [picS rangeOfString:@"="];
            
            NSMutableDictionary * tempDic = [NSMutableDictionary dictionary];
            
            if (dc.length > 0) {
                NSString * elementStr = [picS substringToIndex:dc.location];//元素名字
                NSString * elementPrice = [picS substringFromIndex:dc.location+1];//元素价格
                [tempDic setObject:elementStr forKey:@"name"];
                [tempDic setObject:elementPrice forKey:@"price"];
            }
            else{
                continue;
            }
            
            [picArray addObject:tempDic];
            if (c.location+1 < guigeStr.length) {
                guigeStr = [guigeStr substringFromIndex:c.location+1];
                c = [guigeStr rangeOfString:@";"];
            }
            else{
                break;
            }
        }
    }
    
    return picArray;
}

#pragma mark - 备注左移动
+ (void)moveTowardleft:(UIView *)view offet:(CGFloat)offet
{
    CGFloat duration = offet*0.06;
    
    [UIView animateWithDuration:duration animations:^{
        CGRect rect = view.frame;
        rect.origin.x -= offet;
        view.frame = rect;
    }completion:^(BOOL finished) {
        CGRect rect = view.frame;
        rect.origin.x += offet;
        view.frame = rect;
        
        [lhColor moveTowardleft:view offet:offet];
    }];
}


+ (NSInteger)nowDay
{
    NSDate * nowDate = [NSDate date];
    NSDateFormatter * df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"dd"];
    NSInteger day = [[df stringFromDate:nowDate]integerValue];
    
    return day;
}

+ (void)wangluoAlertShow
{
    if (IOS8) {
        UIAlertController * alertC = [UIAlertController alertControllerWithTitle:@"连接异常" message:@"请检查网络或稍后重试！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }];
        [alertC addAction:cancelAction];
        
        [tempVC presentViewController:alertC animated:YES completion:^{

        }];
    }
    else{
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"连接异常" message:@"请检查网络或稍后重试！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alert show];
    }
}

+ (void)requestFailAlertShow:(NSNotification *)noti
{
    NSString * str = [NSString stringWithFormat:@"%@",[noti.userInfo objectForKey:@"msg"]];
    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:str delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

+ (void)showOldPriceLabel:(UIView *)nowLabel nowPrice:(CGFloat)nowPrice oldPrice:(CGFloat)oldPrice
{
    NSString * olStr = [NSString stringWithFormat:@"%.2f",oldPrice/100];
    if (nowPrice != oldPrice) {
        UILabel * olPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(nowLabel.frame.size.width+nowLabel.frame.origin.x+5, nowLabel.frame.origin.y+1.5, 100, 20)];
        olPriceLabel.text = olStr;
        olPriceLabel.textColor = [UIColor colorWithRed:100.0/255 green:100.0/255 blue:100.0/255 alpha:1];
        olPriceLabel.font = [UIFont fontWithName:fontName size:12];
        olPriceLabel.font = [UIFont systemFontOfSize:12];
        [olPriceLabel sizeToFit];
        [nowLabel.superview addSubview:olPriceLabel];
        
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(olPriceLabel.frame.origin.x, olPriceLabel.frame.origin.y+7.5, olPriceLabel.frame.size.width, 1)];
        line.backgroundColor = [UIColor blackColor];
        line.alpha = 0.5;
        [nowLabel.superview addSubview:line];
    }
}

+ (CGSize)sizeWithFontWhenIOS7:(NSString *)text font:(UIFont *)font
{
    NSDictionary *attribute = @{NSFontAttributeName: font};
    CGSize titleSize = [text sizeWithAttributes:attribute];
    
    return titleSize;
}


+ (CGSize)sizeWithFontWhenIOS7:(NSString *)text font:(UIFont *)font constrainedToSize:(CGSize)mSize lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = lineBreakMode;
    
    NSDictionary *attributes = @{NSFontAttributeName: font, NSParagraphStyleAttributeName: paragraphStyle};
    CGSize detailsLabelSize = [text boundingRectWithSize:mSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
    
    return detailsLabelSize;
}

+ (void)sizeWithFontWhenIOS7:(NSString *)text font:(UIFont *)font rect:(CGRect)rect forWidth:(CGFloat)forWidth fontSize:(CGFloat)fontSize lineBreakMode:(NSLineBreakMode)lineBreakMode baselineAdjustment:(UIBaselineAdjustment)baselineAdjustment
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = lineBreakMode;
    
    UIFont * tempFont = font;
    tempFont = [UIFont systemFontOfSize:fontSize];
    
    NSDictionary *attributes = @{NSFontAttributeName: tempFont, NSParagraphStyleAttributeName: paragraphStyle,NSBaselineOffsetAttributeName:[NSNumber numberWithFloat:1.0]};
    [text drawInRect:rect withAttributes:attributes];
}

+ (void)drawInRectWhenIOS7:(NSString *)text rect:(CGRect)rect font:(UIFont *)font
{

    [text drawInRect:rect withAttributes:@{NSFontAttributeName:font}];

}


#pragma mark - 支付宝购买
- (void)payInAliyPayWithDic:(NSDictionary *)payDic withOrderDic:(NSDictionary *)di callback:(CompletionBlock)completionBlock
{
    [lhColor shareColor].noShowKaiChang = YES;
    NSString *partner = [payDic objectForKey:@"partner"];
    NSString *seller = [payDic objectForKey:@"seller_email"];
    NSString *privateKey = [payDic objectForKey:@"private_key"];
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 || [seller length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }

    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = [di objectForKey:@"orderCode"]; //订单ID（由商家自行制定）
    order.productName = [di objectForKey:@"productName"]; //商品标题
    order.productDescription = [di objectForKey:@"productDescription"]; //商品描述
//    order.amount = [NSString stringWithFormat:@"%.2f",[[di objectForKey:@"money"]doubleValue]]; //商品价格
    order.amount = @"0.01";
    order.notifyURL = [payDic objectForKey:@"notify_url"]; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"3m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"drivealipaytiaozhuan";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    //	//NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    
    [lhColor shareColor].noShowKaiChang = YES;//不显示开场图片
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        //NSLog(@"支付字符 %@",orderString);
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            //NSLog(@"reslut = %@",resultDic);
            
            completionBlock(resultDic);
            
        }];
    }
}

#pragma mark - 微信支付
- (void)wxPayWithPayDic:(NSDictionary *)payDic OrderDic:(NSDictionary *)orderDic
{
    
    NSLog(@"支付数据 %@ \n %@",payDic,orderDic);

    [lhColor shareColor].noShowKaiChang = YES;
    
//    NSString * appIdStr = [NSString stringWithFormat:@"%@",[payDic objectForKey:@"app_id"]];
//    NSString * mchIdStr = [NSString stringWithFormat:@"%@",[payDic objectForKey:@"mch_id"]];
//    NSString * apiKeyStr = [NSString stringWithFormat:@"%@",[payDic objectForKey:@"api_key"]];
    
    //创建支付签名对象 && 初始化支付签名对象
//    WeChatPayManager* wxpayManager = [[WeChatPayManager alloc]initWithAppID:appIdStr mchID:mchIdStr spKey:apiKeyStr];
    
    //获取到实际调起微信支付的参数后，在app端调起支付
    //生成预支付订单，实际上就是把关键参数进行第一次加密。
//    NSMutableDictionary *dict = [wxpayManager getPrepayWithOrderName:name
//                                price:price
//                                device:device];
    
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] initWithDictionary:payDic];
//    [wxpayManager getPrepayWithPayDic:payDic withOrderDic:orderDic];
    
    NSLog(@"shuz  %@",dict );
    
//    if(dict == nil){
//        //错误提示
//        NSString *debug = [wxpayManager getDebugInfo];
//        NSLog(@"%@",debug);
//        return;
//    }
    
    NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
    
    //调起微信支付
    PayReq* req             = [[PayReq alloc] init];
    req.openID              = [dict objectForKey:@"appId"];
    req.partnerId          = [dict objectForKey:@"partnerid"];
    req.prepayId            = [dict objectForKey:@"prepayid"];
    req.nonceStr            = [dict objectForKey:@"noncestr"];
    req.timeStamp          = stamp.intValue;
    req.package            = [dict objectForKey:@"packageStr"];
    req.sign                = [dict objectForKey:@"paySign"];
    
    NSLog(@"支付参数 %@",dict);
    
    BOOL flag = [WXApi sendReq:req];
    if (!flag) {
        [lhColor showAlertWithMessage:@"请求微信失败" withSuperView:tempVC.view withHeih:DeviceMaxHeight/2];
    }
}

#pragma mark - 提示
+ (void)showAlertWithMessage:(NSString *)message withSuperView:(UIView *)superView withHeih:(CGFloat)heih
{
    if (!tempLabel) {
        tempLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, heih, DeviceMaxWidth, 40)];
        tempLabel.layer.cornerRadius = 5;
        tempLabel.layer.masksToBounds = YES;
        tempLabel.backgroundColor = [UIColor blackColor];
        tempLabel.textColor = [UIColor whiteColor];
        tempLabel.font = [UIFont fontWithName:fontName size:13];
        tempLabel.text = message;
        tempLabel.textAlignment = NSTextAlignmentCenter;
        
        [tempLabel sizeToFit];
        tempLabel.frame = CGRectMake((DeviceMaxWidth-tempLabel.frame.size.width)/2, heih, tempLabel.frame.size.width+20, 40);
    }
    else{
        tempLabel.alpha = 1;
        tempLabel.hidden = NO;
        tempLabel.text = message;
        
        [tempLabel sizeToFit];
        tempLabel.frame = CGRectMake((DeviceMaxWidth-tempLabel.frame.size.width)/2, heih, tempLabel.frame.size.width+20, 40);
    }
    
    [superView addSubview:tempLabel];
    
    [onlyColor performSelector:@selector(tempLabelDis) withObject:nil afterDelay:2];
    
}

- (void)tempLabelDis
{
    if (tempLabel) {
        [UIView animateWithDuration:0.5 animations:^{
            tempLabel.alpha = 0;
        }completion:^(BOOL finished) {
            [tempLabel removeFromSuperview];
            tempLabel = nil;
        }];
    }
}


+ (UIImage *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (NSString *)numberStringWithNumber:(NSString *)number
{
    NSTimeInterval nu = [number doubleValue];
    
    if (nu < 10000) {
        return [NSString stringWithFormat:@"%d",(int)nu];
    }
    else if(nu < 100000000){
        return [NSString stringWithFormat:@"%d万",(int)nu/10000];
    }
    
    if (number && number.length > 12) {
        return [NSString stringWithFormat:@"%@万亿",[number substringToIndex:number.length-12]];
    }
    
    if (number && number.length > 8) {
        return [NSString stringWithFormat:@"%@亿",[number substringToIndex:number.length-8]];
    }
    
    return 0;
}

//是否登录
+ (BOOL)loginIsOrNo
{
    if ([lhColor shareColor].isOnLine) {
        return YES;
    }
    else{
        //跳转到登录界面
        //NSLog(@"跳转到登陆界面");
        FrankLoginView * lVC = [[FrankLoginView alloc]init];
        UINavigationController * nlVC = [[UINavigationController alloc] initWithRootViewController:lVC];
        [tempVC.navigationController presentViewController:nlVC animated:YES completion:^{
            
        }];
        
//        CATransition * transition = [[CATransition alloc]init];
//        transition.type = kCATransitionMoveIn;
//        transition.subtype = kCATransitionFromBottom;
//        [tempVC.navigationController.view.layer addAnimation:transition forKey:nil];
//        [tempVC.navigationController pushViewController:lVC animated:NO];
        
    }
    
    return NO;
}

//获得屏幕图像
- (UIImage *)imageFromView:(UIView *)theView
{
    
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

- (void)btmBtnEvent
{
    [tempVC.navigationController popToRootViewControllerAnimated:YES];
}

+ (void)removeNullLabelWithSuperView:(UIView *)superView
{
    UIView * nullView = (UIView *)[superView viewWithTag:nullLabelTag];
    if (nullView) {
        [nullView removeFromSuperview];
    }
}

+ (void)addANullLabelWithSuperView:(UIView *)superView withFrame:(CGRect)rect withText:(NSString *)str
{
    UIView * nullView = (UIView *)[superView viewWithTag:nullLabelTag];
    if(nullView) {
        [nullView removeFromSuperview];
        nullView = nil;
    }
    if (!nullView) {
        nullView = [[UIView alloc] initWithFrame:rect];
        nullView.tag = nullLabelTag;
        [superView addSubview:nullView];
        
        UIImageView * imgView = [[UIImageView alloc]initWithFrame:CGRectMake((CGRectGetWidth(rect)-160*widthRate)/2, 0, 160*widthRate, 160*widthRate)];
        imgView.image = imageWithName(@"nullImageViewImg");
        [nullView addSubview:imgView];
        
        UILabel * nulLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 160*widthRate, rect.size.width, 20*widthRate)];
        nulLabel.font = [UIFont fontWithName:fontName size:15];
        nulLabel.font = [UIFont systemFontOfSize:15];
        nulLabel.textAlignment = NSTextAlignmentCenter;
        nulLabel.textColor = [UIColor grayColor];
        nulLabel.text = str;
        [nullView addSubview:nulLabel];
    }
}

#pragma mark - 手机号验证
/*手机号码验证 MODIFIED BY HELENSONG*/
-(BOOL) isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
//    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
//    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
//    //    //NSLog(@"phoneTest is %@",phoneTest);
//    return [phoneTest evaluateWithObject:mobile];
    if (mobile && mobile.length == 11 && [mobile characterAtIndex:0] == '1') {
        return YES;
    }
    return NO;
}

//身份证号
+ (BOOL)validateIdentityCard:(NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

#pragma mark - 刷新用户信息
- (void)refreshPersonInfo
{
    NSDictionary *dic = @{@"id":[[lhColor shareColor].userInfo objectForKey:@"id"]};
    
    [FrankNetworkManager postReqeustWithURL:PATH(@"user/queryInfo") params:dic successBlock:^(id returnData){
        if ([[returnData objectForKey:@"status"]integerValue] == 1) {
            [lhColor shareColor].userName = [NSString stringWithFormat:@"%@",[[returnData objectForKey:@"data"] objectForKey:@"name"]];
            [lhColor shareColor].idCard = [NSString stringWithFormat:@"%@",[[returnData objectForKey:@"data"] objectForKey:@"idCard"]];
            [lhColor shareColor].phone = [NSString stringWithFormat:@"%@",[[returnData objectForKey:@"data"] objectForKey:@"phone"]];
        }else{
            [FrankTools requestFailAlertShow:[returnData objectForKey:@"msg"]];
        }
    } failureBlock:^(NSError *error) {
        FLLog(@"%@",error.localizedDescription);
        [FrankTools wangluoAlertShow];
    } showHUD:NO];
}

#pragma mark - 拨打电话
- (void)detailPhone:(NSString *)phone
{
    NSLog(@"拨打电话");
    [self dialPhoneNumber:phone];
}

- (void) dialPhoneNumber:(NSString *)aPhoneNumber
{
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",aPhoneNumber]];
    
    if ( !phoneCallWebView ) {
        phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
}

#pragma mark - 签名算法
+ (NSString *)signStr:(NSDictionary *)dic
{
    NSArray * keyArray = [dic allKeys];
    
    NSMutableString * keyStr = [NSMutableString string];
    
    for (NSString * key in keyArray){
        if (![@"" isEqualToString:[dic objectForKey:key]]&&
            [[dic objectForKey:key] class] != [NSNull class]&&
            [dic objectForKey:key]) {
            [keyStr appendString:key];
        }
    }
    keyStr = [NSMutableString stringWithString:[self sortByASCII:keyStr]];
    [keyStr appendString:@"402880f44eb90120014eb90122860000"];
    return keyStr;
}

+ (NSString *)sortByASCII:(NSString *)keyStr
{
    char *p,*q,*r,temp;
    char * string = (char *)[keyStr UTF8String];
    for(p=string;*p;p++)   /*排序*/
    {
        for(q=r=p;*q;q++)
            if(*r>*q)
                r=q;
        if(r!=p)   /*如果此句执行，说明*p不是最小的，上面的r
                    记录下最小的字符的地址*/
        { temp=*r;
            *r=*p;
            *p=temp;
        }
    }
    for(p=string;*p;p++)/*覆盖掉重复的字符*/
    {
        for(q=p;*p==*q;q++);
        strcpy(p+1,q);
    }
    printf("Result:%s\n",string);
    
    return [NSString stringWithCString:string encoding:NSUTF8StringEncoding];
}

#pragma mark - 字典转json
+ (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

#pragma mark - 教练更新自己的位置
- (void)updateLocation:(CLLocationCoordinate2D)coord
{
    if (![lhColor shareColor].isOnLine) {
        return;
    }
    NSString * nowLocation = [NSString stringWithFormat:@"%.6f,%.6f",coord.longitude,coord.latitude];
    NSDictionary * dic0 = @{@"_id":[lhColor shareColor].mapId,
                            @"_location":nowLocation,
                            @"coatch_id":[[lhColor shareColor].userInfo objectForKey:@"id"]};

    NSDictionary * dic = @{@"key":GDMapKey,
                           @"tableid":GDMapDriverTableId,
                           @"loctype":@"1",
                           @"data":[lhColor dictionaryToJson:dic0]};
    
    [FrankNetworkManager postReqeustWithURL:PATH(@"datamanage/data/update") params:dic successBlock:^(id returnData){
        if ([[returnData objectForKey:@"status"]integerValue] == 1) {
            FLLog(@"更新位置结果%@",returnData);
        }else{
            [FrankTools requestFailAlertShow:[returnData objectForKey:@"msg"]];
        }
    } failureBlock:^(NSError *error) {
        FLLog(@"%@",error.localizedDescription);
        [FrankTools wangluoAlertShow];
    } showHUD:NO];
    
}

//获取本机gps定位
- (void)updateLocation
{
    if(isLocationing)
    {
        return;
    }
    
    //设置定位中
    isLocationing = YES;
    //初始化定位
    if(self.locationManaer == nil)
    {
        countTime = 0;
        self.locationManaer = [[CLLocationManager alloc] init];
        self.locationManaer.delegate = self;
        self.locationManaer.pausesLocationUpdatesAutomatically = NO;
    }
    // 判断定位操作是否被允许
    if([CLLocationManager locationServicesEnabled])
    {
        //兼容iOS8定位
        SEL requestSelector = NSSelectorFromString(@"requestAlwaysAuthorization");
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined && [self.locationManaer respondsToSelector:requestSelector])
        {
            if(![self systemIsLaterThanString:@"8.0"])
            {
                [self.locationManaer requestAlwaysAuthorization];
            }
            else
            {
                [self.locationManaer startUpdatingLocation];
            }
            
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9) {
                self.locationManaer.pausesLocationUpdatesAutomatically = NO;
                self.locationManaer.allowsBackgroundLocationUpdates = YES;
            }
        }
        else
        {
            [self.locationManaer startUpdatingLocation];
        }
    }
    else
    {
        //提示用户无法进行定位操作
        NSString *titleString = @"因iOS系统限制，开启定位服务才能使用，不会作其他用途。\n\n\t步骤：设置>隐私>定位服务>优品学车>始终";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:titleString delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alertView setTag:-10];
        [alertView show];
    }
}

//查询sdk
-(BOOL)systemIsLaterThanString:(NSString *)version
{
    NSString *osVersion = [[UIDevice currentDevice] systemVersion];
    BOOL noRotationNeeded = ([version compare:osVersion options:NSNumericSearch]
                             != NSOrderedDescending);
    return noRotationNeeded;
}

#pragma mark CLLocationManagerDelegate 开始 分割线 ---------------------

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    isLocationing = NO;
    countTime++;
    //此处locations存储了持续更新的位置坐标值
    CLLocation *currentLocation = [locations lastObject];
    CLLocationCoordinate2D coor = currentLocation.coordinate;
    
    if (countTime >= maxDiscountTime) {
//        NSLog(@"提交数据");
//        NSLog(@"得到的经度：%f，纬度：%f",coor.latitude,coor.longitude);
        countTime = 0;
#warning 更新位置
        [self updateLocation:coor];
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if(status == kCLAuthorizationStatusAuthorizedAlways)
    {
        [self.locationManaer startUpdatingLocation];
    }
    else if(status == kCLAuthorizationStatusAuthorized)
    {
        // iOS 7 will redundantly call this line.
        [self.locationManaer startUpdatingLocation];
    }
    else if(status > kCLAuthorizationStatusNotDetermined)
    {
        //...
        [self.locationManaer startUpdatingLocation];
    }
    else if([self systemIsLaterThanString:@"8.0"])
    {
        [self.locationManaer requestAlwaysAuthorization];
    }
    else
    {
        [self.locationManaer startUpdatingLocation];
    }
}

#pragma mark CLLocationManagerDelegate 结束 分割线 ---------------------


#pragma mark - 添加分享
+ (void)fxViewAppear:(UIImage *)Img conStr:(NSString *)cStr withUrlStr:(NSString *)urlStr
{
    fxConStr = cStr;
    fxImg = Img;
    fxUrlStr = urlStr;
    UITapGestureRecognizer * tapG = [[UITapGestureRecognizer alloc]initWithTarget:onlyColor action:@selector(fxViewDisAppear)];
    UIView * grayV = [[UIView alloc]initWithFrame:tempVC.view.frame];
    grayV.tag = fxBgViewTag;
    grayV.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [grayV addGestureRecognizer:tapG];
    [tempVC.view addSubview:grayV];
    
    UIView * fxView = [[UIView alloc]initWithFrame:CGRectMake(0, DeviceMaxHeight, DeviceMaxWidth, 135*widthRate)];
    fxView.tag = fxLowViewTag;
    fxView.backgroundColor = [UIColor whiteColor];
    [tempVC.view addSubview:fxView];
    
    NSArray * a = @[@"微信好友",@"朋友圈",@"QQ好友",@"QQ空间"];
    for (int i = 0; i < 4; i++) {
        lhSymbolCustumButton * fxBtn = [[lhSymbolCustumButton alloc]initWithFrame2:CGRectMake(80*widthRate*i, 0, 80*widthRate, 100*widthRate)];
        fxBtn.tag = i;
        NSString * str = [NSString stringWithFormat:@"fxImage%d",i];
        [fxBtn.imgBtn setImage:imageWithName(str) forState:UIControlStateNormal];
        fxBtn.tLabel.text = [a objectAtIndex:i];
        //        CGRect rec = fxBtn.tLabel.frame;
        //        rec.origin.y = 72*widthRate;
        //        fxBtn.tLabel.frame = rec;
        [fxBtn addTarget:onlyColor action:@selector(fxBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
        [fxView addSubview:fxBtn];
    }
    
    UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, 100*widthRate, DeviceMaxWidth, 35*widthRate);
    cancelBtn.titleLabel.font = [UIFont fontWithName:fontName size:15];
    cancelBtn.backgroundColor = [lhColor colorFromHexRGB:viewColorStr];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[lhColor colorFromHexRGB:contentTitleColorStr1] forState:UIControlStateNormal];
    [cancelBtn addTarget:onlyColor action:@selector(fxViewDisAppear) forControlEvents:UIControlEventTouchUpInside];
    [fxView addSubview:cancelBtn];
    
    [UIView animateWithDuration:0.2 animations:^{
        grayV.alpha = 1;
        fxView.frame = CGRectMake(0, DeviceMaxHeight-135*widthRate, DeviceMaxWidth, 135*widthRate);
    }];
    
}

- (void)fxBtnEvent:(UIButton *)button_
{
    [onlyColor fxViewDisAppear];
    
    ShareType type;
    switch (button_.tag) {
        case 0:{
            //微信好友
            type = ShareTypeWeixiSession;
            break;
        }
        case 1:{
            //微信朋友圈
            type = ShareTypeWeixiTimeline;
            break;
        }
        case 2:{
            //QQ好友
            type = ShareTypeQQ;
            
            break;
        }
        case 3:{
            //新浪微博
            //QQ空间
            type = ShareTypeQQSpace;
            break;
        }
        default:
            break;
    }
    
    [lhColor sendMessageToWeiXinSession:type];
    
}

#pragma mark - 分享
+ (void)sendMessageToWeiXinSession:(NSInteger)shareType
{
    
    ShareType type = (ShareType)shareType;
    //    if (type == ShareTypeSinaWeibo) {
    //        if (![WeiboSDK isWeiboAppInstalled]) {
    //            [lhColor showAlertWithMessage:@"请先安装新浪微博客户端~" withSuperView:tempVC.view withHeih:DeviceMaxHeight/2];
    //
    //            return;
    //        }
    //        if (![WeiboSDK isCanShareInWeiboAPP] || ![WeiboSDK isCanSSOInWeiboApp]) {
    //            [lhColor showAlertWithMessage:@"当前不可分享~" withSuperView:tempVC.view withHeih:DeviceMaxHeight/2];
    //
    //            return;
    //        }
    //    }
    //    else
    if(type == ShareTypeQQ || type == ShareTypeQQSpace){
        if (![QQApiInterface isQQInstalled]) {
            [lhColor showAlertWithMessage:@"请先安装QQ客户端~" withSuperView:tempVC.view withHeih:DeviceMaxHeight/2];
            
            return;
        }
    }
    else if(type == ShareTypeWeixiSession || type == ShareTypeWeixiTimeline){
        if (![WXApi isWXAppInstalled]) {
            [lhColor showAlertWithMessage:@"请先安装微信客户端~" withSuperView:tempVC.view withHeih:DeviceMaxHeight/2];
            
            return;
        }
        if(![WXApi isWXAppSupportApi]){
            [lhColor showAlertWithMessage:@"微信版本不支持分享~" withSuperView:tempVC.view withHeih:DeviceMaxHeight/2];
            
            return;
        }
    }
    
    NSString * titleStr = @"每一公里，油其关心";
    if ([@"优品加油，每一公里，油其关心。跟阿普一起，领券加油！" isEqualToString:fxConStr]) {
        titleStr = @"送您优品加油优惠券，加油每升最高省4毛";
    }
    NSString * urlStr = [NSString stringWithFormat:@"%@/images/icon.png",[lhColor shareColor].fileWebUrl];
    urlStr = @"http://up-driving.com//userfiles/files/msg/appNews/2015/12/logo.jpg";
    id<ISSContent> publishContent = [ShareSDK content:fxConStr defaultContent:nil image:[ShareSDK imageWithUrl:urlStr] title:type==ShareTypeWeixiTimeline?fxConStr:titleStr url:fxUrlStr description:fxConStr mediaType:type==ShareTypeSinaWeibo?SSPublishContentMediaTypeText: SSPublishContentMediaTypeNews];
    //    [lhColor shareColor].noShowKaiChang = YES;
    
    [lhColor addActivityView:tempVC.view];
    
    //2.分享
    [ShareSDK shareContent:publishContent type:type authOptions:nil statusBarTips:YES result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
        [lhColor disAppearActivitiView:tempVC.view];
        
        //如果分享成功
        if (state == SSResponseStateSuccess) {
            ////NSLog(@"分享成功");
            
            [lhColor showAlertWithMessage:@"分享成功~" withSuperView:tempVC.view withHeih:DeviceMaxHeight/2];
            
        }
        else if (state == SSResponseStateFail) {//如果分享失败
            NSLog(@"分享失败,错误码:%ld,错误描述%@",(long)[error errorCode],[error errorDescription]);
            
            if ([error errorCode] == -22003) {
                [lhColor showAlertWithMessage:@"请先安装微信客户端~" withSuperView:tempVC.view withHeih:DeviceMaxHeight/2];
            }
            else if([error errorCode] == -22005){
                [lhColor showAlertWithMessage:@"取消分享~" withSuperView:tempVC.view withHeih:DeviceMaxHeight/2];
            }
            else{
                [lhColor showAlertWithMessage:@"分享失败~" withSuperView:tempVC.view withHeih:DeviceMaxHeight/2];
            }
            
        }
        else if (state == SSResponseStateCancel) {
            [lhColor showAlertWithMessage:@"取消分享~" withSuperView:tempVC.view withHeih:DeviceMaxHeight/2];
            
        }
        
    }];
    
}

- (void)fxViewDisAppear
{
    UIView * grayV = [tempVC.view viewWithTag:fxBgViewTag];
    UIView * fxView = [tempVC.view viewWithTag:fxLowViewTag];
    [UIView animateWithDuration:0.2 animations:^{
        grayV.alpha = 0;
        fxView.frame = CGRectMake(0, DeviceMaxHeight, DeviceMaxWidth, 135*widthRate);
    }completion:^(BOOL finished) {
        [grayV removeFromSuperview];
        [fxView removeFromSuperview];
    }];
}

#pragma mark - 分享给微信好友
+ (void)sendMessageToWeiXinSession
{
    
    //自定义分享，哈哈哈哈哈哈ShareTypeQQSpace
    ShareType type = ShareTypeWeixiSession;
    
    //    NSString * tStr = [NSString stringWithFormat:@"%@",[self.fxDictionary objectForKey:@"theme"]];
    //    NSString * cStr = [NSString stringWithFormat:@"%@",[self.fxDictionary objectForKey:@"content"]];
    
    //    if (!self.tImg) {
    //        self.tImg = imageWithName(@"iconImg.png");
    //    }
    NSString * cStr= @"你好，请于2015年8月10日下午3:00前到达万州考场进行模拟考试训练。";
    id<ISSContent> publishContent = [ShareSDK content:cStr defaultContent:nil image:[ShareSDK pngImageWithImage:imageWithName(@"iconImg.png")] title:@"优易学车通知" url:@"http://www.bs-innotech.com/" description:cStr mediaType:SSPublishContentMediaTypeNews];
    [lhColor shareColor].noShowKaiChang = YES;
    
    [lhColor addActivityView:tempVC.view];
    
    //2.分享
    [ShareSDK showShareViewWithType:type container:nil content:publishContent statusBarTips:YES authOptions:nil shareOptions:nil result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
        
        [lhColor disAppearActivitiView:tempVC.view];
        
        //如果分享成功
        if (state == SSResponseStateSuccess) {
            //NSLog(@"分享成功");
            
            [lhColor showAlertWithMessage:@"发送成功" withSuperView:tempVC.view withHeih:DeviceMaxHeight/2];
            
            //增加积分
            //            [self addShareRecord];
            
        }
        else if (state == SSResponseStateFail) {//如果分享失败
            //NSLog(@"分享失败,错误码:%ld,错误描述%@",(long)[error errorCode],[error errorDescription]);
            
            if ([error errorCode] == -22003) {
                [lhColor showAlertWithMessage:@"请先安装微信客户端" withSuperView:tempVC.view withHeih:DeviceMaxHeight/2];
            }
            else if([error errorCode] == -22005){
                [lhColor showAlertWithMessage:@"取消发送" withSuperView:tempVC.view withHeih:DeviceMaxHeight/2];
            }
            else{
                [lhColor showAlertWithMessage:@"发送失败" withSuperView:tempVC.view withHeih:DeviceMaxHeight/2];
            }
            
        }
        else if (state == SSResponseStateCancel) {
            [lhColor showAlertWithMessage:@"取消发送" withSuperView:tempVC.view withHeih:DeviceMaxHeight/2];
            
        }
    }];
    
}

//根据定位城市，获取显示城市
- (NSString *)city:(NSString *)cityStr
{
    NSString *path=[[NSBundle mainBundle] pathForResource:@"citydict"
                                                   ofType:@"plist"];
    NSMutableDictionary * cities = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    NSMutableArray * keys = [NSMutableArray array];

    [keys addObjectsFromArray:[cities allKeys]];
    
    NSString * cStr = cityStr;
    
    for (NSString * city in keys) {
        NSArray * temA = [cities objectForKey:city];
        for (NSString * c in temA) {
            
            if ([[self nameToPinYinWith:cityStr] hasPrefix:[self nameToPinYinWith:c]]) {
                cStr = c;
            }
        }
    }
    
    return cStr;
}

- (NSString *)nameToPinYinWith:(NSString *)name
{
    HanyuPinyinOutputFormat *outputFormat=[[HanyuPinyinOutputFormat alloc] init];
    [outputFormat setToneType:ToneTypeWithoutTone];
    [outputFormat setVCharType:VCharTypeWithV];
    [outputFormat setCaseType:CaseTypeLowercase];
    NSString *outputPinyin=[PinyinHelper toHanyuPinyinStringWithNSString:name withHanyuPinyinOutputFormat:outputFormat withNSString:@""];
    
    return outputPinyin;
}

+ (CLLocationCoordinate2D)coordWithLocationStr:(NSString *)locationS
{
    NSRange range = [locationS rangeOfString:@"," options:NSLiteralSearch];
    if (range.length) {
        NSString * latitudeStr = [locationS substringFromIndex:range.location+1];
        NSString * longitudeStr = [locationS substringToIndex:range.location];
        
        CGFloat x = [latitudeStr floatValue];
        CGFloat y = [longitudeStr floatValue];
        
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(x,y);
        
        return coord;
    }
    
    return CLLocationCoordinate2DMake(0, 0);
}

- (UIView *)playVedio:(NSString *)url
{
    if (onlyColor.movie) {
        onlyColor.movie = nil;
    }
    
    onlyColor.movie = [[MPMoviePlayerViewController alloc] initWithContentURL :[NSURL fileURLWithPath :[[ NSBundle mainBundle ] pathForResource:url ofType:@"mp4"]]];
    onlyColor.movie.moviePlayer.controlStyle = MPMovieControlStyleNone;
    [onlyColor.movie.view setFrame:CGRectMake(15*widthRate, 64+10*widthRate, DeviceMaxWidth-30*widthRate, 150*widthRate)];
    //        self.movie.moviePlayer.initialPlaybackTime = -1;
    onlyColor.movie.moviePlayer.repeatMode = MPMovieRepeatModeOne;
    onlyColor.movie.moviePlayer.scalingMode = MPMovieScalingModeNone;
    [onlyColor.movie.moviePlayer play];
    
    return onlyColor.movie.view;
}

@end

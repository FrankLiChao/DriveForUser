//
//  AppDelegate.m
//  DriveForUser
//
//  Created by lichao on 16/3/21.
//  Copyright © 2016年 LiFrank. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "FrankLoginView.h"
#import "APIKey.h"
#import <AMapNaviKit/AMapNaviKit.h>
#import <ShareSDK/ShareSDK.h>

#import "iflyMSC/IFlySpeechSynthesizer.h"
#import "iflyMSC/IFlySpeechSynthesizerDelegate.h"
#import "iflyMSC/IFlySpeechConstant.h"
#import "iflyMSC/IFlySpeechUtility.h"
#import "iflyMSC/IFlySetting.h"

#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>

#import "FrankLoginView.h"
#import "FrankNewsNotice.h"
#import "lhFirmOrderViewController.h"
#import "FrankMyOrderDetailView.h"

@interface AppDelegate ()
{
    MainViewController* mainV;
    FrankLoginView *frankLogin;
    UIPageControl * pageControl;
}

@end

@implementation AppDelegate

- (void)configureAPIKey
{
    if ([APIKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"apiKey为空，请检查key是否正确设置" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    }
    
    [AMapNaviServices sharedServices].apiKey = (NSString *)APIKey;
    [MAMapServices sharedServices].apiKey = (NSString *)APIKey;
}

- (void)configIFlySpeech
{
    [IFlySpeechUtility createUtility:[NSString stringWithFormat:@"appid=%@,timeout=%@",@"5565399b",@"20000"]];
    
    [IFlySetting setLogFile:LVL_NONE];
    [IFlySetting showLogcat:NO];
    
    // 设置语音合成的参数
    [[IFlySpeechSynthesizer sharedInstance] setParameter:@"50" forKey:[IFlySpeechConstant SPEED]];//合成的语速,取值范围 0~100
    [[IFlySpeechSynthesizer sharedInstance] setParameter:@"50" forKey:[IFlySpeechConstant VOLUME]];//合成的音量;取值范围 0~100
    
    // 发音人,默认为”xiaoyan”;可以设置的参数列表可参考个 性化发音人列表;
    //    xiaoyan
    [[IFlySpeechSynthesizer sharedInstance] setParameter:@"xiaoyan" forKey:[IFlySpeechConstant VOICE_NAME]];
    
    // 音频采样率,目前支持的采样率有 16000 和 8000;
    [[IFlySpeechSynthesizer sharedInstance] setParameter:@"8000" forKey:[IFlySpeechConstant SAMPLE_RATE]];
    
    // 当你再不需要保存音频时，请在必要的地方加上这行。
    [[IFlySpeechSynthesizer sharedInstance] setParameter:nil forKey:[IFlySpeechConstant TTS_AUDIO_PATH]];
}

-(void)configWebUrlForFile{
    [FrankNetworkManager postReqeustWithURL:PATH(@"system/init/") params:@{} successBlock:^(id returnData){
        if ([[returnData objectForKey:@"status"]integerValue] == 1) {
            NSDictionary *dic = [returnData objectForKey:@"data"];
            if ([dic count]) {
                [lhColor shareColor].fileWebUrl = [NSString stringWithFormat:@"%@/",[dic objectForKey:@"fileServer"]];
                
                [lhColor shareColor].versionDic = [[NSDictionary alloc] initWithDictionary:[[dic objectForKey:@"appVersion"] objectForKey:@"apple"]];
                if (![[[lhColor shareColor].versionDic objectForKey:@"version"] isEqualToString:@""]) {
                    [lhColor shareColor].isEnableCheck = YES;
                    NSLog(@"版本号：%@",[[lhColor shareColor].versionDic objectForKey:@"version"]);
                }
            }else{
                [lhColor shareColor].fileWebUrl = [NSString stringWithFormat:@"http://up-driving/"];
                [lhColor shareColor].isEnableCheck = NO;
            }
            FLLog(@"fileWebUrl = %@",[lhColor shareColor].fileWebUrl);
        }else{
            [lhColor requestFailAlertShow:[returnData objectForKey:@"msg"]];
        }
    } failureBlock:^(NSError *error) {
        FLLog(@"%@",error.localizedDescription);
        [lhColor wangluoAlertShow];
    } showHUD:NO];
}

-(void)initShareFunction
{
    /**
     连接新浪微博开放平台应用以使用相关功能，此应用需要引用SinaWeiboConnection.framework
     http://open.weibo.com上注册新浪微博开放平台应用，并将相关信息填写到以下字段
     **/
    //    [ShareSDK connectSinaWeiboWithAppKey:@"3743201543"
    //                               appSecret:@"ec91521f86601bece92896617fe1355b"
    //                             redirectUri:@"http://www.baidu.com"];
    
    //    [ShareSDK connectSinaWeiboWithAppKey:@"3743201543"
    //                               appSecret:@"ec91521f86601bece92896617fe1355b"
    //                             redirectUri:@"http://www.baidu.com"
    //                            weiboSDKCls:[WeiboSDK class]];
    
    /**
     连接微信应用以使用相关功能，此应用需要引用WeChatConnection.framework和微信官方SDK
     http://open.weixin.qq.com上注册应用，并将相关信息填写以下字段
     **/
    [ShareSDK connectWeChatWithAppId:WeiXinAppID wechatCls:[WXApi class]];
    
    /**
     连接QQ应用以使用相关功能，此应用需要引用QQConnection.framework和QQApi.framework库
     http://mobile.qq.com/api/上注册应用，并将相关信息填写到以下字段
     **/
    //旧版中申请的AppId（如：QQxxxxxx类型），可以通过下面方法进行初始化
    //    [ShareSDK connectQQWithAppId:@"QQ075BCD15" qqApiCls:[QQApi class]];
    //801534719
    //    9761f42bdf3e47f06616ee3bc907dad8
    //    nLJnxQbs6bZ23PJk
    [ShareSDK connectQQWithQZoneAppKey:@"1105151755"
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    
    [ShareSDK connectQZoneWithAppKey:@"1105151755"
                           appSecret:@"wle2G3NAWfAHrulu"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [lhColor shareColor].realToken = TheOneDeviceToken;
    
    //请求文件上传的路径
    [self configWebUrlForFile];
    //检查高德地图的APIKey
    [self configureAPIKey];
    //配置语音
    [self configIFlySpeech];
    
    if (launchOptions && launchOptions.count) {
        NSDictionary * userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if(userInfo)
            
        {
            [lhColor shareColor].pushToNoticeView = YES;
            [lhColor shareColor].apnsDic = [NSDictionary dictionaryWithDictionary:userInfo];
            [lhColor shareColor].type = 1;
        }
    }
    
    //注册通知
    if (IOS8)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)categories:nil]];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
    
    NSString * runCountStr = [[NSUserDefaults standardUserDefaults]objectForKey:runCount];
    if ([runCountStr integerValue] != 1) {//第一次运行程序，开场动画
        frankLogin = [[FrankLoginView alloc] init];
        UINavigationController * nmVC = [[UINavigationController alloc]initWithRootViewController:frankLogin];
        self.window.rootViewController = nmVC;
        [lhColor shareColor].delegateWindow = self.window;
        
        UIScrollView * maxScrollView = [[UIScrollView alloc]initWithFrame:self.window.frame];
        maxScrollView.tag = 101;
        maxScrollView.delegate = self;
        maxScrollView.pagingEnabled = YES;
        maxScrollView.showsHorizontalScrollIndicator = NO;
        maxScrollView.backgroundColor = [UIColor whiteColor];
        [frankLogin.view addSubview:maxScrollView];
        
        pageControl = [[UIPageControl alloc]init];
        pageControl.center = CGPointMake(DeviceMaxWidth/2, DeviceMaxHeight-20*widthRate);
        pageControl.numberOfPages = 3;
        pageControl.currentPage = 0;
        pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        pageControl.pageIndicatorTintColor = [lhColor colorFromHexRGB:mainColorStr];
        [frankLogin.view addSubview:pageControl];
        
        NSInteger j = 40;
        if (iPhone5 || iPhone6 || iPhone6plus) {
            j = 0;
        }
        for (int i=0; i<3; i++) {
            NSString * fileS = [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"kaichangImage%ld",(long)i+j] ofType:@"png"];
            UIImageView * imgView = [[UIImageView alloc]initWithFrame:CGRectMake(DeviceMaxWidth*i, 0, DeviceMaxWidth, DeviceMaxHeight)];
            imgView.image = [UIImage imageWithContentsOfFile:fileS];
            [maxScrollView addSubview:imgView];
        }
        
        maxScrollView.contentSize = CGSizeMake(DeviceMaxWidth*4, DeviceMaxHeight);
    }else{
        mainV = [[MainViewController alloc]init];
        [mainV autoLogin];
        
        UINavigationController * nmVC = [[UINavigationController alloc] initWithRootViewController:mainV];
        self.window.rootViewController = nmVC;
    }
    
    //开辟线程初始化数据
    [self performSelectorInBackground:@selector(prepareSqliteData) withObject:nil];
    
    [lhColor shareColor].delegateWindow = self.window;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)prepareSqliteData
{
    //读取本地数据库中的数据，并存储到沙盒sqlite数据库中
    [ManageSqlite readAccessDataBaseAndSaveToSqlite];
    
    [ManageSqlite readDbDataBaseAndSaveToSqlite];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    pageControl.currentPage = scrollView.contentOffset.x/DeviceMaxWidth;
    
    UIButton * clickBtn = (UIButton *)[scrollView viewWithTag:102];
    if (clickBtn) {
        [clickBtn removeFromSuperview];
    }
    
    if(scrollView.contentOffset.x <= DeviceMaxWidth*2){
        scrollView.backgroundColor = [UIColor whiteColor];
    }
    else if(scrollView.contentOffset.x >= DeviceMaxWidth*2){
        scrollView.backgroundColor = [UIColor clearColor];
    }
    
    if (scrollView.contentOffset.x == DeviceMaxWidth*2) {
        clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        clickBtn.tag = 102;
        clickBtn.frame = CGRectMake(DeviceMaxWidth*2, 0, DeviceMaxWidth, DeviceMaxHeight);
        [clickBtn addTarget:self action:@selector(clickStart) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:clickBtn];
        
        scrollView.backgroundColor = [UIColor clearColor];
    }
    else if(scrollView.contentOffset.x == DeviceMaxWidth*3){
        [scrollView removeFromSuperview];
        [pageControl removeFromSuperview];
        
        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:runCount];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    
}

- (void)clickStart
{
    UIScrollView * tempS = (UIScrollView *)[frankLogin.view viewWithTag:101];
    
    [UIView animateWithDuration:0.5 animations:^{
        tempS.transform = CGAffineTransformMakeScale(2, 2);
        tempS.alpha = 0;
        
    }completion:^(BOOL finished) {
        [tempS removeFromSuperview];
        [pageControl removeFromSuperview];
        
        //        FrankLoginView * lVC = [[FrankLoginView alloc]init];
        //        lVC.type = 6;
        //        UINavigationController * nlVC = [[UINavigationController alloc] initWithRootViewController:lVC];
        //        [frankLogin.navigationController presentViewController:nlVC animated:YES completion:^{
        //
        //        }];
        
        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:runCount];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }];
}

#pragma mark - 第三方的跳转
//实现分享跳转页面
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    NSLog(@"1url = %@   [url host] = %@",url,[url host]);
    
    if (url != nil && [[url host] isEqualToString:@"safepay"]) {
        //支付宝处理
        //        [self parse:url application:application];
        
        return YES;
    }
    else if(url != nil && [[url host] isEqualToString:@"pay"]){
        //微信支付
        return [WXApi handleOpenURL:url delegate:self];
    }
    else{
        //第三方分享处理
        return [ShareSDK handleOpenURL:url wxDelegate:self];
    }
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSLog(@"2url = %@   [url host] = %@",url,[url host]);
    
    if (url != nil && [[url host] isEqualToString:@"safepay"]) {
        //支付宝处理
        //        [self parse:url application:application];
        //跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给SDK
        [[AlipaySDK defaultService]
         processOrderWithPaymentResult:url
         standbyCallback:^(NSDictionary *resultDic) {
             NSLog(@"result = %@", resultDic);
             
             UIViewController * tem = [lhColor shareColor].tempViewC;
             //             NSDictionary * di = [lhColor shareColor].tempOrderDi;
             
             if ([lhColor shareColor].payS == BUY_GOODS){
                 
                 lhFirmOrderViewController * a = (lhFirmOrderViewController *)tem;
                 
                 if([[resultDic objectForKey:@"resultStatus"]integerValue] == 9000){//支付成功
                     
                     [lhColor showAlertWithMessage:@"支付成功" withSuperView:a.view withHeih:DeviceMaxHeight/2];
                     FrankMyOrderDetailView *order = [[FrankMyOrderDetailView alloc] init];
                     [tem.navigationController pushViewController:order animated:YES];
                     //                     [a performSelector:@selector(toMyOrder) withObject:nil afterDelay:1.5];
                     //
                     //                     [[NSUserDefaults standardUserDefaults]setObject:[NSArray array] forKey:savegouwuchefile];
                     //                     [[NSUserDefaults standardUserDefaults]synchronize];
                     
                 }
                 else if([[resultDic objectForKey:@"resultStatus"]integerValue] == 6002){
                     
                     UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请求超时" message:@"请检查网络或稍后重试！" delegate:a cancelButtonTitle:@"取消支付" otherButtonTitles:@"重新支付", nil];
                     alertView.tag = 4;
                     [alertView show];
                     
                 }
                 else{//支付失败
                     
                     UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"支付失败！请重新支付，或选择其他方式支付！" delegate:a cancelButtonTitle:@"取消支付" otherButtonTitles:@"重新支付", nil];
                     alertView.tag = 4;
                     [alertView show];
                     
                 }
             }
             else if([lhColor shareColor].payS == CHONGZHIYUE){
                 if([[resultDic objectForKey:@"resultStatus"]integerValue] == 9000){//支付成功
                     [lhColor showAlertWithMessage:@"支付成功" withSuperView:tem.view withHeih:DeviceMaxHeight/2];
                     
                     //                     double money = [[[lhColor shareColor].userInfo objectForKey:@"gold"]doubleValue]+[[di objectForKey:@"money"]doubleValue]+[[di objectForKey:@"present"]doubleValue];
                     //                     NSString * moneyStr = [NSString stringWithFormat:@"%f",money];
                     //                     [[lhColor shareColor].userInfo setObject:moneyStr forKey:@"gold"];
                     //
                     //                     lhChongZhiViewController * a = (lhChongZhiViewController *)tem;
                     //                     [a performSelector:@selector(backToForeView) withObject:nil afterDelay:1.5];
                     
                 }
                 else if([[resultDic objectForKey:@"resultStatus"]integerValue] == 6002){
                     UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请求超时" message:@"请检查网络或稍后重试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                     [alertView show];
                     
                 }
                 else{//支付失败
                     UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"支付失败，请重新支付！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                     [alertView show];
                     
                 }
             }
             
         }];
        
        return YES;
    }
    else if(url != nil && [[url host] isEqualToString:@"pay"]){
        return [WXApi handleOpenURL:url delegate:self];
    }
    else{
        return [ShareSDK handleOpenURL:url sourceApplication:sourceApplication annotation:annotation wxDelegate:self];
        //        return YES;
    }
}

//收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
- (void)onResp:(BaseResp *)resp
{
    if ([resp isKindOfClass:[PayResp class]])
    {
        PayResp *response = (PayResp *)resp;
        UIViewController * tem = [lhColor shareColor].tempViewC;
        NSDictionary * di = [lhColor shareColor].tempOrderDi;
        
        switch (response.errCode) {
            case WXSuccess: {
                
                if ([lhColor shareColor].payS == BUY_GOODS){
                    lhFirmOrderViewController * a = (lhFirmOrderViewController *)tem;
                    [lhColor showAlertWithMessage:@"支付成功" withSuperView:a.view withHeih:DeviceMaxHeight/2];
                    FrankMyOrderDetailView *order = [[FrankMyOrderDetailView alloc] init];
                    [tem.navigationController pushViewController:order animated:YES];
                    //                    [a performSelector:@selector(toMyOrder) withObject:nil afterDelay:1.5];
                    //
                    //                    [[NSUserDefaults standardUserDefaults]setObject:[NSArray array] forKey:savegouwuchefile];
                    //                    [[NSUserDefaults standardUserDefaults]synchronize];
                }
                else if([lhColor shareColor].payS == CHONGZHIYUE){
                    [lhColor showAlertWithMessage:@"支付成功" withSuperView:tem.view withHeih:DeviceMaxHeight/2];
                    
                    double money = [[[lhColor shareColor].userInfo objectForKey:@"gold"]doubleValue]+[[di objectForKey:@"money"]doubleValue]+[[di objectForKey:@"present"]doubleValue];
                    NSString * moneyStr = [NSString stringWithFormat:@"%f",money];
                    [[lhColor shareColor].userInfo setObject:moneyStr forKey:@"gold"];
                    
                    lhFirmOrderViewController * a = (lhFirmOrderViewController *)tem;
                    a.view.userInteractionEnabled = NO;
                    [a performSelector:@selector(toOrderView) withObject:nil afterDelay:1.5];
                }
                break;
            }
                
            default: {
                
                if ([lhColor shareColor].payS == BUY_GOODS){
                    //                    lhSettleViewController * a = (lhSettleViewController *)tem;
                    //                    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"支付失败！请重新支付，或选择其他方式支付！" delegate:a cancelButtonTitle:@"取消支付" otherButtonTitles:@"重新支付", nil];
                    //                    alertView.tag = 4;
                    //                    [alertView show];
                }
                else if([lhColor shareColor].payS == CHONGZHIYUE){
                    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"支付失败，请重新支付！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertView show];
                }
                
                break;
            }
        }
    }
    
}

#pragma mark - 通知
#pragma mark - 远程通知
//消息推送
//获取DeviceToken成功
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    //这里进行的操作，是将Device Token发送到服务器上
    
    //    if (!deviceToken) {
    //        [lhColor shareColor].realToken = TheOneDeviceToken;
    //        return;
    //    }
    
    NSString *token =
    [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"
                                                           withString:@""]
      stringByReplacingOccurrencesOfString:@">"
      withString:@""]
     stringByReplacingOccurrencesOfString:@" "
     withString:@""];
    
    
    if (!token || [token isEqualToString:@""]) {
        
    }
    else{
        //这里进行的操作，是将Device Token发送到服务器上
        [lhColor shareColor].realToken = [NSString stringWithFormat:@"%@",token];
        
        NSString * localStr = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:saveLocalTokenFile]];
        if (![[lhColor shareColor].realToken isEqualToString:localStr]) {
            [[NSUserDefaults standardUserDefaults]setObject:[lhColor shareColor].realToken forKey:saveLocalTokenFile];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
        [mainV autoLogin];
    }
    
    NSLog(@"token = %@",token);
    
    
}

//注册消息推送失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSString * error_str = [NSString stringWithFormat:@"%@",error];
    NSLog(@"%@",error_str);
    
    [lhColor shareColor].realToken = TheOneDeviceToken;
    //    [mVC autoLogin];
}

//处理收到的消息推送
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    application.applicationIconBadgeNumber += 1;
    [lhColor shareColor].apnsDic = [NSDictionary dictionaryWithDictionary:userInfo];
    
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 5;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 5) {
        if (buttonIndex == 1) {
            NSLog(@"消息中心");
            FrankNewsNotice *notice = [[FrankNewsNotice alloc] init];
            [(UINavigationController *)mainV.navigationController pushViewController:notice animated:YES];
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

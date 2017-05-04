//
//  lhQuestionDetailViewController.m
//  GasStation
//
//  Created by bosheng on 16/2/22.
//  Copyright © 2016年 bosheng. All rights reserved.
//

#import "lhQuestionDetailViewController.h"
#import "NJKWebViewProgressView.h"

@interface lhQuestionDetailViewController ()<UIWebViewDelegate>
{
    NSDictionary * detailDic;//问题详情
    
    UIScrollView * maxScrollView;
    
    //加载进度条显示
    UIProgressView * fxProgressView;
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
    
    UIWebView * ansWebView;
    CGFloat lastHeih;
    
    UIView * funView;//分享及标识是否解决功能条
    UIButton * zanBtn;//是否解决按钮
    UILabel * zanLabel;
}

@end

@implementation lhQuestionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[lhColor shareColor]originalInit:self title:@"帮助中心" imageName:nil backButton:YES];
    
    [lhColor addActivityView123:self.view];
    NSDictionary * dic = @{@"userId":[[lhColor shareColor].userInfo objectForKey:@"id"],
                           @"id":self.questionIdStr};
    
    [FrankNetworkManager postReqeustWithURL:PATH(@"help/question") params:dic successBlock:^(id returnData){
        [lhColor disAppearActivitiView:self.view];
        if ([[returnData objectForKey:@"status"]integerValue] == 1) {
            detailDic = [returnData objectForKey:@"data"];
            [self firmInit];
        }else{
            [FrankTools requestFailAlertShow:[returnData objectForKey:@"msg"]];
        }
    } failureBlock:^(NSError *error) {
        FLLog(@"%@",error.localizedDescription);
        [FrankTools wangluoAlertShow];
        [lhColor disAppearActivitiView:self.view];
    } showHUD:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - firmInit
- (void)firmInit
{
    maxScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, DeviceMaxWidth, DeviceMaxHeight-64)];
    maxScrollView.showsVerticalScrollIndicator = NO;
    maxScrollView.backgroundColor = [lhColor colorFromHexRGB:viewColorStr];
    [self.view addSubview:maxScrollView];
    
    UIView * whiteView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 0)];
    whiteView1.backgroundColor = [UIColor whiteColor];
    [maxScrollView addSubview:whiteView1];
    
    CGFloat heih = 15*widthRate;
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, heih, DeviceMaxWidth-20*widthRate, 10)];
    titleLabel.numberOfLines = 0;
    titleLabel.font = [UIFont fontWithName:fontName size:16];
    titleLabel.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
    titleLabel.text = [NSString stringWithFormat:@"%@",[detailDic objectForKey:@"title"]];
    [maxScrollView addSubview:titleLabel];
    [titleLabel sizeToFit];
    
    heih += CGRectGetHeight(titleLabel.frame)+10*widthRate;
    lastHeih = heih;
    CGRect rec = whiteView1.frame;
    rec.size.height = lastHeih;
    whiteView1.frame = rec;
    
    ansWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, heih, DeviceMaxWidth, 100*widthRate)];
    ansWebView.backgroundColor = [UIColor whiteColor];
    ansWebView.userInteractionEnabled = NO;
//  ansWebView.scalesPageToFit = YES;
    ansWebView.delegate = self;
    ansWebView.scrollView.scrollEnabled = NO;
    ansWebView.scrollView.showsVerticalScrollIndicator = NO;
    ansWebView.scrollView.showsHorizontalScrollIndicator = NO;
    [maxScrollView addSubview:ansWebView];
    
    _progressProxy = [[NJKWebViewProgress alloc] init];
    ansWebView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:CGRectMake(0, 64, DeviceMaxWidth, 2.0)];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:_progressView];
    
    [_progressView setProgress:0 animated:NO];
    
    heih += 107*widthRate;
    
    funView = [[UIView alloc]initWithFrame:CGRectMake(0, heih, DeviceMaxWidth, 100*widthRate)];
    funView.backgroundColor = [UIColor whiteColor];
    [maxScrollView addSubview:funView];
    
    NSArray * imgArray = @[
                    imageWithName(@"helpCenterQuestionNoAnswer"),
                    imageWithName(@"helpCenterShareIcon")];
    NSArray * tArray = @[@"是否解决",@"分享"];
    for (int i = 0; i < 2; i++) {
        UIButton * funBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        funBtn.frame = CGRectMake(DeviceMaxWidth/2*i, 0, DeviceMaxWidth/2, 80*widthRate);
        funBtn.tag = i;
        [funBtn setImage:[imgArray objectAtIndex:i] forState:UIControlStateNormal];
        
        [funBtn addTarget:self action:@selector(funBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
        [funView addSubview:funBtn];
        
        UILabel * tLabel = [[UILabel alloc]initWithFrame:CGRectMake(DeviceMaxWidth/2*i, 60*widthRate, DeviceMaxWidth/2, 40*widthRate)];
        tLabel.textAlignment = NSTextAlignmentCenter;
        tLabel.font = [UIFont fontWithName:fontName size:14];
        tLabel.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
        tLabel.text = [tArray objectAtIndex:i];
        [funView addSubview:tLabel];
        
        if (i == 0) {
            [funBtn setImage:imageWithName(@"helpCenterQuestionAnswered") forState:UIControlStateSelected];
            NSString * isLikeStr = [NSString stringWithFormat:@"%@",[detailDic objectForKey:@"isLike"]];
            if ([isLikeStr integerValue]) {
                funBtn.selected = YES;
                tLabel.textColor = [lhColor colorFromHexRGB:@"ff5855"];
                tLabel.text = @"已解决";
                funBtn.userInteractionEnabled = NO;
            }
            zanBtn = funBtn;
            zanLabel = tLabel;
        }
    }
    
    [self loadWebView];
}

#pragma mark - 
- (void)funBtnEvent:(UIButton *)button_
{
    switch (button_.tag) {
        case 0:{
            if (button_.selected) {
                return;
            }
            else{
                zanBtn.userInteractionEnabled = NO;
                [UIView animateWithDuration:0.2 animations:^{
                    zanBtn.transform = CGAffineTransformMakeScale(1.25, 1.25);
                }completion:^(BOOL finished) {
                    zanBtn.selected = YES;
                    zanLabel.textColor = [lhColor colorFromHexRGB:@"ff5855"];
                    zanLabel.text = @"已解决";
                    [UIView animateWithDuration:0.2 animations:^{
                        zanBtn.transform = CGAffineTransformMakeScale(1, 1);
                    }completion:^(BOOL finished) {
                        NSDictionary * dic = @{@"userId":[[lhColor shareColor].userInfo objectForKey:@"id"],
                                               @"id":[detailDic objectForKey:@"id"]};
                        
                        [FrankNetworkManager postReqeustWithURL:PATH(@"help/like") params:dic successBlock:^(id returnData){
                            zanBtn.userInteractionEnabled = YES;
                            if ([[returnData objectForKey:@"status"]integerValue] == 1) {
                                FLLog(@"%@",returnData);
                            }else{
                                zanBtn.selected = NO;
                                zanLabel.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
                                zanLabel.text = @"是否解决";
                            }
                        } failureBlock:^(NSError *error) {
                            zanBtn.selected = NO;
                            zanLabel.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
                            zanLabel.text = @"是否解决";
                        } showHUD:NO];
                    }];
                }];
            }
            break;
        }
        case 1:{
            NSString * titleStr = [NSString stringWithFormat:@"%@",[detailDic objectForKey:@"title"]];
            NSString * urlStr = [NSString stringWithFormat:@"%@/action/help_findQuestionDetail?userId=%@&questionId=%@",webUrl,[[lhColor shareColor].userInfo objectForKey:@"id"],[detailDic objectForKey:@"id"]];
            urlStr = @"www.baidu.com";
            [lhColor fxViewAppear:nil conStr:titleStr withUrlStr:urlStr];
            break;
        }
        default:
            break;
    }
}

#pragma mark - 加载
- (void)loadWebView
{
    NSString * hStr = [NSString stringWithFormat:@"%@",[detailDic objectForKey:@"content"]];
    [ansWebView loadHTMLString:hStr baseURL:nil];
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
    
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    CGRect rrr = webView.frame;
    rrr.size.height = webView.scrollView.contentSize.height;
    webView.frame = rrr;
    
//    if (webView.scrollView.contentSize.height == 100*widthRate) {
//        [self loadWebView];
//    }
//    else{
        [_progressView setProgress:1 animated:YES];
//    }
    
    CGRect re = webView.frame;
    re.size.height = webView.frame.size.height+10;
    webView.frame = re;
    
    CGFloat heih = lastHeih+CGRectGetHeight(re);
    
    CGRect funRec = funView.frame;
    funRec.origin.y = heih+7*widthRate;
    funView.frame = funRec;
    
    heih = lastHeih+CGRectGetHeight(re)+107*widthRate;
    
    maxScrollView.contentSize = CGSizeMake(DeviceMaxWidth, heih);
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
    [lhColor addANullLabelWithSuperView:webView withFrame:CGRectMake(0, 10*widthRate, DeviceMaxWidth, 100*widthRate) withText:@"加载失败~"];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [_progressView setProgress:0 animated:YES];
}

#pragma mark - view
- (void)viewWillAppear:(BOOL)animated
{
    [lhColor assignmentForTempVC:self];
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

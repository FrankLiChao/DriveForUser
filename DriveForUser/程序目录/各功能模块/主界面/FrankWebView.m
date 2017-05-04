//
//  FrankWebView.m
//  Drive
//
//  Created by lichao on 15/11/10.
//  Copyright © 2015年 bosheng. All rights reserved.
//

#import "FrankWebView.h"
#import "NJKWebViewProgressView.h"

@interface FrankWebView ()<UIWebViewDelegate>
{
    UIWebView * fxWebView;
    //加载进度条显示
    UIProgressView * fxProgressView;
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
}

@end

@implementation FrankWebView

- (void)viewDidLoad {
    [super viewDidLoad];
    [[lhColor shareColor]originalInit:self title:_nameStr imageName:nil backButton:YES];
    NSLog(@"aa = %@",self.myWebUrl);
    if ([self.myWebUrl isEqualToString:@""] || self.myWebUrl == nil) {
        [lhColor addANullLabelWithSuperView:self.view withFrame:CGRectMake(10*widthRate, 70*widthRate, 300*widthRate, 20*widthRate) withText:@"暂无数据"];
    }else{
        [self initFrameView];
    }
}

-(void)initFrameView
{
    fxWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, DeviceMaxWidth, DeviceMaxHeight-64)];
    fxWebView.delegate = self;
    fxWebView.scalesPageToFit = YES;
    [self.view addSubview:fxWebView];
    
    _progressProxy = [[NJKWebViewProgress alloc] init];
    fxWebView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:CGRectMake(0, 64, DeviceMaxWidth, 2.0)];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:_progressView];
    
    [_progressView setProgress:0 animated:NO];
    
    NSURLRequest * req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.myWebUrl]];


    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    [fxWebView loadRequest:req];
}

#pragma mark - UITableViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    //    NSLog(@"");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
    NSLog(@"加载完成");
    fxWebView.scrollView.contentOffset = CGPointMake(0, 0);
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
//    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"网络不可用" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//    [alertView show];
    
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
    
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

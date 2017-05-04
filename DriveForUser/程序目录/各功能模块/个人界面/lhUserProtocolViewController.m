//
//  lhUserProtocolViewController.m
//  GasStation
//
//  Created by bosheng on 15/11/9.
//  Copyright © 2015年 bosheng. All rights reserved.
//

#import "lhUserProtocolViewController.h"
#import "NJKWebViewProgressView.h"

@interface lhUserProtocolViewController ()
{
    //显示服务条款
    UIWebView * fxWebView;
    //加载进度条显示
    UIProgressView * fxProgressView;
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
}

@end

@implementation lhUserProtocolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[lhColor shareColor]originalInit:self title:self.type==5?@"详情":@"用户协议" imageName:nil backButton:YES];
    
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
    
    NSURLRequest *req;
    if(self.type == 5){
        req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.urlStr]];
    }
    else{
        req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://up-driving.com/f/agreement"]];
    }

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [fxWebView loadRequest:req];
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    //    NSLog(@"");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
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

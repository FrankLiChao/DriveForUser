//
//  lhWelcomPageViewController.m
//  GasStation
//
//  Created by bosheng on 15/11/11.
//  Copyright © 2015年 bosheng. All rights reserved.
//

#import "lhWelcomPageViewController.h"

@interface lhWelcomPageViewController ()<UIScrollViewDelegate>
{
    UIPageControl * pageControl;
}

@end

@implementation lhWelcomPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIScrollView * maxScrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    maxScrollView.tag = 101;
    maxScrollView.delegate = self;
    maxScrollView.pagingEnabled = YES;
    maxScrollView.showsHorizontalScrollIndicator = NO;
    maxScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:maxScrollView];
    
    pageControl = [[UIPageControl alloc]init];
    pageControl.center = CGPointMake(DeviceMaxWidth/2, DeviceMaxHeight-20*widthRate);
    pageControl.numberOfPages = 3;
    pageControl.currentPage = 0;
    pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    pageControl.pageIndicatorTintColor = [lhColor colorFromHexRGB:mainColorStr];
    [self.view addSubview:pageControl];
    
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
    
    maxScrollView.contentSize = CGSizeMake(DeviceMaxWidth*3, DeviceMaxHeight);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    else if(scrollView.contentOffset.x < -5){
//        [self clickStart];
    }
    
}

- (void)clickStart
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - view
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [lhColor assignmentForTempVC:self];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
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

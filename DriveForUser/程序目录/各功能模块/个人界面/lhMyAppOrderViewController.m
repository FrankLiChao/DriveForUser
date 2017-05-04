//
//  lhMyAppOrderViewController.m
//  Drive
//
//  Created by bosheng on 15/8/18.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import "lhMyAppOrderViewController.h"

@interface lhMyAppOrderViewController ()

@end

@implementation lhMyAppOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[lhColor shareColor]originalInit:self title:@"预约订单" imageName:nil backButton:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - view
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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

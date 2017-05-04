//
//  FrankStudyBySelfView.m
//  Drive
//
//  Created by lichao on 15/11/9.
//  Copyright © 2015年 bosheng. All rights reserved.
//

#import "FrankStudyBySelfView.h"

@interface FrankStudyBySelfView ()<UIAlertViewDelegate>

@end

@implementation FrankStudyBySelfView

- (void)viewDidLoad {
    [super viewDidLoad];
    [[lhColor shareColor]originalInit:self title:@"自学自考" imageName:nil backButton:YES];
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"开发中，敬请期待！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
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

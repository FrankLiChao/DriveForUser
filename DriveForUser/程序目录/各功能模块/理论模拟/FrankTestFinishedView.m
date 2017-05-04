//
//  FrankTestFinishedView.m
//  Drive
//
//  Created by lichao on 15/8/27.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import "FrankTestFinishedView.h"
#import "FrankRemindView.h"
#import "FrankPracticeView.h"

@interface FrankTestFinishedView ()

@end

@implementation FrankTestFinishedView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initFrameView];
}

-(void)initFrameView{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, DeviceMaxHeight)];
    [self.view addSubview:bgView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, DeviceMaxHeight)];
    if (_scoreForTest<90) {
        if(iPhone5||iPhone6||iPhone6plus){
            [imageView setImage:imageWithName(@"testUnPassed56.jpg")];
        }
        else{
            [imageView setImage:imageWithName(@"testUnPassed4.jpg")];
        }
        
    }else if (_scoreForTest<=100){
        if(iPhone5||iPhone6||iPhone6plus){
            [imageView setImage:imageWithName(@"testPassed56.jpg")];
        }
        else{
            [imageView setImage:imageWithName(@"testPassed4.jpg")];
        }
    }
    
    [bgView addSubview:imageView];
    
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [returnBtn setBackgroundImage:imageWithName(@"close") forState:UIControlStateNormal];
    returnBtn.frame = CGRectMake(DeviceMaxWidth-50*widthRate, 22, 40*widthRate, 40*widthRate);
    [returnBtn addTarget:self action:@selector(clickReturnBtn) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:returnBtn];
    
//    UILabel *nameLb = [[UILabel alloc] initWithFrame:CGRectMake(DeviceMaxWidth-90*widthRate, 64+65*widthRate, 90*widthRate, 20*widthRate)];
//    nameLb.text = @"回家的诱惑";
//    nameLb.font = [UIFont systemFontOfSize:13];
//    nameLb.textColor = [UIColor whiteColor];
//    [bgView addSubview:nameLb];
    
    CGFloat oY = DeviceMaxHeight-100*widthRate;
    if (iPhone5 || iPhone6 || iPhone6plus) {
        oY = DeviceMaxHeight-117*widthRate;
    }
    
    UILabel *scoreLb = [[UILabel alloc] initWithFrame:CGRectMake(DeviceMaxWidth/3-22*widthRate, oY, DeviceMaxWidth/6+15*widthRate, 20*widthRate)];
    scoreLb.text = [NSString stringWithFormat:@"%ld 分",(long)_scoreForTest];
    scoreLb.font = [UIFont systemFontOfSize:15];
    scoreLb.textColor = [lhColor colorFromHexRGB:@"ffdc18"];
    [bgView addSubview:scoreLb];
    
    UILabel *timeLb = [[UILabel alloc] initWithFrame:CGRectMake(DeviceMaxWidth*2/3, oY, DeviceMaxWidth/3-10*widthRate, 20*widthRate)];
    timeLb.text = [NSString stringWithFormat:@"%ld:%ld",(long)((45*60-_timeForseconds)/60)%60,(long)(45*60-_timeForseconds)%60];
    timeLb.font = [UIFont systemFontOfSize:15];
    timeLb.textColor = [lhColor colorFromHexRGB:@"ffdc18"];;
    [bgView addSubview:timeLb];
    
    UIButton *lookError = [UIButton buttonWithType:UIButtonTypeCustom];
    lookError.frame = CGRectMake(10*widthRate, DeviceMaxHeight-50*widthRate, 100*widthRate, 45*widthRate);
    [lookError addTarget:self action:@selector(lookErrorEvent) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:lookError];
    
    UIButton *testAgain = [UIButton buttonWithType:UIButtonTypeCustom];
    testAgain.frame = CGRectMake(DeviceMaxWidth-110*widthRate, DeviceMaxHeight-50*widthRate, 100*widthRate, 45*widthRate);
    [testAgain addTarget:self action:@selector(clickTestAgainBtn) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:testAgain];
}

#pragma mark - 查看错题
- (void)lookErrorEvent
{
    NSMutableArray *wrongTopicArray = [ManageSqlite findWrongRecord];
    if (![wrongTopicArray count]) {
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"暂无错题" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [myAlertView show];
    }else{
        FrankPracticeView *practiceView = [[FrankPracticeView alloc] init];
        practiceView.recordJump = WRONG_QUESTION;
        practiceView.titleStr = @"我的错题";
        practiceView.sqliteArray = wrongTopicArray;
        practiceView.datacount = wrongTopicArray.count;
        [self.navigationController pushViewController:practiceView animated:YES];
        
        [self removeThisVC];
    }
}

-(void)clickTestAgainBtn
{
    FrankRemindView *remindView = [[FrankRemindView alloc] init];
    [self.navigationController pushViewController:remindView animated:YES];
    
    [self removeThisVC];
    
}

#pragma mark - 移除当前页面
- (void)removeThisVC
{
    NSMutableArray * tempVC = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    
    for (UIViewController * vc in tempVC) {
        if ([vc class] == [self class]) {
            [tempVC removeObject:vc];
            break;
        }
    }
    
    self.navigationController.viewControllers = tempVC;
}

#pragma mark - 返回
-(void)clickReturnBtn{
    [self.navigationController popViewControllerAnimated:YES];

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

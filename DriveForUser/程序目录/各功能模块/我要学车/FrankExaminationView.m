//
//  FrankExaminationView.m
//  Drive
//
//  Created by lichao on 15/8/28.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import "FrankExaminationView.h"

@interface FrankExaminationView ()

@end

@implementation FrankExaminationView

- (void)viewDidLoad {
    [super viewDidLoad];
    [[lhColor shareColor]originalInit:self title:@"考项说明" imageName:nil backButton:YES];
    [self initFrameView];
}

-(void)initFrameView{
    CGFloat hight = 0;
    UIScrollView *myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, DeviceMaxWidth, DeviceMaxHeight-64)];
    myScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:myScrollView];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15*widthRate, 10*widthRate, 200*widthRate, 20*widthRate)];
    lab.text = @"2015年国家规定";
    lab.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
    lab.font = [UIFont systemFontOfSize:15];
    [myScrollView addSubview:lab];
    
    UIImageView *subOne = [[UIImageView alloc] initWithFrame:CGRectMake(15*widthRate, 40*widthRate, 60*widthRate, 20*widthRate)];
    [subOne setImage:imageWithName(@"subOne")];
    [myScrollView addSubview:subOne];
    
    UILabel *textLab = [[UILabel alloc] initWithFrame:CGRectMake(15*widthRate, 70*widthRate, DeviceMaxWidth-30*widthRate, 10*widthRate)];
    textLab.font = [UIFont systemFontOfSize:15];
    textLab.text = @"理论培训31学时，就是交通规则的学习，参加理论考试，采用电脑无纸化考试形式，1000道题随机抽取100道作答，考试时间45分钟，满分100分，90分为及格。";
    textLab.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
    textLab.numberOfLines = 0;
    [textLab sizeToFit];
    textLab.frame = CGRectMake(15*widthRate, 70*widthRate, textLab.frame.size.width, textLab.frame.size.height);
    [myScrollView addSubview:textLab];
    
    hight = 70*widthRate+textLab.frame.size.height +10*widthRate;
    
    UIImageView *subTwo = [[UIImageView alloc] initWithFrame:CGRectMake(15*widthRate, hight, 60*widthRate, 20*widthRate)];
    [subTwo setImage:imageWithName(@"subTwo")];
    [myScrollView addSubview:subTwo];
    
    hight = hight + 30*widthRate;
    UILabel *textSubTwo = [[UILabel alloc] initWithFrame:CGRectMake(15*widthRate, hight, DeviceMaxWidth-30*widthRate, 10*widthRate)];
    textSubTwo.text = @"理论培训31学时，就是交通规则的学习，参加理论考试，采用电脑无纸化考试形式，1000道题随机抽取100道作答，考试时间45分钟，满分100分，90分为及格。理论培训31学时，就是交通规则的学习，参加理论考试，采用电脑无纸化考试形式，1000道题随机抽取100道作答，考试时间45分钟，满分100分，90分为及格。";
    textSubTwo.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
    textSubTwo.numberOfLines = 0;
    textSubTwo.font = [UIFont systemFontOfSize:15];
    [textSubTwo sizeToFit];
    [myScrollView addSubview:textSubTwo];
    
    hight = hight+textSubTwo.frame.size.height+10*widthRate;
    
    UIImageView *subThree = [[UIImageView alloc] initWithFrame:CGRectMake(15*widthRate, hight, 60*widthRate, 20*widthRate)];
    [subThree setImage:imageWithName(@"subThree")];
    [myScrollView addSubview:subThree];
    
    hight = hight + 30*widthRate;
    UILabel *threeLable = [[UILabel alloc] initWithFrame:CGRectMake(15*widthRate, hight, DeviceMaxWidth-30*widthRate, 10*widthRate)];
    threeLable.text = @"理论培训31学时，就是交通规则的学习，参加理论考试，采用电脑无纸化考试形式，1000道题随机抽取100道作答，考试时间45分钟，满分100分，90分为及格。";
    threeLable.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
    threeLable.numberOfLines = 0;
    threeLable.font = [UIFont systemFontOfSize:13];
    [threeLable sizeToFit];
    [myScrollView addSubview:threeLable];
    hight = hight+threeLable.frame.size.height+10*widthRate;
    
    myScrollView.contentSize = CGSizeMake(DeviceMaxWidth, hight);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [lhColor assignmentForTempVC:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

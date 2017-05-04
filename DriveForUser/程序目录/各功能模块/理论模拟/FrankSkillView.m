//
//  FrankSkillView.m
//  Drive
//
//  Created by lichao on 15/8/5.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import "FrankSkillView.h"

@interface FrankSkillView ()

@end

@implementation FrankSkillView
//③④⑤⑥⑦⑧⑨⑩
- (void)viewDidLoad {
    [super viewDidLoad];
    [[lhColor shareColor]originalInit:self title:@"考试技巧" imageName:nil backButton:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    textForLable1 = [[UILabel alloc] init];
    textForLable1.text = @"一、 考试内容\n\n①  道路交通安全法律、法规和规章;\n\n②  交通信号及其含义;\n\n③  安全行车、文明驾驶知识;\n\n④  高速公路、山区道路、桥梁、隧道、夜间、恶劣气象和复杂道路条件下的安全驾驶知识;\n\n⑤  出现爆胎、转向失控、控制失灵等紧急情况时的临危处置知识;\n\n⑥  机动车总体构造、主要安全装置常识、日常检查和维护基本知识;\n\n⑦  发生交通事故后的自救、急救等基本知识，以及常见危险物品知识。\n";
    UIFont * font = [UIFont boldSystemFontOfSize:15];
    NSMutableAttributedString * as = [[NSMutableAttributedString alloc]initWithString:textForLable1.text];
    [as addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, 7)];

    textForLable1.numberOfLines = 0;
    textForLable1.font = [UIFont systemFontOfSize:14.0];
    CGSize rect = [self sizeWithString:textForLable1.text font:textForLable1.font];
    textForLable1.frame = CGRectMake(10, 64+10, rect.width-10, rect.height);
    textForLable1.attributedText = as;
    [self.view addSubview:textForLable1];
    
    
    
    textsroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, DeviceMaxWidth, DeviceMaxHeight-64)];
    textsroll.delegate = self;
    textsroll.showsVerticalScrollIndicator = NO;
    textsroll.backgroundColor = [lhColor colorFromHexRGB:viewColorStr];
//    [textForLable addSubview:textsroll];

    textsroll.contentSize = CGSizeMake(DeviceMaxWidth, textsroll.frame.size.height+5);
    
}

- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.view.bounds), MAXFLOAT)//限制最大的宽度和高度
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                    attributes:@{NSFontAttributeName: font}//传人的字体字典
                                       context:nil];
    return rect.size;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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

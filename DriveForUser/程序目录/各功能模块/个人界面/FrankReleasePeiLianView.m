//
//  FrankReleasePeiLianView.m
//  Drive
//
//  Created by lichao on 15/9/8.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import "FrankReleasePeiLianView.h"

@interface FrankReleasePeiLianView ()

@end

@implementation FrankReleasePeiLianView

- (void)viewDidLoad {
    [super viewDidLoad];
    [[lhColor shareColor]originalInit:self title:@"发布陪练信息" imageName:nil backButton:YES];
    [self initFrameView];
}

-(void)initFrameView{
    CGFloat hight = 0;
    UIScrollView *myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64+20*widthRate, DeviceMaxWidth, DeviceMaxHeight-64-20*widthRate)];
    myScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:myScrollView];

    UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, 10*widthRate, 130*widthRate, 20*widthRate)];
    nameLab.text = @"接单人员姓名:";
    nameLab.font = [UIFont systemFontOfSize:15];
    nameLab.textAlignment = NSTextAlignmentRight;
    [myScrollView addSubview:nameLab];
    
    UITextField *nameField = [[UITextField alloc] initWithFrame:CGRectMake(145*widthRate, 10*widthRate, DeviceMaxWidth-160*widthRate, 25*widthRate)];
    nameField.layer.borderWidth = 0.5;
    nameField.layer.borderColor = [[lhColor colorFromHexRGB:contentTitleColorStr1] CGColor];
    nameField.text = @" 王师傅";
    nameField.layer.cornerRadius = 4;
    nameField.textColor = [lhColor colorFromHexRGB:contentTitleColorStr1];
    nameField.font = [UIFont systemFontOfSize:13];
    [myScrollView addSubview:nameField];
    
    UILabel *contactWayLab = [[UILabel alloc] initWithFrame:CGRectMake(5*widthRate, 45*widthRate, 135*widthRate, 20*widthRate)];
    contactWayLab.text = @"接单人员联系方式:";
    contactWayLab.font = [UIFont systemFontOfSize:15];
    contactWayLab.textAlignment = NSTextAlignmentRight;
    [myScrollView addSubview:contactWayLab];
    
    UITextField *contactWayField = [[UITextField alloc] initWithFrame:CGRectMake(145*widthRate, 45*widthRate, DeviceMaxWidth-160*widthRate, 25*widthRate)];
    contactWayField.layer.borderWidth = 0.5;
    contactWayField.layer.borderColor = [[lhColor colorFromHexRGB:contentTitleColorStr1] CGColor];
    contactWayField.text = @" 13858358495";
    contactWayField.layer.cornerRadius = 4;
    contactWayField.textColor = [lhColor colorFromHexRGB:contentTitleColorStr1];
    contactWayField.font = [UIFont systemFontOfSize:13];
    [myScrollView addSubview:contactWayField];
    
    UILabel *shoolNameLab = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, 80*widthRate, 130*widthRate, 20*widthRate)];
    shoolNameLab.text = @"驾校名称:";
    shoolNameLab.font = [UIFont systemFontOfSize:15];
    shoolNameLab.textAlignment = NSTextAlignmentRight;
    [myScrollView addSubview:shoolNameLab];
    
    UITextField *shoolNameField = [[UITextField alloc] initWithFrame:CGRectMake(145*widthRate, 80*widthRate, DeviceMaxWidth-160*widthRate, 25*widthRate)];
    shoolNameField.layer.borderWidth = 0.5;
    shoolNameField.layer.borderColor = [[lhColor colorFromHexRGB:contentTitleColorStr1] CGColor];
    shoolNameField.text = @" 长征驾校";
    shoolNameField.layer.cornerRadius = 4;
    shoolNameField.textColor = [lhColor colorFromHexRGB:contentTitleColorStr1];
    shoolNameField.font = [UIFont systemFontOfSize:13];
    [myScrollView addSubview:shoolNameField];
    
    UILabel *myselfCarLab = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, 115*widthRate, 130*widthRate, 20*widthRate)];
    myselfCarLab.text = @"自带车价格:";
    myselfCarLab.font = [UIFont systemFontOfSize:15];
    myselfCarLab.textAlignment = NSTextAlignmentRight;
    [myScrollView addSubview:myselfCarLab];
    
    UITextField *myselfCarField = [[UITextField alloc] initWithFrame:CGRectMake(145*widthRate, 115*widthRate, DeviceMaxWidth-200*widthRate, 25*widthRate)];
    myselfCarField.layer.borderWidth = 0.5;
    myselfCarField.layer.borderColor = [[lhColor colorFromHexRGB:contentTitleColorStr1] CGColor];
    myselfCarField.text = @" 30";
    myselfCarField.layer.cornerRadius = 4;
    myselfCarField.textColor = [lhColor colorFromHexRGB:contentTitleColorStr1];
    myselfCarField.font = [UIFont systemFontOfSize:13];
    [myScrollView addSubview:myselfCarField];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(DeviceMaxWidth-50*widthRate, 115*widthRate, 30*widthRate, 20*widthRate)];
    lab.text = @"元/h";
    lab.font = [UIFont systemFontOfSize:15];
    [myScrollView addSubview:lab];
    
    UILabel *coachCarLab = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, 150*widthRate, 130*widthRate, 20*widthRate)];
    coachCarLab.text = @"自带车价格:";
    coachCarLab.font = [UIFont systemFontOfSize:15];
    coachCarLab.textAlignment = NSTextAlignmentRight;
    [myScrollView addSubview:coachCarLab];
    
    UITextField *coachCarField = [[UITextField alloc] initWithFrame:CGRectMake(145*widthRate, 150*widthRate, DeviceMaxWidth-200*widthRate, 25*widthRate)];
    coachCarField.layer.borderWidth = 0.5;
    coachCarField.layer.borderColor = [[lhColor colorFromHexRGB:contentTitleColorStr1] CGColor];
    coachCarField.text = @" 30";
    coachCarField.layer.cornerRadius = 4;
    coachCarField.textColor = [lhColor colorFromHexRGB:contentTitleColorStr1];
    coachCarField.font = [UIFont systemFontOfSize:13];
    [myScrollView addSubview:coachCarField];
    
    UILabel *labd = [[UILabel alloc] initWithFrame:CGRectMake(DeviceMaxWidth-50*widthRate, 150*widthRate, 30*widthRate, 20*widthRate)];
    labd.text = @"元/h";
    labd.font = [UIFont systemFontOfSize:15];
    [myScrollView addSubview:labd];
    
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, 200*widthRate, DeviceMaxWidth, 10*widthRate)];
    lineV.backgroundColor = [lhColor colorFromHexRGB:viewColorStr];
    [myScrollView addSubview:lineV];
    
    UILabel *pictureLab = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, 220*widthRate, 100*widthRate, 20*widthRate)];
    pictureLab.text = @"陪练车图片";
    pictureLab.font = [UIFont systemFontOfSize:15];
    pictureLab.textColor = [lhColor colorFromHexRGB:lineColorStr];
    [pictureLab sizeToFit];
    [myScrollView addSubview:pictureLab];
    
    UILabel *hLab = [[UILabel alloc] initWithFrame:CGRectMake(pictureLab.frame.size.width+20*widthRate, 218*widthRate, 150*widthRate, 20*widthRate)];
    hLab.text = @"(最多添加9张图片)";
    hLab.textColor = [lhColor colorFromHexRGB:contentTitleColorStr1];
    hLab.font = [UIFont systemFontOfSize:13];
    [myScrollView addSubview:hLab];
    
    CGFloat space = 0;
    for (int i=0; i<4; i++) {
        if (i==3) {
            UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            addBtn.frame = CGRectMake(10*widthRate+space, 250*widthRate, (DeviceMaxWidth-50*widthRate)/4, (DeviceMaxWidth-50*widthRate)/4);
            [addBtn setBackgroundImage:imageWithName(@"addButtonImg") forState:UIControlStateNormal];
            [addBtn addTarget:self action:@selector(addBtnEvent) forControlEvents:UIControlEventTouchUpInside];
            [myScrollView addSubview:addBtn];
            break;
        }
        UIImageView *imagV = [[UIImageView alloc] initWithFrame:CGRectMake(10*widthRate+space, 250*widthRate, (DeviceMaxWidth-50*widthRate)/4, (DeviceMaxWidth-50*widthRate)/4)];
        imagV.layer.borderWidth= 0.5;
        imagV.layer.borderColor = [[lhColor colorFromHexRGB:contentTitleColorStr1] CGColor];
        [myScrollView addSubview:imagV];
        space += (DeviceMaxWidth-50*widthRate)/4+10*widthRate;
    }
    hight += 250*widthRate + (DeviceMaxWidth-50*widthRate)/4 + 50*widthRate;
    
    UIButton * firmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    firmBtn.frame = CGRectMake(20*widthRate, hight, DeviceMaxWidth-40*widthRate, 40*widthRate);
    firmBtn.titleLabel.font = [UIFont fontWithName:fontName size:15];
    [firmBtn setTitle:@"确认发布" forState:UIControlStateNormal];
    [firmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [firmBtn setBackgroundImage:imageWithName(@"contactDraiver") forState:UIControlStateNormal];
    firmBtn.layer.cornerRadius = 4;
    firmBtn.layer.masksToBounds = YES;
    [firmBtn addTarget:self action:@selector(firmBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    [myScrollView addSubview:firmBtn];
    
    hight += 25;
    
    myScrollView.contentSize = CGSizeMake(DeviceMaxWidth, hight+20*widthRate);
}

-(void)addBtnEvent{
    
}

-(void)firmBtnEvent{

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

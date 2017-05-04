//
//  FrankSchoolDetailView.m
//  Drive
//
//  Created by lichao on 15/8/6.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import "FrankSchoolDetailView.h"
#import "lhDiscussTableViewCell.h"
#import "FrankWebView.h"
#import "FrankGradeCell.h"
#import "FrankBaoMingView.h"

#import "lhGPS.h"

@interface FrankSchoolDetailView ()
{
    UIView *schoolIntroduce;//驾校简介
    UILabel *schInfor;
    UIButton *schBtn;
    UIView *schEnvironment;//驾校环境
    UIView *schHonourView; //驾校荣誉
    
    UIImageView *schMianImage;
    UIImageView *schIamgeOne;
    UIImageView *schIamgeTwo;
    
    UITableView *classtabtype;
    NSArray *contentArray;
    NSMutableArray *classTypeArray;
    NSMutableArray *priceArray;
}
@end

@implementation FrankSchoolDetailView

- (void)viewDidLoad {
    [super viewDidLoad];
    [[lhColor shareColor]originalInit:self title:@"驾校详情" imageName:nil backButton:YES];
//    self.view.backgroundColor = [UIColor whiteColor];
    classTypeArray = [[NSMutableArray alloc] init];
    priceArray = [[NSMutableArray alloc] init];
    [self createScrollView];

    [self requestDataForSchool];
    // Do any additional setup after loading the view.
}

-(void)createScrollView{
    myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, DeviceMaxWidth, DeviceMaxHeight-64)];
    myScrollView.showsVerticalScrollIndicator = NO;
    myScrollView.delegate = self;
    myScrollView.backgroundColor = [lhColor colorFromHexRGB:viewColorStr];
    [self.view addSubview:myScrollView];
}

-(void)requestDataForSchool{
    [lhColor addActivityView123:self.view];
    NSDictionary *dic = @{@"id":self.schoolID};
    [FrankNetworkManager postReqeustWithURL:PATH(@"driving/school") params:dic successBlock:^(id returnData){
        [lhColor disAppearActivitiView:self.view];
        if ([[returnData objectForKey:@"status"]integerValue] == 1) {
            schoolDic = [returnData objectForKey:@"data"];
            if ([schoolDic count]) {
                [self createDetailView];
            }else{
                [lhColor addANullLabelWithSuperView:myScrollView withFrame:CGRectMake(10*widthRate, 70*widthRate, 300*widthRate, 20*widthRate) withText:@"暂无驾校数据"];
            }
        }else{
            [FrankTools requestFailAlertShow:[returnData objectForKey:@"msg"]];
        }
    } failureBlock:^(NSError *error) {
        FLLog(@"%@",error.localizedDescription);
        [FrankTools wangluoAlertShow];
        [lhColor disAppearActivitiView:self.view];
    } showHUD:NO];
}

-(void)refreshSchoolData{
    
    NSString * pStr = [NSString stringWithFormat:@"%@",[schoolDic objectForKey:@"picture"]];
    NSString * allStr = [NSString stringWithFormat:@"%@%@",[lhColor shareColor].fileWebUrl,[schoolDic objectForKey:@"picture"]];

    [lhColor checkImageWithName:pStr withUrlStr:allStr withImgView:schoolImage withPlaceHolder:imageWithName(schoolDefaultImage)];

    NSString * picStr = [NSString stringWithFormat:@"%@",[schoolDic objectForKey:@"spacePicture"]];
    if ([picStr characterAtIndex:picStr.length-1] == ',') {
        picStr = [picStr substringToIndex:picStr.length-1];
    }
    NSArray * picArray = [picStr componentsSeparatedByString:@","];

    NSArray * enImageViewArray = @[schMianImage,schIamgeOne,schIamgeTwo];
    for (int i = 0; i < picArray.count; i++) {
        if (i >= 3) {
            break;
        }
        NSString * pStr0 = [NSString stringWithFormat:@"%@",[picArray objectAtIndex:i]];
        NSString * allStr0 = [NSString stringWithFormat:@"%@%@",[lhColor shareColor].fileWebUrl,[picArray objectAtIndex:i]];
        
        [lhColor checkImageWithName:pStr0 withUrlStr:allStr0 withImgView:[enImageViewArray objectAtIndex:i] withPlaceHolder:imageWithName(schoolDefaultImage)];
    }
    
    myScrollView.contentSize = CGSizeMake(DeviceMaxWidth, schEnvironment.frame.origin.y+175*widthRate+175*widthRate);
    
}

-(void)createDetailView{
    CGFloat hight = 0;
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, hight, DeviceMaxWidth, 110*widthRate)];
    backgroundView.backgroundColor = [UIColor whiteColor];
    [myScrollView addSubview:backgroundView];
    
    schoolImage = [[UIImageView alloc] initWithFrame:CGRectMake(10*widthRate, hight+10*widthRate, 90*widthRate, 90*widthRate)];
    [schoolImage setImage:imageWithName(@"lunboPic4.jpg")];
    [backgroundView addSubview:schoolImage];
    
    NSString * pStr = [NSString stringWithFormat:@"%@",[schoolDic objectForKey:@"picture"]];
    if ([pStr isEqualToString:@""]) {
        NSLog(@"没有图片");
    }else{
        NSString * allStr = [NSString stringWithFormat:@"%@%@",[lhColor shareColor].fileWebUrl,[schoolDic objectForKey:@"picture"]];
        NSLog(@"allStr = %@",allStr);
        [lhColor checkImageWithName:pStr withUrlStr:allStr withImgView:schoolImage];
    }
    
    schoolName = [[UILabel alloc] initWithFrame:CGRectMake(110*widthRate, hight+18*widthRate, 200*widthRate, 40*widthRate)];
    schoolName.font = [UIFont systemFontOfSize:17];
    schoolName.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
    schoolName.text = [NSString stringWithFormat:@"%@",[schoolDic objectForKey:@"name"]];
    schoolName.numberOfLines = 0;
    [schoolName sizeToFit];
    [backgroundView addSubview:schoolName];
    
    schoolType = [[UILabel alloc] initWithFrame:CGRectMake(110*widthRate+schoolName.frame.size.width+5*widthRate, 17*widthRate, 100*widthRate, 20*widthRate)];
    schoolType.font = [UIFont systemFontOfSize:12];
    schoolType.textColor = [lhColor colorFromHexRGB:lineColorStr];
    schoolType.text = @" (合作驾校)";
    [backgroundView addSubview:schoolType];
    
    starImgView = [[TQStarRatingView alloc] initWithFrame:CGRectMake(110*widthRate, 48*widthRate, 80*widthRate, 20*widthRate) numberOfStar:5 distance:5*widthRate HeiDistance:4*widthRate];
//    starImgView.number = 5.0f;
    starImgView.number = [[schoolDic objectForKey:@"score"] doubleValue];
    starImgView.userInteractionEnabled = NO;
    [backgroundView addSubview:starImgView];
    
    stuName = [[UILabel alloc] initWithFrame:CGRectMake(110*widthRate, 80*widthRate, 100*widthRate, 20*widthRate)];
//    stuName.text = [NSString stringWithFormat:@"学员：%d万+",96];
    stuName.font = [UIFont systemFontOfSize:13];
    stuName.text = [NSString stringWithFormat:@"累计学员 : %@",[lhColor numberStringWithNumber:[schoolDic objectForKey:@"studentNumber"]]];
    stuName.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
    [backgroundView addSubview:stuName];
    
    UIButton *reBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    reBtn.frame = CGRectMake(DeviceMaxWidth-80*widthRate, 48*widthRate, 70*widthRate, 25*widthRate);
    reBtn.layer.borderWidth = 0.5;
    reBtn.layer.cornerRadius = 12*widthRate;
    [reBtn setTitle:@"我要报名" forState:UIControlStateNormal];
    [reBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    reBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    reBtn.layer.masksToBounds  = YES;
    reBtn.backgroundColor = [lhColor colorFromHexRGB:lineColorStr];
    reBtn.layer.borderColor = [[lhColor colorFromHexRGB:lineColorStr] CGColor];
    reBtn.backgroundColor = [lhColor colorFromHexRGB:lineColorStr];
    [reBtn addTarget:self action:@selector(clickbaomingEvent) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:reBtn];
    
    hight += 115*widthRate;
    
    UIView *backgroundViewOne = [[UIView alloc] initWithFrame:CGRectMake(0, hight, DeviceMaxWidth, 100*widthRate)];
    backgroundViewOne.backgroundColor = [UIColor whiteColor];
    [myScrollView addSubview:backgroundViewOne];
    
    UIImageView *phoneView = [[UIImageView alloc] initWithFrame:CGRectMake(10*widthRate, 12*widthRate, 20*widthRate, 20*widthRate)];
    [phoneView setImage:[UIImage imageNamed:@"contactUs"]];
    [backgroundViewOne addSubview:phoneView];
    
    schoolPhone = [[UILabel alloc] initWithFrame:CGRectMake(35*widthRate, 15*widthRate, 100*widthRate, 20*widthRate)];
//    schoolPhone.text = @"15982160226";
    schoolPhone.font = [UIFont systemFontOfSize:14];
    schoolPhone.text = [schoolDic objectForKey:@"phone"];
    [backgroundViewOne addSubview:schoolPhone];
    
    UIButton *contactSch = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    contactSch.tag = 1;
    contactSch.frame = CGRectMake(DeviceMaxWidth-80*widthRate, 13*widthRate, 70*widthRate, 24*widthRate);
    contactSch.titleLabel.font = [UIFont systemFontOfSize:13];
    [contactSch setTitle:@"联系驾校" forState:UIControlStateNormal];
    [contactSch setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    contactSch.backgroundColor =  [lhColor colorFromHexRGB:mainColorStr];
//    [contactSch setBackgroundImage:imageWithName(@"contactDraiver") forState:UIControlStateNormal];
    contactSch.layer.cornerRadius = 12*widthRate;
    contactSch.layer.masksToBounds = YES;
    [contactSch addTarget:self action:@selector(clickImageBtn:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundViewOne addSubview:contactSch];

    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(10*widthRate, 50*widthRate, DeviceMaxWidth-20*widthRate, 0.5)];
    lineView.backgroundColor = [lhColor colorFromHexRGB:viewColorStr];
    [backgroundViewOne addSubview:lineView];
    
    UIImageView *schoolAddrView = [[UIImageView alloc] initWithFrame:CGRectMake(10*widthRate, 66*widthRate, 20*widthRate, 20*widthRate)];
    [schoolAddrView setImage:[UIImage imageNamed:@"schoolAddress"]];
    [backgroundViewOne addSubview:schoolAddrView];
    
    schoolAddr = [[UILabel alloc] initWithFrame:CGRectMake(35*widthRate, 65*widthRate, DeviceMaxWidth-150*widthRate, 20*widthRate)];
//    schoolAddr.text = @"天府三街";
    schoolAddr.font = [UIFont systemFontOfSize:14];
    schoolAddr.text = [schoolDic objectForKey:@"site"];
    schoolAddr.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
    [backgroundViewOne addSubview:schoolAddr];
    
    UIButton *comehereBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    comehereBtn.frame = CGRectMake(DeviceMaxWidth-80*widthRate, 63*widthRate, 70*widthRate, 24*widthRate);
    comehereBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [comehereBtn setTitle:@"到这里去" forState:UIControlStateNormal];
    [comehereBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [comehereBtn setBackgroundImage:imageWithName(@"contactDraiver") forState:UIControlStateNormal];
    comehereBtn.backgroundColor = [lhColor colorFromHexRGB:lineColorStr];
    comehereBtn.layer.cornerRadius = 12*widthRate;
    comehereBtn.layer.masksToBounds = YES;
    [comehereBtn addTarget:self action:@selector(clickImageBtn:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundViewOne addSubview:comehereBtn];
    
    UIView * lineView1 = [[UIView alloc]initWithFrame:CGRectMake(10*widthRate, 100*widthRate, DeviceMaxWidth-20*widthRate, 0.5)];
    lineView1.backgroundColor = [lhColor colorFromHexRGB:viewColorStr];
    [backgroundViewOne addSubview:lineView1];
    
    hight += 105*widthRate;

    contentArray = [schoolDic objectForKey:@"drivingRequirements"];
    for (int i=0; i<[contentArray count]; i++) {
        classTypeArray[i] = [NSString stringWithFormat:@"%@: %@",[contentArray[i] objectForKey:@"drivingLicenseType"],[contentArray[i] objectForKey:@"classType"]];
        priceArray[i] = [NSString stringWithFormat:@"¥ %@起",[contentArray[i] objectForKey:@"price"]];
    }
    
    classtabtype = [[UITableView alloc] initWithFrame:CGRectMake(0, hight, DeviceMaxWidth, [contentArray count]*40*widthRate+30*widthRate) style:UITableViewStylePlain];
    classtabtype.delegate = self;
    classtabtype.dataSource = self;
    classtabtype.tag = 5;
    classtabtype.scrollEnabled = NO;
    classtabtype.separatorStyle = UITableViewCellSeparatorStyleNone;
    [myScrollView addSubview:classtabtype];
    
    
//    classTypeArray = @[@"C1 : 计时班（一人一车，自主约车）",@"C1 : 普通班（四人一车）",@"C2 : 计时班（一人一车，自主约车）",@"C2 : 普通班（四人一车）"];
//    priceArray = @[@"¥ 7000起",@"¥ 5000起",@"¥ 7000起",@"¥ 5000起"];
    hight += classtabtype.frame.size.height+5*widthRate;
    
    schoolIntroduce = [[UIView alloc] initWithFrame:CGRectMake(0, hight, DeviceMaxWidth, 123*widthRate)];
    schoolIntroduce.backgroundColor = [UIColor whiteColor];
    [myScrollView addSubview:schoolIntroduce];
    
    UILabel *nameForIntroduce = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, 8*widthRate, 100*widthRate, 20*widthRate)];
    nameForIntroduce.text = @"驾校简介";
    nameForIntroduce.font = [UIFont boldSystemFontOfSize:15];
    nameForIntroduce.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
    [schoolIntroduce addSubview:nameForIntroduce];
    
    UIView *fLineV = [[UIView alloc] initWithFrame:CGRectMake(0, 30*widthRate, DeviceMaxWidth, 0.5)];
    fLineV.backgroundColor = [lhColor colorFromHexRGB:viewColorStr];
    [schoolIntroduce addSubview:fLineV];
    
    schInfor = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, 35*widthRate, DeviceMaxWidth-20*widthRate, 60*widthRate)];
    schInfor.numberOfLines = 0;
//    schInfor.text = @"重庆万州驾驶学校创建于2004年，是重庆省国家一级驾驶员培训机构。经过十年的科学发展，其鲜明的办学特色和突出的办学成绩得到了社会各界的广泛关注和赞誉，被授予“中国道路运输协会优秀会员单位”、荣获了“全国文明诚信优质服务示范单位”、“全国文明诚信优质服务驾校”、 “重庆省机动车驾驶员培训行业协会会长单位”、“重庆省示范性驾校”、“重庆省职业教育先进单位”、“重庆省十强驾校”之首、重庆十佳教育培训单位、“AAA”级优秀驾校、“重庆省先进基层党组织”、重庆省教育系统“工人先锋号”，被重庆团委和重庆省学联首个授予“大学生素质拓展训练技能培训基地”。";
    schInfor.text = [NSString stringWithFormat:@"%@",[schoolDic objectForKey:@"remark"]];
    schInfor.font = [UIFont systemFontOfSize:13];
    schInfor.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
    [schInfor sizeToFit];
    [schoolIntroduce addSubview:schInfor];
    
    schBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    schBtn.frame = CGRectMake(DeviceMaxWidth-90*widthRate, 37*widthRate+schInfor.frame.size.height, 70*widthRate, 30*widthRate);
    schBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [schBtn setTitle:@"查看详情>>" forState:UIControlStateNormal];
    [schBtn setTitleColor:[lhColor colorFromHexRGB:mainColorStr] forState:UIControlStateNormal];
    [schBtn addTarget:self action:@selector(clickSchoolDetails:) forControlEvents:UIControlEventTouchUpInside];
    [schoolIntroduce addSubview:schBtn];
    
    schoolIntroduce.frame = CGRectMake(0, hight, DeviceMaxWidth, 37*widthRate+schInfor.frame.size.height+35*widthRate);
    
    hight += schoolIntroduce.frame.size.height+5*widthRate;
    
    schEnvironment = [[UIView alloc] initWithFrame:CGRectMake(0, hight, DeviceMaxWidth, 175*widthRate)];
    schEnvironment.backgroundColor = [UIColor whiteColor];
    [myScrollView addSubview:schEnvironment];
    
    UILabel *nameForEnvironment = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, 8*widthRate, 100*widthRate, 20*widthRate)];
    nameForEnvironment.text = @"驾校环境";
    nameForEnvironment.font = [UIFont boldSystemFontOfSize:15];
    nameForEnvironment.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
    [schEnvironment addSubview:nameForEnvironment];
    
    UIView *eLineV = [[UIView alloc] initWithFrame:CGRectMake(0, 30*widthRate, DeviceMaxWidth, 0.5*widthRate)];
    eLineV.backgroundColor = [lhColor colorFromHexRGB:viewColorStr];
    [schEnvironment addSubview:eLineV];
    
    NSString * spacePicture = [NSString stringWithFormat:@"%@",[schoolDic objectForKey:@"spacePicture"]];
    NSString * allSpacePicture = [NSString stringWithFormat:@"%@%@",[lhColor shareColor].fileWebUrl,[schoolDic objectForKey:@"spacePicture"]];
    NSArray *spArray = [spacePicture componentsSeparatedByString:@"|"];
    
    schMianImage = [[UIImageView alloc] initWithFrame:CGRectMake(10*widthRate, 33*widthRate, 180*widthRate, 137*widthRate)];
    [schMianImage setImage:imageWithName(@"schoolEnvironment")];
    schMianImage.layer.masksToBounds = YES;
    [schEnvironment addSubview:schMianImage];
    
    if ([spArray count]>0) {
        allSpacePicture = [NSString stringWithFormat:@"%@%@",[lhColor shareColor].fileWebUrl,spArray[0]];
        [lhColor checkImageWithNameCut:spArray[0] withUrlStr:allSpacePicture withImgView:schMianImage withPlaceHolder:imageWithName(@"schoolEnvironment") withSize:CGSizeMake(180*widthRate*2, 137*widthRate*2)];
    }
    
    schIamgeOne = [[UIImageView alloc] initWithFrame:CGRectMake(195*widthRate, 33*widthRate, 115*widthRate, 66*widthRate)];
    [schIamgeOne setImage:imageWithName(@"schoolEnvironment1")];
//    schIamgeOne.layer.borderWidth = 0.5;
//    schIamgeOne.layer.borderColor = [[lhColor colorFromHexRGB:viewColorStr] CGColor];
    schIamgeOne.layer.masksToBounds = YES;
    [schEnvironment addSubview:schIamgeOne];
    
    if ([spArray count] >1) {
        allSpacePicture = [NSString stringWithFormat:@"%@%@",[lhColor shareColor].fileWebUrl,spArray[1]];
        [lhColor checkImageWithNameCut:spArray[1] withUrlStr:allSpacePicture withImgView:schIamgeOne withPlaceHolder:imageWithName(@"schoolEnvironment1") withSize:CGSizeMake(115*widthRate*2, 66*widthRate*2)];
    }
    
    schIamgeTwo = [[UIImageView alloc] initWithFrame:CGRectMake(195*widthRate, 103*widthRate, 115*widthRate, 66*widthRate)];
    [schIamgeTwo setImage:imageWithName(@"schoolEnvironment1")];
//    schIamgeTwo.layer.borderWidth = 0.5;
//    schIamgeTwo.layer.borderColor = [[lhColor colorFromHexRGB:viewColorStr] CGColor];
    schIamgeTwo.layer.masksToBounds = YES;
    [schEnvironment addSubview:schIamgeTwo];
    
    if ([spArray count] >2) {
        allSpacePicture = [NSString stringWithFormat:@"%@%@",[lhColor shareColor].fileWebUrl,spArray[2]];
        [lhColor checkImageWithNameCut:spArray[2] withUrlStr:allSpacePicture withImgView:schIamgeTwo withPlaceHolder:imageWithName(@"schoolEnvironment1") withSize:CGSizeMake(115*widthRate*2, 66*widthRate*2)];
    }
    
    hight += schEnvironment.frame.size.height+5*widthRate;
    
    schHonourView = [[UIView alloc] initWithFrame:CGRectMake(0, hight, DeviceMaxWidth, 170*widthRate)];
    schHonourView.backgroundColor = [UIColor whiteColor];
    [myScrollView addSubview:schHonourView];
    
    UILabel *honourView = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, 5*widthRate, 100*widthRate, 20*widthRate)];
    honourView.text = @"驾校荣誉";
    honourView.font = [UIFont boldSystemFontOfSize:15];
    honourView.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
    [schHonourView addSubview:honourView];
    
    UIView *LineH = [[UIView alloc] initWithFrame:CGRectMake(0, 28*widthRate, DeviceMaxWidth, 0.5*widthRate)];
    LineH.backgroundColor = [lhColor colorFromHexRGB:viewColorStr];
    [schHonourView addSubview:LineH];
    
    NSString * honourPicture = [NSString stringWithFormat:@"%@",[schoolDic objectForKey:@"rewardPicture"]];
    NSString * allhonourPicture = [NSString stringWithFormat:@"%@%@",[lhColor shareColor].fileWebUrl,[schoolDic objectForKey:@"rewardPicture"]];
    NSArray *hnArray = [honourPicture componentsSeparatedByString:@"|"];
    
    UIImageView *honourImage1 = [[UIImageView alloc] initWithFrame:CGRectMake(10*widthRate, 33*widthRate, 180*widthRate, 132*widthRate)];
    [honourImage1 setImage:imageWithName(@"schoolEnvironment1")];
//    honourImage1.layer.borderWidth = 0.5;
//    honourImage1.layer.borderColor = [[lhColor colorFromHexRGB:viewColorStr] CGColor];
    [schHonourView addSubview:honourImage1];
    
    if ([hnArray count]>0) {
        allhonourPicture = [NSString stringWithFormat:@"%@%@",[lhColor shareColor].fileWebUrl,hnArray[0]];
        [lhColor checkImageWithNameCut:hnArray[0] withUrlStr:allhonourPicture withImgView:honourImage1 withPlaceHolder:imageWithName(@"schoolEnvironment") withSize:CGSizeMake(180*widthRate*2, 132*widthRate*2)];
    }
    
    UIImageView *honourImage2 = [[UIImageView alloc] initWithFrame:CGRectMake(195*widthRate, 33*widthRate, 115*widthRate, 64*widthRate)];
    [honourImage2 setImage:imageWithName(@"schoolEnvironment1")];
//    honourImage2.layer.borderColor = [[lhColor colorFromHexRGB:viewColorStr] CGColor];
//    honourImage2.layer.borderWidth = 0.5;
    [schHonourView addSubview:honourImage2];
    
    if ([hnArray count]>1) {
        allhonourPicture = [NSString stringWithFormat:@"%@%@",[lhColor shareColor].fileWebUrl,hnArray[1]];
        [lhColor checkImageWithNameCut:hnArray[1] withUrlStr:allhonourPicture withImgView:honourImage2 withPlaceHolder:imageWithName(@"schoolEnvironment1") withSize:CGSizeMake(115*widthRate*2, 64*widthRate*2)];
    }
    
    UIImageView *honourImage3 = [[UIImageView alloc] initWithFrame:CGRectMake(195*widthRate, 101*widthRate, 115*widthRate, 64*widthRate)];
    [honourImage3 setImage:imageWithName(@"schoolEnvironment1")];
    honourImage3.layer.borderColor = [[lhColor colorFromHexRGB:viewColorStr] CGColor];
    honourImage3.layer.borderWidth = 0.5;
    [schHonourView addSubview:honourImage3];
    
    if ([hnArray count]>2) {
        allhonourPicture = [NSString stringWithFormat:@"%@%@",[lhColor shareColor].fileWebUrl,hnArray[2]];
        [lhColor checkImageWithNameCut:hnArray[2] withUrlStr:allhonourPicture withImgView:honourImage3 withPlaceHolder:imageWithName(@"schoolEnvironment1") withSize:CGSizeMake(115*widthRate*2, 64*widthRate*2)];
    }
    
    hight += 175*widthRate;
/* 驾校分校
    UIView *otherSch = [[UIView alloc] initWithFrame:CGRectMake(0, hight, DeviceMaxWidth, 75*widthRate)];
    otherSch.backgroundColor = [UIColor whiteColor];
    [myScrollView addSubview:otherSch];
    
    UILabel *flab = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, 5*widthRate, 100*widthRate, 20*widthRate)];
    flab.text = @"驾校分校";
    flab.font = [UIFont boldSystemFontOfSize:15];
    flab.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
    [otherSch addSubview:flab];
    
    UIView *linrf = [[UIView alloc] initWithFrame:CGRectMake(0, 28*widthRate, DeviceMaxWidth, 0.5*widthRate)];
    linrf.backgroundColor = [lhColor colorFromHexRGB:viewColorStr];
    [otherSch addSubview:linrf];
    
    CGFloat hightY = 0;
    CGFloat widthX = 0;
    NSArray *schoolArray = @[@"成都高新区江安分校",@"重庆万州分校",@"绵阳开发区分校",@"德阳锦江区分校"];
    for (int i=0; i<4; i++) {
        UIButton *schoolBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        schoolBtn.frame = CGRectMake(10*widthRate+widthX, 38*widthRate+hightY, 100*widthRate, 35*widthRate);
        [schoolBtn setTitle:schoolArray[i] forState:UIControlStateNormal];
        schoolBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [schoolBtn setTitleColor:[lhColor colorFromHexRGB:contentTitleColorStr] forState:UIControlStateNormal];
        schoolBtn.layer.cornerRadius = 3;
        schoolBtn.layer.borderWidth = 0.5;
        schoolBtn.layer.borderColor = [[lhColor colorFromHexRGB:contentTitleColorStr1] CGColor];
        [schoolBtn sizeToFit];
        CGRect rect = schoolBtn.frame;
        rect.size.width += 10*widthRate;
        schoolBtn.frame = rect;
        [otherSch addSubview:schoolBtn];
        
        widthX += schoolBtn.frame.size.width + 10*widthRate;
        if (widthX > DeviceMaxWidth){
            widthX = 0;
            hightY += 35*widthRate;
            CGRect rect = schoolBtn.frame;
            rect.origin.x = widthX + 10*widthRate;
            rect.origin.y = hightY + 38*widthRate;
            schoolBtn.frame = rect;
            otherSch.frame = CGRectMake(0, hight, DeviceMaxWidth, 75*widthRate+hightY);
            
            widthX += schoolBtn.frame.size.width + 10*widthRate;
        }
        
        
        NSLog(@"widthX%d = %f",i,widthX);
        NSLog(@"schoolBtn = %f",schoolBtn.frame.size.width);
        NSLog(@"DeviceMaxWidth = %f",DeviceMaxWidth);
        
    }
    
    hight += otherSch.frame.size.height;
*/
//    UIView *otherSchool = [[UIView alloc] initWithFrame:CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)];
    
//    UIView * tView = [[UIView alloc]initWithFrame:CGRectMake(0, hight, DeviceMaxWidth, 30*widthRate)];
//    tView.backgroundColor = [UIColor whiteColor];
//    [myScrollView addSubview:tView];
    
//    UILabel * tLabel = [[UILabel alloc]initWithFrame:CGRectMake(20*widthRate, 5*widthRate, DeviceMaxWidth-20*widthRate, 20*widthRate)];
//    tLabel.textColor = [lhColor colorFromHexRGB:lineColorStr];
//    tLabel.text = @"学员评价 ( 35 ) ";
//    [tView addSubview:tLabel];
//    
//    UIView * lineV = [[UIView alloc]initWithFrame:CGRectMake(0, 29*widthRate, DeviceMaxWidth, 0.5)];
//    lineV.backgroundColor = [lhColor colorFromHexRGB:viewColorStr];
//    [tView addSubview:lineV];
//    
//    hight += 30*widthRate;
//    
//    stuComments = [[UITableView alloc] initWithFrame:CGRectMake(0, hight, DeviceMaxWidth, 3*80*widthRate) style:UITableViewStylePlain];
//    stuComments.delegate = self;
//    stuComments.dataSource = self;
//    stuComments.separatorColor = [UIColor clearColor];
//    stuComments.backgroundColor = [UIColor clearColor];
//    [myScrollView addSubview:stuComments];
    
    myScrollView.contentSize = CGSizeMake(DeviceMaxWidth, hight+20*widthRate);
}

-(void)clickbaomingEvent{
    FrankBaoMingView *baoming = [[FrankBaoMingView alloc] init];
    baoming.drivingId = [schoolDic objectForKey:@"id"];
    [self.navigationController pushViewController:baoming animated:YES];
}

-(void)clickSchoolDetails:(UIButton *)button_
{
    FrankWebView *myWebView = [[FrankWebView alloc] init];
    myWebView.myWebUrl = [NSString stringWithFormat:@"%@",[schoolDic objectForKey:@"web"]];
    NSLog(@"myWebView.myWebUrl = %@",myWebView.myWebUrl);
    myWebView.nameStr = @"驾校详情";
    [self.navigationController pushViewController:myWebView animated:YES];
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30*widthRate;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * hdView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 30*widthRate)];
    UILabel *headLable = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, 8*widthRate, 100*widthRate, 20*widthRate)];
    headLable.text = @"招生需求";
    headLable.font = [UIFont boldSystemFontOfSize:15];
    headLable.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
    [hdView addSubview:headLable];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 30*widthRate, DeviceMaxWidth, 0.5)];
    line.backgroundColor = [lhColor colorFromHexRGB:viewColorStr];
    [hdView addSubview:line];
    return hdView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [classTypeArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0*widthRate;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * indentifier = @"disCell";
    FrankGradeCell * dtvCell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (dtvCell == nil) {
        dtvCell = [[FrankGradeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    dtvCell.selectionStyle = UITableViewCellSelectionStyleNone;
    dtvCell.nameLable.text = classTypeArray[indexPath.row];
    dtvCell.priceLable.text = priceArray[indexPath.row];
    return dtvCell;
}

-(void)clickImageBtn:(UIButton *)button_{
    if (button_.tag == 1) {
        if (schoolDic && schoolDic.count) {
            [[lhColor shareColor]detailPhone:[schoolDic objectForKey:@"phone"]];
        }
    }
    else{
        NSLog(@"到这里去");
        NSString * latiStr = [NSString stringWithFormat:@"%@",[schoolDic objectForKey:@"latitude"]];
        NSString * lotiStr = [NSString stringWithFormat:@"%@",[schoolDic objectForKey:@"longitude"]];
        CLLocationCoordinate2D endLocation = CLLocationCoordinate2DMake([latiStr doubleValue], [lotiStr doubleValue]);
        [lhColor addActivityView123:self.view];
        __weak typeof(self) ws = self;
        [[lhColor shareColor]locationAddress:^(CLLocationCoordinate2D locationCorrrdinate) {
            if (locationCorrrdinate.latitude == DefaultCoordnate.latitude) {
                [lhColor disAppearActivitiView:ws.view];
                [lhColor showAlertWithMessage:@"获取位置失败~" withSuperView:ws.view withHeih:DeviceMaxHeight/2];
                
            }
            else{
                CLLocationCoordinate2D nowLocation = locationCorrrdinate;
                if (nowLocation.longitude != 0) {
                    [[lhGPS sharedInstanceGPS]prepareData:ws startLocation:nowLocation endLocation:endLocation];//准备数据
                    
                    [[lhGPS sharedInstanceGPS]startNaviGPS];//开始导航
                }
                else{
                    [lhColor disAppearActivitiView:ws.view];
                    [lhColor showAlertWithMessage:@"获取定位有误~" withSuperView:ws.view withHeih:DeviceMaxHeight/2];
                }
            }
        }];
    }

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

@end

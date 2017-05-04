//
//  ViewController.m
//  PracticeSimulation
//
//  Created by lichao on 15/7/15.
//  Copyright (c) 2015年 LiFrank. All rights reserved.
//

#import "FrankMainViewController.h"
#import "FrankPracticeView.h"
#import "FrankChapterPracticeView.h"
#import "FrankTestskillView.h"
#import "FrankSubjectListView.h"
#import "FrankTestpointsView.h"
#import "FrankTestRecordView.h"
#import "lhSymbolCustumButton.h"
#import "FrankRemindView.h"

#define titleBtnOriginalTag 190

@interface FrankMainViewController ()<UIScrollViewDelegate>{
    UIView *subjectTwoView;
    
    UIButton * lastBtn;//当前选中的科目按钮
    
    UIScrollView * maxScollView;//
    UIScrollView * sub2ScrollView;
    UIScrollView * sub3ScrollView;
    UIScrollView * sub4ScrollView;
    
    UIView * mainLine;//选中按钮线
    
    NSArray * titleArray;
}

@end

@implementation FrankMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [[lhColor shareColor]originalInit:self title:@"科目一" imageName:nil backButton:YES];
    [self createHeadFrame];
    [self initMainView];
    
//    [self initFrameView];
//    [self createSpaceView];
    
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)initMainView
{
    
    maxScollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 113, DeviceMaxWidth, DeviceMaxHeight-113)];
    maxScollView.pagingEnabled = YES;
    maxScollView.showsHorizontalScrollIndicator = NO;
    maxScollView.showsVerticalScrollIndicator = NO;
    maxScollView.delegate = self;
    maxScollView.pagingEnabled = YES;
    [self.view addSubview:maxScollView];
    
    maxScollView.contentSize = CGSizeMake(DeviceMaxWidth*4, CGRectGetHeight(maxScollView.frame));
    
    mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, CGRectGetHeight(maxScollView.frame))];
    mainScrollView.showsVerticalScrollIndicator = NO;
    mainScrollView.showsHorizontalScrollIndicator = NO;
    [maxScollView addSubview:mainScrollView];
    
    sub2ScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(DeviceMaxWidth, 0, DeviceMaxWidth, CGRectGetHeight(maxScollView.frame))];
//    sub2ScrollView.backgroundColor = [UIColor redColor];
    sub2ScrollView.showsVerticalScrollIndicator = NO;
    sub2ScrollView.showsHorizontalScrollIndicator = NO;
    [maxScollView addSubview:sub2ScrollView];
    
    sub3ScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(DeviceMaxWidth*2, 0, DeviceMaxWidth, CGRectGetHeight(maxScollView.frame))];
//    sub3ScrollView.backgroundColor = [UIColor orangeColor];
    sub3ScrollView.showsVerticalScrollIndicator = NO;
    sub3ScrollView.showsHorizontalScrollIndicator = NO;
    [maxScollView addSubview:sub3ScrollView];
    
    sub4ScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(DeviceMaxWidth*3, 0, DeviceMaxWidth, CGRectGetHeight(maxScollView.frame))];
//    sub4ScrollView.backgroundColor = [UIColor grayColor];
    sub4ScrollView.showsVerticalScrollIndicator = NO;
    sub4ScrollView.showsHorizontalScrollIndicator = NO;
    [maxScollView addSubview:sub4ScrollView];

    [self sub1Init];
    [self sub2Init];
    [self sub3Init];
    [self sub4Init];
    
}

#pragma mark - 初始化科目四界面
- (void)sub4Init
{
    
    CGFloat frank = DeviceMaxWidth/375;
    
    CGFloat hight = 15*frank;
    
    //随机练习
    UIImageView *randomImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, hight, 187*frank, 99*frank)];
    [randomImage setImage:imageWithName(@"randomImage")];
    randomImage.userInteractionEnabled = YES;
    [sub4ScrollView addSubview:randomImage];
    
    UITapGestureRecognizer *randomTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickrandomBtn4)];
    [randomImage addGestureRecognizer:randomTap];
    
    //难题攻克
    UIImageView *problemSolveImage = [[UIImageView alloc] initWithFrame:CGRectMake(188*frank, hight, 187*frank, 99*frank)];
    [problemSolveImage setImage:imageWithName(@"problemSolveImage")];
    problemSolveImage.userInteractionEnabled = YES;
    [sub4ScrollView addSubview:problemSolveImage];
    
    UITapGestureRecognizer *problemSolveTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickProblemBtn4)];
    [problemSolveImage addGestureRecognizer:problemSolveTap];
    
    hight += 100*frank;
    
    //专题练习
    UIImageView *spImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, hight, 187*frank, 99*frank)];
    [spImage setImage:imageWithName(@"spImage")];
    spImage.userInteractionEnabled = YES;
    [sub4ScrollView addSubview:spImage];
    
    UITapGestureRecognizer *spTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickChapterBtn4)];
    [spImage addGestureRecognizer:spTap];
    
    //易错题集
    UIImageView *wrongTopicImage = [[UIImageView alloc] initWithFrame:CGRectMake(188*frank, hight, 187*frank, 99*frank)];
    [wrongTopicImage setImage:imageWithName(@"wrongTopicImage")];
    wrongTopicImage.userInteractionEnabled = YES;
    [sub4ScrollView addSubview:wrongTopicImage];
    
    UITapGestureRecognizer *wrongTopicTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickWrongTopicBtn4)];
    [wrongTopicImage addGestureRecognizer:wrongTopicTap];
    
    //顺序练习
    UIImageView *practiceImage = [[UIImageView alloc] initWithFrame:CGRectMake(112.5*frank, 40*frank, 150*frank, 150*frank)];
    practiceImage.layer.borderWidth = 0.5;
    practiceImage.layer.borderColor = [[lhColor colorFromHexRGB:viewColorStr] CGColor];
    practiceImage.layer.cornerRadius = 75*frank;
    practiceImage.layer.masksToBounds = YES;
    practiceImage.userInteractionEnabled = YES;
    [practiceImage setImage:imageWithName(@"practiceImage")];
    [sub4ScrollView addSubview:practiceImage];
    
    UITapGestureRecognizer *practiceTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickPracticeBtn4)];
    [practiceImage addGestureRecognizer:practiceTap];
    
    hight += 115*frank;
    
    //考试记录
    UIImageView *testRecordImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, hight, 187*frank, 99*frank)];
    [testRecordImage setImage:imageWithName(@"testRecordImage")];
    testRecordImage.userInteractionEnabled = YES;
    [sub4ScrollView addSubview:testRecordImage];
    
    UITapGestureRecognizer *testRecordTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTestRecordBtn4)];
    [testRecordImage addGestureRecognizer:testRecordTap];
    
    //成绩排行
    UIImageView *resultRankImage = [[UIImageView alloc] initWithFrame:CGRectMake(188*frank, hight, 187*frank, 99*frank)];
    [resultRankImage setImage:imageWithName(@"resultRankImage")];
    resultRankImage.userInteractionEnabled = YES;
    [sub4ScrollView addSubview:resultRankImage];
    
    UITapGestureRecognizer *resultRankTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickResultRankBtn4)];
    [resultRankImage addGestureRecognizer:resultRankTap];
    
    hight += 100*frank;
    
    //考试要点
    UIImageView *testPointsImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, hight, 187*frank, 99*frank)];
    [testPointsImage setImage:imageWithName(@"testPointsImage")];
    testPointsImage.userInteractionEnabled = YES;
    [sub4ScrollView addSubview:testPointsImage];
    
    UITapGestureRecognizer *testPointsTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTestPointsBtn4)];
    [testPointsImage addGestureRecognizer:testPointsTap];
    
    //答题技巧
    UIImageView *testSkillsImage = [[UIImageView alloc] initWithFrame:CGRectMake(188*frank, hight, 187*frank, 99*frank)];
    [testSkillsImage setImage:imageWithName(@"testSkillsImage")];
    testSkillsImage.userInteractionEnabled = YES;
    [sub4ScrollView addSubview:testSkillsImage];
    
    UITapGestureRecognizer *testSkillsTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTestSkillBtn4)];
    [testSkillsImage addGestureRecognizer:testSkillsTap];
    
    //模拟考试
    UIImageView *simulationTestImage = [[UIImageView alloc] initWithFrame:CGRectMake(112.5*frank, hight-75*frank, 150*frank, 150*frank)];
    simulationTestImage.layer.borderWidth = 0.5;
    simulationTestImage.layer.borderColor = [[lhColor colorFromHexRGB:viewColorStr] CGColor];
    simulationTestImage.layer.cornerRadius = 75*frank;
    simulationTestImage.layer.masksToBounds = YES;
    simulationTestImage.userInteractionEnabled = YES;
    [simulationTestImage setImage:imageWithName(@"simulationTestImage")];
    [sub4ScrollView addSubview:simulationTestImage];
    
    UITapGestureRecognizer *simulationTestTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickSimulationTestBtn4)];
    [simulationTestImage addGestureRecognizer:simulationTestTap];
    
    hight += 115*frank;
    
    //我的错题
    UIImageView *myWrongImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, hight, 187*frank, 75*frank)];
    [myWrongImage setImage:imageWithName(@"myWrongImage")];
    myWrongImage.userInteractionEnabled = YES;
    [sub4ScrollView addSubview:myWrongImage];
    
    UITapGestureRecognizer *myWrongTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickMyWrongTopicBtn4)];
    [myWrongImage addGestureRecognizer:myWrongTap];
    
    //我的收藏
    UIImageView *myCollectImage = [[UIImageView alloc] initWithFrame:CGRectMake(188*frank, hight, 187*frank, 75*frank)];
    [myCollectImage setImage:imageWithName(@"myCollectImage")];
    myCollectImage.userInteractionEnabled = YES;
    [sub4ScrollView addSubview:myCollectImage];
    
    UITapGestureRecognizer *myCollectTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCollectionBtn4)];
    [myCollectImage addGestureRecognizer:myCollectTap];
    
    hight += 75*frank;
    
    sub4ScrollView.contentSize = CGSizeMake(DeviceMaxWidth, hight+20*frank);
}

#pragma mark - 初始化科目三界面
- (void)sub3Init
{
    
    CGFloat frank = DeviceMaxWidth/375;
    
    CGFloat hight = 15*frank;
    
    NSArray * tArray = @[@"上车起步+夜间驾驶",@"跟车+超车+会车",@"通过路口+通过人行横道+通过公交汽车",@"变更车道+掉头+靠边停车",@"更多科目三视频"];
    
    UIView * maxView = [[UIView alloc]initWithFrame:CGRectMake(0, hight, DeviceMaxWidth, 200)];
    maxView.backgroundColor = [UIColor whiteColor];
    [sub3ScrollView addSubview:maxView];
    
    UILabel * tLabel = [[UILabel alloc]initWithFrame:CGRectMake(14*widthRate, 0, DeviceMaxWidth-20*widthRate, 30*widthRate)];
    tLabel.text = @"科目三教学视频";
    tLabel.font = [UIFont fontWithName:fontName size:15];
    tLabel.textColor = [lhColor colorFromHexRGB:contentTitleColorStr1];
    [maxView addSubview:tLabel];
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(14*widthRate, 25*widthRate, DeviceMaxWidth-28*widthRate, 0.5)];
    lineView.backgroundColor = [lhColor colorFromHexRGB:contentTitleColorStr1];
    [maxView addSubview:lineView];
    
    hight += 35*widthRate;
    for (int i = 0; i < tArray.count; i++) {
        UITapGestureRecognizer * tapG = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGEvent:)];
        UIImageView * hImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10*widthRate+(i%2)*155*widthRate, 30*widthRate+150*widthRate*(i/2), 145*widthRate, 120*widthRate)];
        hImgView.tag = i+1000;
        if (i < tArray.count-1) {
            hImgView.image = imageWithName(@"testtttt");
        }
        else{
            hImgView.image = imageWithName(@"testtttt2");
        }
        hImgView.layer.cornerRadius = 4*widthRate;
        hImgView.layer.masksToBounds = YES;
        hImgView.userInteractionEnabled = YES;
        [hImgView addGestureRecognizer:tapG];
        [maxView addSubview:hImgView];
        
        UILabel * tLabel = [[UILabel alloc]initWithFrame:CGRectMake(hImgView.frame.origin.x+4*widthRate, hImgView.frame.origin.y+120*widthRate, (DeviceMaxWidth-42*widthRate)/2, 30*widthRate)];
        tLabel.text = [tArray objectAtIndex:i];
        tLabel.font = [UIFont fontWithName:fontName size:15];
        tLabel.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
        [maxView addSubview:tLabel];
        
        if (i%2 == 1) {
            hight += 150*widthRate;
        }
        
    }
    
    if (tArray.count%2 == 1) {
        hight += 150*widthRate;
    }
    
    CGRect re = maxView.frame;
    re.size.height = hight;
    maxView.frame = re;
    
    sub3ScrollView.contentSize = CGSizeMake(DeviceMaxWidth, hight+20*widthRate);
}

#pragma mark - 初始化科目二界面
- (void)sub2Init
{

    CGFloat frank = DeviceMaxWidth/375;
    
    CGFloat hight = 15*frank;
    
    NSArray * tArray = @[@"倒车入库",@"坡道定点停车和起步",@"曲线行驶",@"直角转弯",@"侧方位停车",@"更多科目二视频"];
    
    UIView * maxView = [[UIView alloc]initWithFrame:CGRectMake(0, hight, DeviceMaxWidth, 200)];
    maxView.backgroundColor = [UIColor whiteColor];
    [sub2ScrollView addSubview:maxView];
    
    UILabel * tLabel = [[UILabel alloc]initWithFrame:CGRectMake(14*widthRate, 0, DeviceMaxWidth-20*widthRate, 30*widthRate)];
    tLabel.text = @"科目二教学视频";
    tLabel.font = [UIFont fontWithName:fontName size:15];
    tLabel.textColor = [lhColor colorFromHexRGB:contentTitleColorStr1];
    [maxView addSubview:tLabel];
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(14*widthRate, 25*widthRate, DeviceMaxWidth-28*widthRate, 0.5)];
    lineView.backgroundColor = [lhColor colorFromHexRGB:contentTitleColorStr1];
    [maxView addSubview:lineView];
    
    hight += 35*widthRate;
    for (int i = 0; i < tArray.count; i++) {
        UITapGestureRecognizer * tapG = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGEvent:)];
        UIImageView * hImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10*widthRate+(i%2)*155*widthRate, 30*widthRate+150*widthRate*(i/2), 145*widthRate, 120*widthRate)];
        hImgView.tag = i;
        if (i < tArray.count-1) {
            hImgView.image = imageWithName(@"testtttt");
        }
        else{
            hImgView.image = imageWithName(@"testtttt2");
        }
        hImgView.layer.cornerRadius = 4*widthRate;
        hImgView.layer.masksToBounds = YES;
        hImgView.userInteractionEnabled = YES;
        [hImgView addGestureRecognizer:tapG];
        [maxView addSubview:hImgView];
        
        UILabel * tLabel = [[UILabel alloc]initWithFrame:CGRectMake(hImgView.frame.origin.x+4*widthRate, hImgView.frame.origin.y+120*widthRate, (DeviceMaxWidth-42*widthRate)/2, 30*widthRate)];
        tLabel.text = [tArray objectAtIndex:i];
        tLabel.font = [UIFont fontWithName:fontName size:15];
        tLabel.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
        [maxView addSubview:tLabel];
        
        if (i%2 == 1) {
            hight += 150*widthRate;
        }
        
    }
    
    CGRect re = maxView.frame;
    re.size.height = hight;
    maxView.frame = re;
    
    sub2ScrollView.contentSize = CGSizeMake(DeviceMaxWidth, hight+20*widthRate);
}

- (void)tapGEvent:(UITapGestureRecognizer *)tap_
{
    NSLog(@"tap_.view.tag = %ld",tap_.view.tag);
    NSLog(@"点击看视频");
}

#pragma mark - 初始化科目一界面
- (void)sub1Init
{
    CGFloat frank = DeviceMaxWidth/375;
    
    CGFloat hight = 15*frank;
    
    //随机练习
    UIImageView *randomImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, hight, 187*frank, 99*frank)];
    [randomImage setImage:imageWithName(@"randomImage")];
    randomImage.userInteractionEnabled = YES;
    [mainScrollView addSubview:randomImage];
    
    UITapGestureRecognizer *randomTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickrandomBtn)];
    [randomImage addGestureRecognizer:randomTap];
    
    //难题攻克
    UIImageView *problemSolveImage = [[UIImageView alloc] initWithFrame:CGRectMake(188*frank, hight, 187*frank, 99*frank)];
    [problemSolveImage setImage:imageWithName(@"problemSolveImage")];
    problemSolveImage.userInteractionEnabled = YES;
    [mainScrollView addSubview:problemSolveImage];
    
    UITapGestureRecognizer *problemSolveTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickProblemBtn)];
    [problemSolveImage addGestureRecognizer:problemSolveTap];
    
    hight += 100*frank;
    
    //专题练习
    UIImageView *spImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, hight, 187*frank, 99*frank)];
    [spImage setImage:imageWithName(@"spImage")];
    spImage.userInteractionEnabled = YES;
    [mainScrollView addSubview:spImage];
    
    UITapGestureRecognizer *spTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickChapterBtn)];
    [spImage addGestureRecognizer:spTap];
    
    //易错题集
    UIImageView *wrongTopicImage = [[UIImageView alloc] initWithFrame:CGRectMake(188*frank, hight, 187*frank, 99*frank)];
    [wrongTopicImage setImage:imageWithName(@"wrongTopicImage")];
    wrongTopicImage.userInteractionEnabled = YES;
    [mainScrollView addSubview:wrongTopicImage];
    
    UITapGestureRecognizer *wrongTopicTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickWrongTopicBtn)];
    [wrongTopicImage addGestureRecognizer:wrongTopicTap];
    
    //顺序练习
    UIImageView *practiceImage = [[UIImageView alloc] initWithFrame:CGRectMake(112.5*frank, 40*frank, 150*frank, 150*frank)];
    practiceImage.layer.borderWidth = 0.5;
    practiceImage.layer.borderColor = [[lhColor colorFromHexRGB:viewColorStr] CGColor];
    practiceImage.layer.cornerRadius = 75*frank;
    practiceImage.layer.masksToBounds = YES;
    practiceImage.userInteractionEnabled = YES;
    [practiceImage setImage:imageWithName(@"practiceImage")];
    [mainScrollView addSubview:practiceImage];
    
    UITapGestureRecognizer *practiceTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickPracticeBtn)];
    [practiceImage addGestureRecognizer:practiceTap];
    
    hight += 115*frank;
    
    //考试记录
    UIImageView *testRecordImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, hight, 187*frank, 99*frank)];
    [testRecordImage setImage:imageWithName(@"testRecordImage")];
    testRecordImage.userInteractionEnabled = YES;
    [mainScrollView addSubview:testRecordImage];
    
    UITapGestureRecognizer *testRecordTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTestRecordBtn)];
    [testRecordImage addGestureRecognizer:testRecordTap];
    
    //成绩排行
    UIImageView *resultRankImage = [[UIImageView alloc] initWithFrame:CGRectMake(188*frank, hight, 187*frank, 99*frank)];
    [resultRankImage setImage:imageWithName(@"resultRankImage")];
    resultRankImage.userInteractionEnabled = YES;
    [mainScrollView addSubview:resultRankImage];
    
    UITapGestureRecognizer *resultRankTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickResultRankBtn)];
    [resultRankImage addGestureRecognizer:resultRankTap];
    
    hight += 100*frank;
    
    //考试要点
    UIImageView *testPointsImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, hight, 187*frank, 99*frank)];
    [testPointsImage setImage:imageWithName(@"testPointsImage")];
    testPointsImage.userInteractionEnabled = YES;
    [mainScrollView addSubview:testPointsImage];
    
    UITapGestureRecognizer *testPointsTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTestPointsBtn)];
    [testPointsImage addGestureRecognizer:testPointsTap];
    
    //答题技巧
    UIImageView *testSkillsImage = [[UIImageView alloc] initWithFrame:CGRectMake(188*frank, hight, 187*frank, 99*frank)];
    [testSkillsImage setImage:imageWithName(@"testSkillsImage")];
    testSkillsImage.userInteractionEnabled = YES;
    [mainScrollView addSubview:testSkillsImage];
    
    UITapGestureRecognizer *testSkillsTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTestSkillBtn)];
    [testSkillsImage addGestureRecognizer:testSkillsTap];
    
    //模拟考试
    UIImageView *simulationTestImage = [[UIImageView alloc] initWithFrame:CGRectMake(112.5*frank, hight-75*frank, 150*frank, 150*frank)];
    simulationTestImage.layer.borderWidth = 0.5;
    simulationTestImage.layer.borderColor = [[lhColor colorFromHexRGB:viewColorStr] CGColor];
    simulationTestImage.layer.cornerRadius = 75*frank;
    simulationTestImage.layer.masksToBounds = YES;
    simulationTestImage.userInteractionEnabled = YES;
    [simulationTestImage setImage:imageWithName(@"simulationTestImage")];
    [mainScrollView addSubview:simulationTestImage];
    
    UITapGestureRecognizer *simulationTestTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickSimulationTestBtn)];
    [simulationTestImage addGestureRecognizer:simulationTestTap];
    
    hight += 115*frank;
    
    //我的错题
    UIImageView *myWrongImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, hight, 187*frank, 75*frank)];
    [myWrongImage setImage:imageWithName(@"myWrongImage")];
    myWrongImage.userInteractionEnabled = YES;
    [mainScrollView addSubview:myWrongImage];
    
    UITapGestureRecognizer *myWrongTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickMyWrongTopicBtn)];
    [myWrongImage addGestureRecognizer:myWrongTap];
    
    //我的收藏
    UIImageView *myCollectImage = [[UIImageView alloc] initWithFrame:CGRectMake(188*frank, hight, 187*frank, 75*frank)];
    [myCollectImage setImage:imageWithName(@"myCollectImage")];
    myCollectImage.userInteractionEnabled = YES;
    [mainScrollView addSubview:myCollectImage];
    
    UITapGestureRecognizer *myCollectTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCollectionBtn)];
    [myCollectImage addGestureRecognizer:myCollectTap];
    
    hight += 75*frank;
    
    mainScrollView.contentSize = CGSizeMake(DeviceMaxWidth, hight+20*frank);
}

#pragma mark - 初始化数据
-(void)initData{
    titleArray = @[@"科目一",@"科目二",@"科目三",@"科目四"];
    
    practiceViewController = [[FrankPracticeView alloc]init];
//    [self countWrongAndCollect];
    spaceValue = 10;
}

-(void)initSubjectTwo{
    subjectTwoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, DeviceMaxHeight-64-49)];
    [mainScrollView addSubview:subjectTwoView];
}

//-(void) countWrongAndCollect{
//    wrongCount = [[ManageSqlite findWrongRecord] count];
//    collectCount = [[ManageSqlite findCollectRecord] count];
//}

//创建练习的相关按钮
-(void)selectTestType{
//    CGFloat withX = 0;
    CGFloat hightY = 64.0f + 15*widthRate;
    CGFloat with = 160*widthRate;
    CGFloat hight = (DeviceMaxHeight-64-44-80*widthRate-30)/2;
    
    lhSymbolCustumButton *testButton = [[lhSymbolCustumButton alloc] initWithFrankFrame:CGRectMake(0, hightY, with-1*widthRate, hight)];
    [testButton.titView setImage:imageWithName(@"testByOrder")];
    testButton.backgroundColor = [UIColor whiteColor];
    testButton.titLable.text = @"顺序练习";
    testButton.titLable.font = [UIFont systemFontOfSize:13];
    testButton.titLable.textAlignment = NSTextAlignmentCenter;
    [testButton addTarget:self action:@selector(clickPracticeBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testButton];
    
    lhSymbolCustumButton *randomPractice = [[lhSymbolCustumButton alloc] initWithFrankFrame1:CGRectMake(160*widthRate, hightY, 79*widthRate, (hight-2)/2)];
    [randomPractice.titView setImage:imageWithName(@"testByRandom")];
    randomPractice.backgroundColor = [UIColor whiteColor];
    randomPractice.titLable.text = @"随机练习";
    randomPractice.titLable.font = [UIFont systemFontOfSize:13];
    randomPractice.titLable.textAlignment = NSTextAlignmentCenter;
    [randomPractice addTarget:self action:@selector(clickrandomBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:randomPractice];
    
    lhSymbolCustumButton *problemSolve = [[lhSymbolCustumButton alloc] initWithFrankFrame1:CGRectMake(160*widthRate+80*widthRate, hightY, 79*widthRate, (hight-2)/2)];
    [problemSolve.titView setImage:imageWithName(@"testByProblem")];
    problemSolve.backgroundColor = [UIColor whiteColor];
    problemSolve.titLable.text = @"难题攻克";
    problemSolve.titLable.font = [UIFont systemFontOfSize:13];
    problemSolve.titLable.textAlignment = NSTextAlignmentCenter;
    [problemSolve addTarget:self action:@selector(clickProblemBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:problemSolve];
    
    lhSymbolCustumButton *specialPractice = [[lhSymbolCustumButton alloc] initWithFrankFrame1:CGRectMake(160*widthRate, hightY+(hight-2)/2+1*widthRate, 79*widthRate, (hight-2)/2)];
    [specialPractice.titView setImage:imageWithName(@"testBySpecial")];
    specialPractice.backgroundColor = [UIColor whiteColor];
    specialPractice.titLable.text = @"专项练习";
    specialPractice.titLable.font = [UIFont systemFontOfSize:13];
    specialPractice.titLable.textAlignment = NSTextAlignmentCenter;
    [specialPractice addTarget:self action:@selector(clickChapterBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:specialPractice];
    
    lhSymbolCustumButton *wrongTopic = [[lhSymbolCustumButton alloc] initWithFrankFrame1:CGRectMake(160*widthRate+80*widthRate, hightY+(hight-2)/2+1*widthRate, 79*widthRate, (hight-2)/2)];
    [wrongTopic.titView setImage:imageWithName(@"testByWrong")];
    wrongTopic.backgroundColor = [UIColor whiteColor];
    wrongTopic.titLable.text = @"易错题集";
    wrongTopic.titLable.font = [UIFont systemFontOfSize:13];
    wrongTopic.titLable.textAlignment = NSTextAlignmentCenter;
    [wrongTopic addTarget:self action:@selector(clickWrongTopicBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:wrongTopic];
}

//创建模拟考试相关按钮
-(void)selectSimulationTest{
    CGFloat hightY = 64+15*widthRate;
    CGFloat hight = (DeviceMaxHeight-64-44-80*widthRate-30)/2;
    CGFloat space = 15*widthRate;
    lhSymbolCustumButton *testRecord = [[lhSymbolCustumButton alloc] initWithFrankFrame1:CGRectMake(0, hightY+hight+space, 79*widthRate, (hight-2)/2)];
    [testRecord.titView setImage:imageWithName(@"testByRecord")];
    testRecord.backgroundColor = [UIColor whiteColor];
    testRecord.titLable.text = @"考试记录";
    testRecord.titLable.font = [UIFont systemFontOfSize:13];
    testRecord.titLable.textAlignment = NSTextAlignmentCenter;
    [testRecord addTarget:self action:@selector(clickTestRecordBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testRecord];
    
    lhSymbolCustumButton *resultRank = [[lhSymbolCustumButton alloc] initWithFrankFrame1:CGRectMake(80*widthRate, hightY+hight+space, 79*widthRate, (hight-2)/2)];
    [resultRank.titView setImage:imageWithName(@"testByRank")];
    resultRank.backgroundColor = [UIColor whiteColor];
    resultRank.titLable.text = @"成绩排名";
    resultRank.titLable.font = [UIFont systemFontOfSize:13];
    resultRank.titLable.textAlignment = NSTextAlignmentCenter;
    [resultRank addTarget:self action:@selector(clickResultRankBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:resultRank];
    
    lhSymbolCustumButton *testPoints = [[lhSymbolCustumButton alloc] initWithFrankFrame1:CGRectMake(0, hightY+hight+(hight-2)/2+1*widthRate+space, 79*widthRate, hight/2)];
    [testPoints.titView setImage:imageWithName(@"testByPoints")];
    testPoints.backgroundColor = [UIColor whiteColor];
    testPoints.titLable.text = @"考试要点";
    testPoints.titLable.font = [UIFont systemFontOfSize:13];
    testPoints.titLable.textAlignment = NSTextAlignmentCenter;
    [testPoints addTarget:self action:@selector(clickTestPointsBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testPoints];
    
    lhSymbolCustumButton *testSkills = [[lhSymbolCustumButton alloc]initWithFrankFrame1:CGRectMake(80*widthRate, hightY+hight+(hight-2)/2+1*widthRate+space, 79*widthRate, hight/2)];
    [testSkills.titView setImage:imageWithName(@"testBySkills")];
    testSkills.backgroundColor = [UIColor whiteColor];
    testSkills.titLable.text = @"答题技巧";
    testSkills.titLable.font = [UIFont systemFontOfSize:13];
    testSkills.titLable.textAlignment = NSTextAlignmentCenter;
    [testSkills addTarget:self action:@selector(clickTestSkillBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testSkills];

    lhSymbolCustumButton *simulationTest = [[lhSymbolCustumButton alloc] initWithFrankFrame:CGRectMake(160*widthRate, hightY+hight+space, 160*widthRate, hight)];
    [simulationTest.titView setImage:imageWithName(@"testBySimulation")];
    simulationTest.backgroundColor = [UIColor whiteColor];
    simulationTest.titLable.text = @"模拟考试";
    simulationTest.titLable.font = [UIFont systemFontOfSize:13];
    simulationTest.titLable.textAlignment = NSTextAlignmentCenter;
    [simulationTest addTarget:self action:@selector(clickSimulationTestBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:simulationTest];
}

//创建我的错题和我的收藏按钮
-(void)createWrongAndCollectionView{
    CGFloat withX = 0;
    CGFloat hightY = DeviceMaxHeight-44-30-2-30*widthRate;
    CGFloat with = DeviceMaxWidth;
    CGFloat hight = 30.0f;
    
    UIView *showView = [[UIView alloc] initWithFrame:CGRectMake(withX, hightY, with, hight)];
    showView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:showView];
    
    UIButton *btnOfwrong = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnOfwrong.frame = CGRectMake((DeviceMaxWidth/2-100)/2, hightY, 80, hight);
    [btnOfwrong setTitle:@"我的错题" forState:UIControlStateNormal];
    [btnOfwrong addTarget:self action:@selector(clickMyWrongTopicBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnOfwrong];
    
    showWrongNumber = [[UILabel alloc] initWithFrame:CGRectMake((DeviceMaxWidth/2-100)/2+80, hightY+5, 30, 20)];
    showWrongNumber.layer.backgroundColor = [[UIColor redColor] CGColor];
    showWrongNumber.layer.borderColor = [[UIColor redColor] CGColor];
    showWrongNumber.layer.cornerRadius = 10;
    showWrongNumber.layer.borderWidth = 0.5;
    showWrongNumber.textAlignment = NSTextAlignmentCenter;
    showWrongNumber.font = [UIFont systemFontOfSize: 12.0];
    showWrongNumber.textColor = [UIColor whiteColor];
//    showWrongNumber.text = [NSString stringWithFormat:@"%ld",(long)wrongCount];
    [self.view addSubview:showWrongNumber];
    
    UIButton *btnOfCollection = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnOfCollection.frame = CGRectMake(DeviceMaxWidth/2, hightY, 80, hight);
    [btnOfCollection addTarget:self action:@selector(clickCollectionBtn) forControlEvents:UIControlEventTouchUpInside];
    [btnOfCollection setTitle:@"我的收藏" forState:UIControlStateNormal];
    
    [self.view addSubview:btnOfCollection];
    
    showCollectNub = [[UILabel alloc] initWithFrame:CGRectMake(DeviceMaxWidth/2+80, hightY+5, 30, 20)];
    showCollectNub.layer.backgroundColor = [[UIColor whiteColor] CGColor];
    showCollectNub.layer.borderColor = [[UIColor grayColor] CGColor];
    showCollectNub.layer.cornerRadius = 10;
    showCollectNub.layer.borderWidth = 0.5;
    showCollectNub.textAlignment = NSTextAlignmentCenter;
    showCollectNub.font = [UIFont systemFontOfSize: 12.0];
    showCollectNub.textColor = [UIColor grayColor];
//    showCollectNub.text = [NSString stringWithFormat:@"%ld",(long)collectCount];
    [self.view addSubview:showCollectNub];

}

- (void)createSpaceView{
    CGFloat withX = 0;
    CGFloat hightY = 64.0f+spaceValue+2*DeviceMaxWidth/5+spaceValue+2*DeviceMaxWidth/5+spaceValue+30+spaceValue;
    CGFloat with = DeviceMaxWidth;
    CGFloat hight = DeviceMaxHeight-hightY-49;
    UIView *spaceView = [[UIView alloc] initWithFrame:CGRectMake(withX, hightY, with, hight)];
    spaceView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:spaceView];
}

//进入科目一顺序练习页面
-(void)clickPracticeBtn{
    FrankPracticeView *practiceView = [[FrankPracticeView alloc] init];
    practiceView.recordJump = ORDER_PRACTICE;
    practiceView.subType = 0;
    practiceView.titleStr = @"顺序练习";
    practiceView.sqliteArray = [ManageSqlite findAll];
    practiceView.datacount = [practiceView.sqliteArray count];
    if (practiceView.datacount == 0) {
        return;
    }
    [self.navigationController pushViewController:practiceView animated:YES];
}

//进入科目四的顺序练习
-(void)clickPracticeBtn4{
    FrankPracticeView *practiceView = [[FrankPracticeView alloc] init];
    practiceView.recordJump = ORDER_PRACTICE;
    practiceView.subType = 1;
    practiceView.titleStr = @"顺序练习";
    practiceView.sqliteArray = [ManageSqlite findDb4All];
    practiceView.datacount = [practiceView.sqliteArray count];
    if (practiceView.datacount == 0) {
        return;
    }
    [self.navigationController pushViewController:practiceView animated:YES];
}

//进入科目一随机练习页面
-(void)clickrandomBtn{
    FrankPracticeView *practiceView = [[FrankPracticeView alloc] init];
    practiceView.recordJump = RANDOM_PRACTICE;
    practiceView.subType = 0;
    practiceView.titleStr = @"随机练习";
    practiceView.sqliteArray = [ManageSqlite findAll];
    practiceView.datacount = [practiceView.sqliteArray count];
    if (practiceView.datacount == 0) {
        return;
    }
    [self.navigationController pushViewController:practiceView animated:YES];
}

//进入科目四进入随机练习
-(void)clickrandomBtn4{
    FrankPracticeView *practiceView = [[FrankPracticeView alloc] init];
    practiceView.recordJump = RANDOM_PRACTICE;
    practiceView.subType = 1;
    practiceView.titleStr = @"随机练习";
    practiceView.sqliteArray = [ManageSqlite findDb4All];
    practiceView.datacount = [practiceView.sqliteArray count];
    if (practiceView.datacount == 0) {
        return;
    }
    [self.navigationController pushViewController:practiceView animated:YES];
}

//进入科目一专项练习
-(void)clickChapterBtn{
    FrankChapterPracticeView *chapterPracticeView = [[FrankChapterPracticeView alloc] init];
    chapterPracticeView.subject = 0;
    [self.navigationController pushViewController:chapterPracticeView animated:YES];
}

//进入科目四的专项练习
-(void)clickChapterBtn4{
    FrankChapterPracticeView *chapterPracticeView = [[FrankChapterPracticeView alloc] init];
    chapterPracticeView.subject = 1;
    [self.navigationController pushViewController:chapterPracticeView animated:YES];
}

//进入科目一难题攻克练习
-(void)clickProblemBtn{
    FrankPracticeView *practiceView = [[FrankPracticeView alloc] init];
    practiceView.recordJump = PROBLEM_SOLVE;
    practiceView.subType = 0;
    practiceView.titleStr = @"难题攻克";
    practiceView.sqliteArray = [ManageSqlite findRandomData];   //随机查出100道题
    if ([practiceView.sqliteArray count] == 0) {
        return;
    }
    practiceView.datacount = 100;
    [self.navigationController pushViewController:practiceView animated:YES];
}

//进入科目四难题攻克练习
-(void)clickProblemBtn4{
    FrankPracticeView *practiceView = [[FrankPracticeView alloc] init];
    practiceView.recordJump = PROBLEM_SOLVE;
    practiceView.subType = 1;
    practiceView.titleStr = @"难题攻克";
    practiceView.sqliteArray = [ManageSqlite findRandomData4];   //随机查出100道题
    if ([practiceView.sqliteArray count] == 0) {
        return;
    }
    practiceView.datacount = 100;
    [self.navigationController pushViewController:practiceView animated:YES];
}

//进入科目一易错题集
-(void)clickWrongTopicBtn{
    NSMutableArray *wrongTopicArray = [ManageSqlite findWrongRecord];
    if (![wrongTopicArray count]) {
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您暂无错题，无法统计" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [myAlertView show];
    }else{
        FrankPracticeView *practiceView = [[FrankPracticeView alloc] init];
        practiceView.recordJump = FALLIBLE_ANSWERS;
        practiceView.subType = 0;
        practiceView.titleStr = @"易错题集";
        practiceView.sqliteArray = wrongTopicArray;
        practiceView.datacount = [wrongTopicArray count];
        [self.navigationController pushViewController:practiceView animated:YES];
    }
}

//进入科目四易错题集
-(void)clickWrongTopicBtn4{
    NSMutableArray *wrongTopicArray = [ManageSqlite findWrongRecord4];
    if (![wrongTopicArray count]) {
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您暂无错题，无法统计" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [myAlertView show];
    }else{
        FrankPracticeView *practiceView = [[FrankPracticeView alloc] init];
        practiceView.recordJump = FALLIBLE_ANSWERS;
        practiceView.subType = 1;
        practiceView.titleStr = @"易错题集";
        practiceView.sqliteArray = wrongTopicArray;
        practiceView.datacount = [wrongTopicArray count];
        [self.navigationController pushViewController:practiceView animated:YES];
    }
}

//进入科目一我的错题
-(void)clickMyWrongTopicBtn{
    NSMutableArray *wrongTopicArray = [ManageSqlite findWrongRecord];
    if (![wrongTopicArray count]) {
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"暂无错题" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [myAlertView show];
    }else{
        FrankPracticeView *practiceView = [[FrankPracticeView alloc] init];
        practiceView.recordJump = WRONG_QUESTION;
        practiceView.subType = 0;
        practiceView.titleStr = @"我的错题";
        practiceView.sqliteArray = wrongTopicArray;
        practiceView.datacount = [wrongTopicArray count];
        [self.navigationController pushViewController:practiceView animated:YES];
    }
}

//进入科目四我的错题
-(void)clickMyWrongTopicBtn4{
    NSMutableArray *wrongTopicArray = [ManageSqlite findWrongRecord4];
    if (![wrongTopicArray count]) {
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"暂无错题" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [myAlertView show];
    }else{
        FrankPracticeView *practiceView = [[FrankPracticeView alloc] init];
        practiceView.recordJump = WRONG_QUESTION;
        practiceView.subType = 1;
        practiceView.titleStr = @"我的错题";
        practiceView.sqliteArray = wrongTopicArray;
        practiceView.datacount = [wrongTopicArray count];
        [self.navigationController pushViewController:practiceView animated:YES];
    }
}

//进入科目一我的收藏页面
-(void)clickCollectionBtn{
    NSMutableArray *collectArray = [ManageSqlite findCollectRecord];
    if (![collectArray count]) {
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"暂无收藏" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [myAlertView show];
    }else{
        FrankPracticeView *practiceView = [[FrankPracticeView alloc] init];
        practiceView.recordJump = COLLECT_QUESTION;
        practiceView.subType = 0;
        practiceView.titleStr = @"我的收藏";
        practiceView.sqliteArray = collectArray;
        practiceView.datacount = [collectArray count];
        [self.navigationController pushViewController:practiceView animated:YES];
    }
}

//进入科目四我的收藏页面
-(void)clickCollectionBtn4{
    NSMutableArray *collectArray = [ManageSqlite findCollectRecord4];
    if (![collectArray count]) {
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"暂无收藏" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [myAlertView show];
    }else{
        FrankPracticeView *practiceView = [[FrankPracticeView alloc] init];
        practiceView.recordJump = COLLECT_QUESTION;
        practiceView.subType = 1;
        practiceView.titleStr = @"我的收藏";
        practiceView.sqliteArray = collectArray;
        practiceView.datacount = [collectArray count];
        [self.navigationController pushViewController:practiceView animated:YES];
    }
}

//进入科目一模拟考试
-(void)clickSimulationTestBtn{
    FrankRemindView *remindView = [[FrankRemindView alloc] init];
    remindView.subType = 0;
    [self.navigationController pushViewController:remindView animated:YES];
}

//进入科目四模拟考试
-(void)clickSimulationTestBtn4{
    FrankRemindView *remindView = [[FrankRemindView alloc] init];
    remindView.subType = 1;
    [self.navigationController pushViewController:remindView animated:YES];
}

//进入科目一答题技巧
-(void)clickTestSkillBtn{
    FrankTestskillView *testskillView = [[FrankTestskillView alloc] init];
    [self.navigationController pushViewController:testskillView animated:YES];
}

//进入科目四答题技巧
-(void)clickTestSkillBtn4{
    FrankTestskillView *testskillView = [[FrankTestskillView alloc] init];
    [self.navigationController pushViewController:testskillView animated:YES];
}


//进入科目一排行榜
-(void)clickResultRankBtn{
    FrankSubjectListView *resultRankView = [[FrankSubjectListView alloc] init];
    [self.navigationController pushViewController:resultRankView animated:YES];
}

//进入科目四排行榜
-(void)clickResultRankBtn4{
    FrankSubjectListView *resultRankView = [[FrankSubjectListView alloc] init];
    [self.navigationController pushViewController:resultRankView animated:YES];
}

//进入科目一考试要点
-(void)clickTestPointsBtn{
    FrankTestpointsView *testPointView = [[FrankTestpointsView alloc] init];
    [self.navigationController pushViewController:testPointView animated:YES];
}

//进入科目四考试要点
-(void)clickTestPointsBtn4{
    FrankTestpointsView *testPointView = [[FrankTestpointsView alloc] init];
    [self.navigationController pushViewController:testPointView animated:YES];
}

//进入科目一考试记录
-(void)clickTestRecordBtn{
    NSArray*paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString*path=[paths objectAtIndex:0];
    NSString *filename=[path stringByAppendingPathComponent:@"subject1.plist"];
    NSMutableArray *rootArray = [NSMutableArray arrayWithContentsOfFile:filename];
    if ([rootArray count]) {
        FrankTestRecordView *testRecordView = [[FrankTestRecordView alloc] init];
        testRecordView.subType = 0;
        [self.navigationController pushViewController:testRecordView animated:YES];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"你还没有考试记录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即去考试", nil];
        alertView.tag = 1;
        [alertView show];
    }
}

//进入科目四考试记录
-(void)clickTestRecordBtn4{
    NSArray*paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString*path=[paths objectAtIndex:0];
    NSString *filename=[path stringByAppendingPathComponent:@"subject4.plist"];
    NSMutableArray *rootArray = [NSMutableArray arrayWithContentsOfFile:filename];
    if ([rootArray count]) {
        FrankTestRecordView *testRecordView = [[FrankTestRecordView alloc] init];
        testRecordView.subType = 1;
        [self.navigationController pushViewController:testRecordView animated:YES];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"你还没有考试记录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即去考试", nil];
        alertView.tag = 4;
        [alertView show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSInteger subject = 0;
    if (alertView.tag == 1) {
        subject = 0;
    }
    else if (alertView.tag == 4){
        subject = 1;
    }
    if (buttonIndex == 1) {
        FrankRemindView *remindView = [[FrankRemindView alloc] init];
        remindView.subType = subject;
        [self.navigationController pushViewController:remindView animated:YES];
    }
}

//创建头
-(void)createHeadFrame{
    
    NSArray * tArray = @[@"科目一",@"科目二",@"科目三",@"科目四"];
    for (int i = 0; i < 4; i++) {
        UIButton * titleBtn = [[UIButton alloc]initWithFrame:CGRectMake(DeviceMaxWidth/4*i, 64, DeviceMaxWidth/4, 49)];
        titleBtn.backgroundColor = [UIColor whiteColor];
        titleBtn.titleLabel.font = [UIFont fontWithName:fontName size:15];
        [titleBtn setTitle:[tArray objectAtIndex:i] forState:UIControlStateNormal];
        [titleBtn setTitleColor:[lhColor colorFromHexRGB:mainColorStr] forState:UIControlStateSelected];
        [titleBtn setTitleColor:[lhColor colorFromHexRGB:contentTitleColorStr1] forState:UIControlStateNormal];
        if (i == 0) {
            titleBtn.selected = YES;
            lastBtn = titleBtn;
        }
        titleBtn.tag = i+titleBtnOriginalTag;
        [titleBtn addTarget:self action:@selector(titleBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:titleBtn];
    }
    
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 112.5, DeviceMaxWidth, 0.5)];
    lineView.backgroundColor = [lhColor colorFromHexRGB:contentTitleColorStr1];
    [self.view addSubview:lineView];
    
    mainLine = [[UIView alloc]initWithFrame:CGRectMake(15*widthRate, 112, 50*widthRate, 1)];
    mainLine.backgroundColor = [lhColor colorFromHexRGB:mainColorStr];
    [self.view addSubview:mainLine];
}

- (void)titleBtnEvent:(UIButton *)btn_
{
    
    if (btn_.selected) {
        return;
    }
    lastBtn.selected = NO;
    
    [UIView animateWithDuration:0.1 animations:^{
        btn_.selected = YES;
        
        maxScollView.contentOffset = CGPointMake(DeviceMaxWidth*(btn_.tag-titleBtnOriginalTag), 0);
        
        mainLine.frame = CGRectMake(15*widthRate+DeviceMaxWidth/4*(btn_.tag-titleBtnOriginalTag), 112, 50*widthRate, 1);
    }completion:^(BOOL finished) {
        lastBtn = btn_;
        [lhColor mergeTitle:[titleArray objectAtIndex:btn_.tag-titleBtnOriginalTag]];
    }];
    
    
}

#pragma mark - UIScollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == maxScollView) {
        NSInteger inde = (NSInteger)scrollView.contentOffset.x/DeviceMaxWidth;
        UIButton * nowBtn = (UIButton *)[self.view viewWithTag:inde+titleBtnOriginalTag];
        
        mainLine.frame = CGRectMake(15*widthRate+scrollView.contentOffset.x/4, 112, 50*widthRate, 1);
        lastBtn.selected = NO;
        nowBtn.selected = YES;
        lastBtn = nowBtn;
        
        [lhColor mergeTitle:[titleArray objectAtIndex:inde]];
    }
    
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
//    [self countWrongAndCollect];
//    showWrongNumber.text = [NSString stringWithFormat:@"%ld",(long)wrongCount];
//    showCollectNub.text = [NSString stringWithFormat:@"%ld",(long)collectCount];
    
}

@end

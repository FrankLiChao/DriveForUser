//
//  PracticeViewController.m
//  PracticeSimulation
//
//  Created by lichao on 15/7/16.
//  Copyright (c) 2015年 LiFrank. All rights reserved.
//

#import "FrankPracticeView.h"
#import "FrankPageContentView.h"
#import "FrankCollectionView.h"
#import "Practice.h"
#import "FrankChapterPracticeView.h"
#import "FrankTestFinishedView.h"

@interface FrankPracticeView ()
{
    FrankPageContentView * tpVC;
    lhSymbolCustumButton * titleIndex;          //标题栏序号按钮
    lhSymbolCustumButton * titileExplain;      //标题栏解释按钮
    lhSymbolCustumButton * titileCollect;      //标题栏收藏按钮
    lhSymbolCustumButton * titileTimer;         //标题栏倒计时
    lhSymbolCustumButton * titileSubmit;         //标题栏考试提交
}

@end

@implementation FrankPracticeView
@synthesize explainItem, datacount ,sqliteArray,scoreForTest,swipeRight,titileExplain;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWithData];
//    [self createTabBar];
    [self createTitleView];
    [self createPageView];
    if (self.recordJump == SIMULATION_TEST) {
        [self createCountdownTimerView];
    }
    [self createGestureRecognizer];
}

//初始化数据
-(void) initWithData{
    scoreForTest = 0;
    [[lhColor shareColor]originalInit:self title:self.titleStr imageName:nil backButton:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    manageSqlite = [[ManageSqlite alloc] init];
    _pageContentView = [[FrankPageContentView alloc] init];
    recordArray = [[NSMutableArray alloc] init];
    NSLog(@"self.sqliteArray = %ld",(long)((Practice *)self.sqliteArray[0]).answerRecord);
}

-(void)createTitleView{
    titileExplain = [[lhSymbolCustumButton alloc]initWithFrame:CGRectMake(DeviceMaxWidth-55, 20, 53, 44)];
    [titileExplain setBackgroundImage:imageWithName(@"explain") forState:UIControlStateNormal];
    [titileExplain setBackgroundImage:imageWithName(@"explain1") forState:UIControlStateSelected];
    titileExplain.tLabel.text = @"查看详解";
    [titileExplain addTarget:self action:@selector(clickExplainBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:titileExplain];
    
    titileCollect = [[lhSymbolCustumButton alloc]initWithFrame:CGRectMake(DeviceMaxWidth-105, 20, 53, 44)];
    [titileCollect setBackgroundImage:imageWithName(@"collect") forState:UIControlStateNormal];
    [titileCollect setBackgroundImage:imageWithName(@"collect1") forState:UIControlStateSelected];
    titileCollect.tLabel.text = @"收藏";
    [titileCollect addTarget:self action:@selector(clickCollectBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:titileCollect];
    
    titleIndex = [[lhSymbolCustumButton alloc]initWithFrame:CGRectMake(DeviceMaxWidth-155, 20, 53, 44)];
    [titleIndex setBackgroundImage:imageWithName(@"selectIndex") forState:UIControlStateNormal];
    [titleIndex setBackgroundImage:imageWithName(@"selectIndex") forState:UIControlStateSelected];
    titleIndex.tLabel.text = [[NSString alloc] initWithFormat:@"%ld/%ld",(long)_pageContentView.pageIndex,(long)datacount];
    [titleIndex addTarget:self action:@selector(clickIndexBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:titleIndex];
    
    titileTimer = [[lhSymbolCustumButton alloc]initWithFrame:CGRectMake(DeviceMaxWidth-205, 20, 53, 44)];
    [titileTimer setBackgroundImage:imageWithName(@"TimerForTest") forState:UIControlStateNormal];
    titileTimer.tLabel.text = [NSString stringWithFormat:@"%d:%d",45,00];
    titileTimer.hidden = YES;
    [self.view addSubview:titileTimer];
    
    titileSubmit = [[lhSymbolCustumButton alloc]initWithFrame:CGRectMake(DeviceMaxWidth-55, 20, 53, 44)];
    [titileSubmit setBackgroundImage:imageWithName(@"testpaper") forState:UIControlStateNormal];
    titileSubmit.tLabel.text = @"交卷";
    titileSubmit.hidden = YES;
    [titileSubmit addTarget:self action:@selector(clickSubmitBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:titileSubmit];
}

#pragma mark - 标题栏事件
-(void)clickIndexBtn:(UIButton *)button_
{
    [self showCollectionView];
    if (button_.selected) {
        button_.selected = NO;
    }else{
        button_.selected = YES;
    }
}

-(void)clickCollectBtn:(UIButton *)button_
{
    NSString *msg = nil;
    NSInteger testIndex = ((Practice *)(sqliteArray[_pageContentView.pageIndex-1])).testID;
    if (button_.selected) {
        button_.selected = NO;
        titileCollect.tLabel.text = @"收藏";
        if (self.subType == 0) {
            [ManageSqlite updateAccordingTestID:testIndex withCollect:0];
        }else if (self.subType == 1){
            [ManageSqlite updateAccordingTestID4:testIndex withCollect:0];
        }
        msg = @"取消成功";
    }else{
        button_.selected = YES;
        titileCollect.tLabel.text = @"已收藏";
        if (self.subType == 0) {
            [ManageSqlite updateAccordingTestID:testIndex withCollect:1];
        }else if (self.subType){
            [ManageSqlite updateAccordingTestID4:testIndex withCollect:1];
        }
        msg = @"收藏成功";
    }
    [lhColor showAlertWithMessage:msg withSuperView:self.view withHeih:DeviceMaxHeight/2];
}

-(void)clickExplainBtn:(UIButton *)button_
{
    if (button_.selected) {
        button_.selected = NO;
        titileExplain.tLabel.text = @"查看详解";
        [tpVC hideTextView];
    }else{
        button_.selected = YES;
        titileExplain.tLabel.text = @"收起详解";
        [tpVC hideTextView];
    }
}

-(void)clickSubmitBtn:(UIButton *)button_
{
    NSLog(@"点击交卷");
    [self clickTestOver];
}

//创建手势
-(void)createGestureRecognizer{
    self.leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    self.rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    
    self.leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    self.rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:self.leftSwipeGestureRecognizer];
    [self.view addGestureRecognizer:self.rightSwipeGestureRecognizer];
}

//创建pageView
-(void)createPageView{
    NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin] forKey:UIPageViewControllerOptionSpineLocationKey];
    self.pageViewController = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
    self.pageViewController.delegate = self;
    [[self.pageViewController view] setFrame:CGRectMake(0, 64, DeviceMaxWidth, DeviceMaxHeight-64)];
    FrankPageContentView *startViewController = nil;
    self.view.backgroundColor = [UIColor whiteColor];
    if (_recordJump == RANDOM_PRACTICE){ //随机练习
        NSInteger index = [self getRandomNumber:1 to:datacount];
        _pageContentView.pageIndex = index;
        startViewController = [self viewControllerAtIndex:index];
    }
    else if (_recordJump == TEST_HISTORY){
        NSArray*paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString*path=[paths objectAtIndex:0];
        NSString *filename = nil;
        if (self.subType == 0) {
            filename=[path stringByAppendingPathComponent:@"subject1.plist"];
        }else{
            filename=[path stringByAppendingPathComponent:@"subject4.plist"];
        }
        rootArray = [NSMutableArray arrayWithContentsOfFile:filename];
        plistArray = [rootArray[self.recordIndex] objectForKey:@"array"];
        if (![plistArray count]) {
            NSLog(@"plist文件为空");
        }
        sqliteArray = [[NSMutableArray alloc] init];
        for (int i=0; i<[plistArray count]; i++) {
            Practice *p = [ManageSqlite findRecordByID:[plistArray[i] integerValue]];
            [sqliteArray addObject:p];
        }
        _pageContentView.pageIndex = 1;
        startViewController = [self viewControllerAtIndex:1];
    }else {
        _pageContentView.pageIndex = 1;
        startViewController = [self viewControllerAtIndex:1];
    }
    
    NSArray *viewControllers = @[startViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    self.pageViewController.view.frame = CGRectMake(0,64, DeviceMaxWidth, DeviceMaxHeight-64);
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
}

//获取随机数
-(NSInteger)getRandomNumber:(NSInteger)from to:(NSInteger)to
{
    return (NSInteger)(from + (arc4random() % (to - from + 1)));
}

//创建倒计时的view
-(void)createCountdownTimerView{
    titileTimer.hidden = NO;
    titileSubmit.hidden = NO;
    titileExplain.hidden = YES;
    totalNumber = 45*60;
    NSInteger stepTimer = 1;
    countdownTimer = [NSTimer scheduledTimerWithTimeInterval:stepTimer target:self selector:@selector(countdownTimer) userInfo:nil repeats:YES];
}

//倒计时显示的方法
-(void)countdownTimer{
    totalNumber = totalNumber - 1;
    NSInteger seconds = totalNumber % 60;
    NSInteger minutes = (totalNumber / 60) % 60;
    NSString *timeString = [NSString stringWithFormat:@"%ld:%ld",(long)minutes, (long)seconds];
    titileTimer.tLabel.text = timeString;
    if (totalNumber == 0) { //假设倒数到0结束
        [countdownTimer invalidate];
        countdownTimer = nil;
    }
}

//保存数组到本地plist文件
-(void)saveDataToPlist{
    NSMutableArray * array=[[NSMutableArray alloc]init];
    for (int i=0; i<[sqliteArray count]; i++) {
        [array addObject:[NSNumber numberWithInteger:((Practice *)(self.sqliteArray[i])).testID]];
    }
    NSArray *keyArray = @[@"score",@"data",@"time",@"array"];
    recordArray[3] = array;
    NSDictionary *indexDic = [[NSDictionary alloc] initWithObjects:recordArray forKeys:keyArray];
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *filename = nil;
    if (self.subType == 0) {
        filename=[path stringByAppendingPathComponent:@"subject1.plist"];
    }else if (self.subType == 1){
        filename=[path stringByAppendingPathComponent:@"subject4.plist"];
    }
    rootArray = [[NSMutableArray alloc] initWithContentsOfFile:filename];
    if(rootArray == nil)
    {
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        arr[0] = indexDic;
        BOOL tag = [arr writeToFile:filename atomically:YES];
        if (!tag) {
            NSLog(@"写入失败");
        }

    }else{
        NSInteger count = [rootArray count];
        rootArray[count] = indexDic;
        BOOL tag = [rootArray writeToFile:filename atomically:YES];
        if (!tag) {
            NSLog(@"写入失败");
        }
    }
}

//创建tabBar
-(void)createTabBar{
    CGRect footFrame = CGRectMake(0, DeviceMaxHeight-49.0f, DeviceMaxWidth, 49.0f);
    _tabBar = [[UITabBar alloc] initWithFrame:footFrame];
    lableItem = [[UITabBarItem alloc] initWithTitle:[[NSString alloc] initWithFormat:@"%ld/%ld",(long)_pageContentView.pageIndex,(long)datacount] image:[UIImage imageNamed:@"selectIndex"] tag:0];
    lableItem.selectedImage = imageWithName(@"selectIndex1");
    collectionItem = [[UITabBarItem alloc] initWithTitle:@"收藏本题" image:[UIImage imageNamed:@"collect"] tag:1];
    collectionItem.selectedImage = imageWithName(@"collect1");
    if (_recordJump == SIMULATION_TEST) {
        commitItem = [[UITabBarItem alloc] initWithTitle:@"交卷" image:[UIImage imageNamed:@"testpaper" ]tag:2];
        commitItem.selectedImage = imageWithName(@"testpaper1");
        _tabBar.items = @[lableItem,collectionItem,commitItem];
    }else{
        explainItem = [[UITabBarItem alloc] initWithTitle:@"本题解释" image:[UIImage imageNamed:@"explain" ]tag:2];
        explainItem.selectedImage = imageWithName(@"explain1");
        _tabBar.items = @[lableItem,collectionItem,explainItem];
    }
    _tabBar.delegate = self;
    [self.view addSubview:_tabBar];
}

//控制页面跳转
-(void)nextPageControl:(NSNumber *)number{
    NSInteger index = [number intValue];
    if (index > datacount) {
        return;
    }
    _pageContentView.pageIndex = index;
    FrankPageContentView *startingViewController = [self viewControllerAtIndex:index];
    NSArray *viewControllers = @[startingViewController];
    if (swipeRight) {
        [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
    }else{
        [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    }
}

//按照题号创建view
- (FrankPageContentView *)viewControllerAtIndex:(NSInteger)index{
    if (index == 0) {
        return nil;
    }
    if ([sqliteArray count] == 0) {
        sqliteArray = [ManageSqlite findAll];
    }
    _pageContentView.pageIndex = index;
    FrankPageContentView *childView = [[FrankPageContentView alloc] init];
    tpVC = childView;
    childView.delegate = self;
    NSLog(@"datacount = %ld",datacount);
    if ((datacount == 0) || (index > datacount)) {
        return nil;
    }
    _practiceManage = sqliteArray[index-1];
    titleIndex.tLabel.text = [[NSString alloc] initWithFormat:@"%ld/%ld",(long)index,(long)datacount];
    childView.titleText = _practiceManage.testSubject;
    childView.imageName = _practiceManage.imageName;
    childView.answerA = _practiceManage.answerA;
    childView.answerB = _practiceManage.answerB;
    childView.answerC = _practiceManage.answerC;
    childView.answerD = _practiceManage.answerD;
    childView.answer  = _practiceManage.testAnswer;
    childView.analysis = _practiceManage.testAnalysis;
    childView.pageIndex = index;
    childView.questionType = _practiceManage.questionType;
    childView.testID  = _practiceManage.testID;
    childView.subType = self.subType;
    
    if (_recordJump == COLLECT_QUESTION) {
        titileCollect.tLabel.text = @"已收藏";
        titileCollect.selected = YES;
    }else{
        //判断是科目一还是科目四
        if (self.subType == 0)
        {
            NSInteger collect = [ManageSqlite findCollectRecord:index];
            if (collect == 0) {
                titileCollect.tLabel.text = @"收藏";
                titileCollect.selected = NO;
            }else{
                titileCollect.tLabel.text = @"已收藏";
                titileCollect.selected = YES;
            }
        }else if (self.subType == 1)
        {
            NSInteger collect = [ManageSqlite findCollectRecord4:index];
            if (collect == 0) {
                titileCollect.tLabel.text = @"收藏";
                titileCollect.selected = NO;
            }else{
                titileCollect.tLabel.text = @"已收藏";
                titileCollect.selected = YES;
            }
        }
    }
    titileExplain.tLabel.text = @"查看详情";
    titileExplain.selected = NO;
    return childView;
}

- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
    if (_recordJump == RANDOM_PRACTICE) { //随机练习
        if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
            swipeRight = YES;
            [self nextPageControl:[NSNumber numberWithInteger:[self getRandomNumber:1 to:datacount]]];
        }else{
            swipeRight = NO;
            [self nextPageControl:[NSNumber numberWithInteger:[self getRandomNumber:1 to:datacount]]];
        }
    }else
    { //顺序练习
        if (sender.direction == UISwipeGestureRecognizerDirectionRight) { //右划
            NSInteger index = _pageContentView.pageIndex;
            if ((index == 1)|| (index == NSNotFound)) {
                
            }else{
                index--;
                swipeRight = YES;
                [self nextPageControl:[NSNumber numberWithInteger:index]];
            }
        }
        if (sender.direction == UISwipeGestureRecognizerDirectionLeft) { //左划
            NSInteger index = _pageContentView.pageIndex;
            if ((index == NSNotFound) || index == datacount){
                
            }else{
                index++;
                swipeRight = NO;
                [self nextPageControl:[NSNumber numberWithInteger:index]];
            }
        }
    }
}

//返回要创建的页数
-(NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController{
    return datacount;
}

//选中tabBar时调用
- (void)tabBar:(UITabBar *)tabbar didSelectItem:(UITabBarItem *)item
{
    NSLog(@"Selected is %ld",(long)item.tag);
    NSString *msg = nil;
    if (0 == item.tag) {
        [self showCollectionView];
    }else if (1==item.tag) {
        NSInteger testIndex = ((Practice *)(sqliteArray[_pageContentView.pageIndex-1])).testID;
        if ([collectionItem.title isEqualToString:@"收藏本题"]) {
            if (self.subType == 0) {
                [ManageSqlite updateAccordingTestID:testIndex withCollect:1];
            }else if (self.subType == 1){
                [ManageSqlite updateAccordingTestID4:testIndex withCollect:1];
            }
            collectionItem.title = @"取消收藏";
            msg = @"收藏成功";
        }else{
            if (self.subType == 0) {
                [ManageSqlite updateAccordingTestID:testIndex withCollect:0];
            }else if (self.subType == 1){
                [ManageSqlite updateAccordingTestID4:testIndex withCollect:0];
            }
            collectionItem.title = @"收藏本题";
            msg = @"取消成功";
        }
        [lhColor showAlertWithMessage:msg withSuperView:self.view withHeih:DeviceMaxHeight/2];
    }else if(2 == item.tag) {
        if (_recordJump == SIMULATION_TEST) {
            [self clickTestOver];
        }else{
            if ([explainItem.title isEqualToString:@"本题解释"]) {
                [tpVC hideTextView];
                explainItem.title = @"收起解释";
                
            } else {
                explainItem.title = @"本题解释";
                [tpVC hideTextView];
            }
        }
    }
}

//交卷操作
-(void)clickTestOver{
    //字符串的分割
    NSArray *strArray = [titileTimer.tLabel.text componentsSeparatedByString:@":"];
    if (strArray) {
        timeForseconds = [strArray[0] integerValue]*60 +[strArray[1] integerValue];
    }
    NSDateComponents *comps = [self getTimeFromString];
    recordArray[0] = [NSString stringWithFormat:@"%ld",(long)scoreForTest];
    recordArray[1] = [NSString stringWithFormat:@"%ld-%ld-%ld",(long)[comps year],(long)[comps month],(long)[comps day]];
    recordArray[2] = [NSString stringWithFormat:@"%ld:%ld",(long)((45*60-timeForseconds)/60)%60,(long)(45*60-timeForseconds)%60];
    [self saveDataToPlist];
    FrankTestFinishedView *testFinished = [[FrankTestFinishedView alloc] init];
    testFinished.scoreForTest = scoreForTest;
    testFinished.timeForseconds = timeForseconds;
    [self.navigationController pushViewController:testFinished animated:YES];
    
    [self removeThisVC];
}

#pragma mark - 移除当前页面
- (void)removeThisVC
{
    NSMutableArray * tempVC1 = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    
    for (UIViewController * vc in tempVC1) {
        if ([vc class] == [self class]) {
            [tempVC1 removeObject:vc];
            break;
        }
    }
    
    self.navigationController.viewControllers = tempVC1;
}

-(NSDateComponents *)getTimeFromString{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    comps = [calendar components:unitFlags fromDate:[NSDate date]];
    return comps;
}

//在视图中显示collectionView
-(void)showCollectionView{
    collectionView = [[FrankCollectionView alloc] init];
    collectionView.cellDataForArry = [NSMutableArray arrayWithArray:sqliteArray];
    collectionView.delegate = self;
    [self.view addSubview:collectionView.view];
    
    [collectionView.returnBtn addTarget:self action:@selector(hideCollectionView) forControlEvents:UIControlEventTouchUpInside];
    collectionView.view.frame = CGRectMake(0, DeviceMaxHeight, DeviceMaxWidth, DeviceMaxHeight);
    [UIView animateWithDuration:0.15 delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         collectionView.view.frame = CGRectMake(0, 0, DeviceMaxWidth, DeviceMaxHeight);
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

//隐藏collectionView
-(void)hideCollectionView{
    [UIView animateWithDuration:0.15 delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         collectionView.view.frame = CGRectMake(0, DeviceMaxHeight, DeviceMaxWidth, DeviceMaxHeight);
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

-(void)hideOrShowExplain:(BOOL)action{
    if (action) {
        explainItem.title = @"本题解释";
    }else{
        explainItem.title = @"收起解释";
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated{

}

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    NSLog(@"%ld",buttonIndex);
//    if (buttonIndex == 0) {
//        [self clickTestOver];
//    }else if (buttonIndex == 1){
//    
//    }
//}

#pragma mark - view
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [lhColor assignmentForTempVC:self];
}

@end

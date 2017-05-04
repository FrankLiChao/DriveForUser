//
//  MainViewController.m
//  Drive
//
//  Created by bosheng on 15/7/26.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import "MainViewController.h"
#import "FrankMainViewController.h"
#import "lhPersonalViewController.h"
#import "lhWantStudyViewController.h"
#import "lhFunctionCollectionViewCell.h"
#import "lhDriTestCirViewController.h"
#import "lhMyDrSchoolViewController.h"
#import "lhAppointSimuViewController.h"
#import "lhHotTableViewCell.h"
#import "lhSelectCityViewController.h"
#import "lhBildIDCardViewController.h"
#import "lhScanQRViewController.h"
#import "FrankStudyBySelfView.h"
#import "FrankWebView.h"
#import "MJRefresh.h"
#import "FrankNewsNotice.h"
#import "FrankLoginView.h"

#import "UIImageView+MJWebCache.h"

@interface MainViewController ()<
UIScrollViewDelegate,
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
UITableViewDataSource,
UITableViewDelegate,
UIAlertViewDelegate>
{
    UIView * maxView;//所有视图
    
    UIScrollView * maxScrollView;//整个界面是个scrollView
    
    //banner
    UIScrollView * bannerScrollView;//横幅广告
    NSMutableArray * bannerPicArray;//广告数据
    NSInteger counTime;//时间
    UIPageControl * bannerPC;
    NSTimer * moveTimer;//计时器
    NSInteger timeDistance;//自动切换广告时间间隔
    
    //模块功能
    UICollectionView * funCView;
    NSArray * funArray;
    
    //热门
    UITableView * hotTableView;
    UIView * hotView;
    
    UILabel * cityLabel;//显示城市名
    
    UIImageView * stationImgView;
    NSArray * newsArray;//新闻
}

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    maxView = [[UIView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:maxView];
    
    [lhColor shareColor].nowCityStr = @"成都";
    
    [[lhColor shareColor]originalInitView:maxView title:@"" imageName:nil backButton:NO];
    [self createTitle];
    
    UIButton * llBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    llBtn.frame = CGRectMake(DeviceMaxWidth-60, 20, 60, 44);
    [llBtn setBackgroundImage:imageWithName(@"personalIcon") forState:UIControlStateNormal];
    [llBtn addTarget:self action:@selector(llBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:llBtn];
    
    /*
     UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(DeviceMaxWidth-45, 27, 0.5, 30)];
     lineView.alpha = 0.4;
     lineView.backgroundColor = [UIColor blackColor];
     [self.view addSubview:lineView];
     
     UIButton * moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
     moreBtn.frame = CGRectMake(DeviceMaxWidth-50, 20, 50, 44);
     [moreBtn setBackgroundImage:imageWithName(@"mainMore1") forState:UIControlStateNormal];
     [moreBtn addTarget:self action:@selector(moreBtnEvent) forControlEvents:UIControlEventTouchUpInside];
     //    [self.view addSubview:moreBtn];
     */
    maxScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, DeviceMaxWidth, DeviceMaxHeight-64)];
    maxScrollView.delegate = self;
    maxScrollView.showsVerticalScrollIndicator = NO;
    maxScrollView.backgroundColor = [lhColor colorFromHexRGB:viewColorStr];
    [maxView addSubview:maxScrollView];
    
    [maxScrollView addHeaderWithTarget:self action:@selector(headerRefresh)];
    
    maxScrollView.contentSize = CGSizeMake(DeviceMaxWidth, maxScrollView.frame.size.height+5);
    
    newsArray = [[NSUserDefaults standardUserDefaults] objectForKey:saveMainNewsArrayFile];
    if (!newsArray) {
        newsArray = [NSArray array];
    }
    
    [self firmLabel];
    //轮播
    NSMutableArray * lA = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:mainViewlunboPicFile]];
    bannerPicArray = [NSMutableArray array];
    //    NSLog(@"chushihua lun bo  %@",lA);
    if (lA && lA.count > 0) {
        for (int i = 0; i < lA.count; i++) {
            
            NSMutableString * iS = [NSMutableString stringWithFormat:@"%@",[[lA objectAtIndex:i] objectForKey:@"img"]];
            NSString * nStr = [iS stringByReplacingOccurrencesOfString:@"/" withString:@""];
            
            UIImage * imgV = [[lhColor shareColor] readImageWithNameOther:nStr];
            if (imgV) {
                [bannerPicArray addObject:imgV];
            }
        }
    }
    else{
        [bannerPicArray addObject:imageWithName(@"lunboPic2.jpg")];
        [bannerPicArray addObject:imageWithName(@"lunboPic0.jpg")];
        [bannerPicArray addObject:imageWithName(@"lunboPic1.jpg")];
        [bannerPicArray addObject:imageWithName(@"lunboPic2.jpg")];
        [bannerPicArray addObject:imageWithName(@"lunboPic0.jpg")];
    }
    
    [self initLunBoViewO:bannerPicArray];
    
    [self requestData];
}

-(void)createTitle{
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake((DeviceMaxWidth-100*widthRate)/2, 34, 100*widthRate, 20)];
    lable.text = @"优品学车";
    lable.font = [UIFont systemFontOfSize:18];
    lable.textColor = [UIColor whiteColor];
    lable.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 下拉刷新
- (void)headerRefresh
{
    [self requestData];
}

#pragma mark - 请求数据
- (void)requestData
{
    NSString * typeStr = @"1";
    NSString * cityStr = @"重庆";
    if ([lhColor shareColor].isOnLine) {
        typeStr = [NSString stringWithFormat:@"%@",[[lhColor shareColor].userInfo objectForKey:@"type"]];
    }
    if ([lhColor shareColor].nowCityStr) {
        NSLog(@"当前城市 = %@",[lhColor shareColor].nowCityStr);
        cityStr = [lhColor shareColor].nowCityStr;
    }
    NSDictionary * dic = @{@"type":typeStr,
                           @"location":cityStr};
    
    [FrankNetworkManager postReqeustWithURL:PATH(@"msg/news") params:dic successBlock:^(id returnData){
        [maxScrollView headerEndRefreshing];
        if ([[returnData objectForKey:@"status"]integerValue] == 1) {
            newsArray = [[returnData objectForKey:@"data"] objectForKey:@"news"];
            bannerPicArray = [[returnData objectForKey:@"data"] objectForKey:@"sliders"];
            if (newsArray && newsArray.count) {
                [hotTableView reloadData];
                [[NSUserDefaults standardUserDefaults]setObject:newsArray forKey:saveMainNewsArrayFile];
                [[NSUserDefaults standardUserDefaults]synchronize];
            }
            if (bannerPicArray && bannerPicArray.count) {
                
                NSMutableArray * tempA = [NSMutableArray arrayWithArray:bannerPicArray];
                [tempA insertObject:[tempA objectAtIndex:tempA.count-1] atIndex:0];
                [tempA insertObject:[tempA objectAtIndex:1] atIndex:tempA.count];
                
                bannerPicArray = [NSMutableArray arrayWithArray:tempA];
                
                [self initLunBoView:bannerPicArray];
                
                [[NSUserDefaults standardUserDefaults]setObject:bannerPicArray forKey:mainViewlunboPicFile];
                [[NSUserDefaults standardUserDefaults]synchronize];
            }
        }else{
            [FrankTools requestFailAlertShow:[returnData objectForKey:@"msg"]];
        }
    } failureBlock:^(NSError *error) {
        FLLog(@"%@",error.localizedDescription);
        [FrankTools wangluoAlertShow];
    } showHUD:NO];
}

#pragma mark - 自动登录
- (void)autoLogin
{
    //检查是否有已登录账户
    double tim = [[NSDate date]timeIntervalSince1970];
    double remTim = [[[NSUserDefaults standardUserDefaults]objectForKey:autoLoginTimeFile]doubleValue];
    if (tim < remTim) {//自动登录没过期，登陆
        //
        NSDictionary * uDic = [[NSUserDefaults standardUserDefaults] objectForKey:saveLoginInfoFile];
        if (uDic && uDic.count > 0) {
            //            [uDic objectForKey:@"phone"]
            //            @"15884478707"
            //            @"13258358090"
            //            NSString * str = [NSString stringWithFormat:@"login?loginId=%@&mark=apple&token=%@&type=%@",[uDic objectForKey:@"phone"],[lhColor shareColor].realToken,[uDic objectForKey:@"type"]];
            //            NSString * str = [NSString stringWithFormat:@"login?loginId=%@&mark=apple&token=%@&type=%@",@"15982160226",[lhColor shareColor].realToken,[uDic objectForKey:@"type"]];
            
            //            NSString * str = [NSString stringWithFormat:@"login.ajax?loginId=%@&mark=apple&token=%@&type=%@",[uDic objectForKey:@"phone"],[lhColor shareColor].realToken,[uDic objectForKey:@"type"]];
            NSDictionary *dic = @{@"loginId":[uDic objectForKey:@"phone"],
                                  @"mark":@"apple",
                                  @"token":[lhColor shareColor].realToken,
                                  @"type":[uDic objectForKey:@"type"]};
            
            [FrankNetworkManager postReqeustWithURL:PATH(@"login") params:dic successBlock:^(id returnData){
                if ([[returnData objectForKey:@"status"]integerValue] == 1) {
                    [self dismissViewControllerAnimated:YES completion:^{
                    }];
                    
                    [lhColor shareColor].userInfo = [NSMutableDictionary dictionaryWithDictionary:[returnData objectForKey:@"data"]];
                    [lhColor shareColor].isBind = [[[returnData objectForKey:@"data"]objectForKey:@"isBind"]integerValue];
                    [lhColor shareColor].isOnLine = YES;
                    //        NSInteger roleId = [[[lhColor shareColor].userInfo objectForKey:@"type"]integerValue];
                    [lhColor shareColor].mapId = [[lhColor shareColor].userInfo objectForKey:@"mapId"];
                    [self updateMainViewByRoleId:USER_NORMAL];
                    
                    //登陆成功后延长自动登陆时间,30天
                    double tim = (double)[[NSDate date]timeIntervalSince1970]+3600*24*30;
                    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithDouble:tim] forKey:autoLoginTimeFile];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                }else{
                    [FrankTools requestFailAlertShow:[returnData objectForKey:@"msg"]];
                }
            } failureBlock:^(NSError *error) {
                FLLog(@"%@",error.localizedDescription);
                [FrankTools wangluoAlertShow];
            } showHUD:NO];
        }
    }else{
        
    }
}

#pragma mark - 更新主界面
- (void)updateMainViewByRoleId:(userStyle)userId
{
    
    if (userId == USER_NORMAL || userId == 0) {
        funArray = @[@{@"name":@"预约模拟",@"image":@"funImage1"},
                     @{@"name":@"理论模拟",@"image":@"funImage2"},
                     @{@"name":@"我要学车",@"image":@"funImage3"},
                     @{@"name":@"我的驾校",@"image":@"funImage_school"},
                     @{@"name":@"扫码",@"image":@"funImage5"},
                     @{@"name":@"驾考圈",@"image":@"funImage4"},
                     @{@"name":@"自学自考",@"image":@"funImage7"},
                     @{@"name":@"计时学车",@"image":@"funImage8"}];
    }
    else if(userId == USER_DRIVER){
        funArray = @[@{@"name":@"考场预约",@"image":@"funImage1"},
                     @{@"name":@"招生管理",@"image":@"funImage11"},
                     @{@"name":@"我的学员",@"image":@"funImage3"},
                     @{@"name":@"预约练车",@"image":@"funImage2"},
                     @{@"name":@"查违章",@"image":@"funImage10"},
                     @{@"name":@"陪练",@"image":@"funImage6"},
                     @{@"name":@"更多···",@"image":@"funImage9"}];
    }
    
    [funCView reloadData];
}

#pragma mark - 定位城市
- (void)locationCity:(LocationCityBlock)cityBlock
{
    [[lhColor shareColor]locationCity:^(NSString *city) {
        //        if (city) {
        //            [lhColor shareColor].nowCityStr = [[lhColor shareColor] city:city];;
        //        }
        //        else{
        //            [lhColor shareColor].nowCityStr = @"";
        //        }
        
        cityBlock(city);
    }];
}

#pragma mark - 初始化，不用刷新控件
- (void)firmLabel
{
    timeDistance = 4;
    funArray = @[];
    
    cityLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, 28, 30)];
    cityLabel.textAlignment = NSTextAlignmentCenter;
    cityLabel.textColor = [UIColor whiteColor];
    cityLabel.text = @"成都";
    cityLabel.font = [UIFont fontWithName:fontName size:14];
    [self.view addSubview:cityLabel];
    
    [cityLabel sizeToFit];
    CGRect rRec = cityLabel.frame;
    rRec.size.width += 10;
    rRec.size.height = 30;
    cityLabel.frame = rRec;
    
    stationImgView = [[UIImageView alloc]initWithFrame:CGRectMake(cityLabel.frame.origin.x+CGRectGetWidth(cityLabel.frame), 41, 14, 7)];
    stationImgView.image = imageWithName(@"newluzhou1.png");
    [self.view addSubview:stationImgView];
    
    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 20, 120, 44);
    [leftBtn addTarget:self action:@selector(leftBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftBtn];
    
    NSString * localCity = [[NSUserDefaults standardUserDefaults]objectForKey:saveLocalCityName];
    
    if (localCity && localCity.length > 0) {
        [lhColor shareColor].nowCityStr = localCity;
    }
    __weak typeof(self) ws = self;
    [self locationCity:^(NSString *city) {
        if (![[[lhColor shareColor] city:city] isEqualToString:[lhColor shareColor].nowCityStr]) {
            if (localCity && localCity.length > 0) {
                NSString * s = [NSString stringWithFormat:@"定位到您当前城市为<%@>,是否切换？",[[lhColor shareColor] city:city]];
                UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:[[lhColor shareColor] city:city] message:s delegate:ws cancelButtonTitle:@"取消" otherButtonTitles:@"切换", nil];
                alertView.tag = 7;
                [alertView show];
            }
            else{
                [lhColor shareColor].nowCityStr = [[lhColor shareColor] city:city];
                [ws leftCity];
            }
        }
    }];
    
    
    CGFloat heih = 0;
    bannerScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 120*widthRate)];
    bannerScrollView.scrollEnabled = NO;
    bannerScrollView.contentOffset = CGPointMake(DeviceMaxWidth, 0);
    bannerScrollView.pagingEnabled = YES;
    bannerScrollView.showsHorizontalScrollIndicator = NO;
    [maxScrollView addSubview:bannerScrollView];
    
    bannerPC = [[UIPageControl alloc]init];
    bannerPC.currentPageIndicatorTintColor = [lhColor colorFromHexRGB:mainColorStr];
    bannerPC.pageIndicatorTintColor = [UIColor whiteColor];
    [maxScrollView addSubview:bannerPC];
    
    UISwipeGestureRecognizer * swipLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swip:)];
    UISwipeGestureRecognizer * swip = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swip:)];
    swip.direction = UISwipeGestureRecognizerDirectionLeft;
    UIButton * topUrlButton = [UIButton buttonWithType:UIButtonTypeCustom];
    topUrlButton.frame = bannerScrollView.frame;
    [topUrlButton addTarget:self action:@selector(topUrlButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    [topUrlButton addGestureRecognizer:swipLeft];
    [topUrlButton addGestureRecognizer:swip];
    [maxScrollView addSubview:topUrlButton];
    
    heih += bannerScrollView.frame.size.height;
    //模块功能
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    funCView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, heih, DeviceMaxWidth, 196*widthRate) collectionViewLayout:flowLayout];
    funCView.backgroundColor = [UIColor whiteColor];
    funCView.delegate = self;
    funCView.dataSource = self;
    [maxScrollView addSubview:funCView];
    
    [funCView registerClass:[lhFunctionCollectionViewCell class] forCellWithReuseIdentifier:@"funCell"];
    
    heih += funCView.frame.size.height+9*widthRate;
    //热门
    hotTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, heih+20, DeviceMaxWidth, 220*widthRate) style:UITableViewStylePlain];
    hotTableView.scrollEnabled = NO;
    hotTableView.delegate = self;
    hotTableView.dataSource = self;
    hotTableView.separatorColor = [UIColor clearColor];
    hotTableView.backgroundColor = [UIColor clearColor];
    [maxScrollView addSubview:hotTableView];
    
    UIView * w = [[UIView alloc]initWithFrame:CGRectMake(0, heih, DeviceMaxWidth, 20*widthRate)];
    w.backgroundColor = [UIColor whiteColor];
    [maxScrollView addSubview:w];
    
    UIImageView * hotIcon = [[UIImageView alloc]initWithFrame:CGRectMake(0, heih, 73*widthRate, 20*widthRate)];
    hotIcon.image = imageWithName(@"hotIcon");
    [maxScrollView addSubview:hotIcon];
    
    UILabel *hotCity = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, heih, 63*widthRate, 20*widthRate)];
    hotCity.text = @"优品精选";
    hotCity.font = [UIFont systemFontOfSize:13];
    hotCity.textColor = [UIColor whiteColor];
    //    hotCity.textAlignment = NSTextAlignmentCenter;
    [maxScrollView addSubview:hotCity];
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(73*widthRate-1, heih, DeviceMaxWidth-73*widthRate+1, 0.5)];
    lineView.backgroundColor = [lhColor colorFromHexRGB:mainColorStr];
    [maxScrollView addSubview:lineView];
    
    heih += hotTableView.frame.size.height+20*widthRate+10;
    
    if (heih > maxScrollView.frame.size.height+5) {
        maxScrollView.contentSize = CGSizeMake(DeviceMaxWidth, heih);
    }
    
    [self updateMainViewByRoleId:USER_NORMAL];
}

- (void)leftCity
{
    cityLabel.text = [lhColor shareColor].nowCityStr;
    
    [cityLabel sizeToFit];
    CGRect rRec = cityLabel.frame;
    
    if (rRec.size.width+10 > 120*widthRate) {
        rRec.size.width = 120*widthRate;
    }
    else{
        rRec.size.width += 10;
    }
    
    rRec.size.height = 30;
    cityLabel.frame = rRec;
    
    stationImgView.frame = CGRectMake(cityLabel.frame.origin.x+CGRectGetWidth(cityLabel.frame), 41, 14, 7);
}

#pragma mark - 点击定位
- (void)leftBtnEvent
{
    lhSelectCityViewController * scVC = [[lhSelectCityViewController alloc]init];
    [self.navigationController pushViewController:scVC animated:YES];
    NSLog(@"点击定位");
}

#pragma mark - UITabelViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![newsArray count]) {
        FrankWebView *myWebView = [[FrankWebView alloc] init];
        myWebView.nameStr = @"优品精选";
        [self.navigationController pushViewController:myWebView animated:YES];
        return;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@",[[newsArray objectAtIndex:indexPath.row] objectForKey:@"target"]];
    
    if (![@"" isEqualToString:urlString] && ![urlString rangeOfString:@"null"].length) {
        FrankWebView *myWebView = [[FrankWebView alloc] init];
        myWebView.myWebUrl = urlString;
        myWebView.nameStr = @"优品精选";
        [self.navigationController pushViewController:myWebView animated:YES];
    }
    
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110*widthRate;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    CGRect htRect = hotTableView.frame;
    htRect.size.height = 110*widthRate*newsArray.count;
    hotTableView.frame = htRect;
    
    CGFloat heih = htRect.origin.y+htRect.size.height+20*widthRate;
    if (heih > maxScrollView.frame.size.height+5) {
        maxScrollView.contentSize = CGSizeMake(DeviceMaxWidth, heih);
    }
    else{
        maxScrollView.contentSize = CGSizeMake(DeviceMaxWidth, maxScrollView.frame.size.height+5);
    }
    
    return newsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * difier = @"hotCell";
    lhHotTableViewCell * hotCell = [tableView dequeueReusableCellWithIdentifier:difier];
    if (hotCell == nil) {
        hotCell = [[lhHotTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:difier];
    }
    hotCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary * newsDic = [newsArray objectAtIndex:indexPath.row];
    hotCell.titleLabel.text = [NSString stringWithFormat:@"%@",[newsDic objectForKey:@"title"]];
    hotCell.jELable.text = [NSString stringWithFormat:@"%@",[newsDic objectForKey:@"content"]];
    
    NSString * dateStr = [NSString stringWithFormat:@"%@",[newsDic objectForKey:@"time"]];
    //    NSDateFormatter * df = [[NSDateFormatter alloc]init];
    //    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //    NSTimeInterval timeS = [[df dateFromString:dateStr]timeIntervalSince1970]*1000;
    hotCell.timeLabel.text = [lhColor distanceTimeWithBeforeTime:[dateStr doubleValue]];
    hotCell.nameLabel.text = [NSString stringWithFormat:@"%@",[newsDic objectForKey:@"name"]];
    
    NSString * nStr = [NSString stringWithFormat:@"%@",[newsDic objectForKey:@"img"]];
    NSString * allStr = [NSString stringWithFormat:@"%@%@",[lhColor shareColor].fileWebUrl,nStr];
    NSLog(@"%@",allStr);
    [lhColor checkImageWithNameCut:nStr withUrlStr:allStr withImgView:hotCell.headImageV withPlaceHolder:imageWithName(@"pic_loaderror") withSize:CGSizeMake(110*widthRate*2, 94*widthRate*2)];
    
    return hotCell;
    
}

#pragma mark - 功能模块
#pragma mark - UICollectionViewDateSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return funArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * indentifier = @"funCell";
    
    lhFunctionCollectionViewCell * funCell = [collectionView dequeueReusableCellWithReuseIdentifier:indentifier forIndexPath:indexPath];
    
    NSString * imgStr = [NSString stringWithFormat:@"%@",[[funArray objectAtIndex:indexPath.row] objectForKey:@"image"]];
    funCell.titleImgView.image = imageWithName(imgStr);
    
    NSString * Str = [NSString stringWithFormat:@"%@",[[funArray objectAtIndex:indexPath.row] objectForKey:@"name"]];
    funCell.titleLabel.text = Str;
    
    return funCell;
}


#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(73*widthRate, 71*widthRate);
}
//定义每个UICollectionView 的 margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(20*widthRate, 14*widthRate, 1, 14*widthRate);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 14*widthRate;
}

#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    lhFunctionCollectionViewCell * cell = (lhFunctionCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    if ([@"预约模拟" isEqualToString:cell.titleLabel.text]) {
        
        if ([lhColor loginIsOrNo]) {
            //            UIAlertView * slectAlertView = [[UIAlertView alloc]initWithTitle:@"请选择车辆" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"模拟考试车",@"模拟教练车", nil];
            //            slectAlertView.tag = 4;
            //            [slectAlertView show];
            lhAppointSimuViewController * asVC = [[lhAppointSimuViewController alloc]init];
            asVC.appointType = 5;
            [self.navigationController pushViewController:asVC animated:YES];
        }
    }
    else if([@"理论模拟" isEqualToString:cell.titleLabel.text]){
        if ([lhColor loginIsOrNo]) {
            FrankMainViewController * fmVC = [[FrankMainViewController alloc]init];
            [self.navigationController pushViewController:fmVC animated:YES];
        }
    }
    else if([@"我要学车" isEqualToString:cell.titleLabel.text]){
        if([lhColor loginIsOrNo]){
            lhWantStudyViewController * wsVC = [[lhWantStudyViewController alloc]init];
            [self.navigationController pushViewController:wsVC animated:YES];
        }
    }
    else if([@"驾考圈" isEqualToString:cell.titleLabel.text]){
        //        [self willOpen];
        if([lhColor loginIsOrNo]){
            lhDriTestCirViewController * fmVC = [[lhDriTestCirViewController alloc]init];
            [self.navigationController pushViewController:fmVC animated:YES];
        }
    }
    else if([@"扫码" isEqualToString:cell.titleLabel.text]){
        //        [self willOpen];
        if ([lhColor loginIsOrNo]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"扫码说明" message:@"请扫描科目考试完成后的条形码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            alertView.tag = 10;
            [alertView show];
        }
    }
    else if([@"我的驾校" isEqualToString:cell.titleLabel.text]){
        
        if ([lhColor loginIsOrNo]) {
            
            if (![lhColor shareColor].isBind) {
                UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您尚未绑定身份信息，现在去绑定？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alertView.tag = 5;
                [alertView show];
            }
            else{
                lhMyDrSchoolViewController * fmVC = [[lhMyDrSchoolViewController alloc]init];
                [self.navigationController pushViewController:fmVC animated:YES];
            }
        }
    }
    else if([@"自学自考" isEqualToString:cell.titleLabel.text]){
        //        [self willOpen];
        if ([lhColor loginIsOrNo]) {
            //            FrankStudyBySelfView *studyView = [[FrankStudyBySelfView alloc] init];
            //            [self.navigationController pushViewController:studyView animated:YES];
            FrankWebView *myWebView = [[FrankWebView alloc] init];
            myWebView.myWebUrl = @"http://cq.122.gov.cn";
            myWebView.nameStr = @"自学自考";
            [self.navigationController pushViewController:myWebView animated:YES];
        }
    }
    else if ([@"计时学车" isEqualToString:cell.titleLabel.text]){
        //        FrankLoginView *lg = [[FrankLoginView alloc] init];
        //        [self.navigationController pushViewController:lg animated:YES];
        [self willOpen];
    }
}

//返回这个UICollectionView是否可以被选择
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - 功能即将开放提示
- (void)willOpen
{
    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该功能即将开放，敬请期待~" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 5) {
        if (buttonIndex == 0) {//取消
            //            lhAppointSimuViewController * asVC = [[lhAppointSimuViewController alloc]init];
            //            asVC.appointType = 6;
            //            [self.navigationController pushViewController:asVC animated:YES];
        }
        else if(buttonIndex == 1){//去绑定
            lhBildIDCardViewController * bcVC = [[lhBildIDCardViewController alloc]init];
            [self.navigationController pushViewController:bcVC animated:YES];
        }
    }
    else if(alertView.tag == 4){//选择模拟车
        if (buttonIndex == 1) {
            NSLog(@"模拟考试车");
            lhAppointSimuViewController * asVC = [[lhAppointSimuViewController alloc]init];
            asVC.appointType = 5;
            [self.navigationController pushViewController:asVC animated:YES];
        }
        else if(buttonIndex == 2){
            NSLog(@"模拟教练车");
            if (![lhColor shareColor].isBind) {
                UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您尚未绑定身份信息，现在去绑定？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alertView.tag = 5;
                [alertView show];
            }
            else{
                lhAppointSimuViewController * asVC = [[lhAppointSimuViewController alloc]init];
                asVC.appointType = 6;
                [self.navigationController pushViewController:asVC animated:YES];
            }
            
        }
    }
    else if (alertView.tag == 10){ //扫码说明
        [self moreBtnEvent];
    }
    else if(alertView.tag == 7){//定位城市发生改变
        if (buttonIndex == 1) {
            [lhColor shareColor].nowCityStr = alertView.title;
            
            [[NSUserDefaults standardUserDefaults] setObject:[lhColor shareColor].nowCityStr forKey:saveLocalCityName];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            [self leftCity];
        }
    }
    if (alertView.tag == 3) {
        if (buttonIndex == 1) {
            NSString * str = [[lhColor shareColor].versionDic objectForKey:@"downloadUrl"];
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:str]];
        }else{
            [lhColor shareColor].isEnableCheck = NO;
        }
        
    }
}

#pragma mark - 轮播相关
//My UIScrollViewDelegate
- (void)scrollViewDidScrollToRight:(UIScrollView *)scrollView
{
    if (scrollView == bannerScrollView) {
        counTime = 0;
        
        UIScrollView * tempS = (UIScrollView *)scrollView;
        
        [UIView animateWithDuration:0.5 animations:^{
            tempS.contentOffset = CGPointMake(tempS.contentOffset.x+DeviceMaxWidth, 0);
            
        }completion:^(BOOL finished) {
            
            if (tempS.contentOffset.x > (bannerPicArray.count-2)*DeviceMaxWidth) {
                tempS.contentOffset = CGPointMake(DeviceMaxWidth, 0);
            }
            
            bannerPC.currentPage = bannerScrollView.contentOffset.x/DeviceMaxWidth-1;
        }];
    }
    
}

- (void)scrollViewDidScrollToLeft:(UIScrollView *)scrollView
{
    
    counTime = 0;
    
    UIScrollView * tempS = scrollView;
    
    
    [UIView animateWithDuration:0.5 animations:^{
        tempS.contentOffset = CGPointMake(tempS.contentOffset.x-DeviceMaxWidth, 0);
        
    }completion:^(BOOL finished) {
        if (tempS.contentOffset.x < DeviceMaxWidth) {
            tempS.contentOffset = CGPointMake(DeviceMaxWidth*(bannerPicArray.count-2), 0);
        }
        
        bannerPC.currentPage = bannerScrollView.contentOffset.x/DeviceMaxWidth-1;
    }];
    
    
}

#pragma mark - 初始化轮播，本地图片
//初始化轮播
- (void)initLunBoViewO:(NSArray *)foodArrayNew
{
    if (bannerScrollView) {
        for (UIView * view in bannerScrollView.subviews) {
            [view removeFromSuperview];
        }
    }
    
    for (int i = 0; i < foodArrayNew.count; i++) {
        UIImageView * foodimg = [[UIImageView alloc]initWithFrame:CGRectMake(i*DeviceMaxWidth, 0, DeviceMaxWidth, bannerScrollView.frame.size.height)];
        foodimg.userInteractionEnabled = YES;
        foodimg.tag = i;
        foodimg.image = [foodArrayNew objectAtIndex:i];
        [bannerScrollView addSubview:foodimg];
        
    }
    bannerPC.numberOfPages = foodArrayNew.count-2;
    bannerPC.center = CGPointMake(DeviceMaxWidth/2, bannerScrollView.frame.size.height-10);
    
    bannerScrollView.contentOffset = CGPointMake(DeviceMaxWidth, 0);
    
}

//-(void)clickImageView:(id)sender
//{
//    NSLog(@"点击图片 = %@",sender);
//}

//初始化轮播
- (void)initLunBoView:(NSArray *)foodArrayNew
{
    if (bannerScrollView) {
        for (UIView * view in bannerScrollView.subviews) {
            [view removeFromSuperview];
        }
    }
    
    for (int i = 0; i < foodArrayNew.count; i++) {
        UIImageView * foodimg = [[UIImageView alloc]initWithFrame:CGRectMake(i*DeviceMaxWidth, 0, DeviceMaxWidth, bannerScrollView.frame.size.height)];
        foodimg.backgroundColor = [UIColor grayColor];
        foodimg.userInteractionEnabled = YES;
        foodimg.tag = i;
        NSString * hStr = [[foodArrayNew objectAtIndex:i] objectForKey:@"img"];
        if (![hStr isEqualToString:@""]) {
            NSString * str = [NSString stringWithFormat:@"%@%@",[lhColor shareColor].fileWebUrl,hStr];
            
            [lhColor checkImageWithName:hStr withUrlStr:str withImgView:foodimg withPlaceHolder:imageWithName(@"lunboPic0.jpg")];
        }
        
        [bannerScrollView addSubview:foodimg];
    }
    
    bannerPC.numberOfPages = foodArrayNew.count-2;
    bannerPC.center = CGPointMake(DeviceMaxWidth/2, bannerScrollView.frame.size.height-10);
    bannerScrollView.contentOffset = CGPointMake(DeviceMaxWidth, 0);
    
}

- (void)swip:(UISwipeGestureRecognizer *)gesture_
{
    
    if (gesture_.direction == UISwipeGestureRecognizerDirectionRight) {
        
        [self scrollViewDidScrollToLeft:bannerScrollView];
        
    }
    else if(gesture_.direction == UISwipeGestureRecognizerDirectionLeft){
        
        [self scrollViewDidScrollToRight:bannerScrollView];
        
    }
}

//跳转链接
- (void)topUrlButtonEvent
{
    
    NSInteger index = (NSInteger)(bannerScrollView.contentOffset.x/DeviceMaxWidth);
    if (index >= bannerPicArray.count) {
        return;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@",[[bannerPicArray objectAtIndex:index] objectForKey:@"target"]];
    
    if (urlString && ![@"" isEqualToString:urlString] && ![urlString rangeOfString:@"null"].length) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlString]];
    }
    
    
    //    FrankWebView *myWebView = [[FrankWebView alloc] init];
    //    myWebView.myWebUrl = urlString;
    //    myWebView.nameStr = @"驾校动态";
    //    [self.navigationController pushViewController:myWebView animated:YES];
    /*
     if ([[bannerPicArray objectAtIndex:index]class] == [UIImage class]) {
     return;
     }
     
     NSString * urlStr = [[bannerPicArray objectAtIndex:index] objectForKey:@"url"];
     if (!urlStr || urlStr == nil || [urlStr class] == [[NSNull alloc]class] || [urlStr isEqualToString:@"<null>"] || [urlStr isEqualToString:@""]) {
     
     }
     else{
     [lhColor shareColor].noShowKaiChang = YES;
     [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlStr]];
     
     }
     */
}


- (void)moveTimerEvent
{
    counTime++;
    
    if (counTime == timeDistance) {
        counTime = 0;
        
        [UIView animateWithDuration:0.5 animations:^{
            bannerScrollView.contentOffset = CGPointMake(bannerScrollView.contentOffset.x+DeviceMaxWidth, 0);
        }completion:^(BOOL finished) {
            if (bannerScrollView.contentOffset.x > (bannerPicArray.count-2)*DeviceMaxWidth) {
                bannerScrollView.contentOffset = CGPointMake(DeviceMaxWidth, 0);
                
            }
            
            bannerPC.currentPage = bannerScrollView.contentOffset.x/DeviceMaxWidth-1;
        }];
    }
    
}

#pragma mark - 个人
//按钮点击
- (void)llBtnEvent
{
    NSLog(@"点击查看个人");
    if ([lhColor loginIsOrNo]) {
        lhPersonalViewController * pVC = [[lhPersonalViewController alloc]init];
        pVC.type = [[[lhColor shareColor].userInfo objectForKey:@"type"]integerValue];
        [self.navigationController pushViewController:pVC animated:YES];
    }
    
}

- (void)createData:(NSNotification *)noti
{
    NSLog(@"结果 %@",noti.userInfo);
    [lhColor disAppearActivitiView:self.view];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:noti.name object:nil];
}

#pragma mark - 更多
- (void)moreBtnEvent
{
    NSLog(@"更多");
    lhScanQRViewController * sqVC = [[lhScanQRViewController alloc]init];
    [self.navigationController pushViewController:sqVC animated:YES];
}

- (void)uploadPhotoEvent:(NSNotification *)noti
{
    NSLog(@"上传图片结果 %@",noti.userInfo);
    [lhColor disAppearActivitiView:self.view];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:noti.name object:nil];
    if (!noti.userInfo || [noti.userInfo class] == [[NSNull alloc]class]) {
        
        [lhColor wangluoAlertShow];
        
    }
    if ([[noti.userInfo objectForKey:@"status"]integerValue] == 1) {
        
        
    }
}

#pragma mark - view
- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"ado = %f",[UIApplication sharedApplication].statusBarFrame.size.height);
    
    [super viewWillAppear:animated];
    [lhColor assignmentForTempVC:self];
    
    [self leftCity];
    
    if(moveTimer){
        [moveTimer invalidate];
        moveTimer = nil;
    }
    
    moveTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(moveTimerEvent) userInfo:nil repeats:YES];
    //    [[NSRunLoop currentRunLoop]addTimer:moveTimer forMode:NSRunLoopCommonModes];
    [self checkVersionInfo];  //检测版本更新
}

#pragma mark - 检测版本更新
-(void)checkVersionInfo
{
    if(![lhColor shareColor].isOnLine){
        return;
    }
    
    NSString * phoneStr = [NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults]objectForKey:saveLoginInfoFile] objectForKey:@"phone"]];
    if ([lhColor shareColor].isEnableCheck && ![@"13258358090" isEqualToString:phoneStr] && ![@"15884478707" isEqualToString:phoneStr]) {
        
        [lhColor shareColor].isEnableCheck = NO;
        NSDictionary * infoDict = [[NSBundle mainBundle]infoDictionary];
        NSMutableString * nowVersion = [NSMutableString stringWithFormat:@"%@",[infoDict objectForKey:@"CFBundleShortVersionString"]];
        NSString * nowVersionS = [nowVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
        NSMutableString * foStr = [NSMutableString stringWithFormat:@"%@",[[lhColor shareColor].versionDic objectForKey:@"version"]];
        NSString * foreVersion = [foStr stringByReplacingOccurrencesOfString:@"." withString:@""];
        NSLog(@"nowNumber = %ld , forNumber = %ld",[nowVersionS integerValue],[foreVersion integerValue]);
        if ([nowVersionS integerValue] < [foreVersion integerValue]) {
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"优品学车新版本 %@",[[lhColor shareColor].versionDic objectForKey:@"version"]] message:@"" delegate:self cancelButtonTitle:@"稍后再说" otherButtonTitles:@"立即更新", nil];
            alertView.tag = 3;
            [alertView show];
            
        }
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    if ([lhColor shareColor].type == 1) {
        FrankNewsNotice *notice = [[FrankNewsNotice alloc] init];
        [self.navigationController pushViewController:notice animated:YES];
    }
}

- (void)viewWillDisAppear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if(moveTimer){
        [moveTimer invalidate];
        moveTimer = nil;
    }
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

//
//  lhDriTestCirViewController.m
//  Drive
//
//  Created by bosheng on 15/7/30.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import "lhDriTestCirViewController.h"
#import "lhWriteViewController.h"
#import "MJRefresh.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "UIImage+Cut.h"
#import "FrankJiaKaoQuanCell.h"
#import "FrankTopicsView.h"
#import "FrankWriteTopic.h"

@interface lhDriTestCirViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate>
{
    UIPageControl * topPageControl;
    
    UITableView * conTableView;
    NSInteger pNo;                  //消息当前页数
    NSInteger allPno;               //消息总页数
    NSMutableArray *dataArray;      //消息数据
    NSString *reportId;             //举报的id
    NSArray *categoryArry;          //请求的分组
}

@end

@implementation lhDriTestCirViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[lhColor shareColor]originalInit:self title:@"驾考圈" imageName:nil backButton:YES];
    dataArray = [NSMutableArray array];
    pNo = 1;
    allPno = 1;
    reportId = @"";
    imageArray = [[NSMutableArray alloc] init];
    [self requestData];
}

-(void)requestData
{
     NSDictionary * dic = @{@"pageSize":@"10",
                           @"pageNo":[NSString stringWithFormat:@"%ld",(long)pNo],
                           @"id":[[lhColor shareColor].userInfo objectForKey:@"id"]};
    NSLog(@"dic = %@",dic);
    
    [FrankNetworkManager postReqeustWithURL:PATH(@"bbs/index") params:dic successBlock:^(id returnData){
        if (pNo == 1) {
            [conTableView headerEndRefreshing];
        }
        else{
            [conTableView footerEndRefreshing];
        }
        if ([[returnData objectForKey:@"status"]integerValue] == 1) {
            if (pNo == 1) {
                allPno = [[[returnData objectForKey:@"data"] objectForKey:@"totalPages"] integerValue];
                dataArray = [[returnData objectForKey:@"data"] objectForKey:@"data"];
                categoryArry = [[returnData objectForKey:@"data"] objectForKey:@"categories"];
                NSLog(@"categoryArry = %@",categoryArry);
                [self firmInit];
            }
            else{
                NSArray * tempA = [[returnData objectForKey:@"data"] objectForKey:@"data"];
                if (tempA && tempA.count > 0) {
                    NSMutableArray * tArray = [NSMutableArray arrayWithArray:dataArray];
                    [tArray addObjectsFromArray:tempA];
                    dataArray = tArray;
                    [conTableView reloadData];
                }
            }
        }else{
            [FrankTools requestFailAlertShow:[returnData objectForKey:@"msg"]];
        }
        if (dataArray && dataArray.count > 0) {
            [lhColor removeNullLabelWithSuperView:conTableView];
        }
        else{
            [lhColor addANullLabelWithSuperView:conTableView withFrame:CGRectMake(0, 100*widthRate, DeviceMaxWidth, 100*widthRate) withText:@"暂无话题信息~"];
        }
    } failureBlock:^(NSError *error) {
        FLLog(@"%@",error.localizedDescription);
        [FrankTools wangluoAlertShow];
    } showHUD:NO];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)firmInit
{
    UIImageView *writeImage = [[UIImageView alloc] initWithFrame:CGRectMake(290*widthRate, 31, 20, 20)];
    [writeImage setImage:imageWithName(@"release_D")];
    [self.view addSubview:writeImage];
    
    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(250*widthRate, 20, 70*widthRate, 44);
    [rightBtn addTarget:self action:@selector(rightBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightBtn];
    
    UIScrollView * whiteView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, DeviceMaxWidth, DeviceMaxHeight-64)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteView];
    
    UIScrollView * topFunScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 160*widthRate)];
    topFunScrollView.delegate = self;
    topFunScrollView.pagingEnabled = YES;
    topFunScrollView.showsHorizontalScrollIndicator = NO;
    [whiteView addSubview:topFunScrollView];
    topFunScrollView.contentSize = CGSizeMake(DeviceMaxWidth*2, 0);
    
    topPageControl = [[UIPageControl alloc]init];
    topPageControl.center = CGPointMake(DeviceMaxWidth/2, 85*widthRate);
    topPageControl.numberOfPages = 2;
    topPageControl.currentPage = 0;
    topPageControl.currentPageIndicatorTintColor = [lhColor colorFromHexRGB:mainColorStr];
    topPageControl.pageIndicatorTintColor = [UIColor grayColor];
    [whiteView addSubview:topPageControl];
    
//    topicArray = @[@"学车趣事",@"一起吐槽",@"买车指导",@"考前许愿",@"晒驾校",@"晒成绩",@"晒教练",@"晒驾照"];
//    
//    topicImage = @[@"practiceInterest",@"tucao",@"buyCar",@"wishImage",@"sunSchool",@"sunGrade",@"sunCoach",@"sunDriving"];
    for (int i = 0; i < categoryArry.count; i++) {
        UIImageView *pImage = [[UIImageView alloc] initWithFrame:CGRectMake(20*widthRate+80*widthRate*i, 10*widthRate, 40*widthRate, 40*widthRate)];
//        pImage.layer.cornerRadius = 20*widthRate;
//        pImage.backgroundColor = [lhColor colorFromHexRGB:mainColorStr];
//        [pImage setImage:imageWithName(topicImage[i])];
        [lhColor checkImageWithName:[NSString stringWithFormat:@"%@",[categoryArry[i] objectForKey:@"icon"]] withUrlStr:[NSString stringWithFormat:@"%@%@",[lhColor shareColor].fileWebUrl,[categoryArry[i] objectForKey:@"icon"]] withImgView:pImage];
        [topFunScrollView addSubview:pImage];
        
        UILabel *pLable = [[UILabel alloc] initWithFrame:CGRectMake(80*widthRate*i, 55*widthRate, 80*widthRate, 20*widthRate)];
        pLable.text = [categoryArry[i] objectForKey:@"name"];
        pLable.font = [UIFont systemFontOfSize:15];
        pLable.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
        pLable.textAlignment = NSTextAlignmentCenter;
        [topFunScrollView addSubview:pLable];
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        btn.frame = CGRectMake(80*widthRate*i, 0, 80*widthRate, 80*widthRate);
        [btn addTarget:self action:@selector(funBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
        [topFunScrollView addSubview:btn];
    }
    
    UILabel * tLabel = [[UILabel alloc]initWithFrame:CGRectMake(20*widthRate, 90*widthRate, 100*widthRate, 20*widthRate)];
    tLabel.text = @"精选话题";
    tLabel.font = [UIFont fontWithName:fontName size:13];
    tLabel.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
    [whiteView addSubview:tLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10*widthRate, 110*widthRate, DeviceMaxWidth-20*widthRate, 0.5)];
    lineView.backgroundColor = [lhColor colorFromHexRGB:viewColorStr];
    [whiteView addSubview:lineView];
    
    conTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 111*widthRate, DeviceMaxWidth, CGRectGetHeight(whiteView.frame)-111*widthRate) style:UITableViewStylePlain];
    conTableView.showsVerticalScrollIndicator = NO;
    conTableView.delegate = self;
    conTableView.dataSource = self;
    conTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [whiteView addSubview:conTableView];
    
    [conTableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    [conTableView addFooterWithTarget:self action:@selector(footerRefresh)];
}

//下拉刷新
- (void)headerRefresh
{
    pNo = 1;
    [self requestData];
}

//上拉加载
- (void)footerRefresh
{
    if (pNo >= allPno) {
        [lhColor showAlertWithMessage:@"没有更多数据了~" withSuperView:self.view withHeih:DeviceMaxHeight-80];
        [conTableView footerEndRefreshing];
        return;
    }
    
    pNo++;
    [self requestData];
}
/*
#pragma mark - 下拉刷新
- (void)headerRefresh
{
    [conTableView headerEndRefreshing];
}

#pragma mark - 上拉加载
- (void)footerRefresh
{
    [conTableView footerEndRefreshing];
}
*/
#pragma mark - UITabelViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    lhWriteViewController *wriDetail = [[lhWriteViewController alloc] init];
    wriDetail.topicDic = [dataArray objectAtIndex:indexPath.row];
    wriDetail.commentMark = 0;
    [self.navigationController pushViewController:wriDetail animated:YES];
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat hight = 72*widthRate;
    NSDictionary * oned = [dataArray objectAtIndex:indexPath.row];
    NSString * str = [NSString stringWithFormat:@"%@",[oned objectForKey:@"content"]];
//    CGSize size1 = [self sizeWithString:str font:[UIFont systemFontOfSize:15]];
//    hight += size1.height;
    UILabel * labe = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, hight, DeviceMaxWidth-20*widthRate, 100)];
    labe.numberOfLines = 0;
    labe.font = [UIFont systemFontOfSize:15];
    labe.text = str;
    [labe sizeToFit];
    hight += labe.frame.size.height;
    hight += 35*widthRate;
    
    NSString *pictureStr = [NSString stringWithFormat:@"%@",[oned objectForKey:@"picture"]];
    if (pictureStr == nil || [pictureStr isEqualToString:@""]) {
    }else{
        hight += 110*widthRate;
    }
    return hight;
//    return 120*widthRate;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}

/*
 //cell的3D动画效果
 cell.layer.transform = CATransform3DMakeScale(1.2, 1.2, 1);
 //设置动画时间为0.25秒,xy方向缩放的最终值为1
 [UIView animateWithDuration:0.7 animations:^{
 cell.layer.transform = CATransform3DMakeScale(1, 1, 1);
 }];
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * indentifier = @"conCell";
    FrankJiaKaoQuanCell * cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[FrankJiaKaoQuanCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dataDic = [dataArray objectAtIndex:indexPath.row];
    
    [cell.zanBtn addTarget:self action:@selector(clickZanEvent:) forControlEvents:UIControlEventTouchUpInside];
    [cell.commentBtn addTarget:self action:@selector(clickCommentEvent:) forControlEvents:UIControlEventTouchUpInside];
    [cell.reportBtn addTarget:self action:@selector(clickReportEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    //设置头像
    NSString *imageStr = [dataDic objectForKey:@"avatar"];
    if (![imageStr isEqualToString:@""]) {
        [lhColor checkImageWithName:imageStr withUrlStr:[NSString stringWithFormat:@"%@%@",[lhColor shareColor].fileWebUrl,imageStr] withImgView:cell.titleImage];
    }
    cell.nameLable.text = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"name"]];
    
    cell.contentLable.text = [dataDic objectForKey:@"content"];
    CGSize size1 = [self sizeWithString:[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"content"]] font:[UIFont systemFontOfSize:15]];
    cell.contentLable.numberOfLines = 0;
    [cell.contentLable sizeToFit];
    cell.contentLable.frame = CGRectMake(10*widthRate, 65*widthRate, DeviceMaxWidth-20*widthRate, size1.height);
    
    //设置图片
    NSString *pictureStr = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"picture"]];
    NSArray *imageAy = @[cell.uploadImage1,cell.uploadImage2,cell.uploadImage3];
    NSArray *pictureArray = nil;
    
    if (pictureStr == nil || [pictureStr isEqualToString:@""]) {
    }else{
        pictureArray = [pictureStr componentsSeparatedByString:@"|"];
    }
    if (pictureArray.count>3) {
        for (int i=0; i<3; i++) {
            UIImageView *imageV = (UIImageView *)imageAy[i];
            imageV.hidden = NO;
            imageV.tag = i;
            imageV.frame = CGRectMake(10*widthRate+(290*widthRate/3+5*widthRate)*i, 65*widthRate+size1.height+10*widthRate, 290*widthRate/3, 100*widthRate);
            [lhColor checkImageWithNameCut:[NSString stringWithFormat:@"%@",pictureArray[i]] withUrlStr:[NSString stringWithFormat:@"%@%@",[lhColor shareColor].fileWebUrl,pictureArray[i]] withImgView:imageV withPlaceHolder:imageWithName(@"") withSize:CGSizeMake(290*widthRate/3*2, 100*widthRate*2)];
            
            UITapGestureRecognizer *imageGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImageViewEvent:)];
            [imageV addGestureRecognizer:imageGesture];
        }
        cell.pictureCount.hidden = NO;
        cell.pictureCount.text = [NSString stringWithFormat:@"%lu张",(unsigned long)pictureArray.count];
        
        cell.footView.frame = CGRectMake(10*widthRate, 65*widthRate+size1.height+120*widthRate, DeviceMaxWidth-20*widthRate, 35*widthRate);
    }else if (pictureArray.count>0) {
        for (int i=0; i<imageAy.count; i++) {
            UIImageView *imageV = (UIImageView *)imageAy[i];
            imageV.hidden = YES;
        }
        for (int i=0; i<pictureArray.count; i++) {
            UIImageView *imageV = (UIImageView *)imageAy[i];
            imageV.hidden = NO;
            imageV.tag = i;
            imageV.frame = CGRectMake(10*widthRate+(290*widthRate/3+5*widthRate)*i, 65*widthRate+size1.height+10*widthRate, 290*widthRate/3, 100*widthRate);
            [lhColor checkImageWithNameCut:[NSString stringWithFormat:@"%@",pictureArray[i]] withUrlStr:[NSString stringWithFormat:@"%@%@",[lhColor shareColor].fileWebUrl,pictureArray[i]] withImgView:imageV withPlaceHolder:imageWithName(@"") withSize:CGSizeMake(290*widthRate/3*2, 100*widthRate*2)];
            
            UITapGestureRecognizer *imageGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImageViewEvent:)];
            [imageV addGestureRecognizer:imageGesture];
        }
        
        cell.pictureCount.hidden = YES;
        cell.footView.frame = CGRectMake(10*widthRate, 65*widthRate+size1.height+120*widthRate, DeviceMaxWidth-20*widthRate, 35*widthRate);
    }else{
        cell.footView.frame = CGRectMake(10*widthRate, 65*widthRate+size1.height+15*widthRate, DeviceMaxWidth-20*widthRate, 35*widthRate);
        for (int i=0; i<imageAy.count; i++) {
            UIImageView *imageV = (UIImageView *)imageAy[i];
            imageV.hidden = YES;
        }
        cell.pictureCount.hidden = YES;
    }
    
    cell.comeLable.text = [dataDic objectForKey:@"category"];
    cell.addrLable.text = [dataDic objectForKey:@"city"];
    cell.timeLable.text = [lhColor distanceTimeWithBeforeTime:[[dataDic objectForKey:@"createTime"] doubleValue]];
    cell.countComment.text = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"commentCount"]];
    cell.countZan.text = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"likeCount"]];
    if ([[dataDic objectForKey:@"liked"] integerValue] == 1) {
        cell.zanBtn.selected = YES;
        [cell.zanImage setImage:imageWithName(@"zan_Yes")];
        cell.countZan.textColor = [UIColor redColor];
    }else{
        cell.zanBtn.selected = NO;
        [cell.zanImage setImage:imageWithName(@"zan_No")];
        cell.countZan.textColor = [lhColor colorFromHexRGB:contentTitleColorStr1];
    }
    
    
    return cell;
}

// 获取字符串长度
- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(DeviceMaxWidth-20*widthRate, MAXFLOAT)//限制最大的宽度和高度
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                    attributes:@{NSFontAttributeName: font}//传人的字体字典
                                       context:nil];
    return rect.size;
}


-(void)clickImageViewEvent:(UITapGestureRecognizer *)tap{
    FrankJiaKaoQuanCell *cell = (FrankJiaKaoQuanCell *)tap.view.superview;
    NSIndexPath *indexPath = [conTableView indexPathForCell:cell];
    NSLog(@"indexPath.row = %ld",indexPath.row);
    NSString *pictureStr = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"picture"];
    NSArray *array = [pictureStr componentsSeparatedByString:@"|"];
    imageArray = [[NSMutableArray alloc] initWithArray:array];
    
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray array];
    
    for (int i=0; i<imageArray.count; i++) {
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[lhColor shareColor].fileWebUrl,imageArray[i]]];
        [photos addObject:photo];
    }
    
//    photo.url = [NSURL URLWithString:httpUrl];
//    photo.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"testImage.png" ofType:nil]]; //图片
//    photo.srcImageView = (UIImageView *)imageArray[0];

    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    NSLog(@"tag = %ld",tap.view.tag);
    browser.currentPhotoIndex = tap.view.tag; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
}

-(void)clickReportEvent:(UIButton *)btn{
    FrankJiaKaoQuanCell *cell = (FrankJiaKaoQuanCell *)btn.superview.superview;
    NSIndexPath *indexPath = [conTableView indexPathForCell:cell];
    reportId = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"id"];
    UIActionSheet * actionSheet = [[UIActionSheet alloc]initWithTitle:@"请选择举报类型" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"敏感话题",@"淫秽色情",@"垃圾广告",@"人身攻击", nil];
    [actionSheet showInView:self.view];
//    [lhColor showAlertWithMessage:@"举报成功" withSuperView:self.view withHeih:DeviceMaxHeight/2];
    
}

-(void)clickZanEvent:(UIButton *)sender{
    FrankJiaKaoQuanCell *cell = (FrankJiaKaoQuanCell *)sender.superview.superview;
    NSIndexPath *indexPath = [conTableView indexPathForCell:cell];
    NSString *topicId = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"id"];
    cell.zanImage.layer.transform = CATransform3DMakeScale(1.2, 1.2, 1);
    cell.countZan.layer.transform = CATransform3DMakeScale(1.2, 1.2, 1);
    //设置动画时间为0.25秒,xy方向缩放的最终值为1
    [UIView animateWithDuration:0.5 animations:^{
        cell.zanImage.layer.transform = CATransform3DMakeScale(1, 1, 1);
        cell.countZan.layer.transform = CATransform3DMakeScale(1, 1, 1);
    }];
    NSInteger zanNumber = [cell.countZan.text integerValue];
    if (sender.selected) {
        sender.selected = NO;
        [cell.zanImage setImage:imageWithName(@"zan_No")];
        cell.countZan.text = [NSString stringWithFormat:@"%ld",zanNumber-1];
        cell.countZan.textColor = [lhColor colorFromHexRGB:contentTitleColorStr1];
    }else{
        sender.selected = YES;
        [cell.zanImage setImage:imageWithName(@"zan_Yes")];
        cell.countZan.textColor = [UIColor redColor];
        cell.countZan.text = [NSString stringWithFormat:@"%ld",zanNumber+1];
    }
    [self requestZanData:topicId];
}

-(void)clickCommentEvent:(UIButton *)sender{
    FrankJiaKaoQuanCell *cell = (FrankJiaKaoQuanCell *)sender.superview.superview;
    NSIndexPath *indexPath = [conTableView indexPathForCell:cell];
//    NSInteger countComment = [cell.countComment.text integerValue];
//    if (sender.selected) {
//        sender.selected = NO;
//        cell.countComment.text = [NSString stringWithFormat:@"%ld",countComment-1];
//        
//    }else{
//        sender.selected = YES;
//        cell.countComment.text = [NSString stringWithFormat:@"%ld",countComment+1];
//    }
    lhWriteViewController *wriDetail = [[lhWriteViewController alloc] init];
    wriDetail.topicDic = [dataArray objectAtIndex:indexPath.row];
    wriDetail.commentMark = 1;
    [self.navigationController pushViewController:wriDetail animated:YES];
}

#pragma mark - 点赞
-(void)requestZanData:(NSString *)topicId
{
    NSDictionary * dic = @{@"id":[[lhColor shareColor].userInfo objectForKey:@"id"],
                           @"topicId":topicId};
    NSLog(@"dic = %@",dic);
    
    [FrankNetworkManager postReqeustWithURL:PATH(@"bbs/like") params:dic successBlock:^(id returnData){
        if ([[returnData objectForKey:@"status"]integerValue] == 1) {
            
        }else{
            [FrankTools requestFailAlertShow:[returnData objectForKey:@"msg"]];
        }
    } failureBlock:^(NSError *error) {
        FLLog(@"%@",error.localizedDescription);
        [FrankTools wangluoAlertShow];
    } showHUD:NO];
}

#pragma mark - 刷新
-(void)refreshTabView
{
    pNo = 1;
    [self requestData];
}

#pragma mark - 举报
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *jubaoStr = nil;
    NSLog(@"buttonIndex = %ld",buttonIndex);
    if (buttonIndex == 0){
        jubaoStr = @"敏感话题";
    }else if (buttonIndex == 1){
        jubaoStr = @"淫秽色情";
    }else if (buttonIndex == 2){
        jubaoStr = @"垃圾广告";
    }else if (buttonIndex == 3){
        jubaoStr = @"人生攻击";
    }else{
        jubaoStr = @"";
    }
    if ([jubaoStr isEqualToString:@""]) {
        
    }else{
        NSDictionary * dic = @{@"id":[[lhColor shareColor].userInfo objectForKey:@"id"],
                               @"topicId":reportId,
                               @"category":jubaoStr,
                               @"content":@""};
        NSLog(@"dic = %@",dic);
        
        [FrankNetworkManager postReqeustWithURL:PATH(@"bbs/report") params:dic successBlock:^(id returnData){
            if ([[returnData objectForKey:@"status"]integerValue] == 1) {
                [lhColor showAlertWithMessage:@"举报成功" withSuperView:self.view withHeih:DeviceMaxHeight/2];
            }else{
                [FrankTools requestFailAlertShow:[returnData objectForKey:@"msg"]];
            }
        } failureBlock:^(NSError *error) {
            FLLog(@"%@",error.localizedDescription);
            [FrankTools wangluoAlertShow];
        } showHUD:NO];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    topPageControl.currentPage = scrollView.contentOffset.x/DeviceMaxWidth;
}

#pragma mark - 
- (void)funBtnEvent:(UIButton *)button_
{
    FrankTopicsView *topicsView = [[FrankTopicsView alloc] init];
    topicsView.titleString = [categoryArry[button_.tag] objectForKey:@"name"];
    topicsView.categoryArray = categoryArry;
    topicsView.category = [NSString stringWithFormat:@"%ld",(long)button_.tag+1];
    [self.navigationController pushViewController:topicsView animated:YES];
}

#pragma mark - 写帖子
- (void)rightBtnEvent
{
    NSLog(@"写帖子");
//    lhWriteViewController * wVC = [[lhWriteViewController alloc]init];
//    [self.navigationController pushViewController:wVC animated:YES];
    if ([categoryArry count]) {
        FrankWriteTopic *writeTopic = [[FrankWriteTopic alloc] init];
        writeTopic.categoryArray = categoryArry;
        writeTopic.delegate = self;
        writeTopic.vcType = 1;
        [self.navigationController pushViewController:writeTopic animated:YES];
    }else{
        [lhColor showAlertWithMessage:@"请检查你的网络" withSuperView:self.view withHeih:DeviceMaxHeight/2];
    }
    
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

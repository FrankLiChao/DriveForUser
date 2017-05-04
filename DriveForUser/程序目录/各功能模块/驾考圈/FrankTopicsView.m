//
//  FrankTopicsView.m
//  Drive
//
//  Created by lichao on 15/11/6.
//  Copyright © 2015年 bosheng. All rights reserved.
//

#import "FrankTopicsView.h"
#import "FrankJiaKaoQuanCell.h"
#import "MJPhoto.h"
#import "MJRefresh.h"
#import "MJPhotoBrowser.h"
#import "lhWriteViewController.h"
#import "FrankWriteTopic.h"


@interface FrankTopicsView ()<UIActionSheetDelegate>{
    NSInteger pNo;//消息当前页数
    NSInteger allPno;//消息总页数
    NSMutableArray *topicArray;//消息数据
    NSString *reportId;           //举报的id
}

@end

@implementation FrankTopicsView

- (void)viewDidLoad {
    [super viewDidLoad];
    [[lhColor shareColor]originalInit:self title:self.titleString imageName:nil backButton:YES];
    topicArray = [[NSMutableArray alloc] init];
    pNo = 1;
    allPno = 1;
    [self initFrameView];
//    [self requestData];
}

-(void)requestData
{
    NSDictionary * dic = @{@"id":[[lhColor shareColor].userInfo objectForKey:@"id"],
                           @"category":self.category,
                           @"pageSize":@"10",
                           @"pageNo":[NSString stringWithFormat:@"%ld",(long)pNo]};
    
    [FrankNetworkManager postReqeustWithURL:PATH(@"bbs/topicList") params:dic successBlock:^(id returnData){
        if (pNo == 1) {
            [myTableView headerEndRefreshing];
        }
        else{
            [myTableView footerEndRefreshing];
        }
        if ([[returnData objectForKey:@"status"]integerValue] == 1) {
            if (pNo == 1) {
                allPno = [[[returnData objectForKey:@"data"] objectForKey:@"totalPages"] integerValue];
                topicArray = [[returnData objectForKey:@"data"] objectForKey:@"data"];
                if (topicArray.count>0) {
                    [myTableView reloadData];
                }
            }
            else{
                NSArray * tempA = [[returnData objectForKey:@"data"] objectForKey:@"data"];
                if (tempA && tempA.count > 0) {
                    NSMutableArray * tArray = [NSMutableArray arrayWithArray:topicArray];
                    [tArray addObjectsFromArray:tempA];
                    topicArray = tArray;
                }
            }
        }else{
            [FrankTools requestFailAlertShow:[returnData objectForKey:@"msg"]];
        }
    } failureBlock:^(NSError *error) {
        FLLog(@"%@",error.localizedDescription);
        [FrankTools wangluoAlertShow];
    } showHUD:NO];
}

-(void)initFrameView{
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, DeviceMaxWidth, DeviceMaxHeight-64) style:UITableViewStylePlain];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.showsVerticalScrollIndicator = NO;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:myTableView];
    
    UIImageView *writeImage = [[UIImageView alloc] initWithFrame:CGRectMake(290*widthRate, 31, 20, 20)];
    [writeImage setImage:imageWithName(@"release_D")];
    [self.view addSubview:writeImage];
    
    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(250*widthRate, 20, 70*widthRate, 44);
    [rightBtn addTarget:self action:@selector(rightBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightBtn];
    
    [lhColor addActivityView123:self.view];
    [myTableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    [myTableView addFooterWithTarget:self action:@selector(footerRefresh)];
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
        [myTableView footerEndRefreshing];
        return;
    }
    
    pNo++;
    [self requestData];
}

#pragma mark - 刷新
-(void)refreshTabView
{
    pNo = 1;
    [self requestData];
}

#pragma mark - 写帖子
- (void)rightBtnEvent
{
//    lhWriteViewController * wVC = [[lhWriteViewController alloc]init];
//    [self.navigationController pushViewController:wVC animated:YES];
    FrankWriteTopic *writeTopic = [[FrankWriteTopic alloc] init];
    writeTopic.categoryArray = self.categoryArray;
    writeTopic.topicDelegate = self;
    writeTopic.vcType = 2;
    [self.navigationController pushViewController:writeTopic animated:YES];
}

#pragma mark - UITabelViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    lhWriteViewController *wriDetail = [[lhWriteViewController alloc] init];
    wriDetail.topicDic = [topicArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:wriDetail animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return topicArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat hight = 72*widthRate;
    NSDictionary * oned = [topicArray objectAtIndex:indexPath.row];
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
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * tifier = @"cellName";
    
    FrankJiaKaoQuanCell *cell = [tableView dequeueReusableCellWithIdentifier:tifier];
    if (cell == nil) {
        cell = [[FrankJiaKaoQuanCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tifier];
    }
    
    [cell.zanBtn addTarget:self action:@selector(clickZanEvent:) forControlEvents:UIControlEventTouchUpInside];
    [cell.commentBtn addTarget:self action:@selector(clickCommentEvent:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dataDic = [topicArray objectAtIndex:indexPath.row];
    
//    UITapGestureRecognizer *imageGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImageViewEvent)];
//    [cell.uploadImage1 addGestureRecognizer:imageGesture];
    
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
            imageV.frame = CGRectMake(10*widthRate+(290*widthRate/3+5*widthRate)*i, 65*widthRate+size1.height+10*widthRate, 290*widthRate/3, 100*widthRate);
            [lhColor checkImageWithName:[NSString stringWithFormat:@"%@",pictureArray[i]] withUrlStr:[NSString stringWithFormat:@"%@%@",[lhColor shareColor].fileWebUrl,pictureArray[i]] withImgView:imageV];
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
            imageV.frame = CGRectMake(10*widthRate+(290*widthRate/3+5*widthRate)*i, 65*widthRate+size1.height+10*widthRate, 290*widthRate/3, 100*widthRate);
            [lhColor checkImageWithName:[NSString stringWithFormat:@"%@",pictureArray[i]] withUrlStr:[NSString stringWithFormat:@"%@%@",[lhColor shareColor].fileWebUrl,pictureArray[i]] withImgView:imageV];
        }
        
        cell.pictureCount.hidden = YES;
        cell.footView.frame = CGRectMake(10*widthRate, 65*widthRate+size1.height+120*widthRate, DeviceMaxWidth-20*widthRate, 35*widthRate);
    }else{
        cell.footView.frame = CGRectMake(10*widthRate, 65*widthRate+size1.height+10*widthRate, DeviceMaxWidth-20*widthRate, 35*widthRate);
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

-(void)clickZanEvent:(UIButton *)sender{
    FrankJiaKaoQuanCell *cell = (FrankJiaKaoQuanCell *)sender.superview.superview;
    NSIndexPath *indexPath = [myTableView indexPathForCell:cell];
    NSString *topicId = [[topicArray objectAtIndex:indexPath.row] objectForKey:@"id"];
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

#pragma mark - 点赞
-(void)requestZanData:(NSString *)topicId
{
    NSDictionary * dic = @{@"id":[[lhColor shareColor].userInfo objectForKey:@"id"],
                           @"topicId":topicId};
    NSLog(@"dic = %@",dic);
    
    [FrankNetworkManager postReqeustWithURL:PATH(@"bbs/like") params:dic successBlock:^(id returnData){
        FLLog(@"%@",returnData);
        if ([[returnData objectForKey:@"status"]integerValue] == 1) {
        }else{
            [FrankTools requestFailAlertShow:[returnData objectForKey:@"msg"]];
        }
    } failureBlock:^(NSError *error) {
        FLLog(@"%@",error.localizedDescription);
        [FrankTools wangluoAlertShow];
    } showHUD:NO];
}

-(void)clickCommentEvent:(UIButton *)sender{
    FrankJiaKaoQuanCell *cell = (FrankJiaKaoQuanCell *)sender.superview.superview;
    NSIndexPath *indexPath = [myTableView indexPathForCell:cell];
    if (sender.selected) {
        sender.selected = NO;
    }else{
        sender.selected = YES;
    }
    lhWriteViewController *wriDetail = [[lhWriteViewController alloc] init];
    wriDetail.topicDic = [topicArray objectAtIndex:indexPath.row];
    wriDetail.commentMark = 1;
    [self.navigationController pushViewController:wriDetail animated:YES];
}

-(void)clickReportEvent:(UIButton *)btn{
    FrankJiaKaoQuanCell *cell = (FrankJiaKaoQuanCell *)btn.superview.superview;
    NSIndexPath *indexPath = [myTableView indexPathForCell:cell];
    reportId = [[topicArray objectAtIndex:indexPath.row] objectForKey:@"id"];
    UIActionSheet * actionSheet = [[UIActionSheet alloc]initWithTitle:@"请选择举报类型" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"敏感话题",@"淫秽色情",@"垃圾广告",@"人身攻击", nil];
    [actionSheet showInView:self.view];
    //    [lhColor showAlertWithMessage:@"举报成功" withSuperView:self.view withHeih:DeviceMaxHeight/2];
    
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

#pragma mark - view
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [lhColor assignmentForTempVC:self];
    [self requestData];
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

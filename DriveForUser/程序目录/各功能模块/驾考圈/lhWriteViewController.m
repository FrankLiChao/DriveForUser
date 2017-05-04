//
//  lhWriteViewController.m
//  Drive
//
//  Created by bosheng on 15/7/31.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import "lhWriteViewController.h"
#import "UIImage+Cut.h"
#import "FrankCommentCell.h"
#import "MJRefresh.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "UIScrollView+FrankScrollerView_touch.h"   //让UIScrollView响应touch方法

@interface lhWriteViewController ()<UITextFieldDelegate,UIScrollViewDelegate>{
    UIScrollView *myScrollView;
    NSMutableArray *commentArray;
    NSInteger pNo;//消息当前页数
    NSInteger allPno;//消息总页数
    UITextField *releaseField;
    UIToolbar *toolBar;
    UIButton *sendBtn;          //评论发送按钮
    UITextField *inputView;
    NSInteger zanCount;
    UIView *maxView;
}

@end

@implementation lhWriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[lhColor shareColor]originalInit:self title:@"话题详情" imageName:nil backButton:YES];
    maxView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, DeviceMaxWidth, DeviceMaxHeight)];
    [self.view addSubview:maxView];
    
    [self initToolbar];
    commentArray = [[NSMutableArray alloc] init];
    pNo = 1;
    allPno = 1;
    zanCount = [[self.topicDic objectForKey:@"likeCount"] integerValue];
    [self requstTopicDetails];
}

-(void)initToolbar
{
    releaseField = [[UITextField alloc] init];
    releaseField.delegate = self;
    [self.view addSubview:releaseField];
    toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 40*widthRate)];
    releaseField.inputAccessoryView = toolBar;
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 40*widthRate)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.borderWidth = 0.5;
    bgView.layer.borderColor = [[lhColor colorFromHexRGB:viewColorStr] CGColor];
    [toolBar addSubview:bgView];
    
    inputView = [[UITextField alloc] initWithFrame:CGRectMake(5*widthRate, 5*widthRate, 270*widthRate, 30*widthRate)];
    inputView.backgroundColor = [UIColor whiteColor];
    inputView.delegate = self;
    [bgView addSubview:inputView];
    
    sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.frame = CGRectMake(DeviceMaxWidth-45*widthRate, 5*widthRate, 40*widthRate, 30*widthRate);
    sendBtn.layer.cornerRadius = 5*widthRate;
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[lhColor colorFromHexRGB:mainColorStr] forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(clickSendBtn:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:sendBtn];
}

-(void)clickSendBtn:(UIButton *)button_
{
    NSLog(@"点击发表 = %@",self.topicDic);
    [inputView resignFirstResponder];
    [releaseField resignFirstResponder];
    if ([inputView.text isEqualToString:@""]) {
        return;
    }
    NSDictionary * dic = @{@"id":[[lhColor shareColor].userInfo objectForKey:@"id"],
                           @"topicId":[self.topicDic objectForKey:@"id"],
                           @"content":inputView.text
                           };
    NSLog(@"dic = %@",dic);
    [FrankNetworkManager postReqeustWithURL:PATH(@"bbs/comment") params:dic successBlock:^(id returnData){
        if ([[returnData objectForKey:@"status"]integerValue] == 1) {
            [lhColor showAlertWithMessage:@"评论成功" withSuperView:self.view withHeih:DeviceMaxHeight/2];
            [self requstTopicDetails];
        }else{
            [FrankTools requestFailAlertShow:[returnData objectForKey:@"msg"]];
        }
    } failureBlock:^(NSError *error) {
        FLLog(@"%@",error.localizedDescription);
        [FrankTools wangluoAlertShow];
    } showHUD:NO];
}

-(void)sendComment:(NSNotification *)infor
{
    NSLog(@"发表评论 = %@",infor.userInfo);
    [[NSNotificationCenter defaultCenter]removeObserver:self name:infor.name object:nil];
    if (!infor.userInfo || [infor.userInfo class] == [NSNull class]) {
        [lhColor wangluoAlertShow];
    }
    else if([[infor.userInfo objectForKey:@"status"]integerValue] == 1){
        [lhColor showAlertWithMessage:@"评论成功" withSuperView:self.view withHeih:DeviceMaxHeight/2];
        [self requstTopicDetails];
    }
    else{
        [lhColor requestFailAlertShow:infor];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [inputView resignFirstResponder];
    [releaseField resignFirstResponder];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [inputView resignFirstResponder];
    [releaseField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [inputView resignFirstResponder];
    [releaseField resignFirstResponder];
    
    return YES;
}

-(void)requstTopicDetails
{
//    [lhColor addActivityView123:self.view];
    NSDictionary * dic = @{@"id":[self.topicDic objectForKey:@"id"],
                           @"pageSize":@"10",
                           @"pageNo":[NSString stringWithFormat:@"%ld",(long)pNo]};
    NSLog(@"dic = %@",dic);
    
    [FrankNetworkManager postReqeustWithURL:PATH(@"bbs/commentList") params:dic successBlock:^(id returnData){
        if (pNo == 1) {
            [myTableView headerEndRefreshing];
        }
        else{
            [myTableView footerEndRefreshing];
        }
        if ([[returnData objectForKey:@"status"]integerValue] == 1) {
            if (pNo == 1) {
                allPno = [[[returnData objectForKey:@"data"] objectForKey:@"totalPages"] integerValue];
                commentArray = [[returnData objectForKey:@"data"] objectForKey:@"data"];
            }
            else{
                NSArray * tempA = [[returnData objectForKey:@"data"] objectForKey:@"data"];
                if (tempA && tempA.count > 0) {
                    NSMutableArray * tArray = [NSMutableArray arrayWithArray:commentArray];
                    [tArray addObjectsFromArray:tempA];
                    commentArray = tArray;
                }
            }
        }else{
            [FrankTools requestFailAlertShow:[returnData objectForKey:@"msg"]];
        }
        [self initFrameView];
    } failureBlock:^(NSError *error) {
        FLLog(@"%@",error.localizedDescription);
        [FrankTools wangluoAlertShow];
    } showHUD:NO];
}

- (void)headerRefresh
{
    pNo = 1;
    [self requstTopicDetails];
}

//上拉加载
- (void)footerRefresh
{
    if (pNo >= allPno) {
        [lhColor showAlertWithMessage:@"没有更多数据了~" withSuperView:self.view withHeih:DeviceMaxHeight-80];
        [myScrollView footerEndRefreshing];
        return;
    }
    pNo++;
    [self requstTopicDetails];
}

-(void)initFrameView{
    myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, DeviceMaxHeight-64)];
    myScrollView.showsVerticalScrollIndicator = NO;
    myScrollView.backgroundColor = [UIColor whiteColor];
    myScrollView.delegate = self;
    [maxView addSubview:myScrollView];
    
    NSLog(@"self.topicDic = %@",self.topicDic);
    
    CGFloat hight = 10*widthRate;
    UIImageView *headImage = [[UIImageView alloc] initWithFrame:CGRectMake(10*widthRate, hight, 30*widthRate, 30*widthRate)];
    [headImage setImage:imageWithName(@"defaultHead")];
    headImage.layer.masksToBounds = YES;
    headImage.layer.cornerRadius = 15*widthRate;
    [myScrollView addSubview:headImage];
    
    NSString *hdImage = [self.topicDic objectForKey:@"avatar"];
    if (![hdImage isEqualToString:@""]) {
        [lhColor checkImageWithName:hdImage withUrlStr:[NSString stringWithFormat:@"%@%@",[lhColor shareColor].fileWebUrl,hdImage] withImgView:headImage];
    }
    
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(45*widthRate, hight, DeviceMaxWidth-55*widthRate, 15*widthRate)];
    name.text = [self.topicDic objectForKey:@"name"];
    name.font = [UIFont systemFontOfSize:15];
    name.textColor = [lhColor colorFromHexRGB:@"221714"];
    [myScrollView addSubview:name];
    
    UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake(45*widthRate, hight+16*widthRate, DeviceMaxWidth-55*widthRate, 20*widthRate)];
    time.text = [lhColor distanceTimeWithBeforeTime:[[self.topicDic objectForKey:@"createTime"] doubleValue]];
    
    time.font = [UIFont systemFontOfSize:12];
    time.textColor = [lhColor colorFromHexRGB:contentTitleColorStr1];
    [myScrollView addSubview:time];
    
    hight += 40*widthRate;
    
    NSString *contentStr = [self.topicDic objectForKey:@"content"];
    NSMutableAttributedString *as = [[NSMutableAttributedString alloc] initWithString:contentStr];
    NSMutableParagraphStyle * ps = [[NSMutableParagraphStyle alloc]init];
    [ps setLineSpacing:6];
    [as addAttribute:NSParagraphStyleAttributeName value:ps range:NSMakeRange(0, contentStr.length)];
    UILabel *content = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, hight, DeviceMaxWidth-20*widthRate, 20)];
    content.textColor = [lhColor colorFromHexRGB:@"221714"];
    content.font = [UIFont systemFontOfSize:15];
    content.numberOfLines = 0;
    content.attributedText = as;
    [content sizeToFit];
    [myScrollView addSubview:content];
    
    hight += content.frame.size.height + 10*widthRate;
    
    NSString *picStr = [self.topicDic objectForKey:@"picture"];
    NSArray *picArray = [picStr componentsSeparatedByString:@"|"];
    if (picStr == nil || [picStr isEqualToString:@""]) {
    }else{
        NSInteger count = 0;
        if (picArray.count>3) {
            count = 3;
        }else if(picArray.count>0){
            count = picArray.count;
        }else{
            count = 0;
        }
        for (int i=0; i<count; i++) {
            UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(10*widthRate+i*(96.6*widthRate+5*widthRate), hight, 96.6*widthRate, 100*widthRate)];
            [lhColor checkImageWithName:[NSString stringWithFormat:@"%@",picArray[i]] withUrlStr:[NSString stringWithFormat:@"%@%@",[lhColor shareColor].fileWebUrl,picArray[i]] withImgView:imageV];
            imageV.image = [imageV.image clipImageWithScaleWithsize:CGSizeMake(96.6*widthRate*2, 2*100*widthRate)];
            imageV.userInteractionEnabled = YES;
            [myScrollView addSubview:imageV];
            imageV.tag = i;
            
            UITapGestureRecognizer *imageGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImageViewEvent:)];
            [imageV addGestureRecognizer:imageGesture];
        }
        if (picArray.count>3) {
            UILabel *pictureCount = [[UILabel alloc] initWithFrame:CGRectMake(DeviceMaxWidth-35*widthRate, hight+85*widthRate, 25*widthRate, 15*widthRate)];
            pictureCount.text = [NSString stringWithFormat:@"%ld张",picArray.count];
            pictureCount.font = [UIFont systemFontOfSize:13];
            pictureCount.textColor = [UIColor whiteColor];
            pictureCount.textAlignment = NSTextAlignmentCenter;
            pictureCount.backgroundColor = [UIColor redColor];
            pictureCount.backgroundColor = [UIColor colorWithRed:53.0/255.0 green:152.0/255.0 blue:220.0/255.0 alpha:0.5];
            [myScrollView addSubview:pictureCount];
        }
        
        hight += 110*widthRate;
    }
    
    UILabel *topicType = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, hight, 50*widthRate, 15*widthRate)];
    topicType.text = [self.topicDic objectForKey:@"category"];
    topicType.font = [UIFont systemFontOfSize:12];
    topicType.textColor = [lhColor colorFromHexRGB:mainColorStr];
    topicType.layer.borderWidth = 0.5;
    topicType.layer.borderColor = [[lhColor colorFromHexRGB:mainColorStr] CGColor];
    topicType.textAlignment = NSTextAlignmentCenter;
    topicType.layer.cornerRadius = 7*widthRate;
    [myScrollView addSubview:topicType];
    
    UILabel *address = [[UILabel alloc] initWithFrame:CGRectMake(70*widthRate, hight, DeviceMaxWidth-70*widthRate, 15*widthRate)];
    address.text = [self.topicDic objectForKey:@"city"];
    address.textColor = [lhColor colorFromHexRGB:contentTitleColorStr1];
    address.font = [UIFont systemFontOfSize:13];
    [myScrollView addSubview:address];
    
    hight += 25*widthRate;
    
    UIView *lineP = [[UIView alloc] initWithFrame:CGRectMake(10*widthRate, hight, DeviceMaxWidth-20*widthRate, 0.5)];
    lineP.backgroundColor = [lhColor colorFromHexRGB:viewColorStr];
    [myScrollView addSubview:lineP];
/*
    NSString *nameStr = @"じ☆ve真心相爱═╬,╭ァ虞美人,鹿还长别心凡i,你是好人我是坏人,白色衬衣,exodus,一梦醉英雄,薄荷加冰多凉,孤独的角落?,不经历哪来的呼风唤雨,南栀倾寒,努力↗才幸福,我要去傻帽买下exo等赞过";
    NSMutableAttributedString *as1 = [[NSMutableAttributedString alloc] initWithString:nameStr];
    NSMutableParagraphStyle * ps1 = [[NSMutableParagraphStyle alloc]init];
    [ps1 setLineSpacing:6];
    [as1 addAttribute:NSParagraphStyleAttributeName value:ps1 range:NSMakeRange(0, contentStr.length)];
    [as1 addAttribute:NSForegroundColorAttributeName value:[lhColor colorFromHexRGB:contentTitleColorStr1] range:NSMakeRange(nameStr.length-3, 3)];
    UILabel *zanName = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, hight+10*widthRate, DeviceMaxWidth-20*widthRate, 20*widthRate)];
    zanName.font = [UIFont systemFontOfSize:13];
    zanName.textColor = [lhColor colorFromHexRGB:mainColorStr];
    zanName.attributedText = as1;
    zanName.numberOfLines = 0;
    [zanName sizeToFit];
    [myScrollView addSubview:zanName];
*/
//    UILabel *zanName = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, hight+10*widthRate, DeviceMaxWidth-20*widthRate, 20*widthRate)];
//    zanName.font = [UIFont systemFontOfSize:13];
//    zanName.textColor = [lhColor colorFromHexRGB:mainColorStr];
//    zanName.text = [NSString stringWithFormat:@"%ld人赞过",[[self.topicDic objectForKey:@"likeCount"] integerValue]];
//    [myScrollView addSubview:zanName];
//    
//    hight += zanName.frame.size.height+20*widthRate;
//    
//    UIView *lineU = [[UIView alloc] initWithFrame:CGRectMake(10*widthRate, hight-0.5, DeviceMaxWidth-20*widthRate, 0.5)];
//    lineU.backgroundColor = [lhColor colorFromHexRGB:viewColorStr];
//    [myScrollView addSubview:lineU];
    
    hight += 5*widthRate;
    
    UILabel *totalCount = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, hight, DeviceMaxWidth-20*widthRate, 20*widthRate)];
    totalCount.text = [NSString stringWithFormat:@"%ld条评论",[[self.topicDic objectForKey:@"commentCount"] integerValue]];
    totalCount.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
    totalCount.font = [UIFont systemFontOfSize:13];
    [myScrollView addSubview:totalCount];
    
    hight += 30*widthRate;
    
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, hight, DeviceMaxWidth, commentArray.count*70*widthRate) style:UITableViewStylePlain];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.scrollEnabled = NO;
    [myScrollView addSubview:myTableView];
    
    hight += myTableView.frame.size.height;
    
    myScrollView.contentSize = CGSizeMake(DeviceMaxWidth, hight+100*widthRate);
    
    UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(0, DeviceMaxHeight-50*widthRate, DeviceMaxWidth, 50*widthRate)];
    bgview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgview];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 0.5)];
    lineView.backgroundColor = [lhColor colorFromHexRGB:contentTitleColorStr1];
    [bgview addSubview:lineView];
    
    zanImage = [[UIImageView alloc] initWithFrame:CGRectMake(110*widthRate, 5*widthRate, 25*widthRate, 25*widthRate)];
    [zanImage setImage:imageWithName(@"zan_No")];
    [bgview addSubview:zanImage];
    
    self.countZan = [[UILabel alloc] initWithFrame:CGRectMake(100*widthRate, 23*widthRate, 45*widthRate, 30*widthRate)];
    self.countZan.font = [UIFont systemFontOfSize:11];
    self.countZan.text = [NSString stringWithFormat:@"赞(%@)",[self.topicDic objectForKey:@"likeCount"]];
    self.countZan.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
    self.countZan.textAlignment = NSTextAlignmentCenter;
    [bgview addSubview:self.countZan];
    
    UIButton *clickZan = [UIButton buttonWithType:UIButtonTypeCustom];
    clickZan.frame = CGRectMake(100*widthRate, 0, 40*widthRate, 50*widthRate);
    if ([[self.topicDic objectForKey:@"liked"] integerValue]) {
        [zanImage setImage:imageWithName(@"zan_Yes")];
        self.countZan.textColor = [UIColor redColor];
        clickZan.selected = YES;
    }else{
        [zanImage setImage:imageWithName(@"zan_No")];
        self.countZan.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
        clickZan.selected = NO;
    }
    [clickZan addTarget:self action:@selector(clickZanEvent:) forControlEvents:UIControlEventTouchUpInside];
    [bgview addSubview:clickZan];
    
    commentImage = [[UIImageView alloc] initWithFrame:CGRectMake(190*widthRate, 5*widthRate, 25*widthRate, 25*widthRate)];
    [commentImage setImage:imageWithName(@"message_D")];
    [bgview addSubview:commentImage];
    
    self.countComment = [[UILabel alloc] initWithFrame:CGRectMake(180*widthRate, 23*widthRate, 45*widthRate, 30*widthRate)];
    self.countComment.font = [UIFont systemFontOfSize:11];
    self.countComment.text = [NSString stringWithFormat:@"评论(%@)",[self.topicDic objectForKey:@"commentCount"]];
    self.countComment.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
    self.countComment.textAlignment = NSTextAlignmentCenter;
    [bgview addSubview:self.countComment];
    
    UIButton *commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commentBtn.frame = CGRectMake(175*widthRate, 0, 50*widthRate, 50*widthRate);
    [commentBtn addTarget:self action:@selector(clickReplyEvent) forControlEvents:UIControlEventTouchUpInside];
    [bgview addSubview:commentBtn];
 
    [myScrollView addHeaderWithTarget:self action:@selector(headerRefresh)];
    [myScrollView addFooterWithTarget:self action:@selector(footerRefresh)];
    if (self.commentMark == 1) {
        self.commentMark = 0;
        [self clickReplyEvent];
        [self performSelector:@selector(clickReplyEvent) withObject:nil afterDelay:1];
    }
}

#pragma mark - 图片预览
-(void)clickImageViewEvent:(UITapGestureRecognizer *)tap{
    NSString *pictureStr = [self.topicDic objectForKey:@"picture"];
    NSArray *array = [pictureStr componentsSeparatedByString:@"|"];
    NSMutableArray *imageArray = [[NSMutableArray alloc] initWithArray:array];
    
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

-(void)clickReplyEvent{
//    if ([btn.superview.subviews isKindOfClass:[NSArray class]]) {
//        NSLog(@"子视图包含UILable控件");
//    }
//    else if ([btn.superview.subviews isKindOfClass:[UIImageView class]]){
//        NSLog(@"子视图包含UIImageView控件");
//    }else{
//        NSLog(@"%@",btn.superview.subviews);
//    }
    [releaseField becomeFirstResponder];
    [inputView becomeFirstResponder];
}

-(void)clickZanEvent:(UIButton *)btn{
    if (btn.selected) {
        btn.selected = NO;
        zanCount -= 1;
        [zanImage setImage:imageWithName(@"zan_No")];
        self.countZan.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
        self.countZan.text = [NSString stringWithFormat:@"赞(%ld)",zanCount];
        
    }else{
        btn.selected = YES;
        zanCount += 1;
        [zanImage setImage:imageWithName(@"zan_Yes")];
        self.countZan.textColor = [UIColor redColor];
        self.countZan.text = [NSString stringWithFormat:@"赞(%ld)",zanCount];
    }
    [self requestZanData:[self.topicDic objectForKey:@"id"]];
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

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return commentArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70*widthRate;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * tifier = @"cellName";
    
    FrankCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:tifier];
    if (cell == nil) {
        cell = [[FrankCommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dic = [commentArray objectAtIndex:indexPath.row];
    NSLog(@"dic = %@",dic);
    NSString *imageStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"avatar"]];
    [lhColor checkImageWithName:imageStr withUrlStr:[NSString stringWithFormat:@"%@%@",[lhColor shareColor].fileWebUrl,imageStr] withImgView:cell.hdImageV];
    cell.content.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"content"]];
    cell.name.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
    cell.time.text = [NSString stringWithFormat:@"%@",[lhColor distanceTimeWithBeforeTime:[[dic objectForKey:@"createTime"] doubleValue]]];
    return cell;
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

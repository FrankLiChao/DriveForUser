//
//  PageViewController.m
//  PracticeSimulation
//
//  Created by lichao on 15/7/16.
//  Copyright (c) 2015年 LiFrank. All rights reserved.
//

#import "FrankPageContentView.h"
#import "FrankPracticeView.h"
#import "Practice.h"
#import "FrankTableViewCell.h"
#import <AVFoundation/AVFoundation.h>

@interface FrankPageContentView (){
    NSArray *valueForCell;
    UIButton *selectBtn;
    NSMutableSet *selectCell;
    AVPlayer *player;
}

@end

@implementation FrankPageContentView

- (void)viewDidLoad {
    [super viewDidLoad];
    //禁用右划手势
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    selectCell = [[NSMutableSet alloc] init];
    [self initFrameView];
    
}

-(void)initFrameView{
    CGFloat hight = 0;
    _myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, DeviceMaxHeight-64)];
    _myScrollView.backgroundColor = [UIColor whiteColor];
    _myScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_myScrollView];
    
    //创建答题标题
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10*widthRate, 10*widthRate, DeviceMaxWidth-20*widthRate, 20*widthRate)];
    label.numberOfLines = 0; // 需要把显示行数设置成无限制
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
    label.userInteractionEnabled = YES;
    if (_questionType == 2) {
        NSArray *subjectArray =  [_titleText componentsSeparatedByString:@"#"];
        if ([subjectArray count] == 5) {
            _titleText = subjectArray[0];
            valueForCell = @[subjectArray[1],subjectArray[2],subjectArray[3],subjectArray[4]];
        }
    }else{
        valueForCell = @[_answerA,_answerB,_answerC,_answerD];
    }
    label.text = [NSString stringWithFormat:@"%ld、 %@",(long)_pageIndex,_titleText];
    label.textAlignment = NSTextAlignmentLeft;
    label.lineBreakMode = NSLineBreakByCharWrapping;
    [label sizeToFit];
    label.userInteractionEnabled = YES;
    [_myScrollView addSubview:label];
    
    hight = label.frame.size.height + 10*widthRate;
    
    //创建图片View
    UIImage *image = [UIImage imageNamed:_imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15*widthRate, hight+10*widthRate, DeviceMaxWidth-30*widthRate, 300)];
    imageView.userInteractionEnabled = YES;
    if ([_imageName isEqualToString:@""]) {
        
    }
    else if (_questionType == 3){
        NSString *url = [_imageName lastPathComponent];
        url = [[url componentsSeparatedByString:@"."] objectAtIndex:0];
        
        NSURL *aVUrl = [[NSBundle mainBundle] URLForResource:url withExtension:@"mp4"];
        
        player = [AVPlayer playerWithURL:aVUrl];
        AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
        playerLayer.frame = CGRectMake(15*widthRate, hight, DeviceMaxWidth-30*widthRate, 150*widthRate);
        [_myScrollView.layer addSublayer:playerLayer];
        [player play];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(runLoopTheMovie:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        
        hight += 150*widthRate;
    }
    else{
        [imageView setImage:[UIImage imageNamed:_imageName]];
        if (image.size.width > DeviceMaxWidth) {
            imageView.frame = CGRectMake(15*widthRate, hight+10*widthRate, DeviceMaxWidth-30*widthRate, image.size.height);
        }else{
            imageView.frame = CGRectMake((DeviceMaxWidth-image.size.width)/2, hight+10*widthRate, image.size.width, image.size.height);
        }
        [_myScrollView addSubview:imageView];
        
        hight += imageView.frame.size.height + 10*widthRate;
        
    }
    
    hight += 10*widthRate;
    
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, hight, DeviceMaxWidth, 0.5)];
    lineV.backgroundColor = [lhColor colorFromHexRGB:viewColorStr];
    [_myScrollView addSubview:lineV];
    
    //创建选项的tabView
    if ([_answerC isEqualToString:@""]) {
        myTabView = [[UITableView alloc] initWithFrame:CGRectMake(0, hight+0.5*widthRate, DeviceMaxWidth, 80*widthRate) style:UITableViewStylePlain];
    }else{
        myTabView = [[UITableView alloc] initWithFrame:CGRectMake(0, hight+0.5*widthRate, DeviceMaxWidth, 160*widthRate) style:UITableViewStylePlain];
    }
    myTabView.separatorColor = [UIColor clearColor];
    myTabView.scrollEnabled = NO;
    myTabView.dataSource = self;
    myTabView.delegate = self;
    myTabView.userInteractionEnabled = YES;
    [_myScrollView addSubview:myTabView];
    
    hight += myTabView.frame.size.height;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, hight-0.5*widthRate, DeviceMaxWidth, 0.5)];
    lineView.backgroundColor = [lhColor colorFromHexRGB:viewColorStr];
    [_myScrollView addSubview:lineView];
    
    if (_questionType == 2) {  //表示多选题
        selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        selectBtn.frame = CGRectMake(40*widthRate, hight+10*widthRate, DeviceMaxWidth-80*widthRate, 40*widthRate);
        selectBtn.backgroundColor = [UIColor grayColor];
        selectBtn.layer.cornerRadius = 10;
        selectBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [selectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [selectBtn addTarget:self action:@selector(selectMoreEvent:) forControlEvents:UIControlEventTouchUpInside];
        [selectBtn setTitle:@"确定" forState:UIControlStateNormal];
        selectBtn.enabled = NO;
        [_myScrollView addSubview:selectBtn];
        
        hight += 40*widthRate + 10*widthRate;
    }

    //创建解释的View
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"最佳解释：\n\n%@",_analysis]];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(0, 5)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(0, 5)];
    _textView = [[UILabel alloc] initWithFrame:CGRectMake(15*widthRate, hight+10*widthRate, DeviceMaxWidth-30*widthRate, 0)];
    _textView.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
    _textView.attributedText = str;
    _textView.font = [UIFont systemFontOfSize:13];
    _textView.numberOfLines = 0;
    _textView.textAlignment = NSTextAlignmentLeft;
    _textView.lineBreakMode = NSLineBreakByCharWrapping;
    _textView.hidden = YES;
    _textView.userInteractionEnabled = YES;
    [_textView sizeToFit];
    [_myScrollView addSubview:_textView];
    [self.delegate hideOrShowExplain:YES];
    hight += _textView.frame.size.height;
    _myScrollView.contentSize = CGSizeMake(DeviceMaxWidth, hight+64+50*widthRate);
}

- (void)runLoopTheMovie:(NSNotification *)infor{
    //注册的通知  可以自动把 AVPlayerItem 对象传过来，只要接收一下就OK
    AVPlayerItem * playerItem = [infor object];
    //关键代码
    [playerItem seekToTime:kCMTimeZero];
    [player play];
}

-(void)selectMoreEvent:(UIButton *)button_{
    NSString *rightQuestion = nil;
    NSArray *rightArray = nil;
    NSInteger index = 0;
    switch ((int)_answer) {
        case 1:
        {
            NSString *answer = [_answerA stringByReplacingOccurrencesOfString:@"①" withString:@"1,"];
            answer = [answer stringByReplacingOccurrencesOfString:@"②" withString:@"2,"];
            answer = [answer stringByReplacingOccurrencesOfString:@"③" withString:@"3,"];
            answer = [answer stringByReplacingOccurrencesOfString:@"④" withString:@"4,"];
            NSMutableString * answerStr = [NSMutableString stringWithString:answer];
            rightQuestion = [answerStr substringToIndex:([answerStr length]-1)];
        }
            break;
        case 2:
        {
            NSString *answer = [_answerB stringByReplacingOccurrencesOfString:@"①" withString:@"1,"];
            answer = [answer stringByReplacingOccurrencesOfString:@"②" withString:@"2,"];
            answer = [answer stringByReplacingOccurrencesOfString:@"③" withString:@"3,"];
            answer = [answer stringByReplacingOccurrencesOfString:@"④" withString:@"4,"];
            NSMutableString * answerStr = [NSMutableString stringWithString:answer];
            rightQuestion = [answerStr substringToIndex:([answerStr length]-1)];
        }
            break;
        case 3:
        {
            NSString *answer = [_answerC stringByReplacingOccurrencesOfString:@"①" withString:@"1,"];
            answer = [answer stringByReplacingOccurrencesOfString:@"②" withString:@"2,"];
            answer = [answer stringByReplacingOccurrencesOfString:@"③" withString:@"3,"];
            answer = [answer stringByReplacingOccurrencesOfString:@"④" withString:@"4,"];
            NSMutableString * answerStr = [NSMutableString stringWithString:answer];
            rightQuestion = [answerStr substringToIndex:([answerStr length]-1)];
        }
            break;
        case 4:
        {
            NSString *answer = [_answerD stringByReplacingOccurrencesOfString:@"①" withString:@"1,"];
            answer = [answer stringByReplacingOccurrencesOfString:@"②" withString:@"2,"];
            answer = [answer stringByReplacingOccurrencesOfString:@"③" withString:@"3,"];
            answer = [answer stringByReplacingOccurrencesOfString:@"④" withString:@"4,"];
            NSMutableString * answerStr = [NSMutableString stringWithString:answer];
            rightQuestion = [answerStr substringToIndex:([answerStr length]-1)];
        }
            break;
        default:
            break;
    }
    rightQuestion = [rightQuestion stringByReplacingOccurrencesOfString:@" " withString:@""];
    rightArray = [rightQuestion componentsSeparatedByString:@","];
    NSArray *selectArray = [selectCell allObjects];
    NSMutableSet *rightSet = [[NSMutableSet alloc] initWithArray:rightArray];
    if ([rightSet isEqual:selectCell]) {
        NSLog(@"数组相等");
        [ManageSqlite updateAccordingTestID4:_testID withUserAns:1];
        self.delegate.swipeRight = NO;
        [self.delegate performSelector:@selector(nextPageControl:) withObject:[NSNumber numberWithInteger:_pageIndex +1] afterDelay:0.4];
    }else{
        [ManageSqlite updateAccordingTestID4:_testID withUserAns:2];
        if (self.delegate.recordJump == SIMULATION_TEST) {   //考试模拟不显示详情
            self.delegate.swipeRight = NO;
            [self.delegate performSelector:@selector(nextPageControl:) withObject:[NSNumber numberWithInteger:_pageIndex +1] afterDelay:0.4];
        }else{
            [self.delegate hideOrShowExplain:NO];
            _textView.hidden = NO;
        }
        
    }
    for (int i=0; i<[rightArray count]; i++) {
        index = [rightArray[i] integerValue] -1;
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        FrankTableViewCell *cell = (FrankTableViewCell *)[myTabView cellForRowAtIndexPath:indexPath];
        cell.answerForLab.textColor = [UIColor greenColor];
        cell.lableForImage.textColor = [UIColor greenColor];
        cell.lableForImage.layer.borderColor = [UIColor greenColor].CGColor;
    }
    for (int i=0; i<[selectArray count]; i++) {
        if ([rightArray containsObject:selectArray[i]]) {
        
        }else{
            NSLog(@"select = %@",selectArray[i]);
            index = [selectArray[i] integerValue] -1;
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
            FrankTableViewCell *cell = (FrankTableViewCell *)[myTabView cellForRowAtIndexPath:indexPath];
            cell.answerForLab.textColor = [UIColor redColor];
            cell.lableForImage.textColor = [UIColor redColor];
            cell.lableForImage.layer.borderColor = [UIColor redColor].CGColor;
        }
    }
}

-(void) hideTextView{
    if (_textView.hidden) {
        _textView.hidden = NO;
    }else{
        _textView.hidden = YES;
    }
}

//获取字符串长度
- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.view.bounds), MAXFLOAT)//限制最大的宽度和高度
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                    attributes:@{NSFontAttributeName: font}//传人的字体字典
                                       context:nil];
    return rect.size;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([_answerC isEqualToString:@""]) {
        return 2;
    }
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    FrankTableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (tableCell == nil) {
        tableCell = [[FrankTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
//    tableCell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (indexPath.row) {
        case 0:
            tableCell.lableForImage.text = @"A";
            break;
        case 1:
            tableCell.lableForImage.text = @"B";
            break;
        case 2:
            tableCell.lableForImage.text = @"C";
            break;
        case 3:
            tableCell.lableForImage.text = @"D";
            break;
        default:
            break;
    }
    tableCell.answerForLab.text = valueForCell[indexPath.row];
    tableCell.tag = 100+indexPath.row;
    NSInteger answerRecord = ((Practice *)self.delegate.sqliteArray[_pageIndex-1]).answerRecord;
    if (answerRecord == (indexPath.row + 1)) {
//        tableCell.backgroundColor = [lhColor colorFromHexRGB:viewColorStr];
        tableCell.selected = YES;
    }
    if (answerRecord > 0) {
        if (answerRecord == _answer) {  //正确的记录
            if ((indexPath.row+1) == answerRecord) {
                tableCell.answerForLab.textColor = [UIColor greenColor];
                tableCell.lableForImage.textColor = [UIColor greenColor];
                tableCell.lableForImage.layer.borderColor = [UIColor greenColor].CGColor;
            }
        }else{  //错误的记录
            if ((indexPath.row+1) == _answer) {
                tableCell.answerForLab.textColor = [UIColor greenColor];
                tableCell.lableForImage.textColor = [UIColor greenColor];
                tableCell.lableForImage.layer.borderColor = [UIColor greenColor].CGColor;
            }else if ((indexPath.row+1) == answerRecord){
                tableCell.answerForLab.textColor = [UIColor redColor];
                tableCell.lableForImage.textColor = [UIColor redColor];
                tableCell.lableForImage.layer.borderColor = [UIColor redColor].CGColor;
            }
            _textView.hidden = NO;
            self.delegate.titileExplain.tLabel.text = @"收起详情";
            self.delegate.titileExplain.selected = YES;
        }
        myTabView.delegate = nil;
    }
    return tableCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40*widthRate;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIndex = [NSString stringWithFormat:@"%ld",(long)indexPath.row+1];
    CGFloat delay = 0.8;
    if (_questionType == 2) {
        FrankTableViewCell * ftvCell = (FrankTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        ftvCell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (ftvCell.selectType) {
            ftvCell.backgroundColor = [UIColor whiteColor];
            ftvCell.selectType = 0;
        }else{
            ftvCell.backgroundColor = [lhColor colorFromHexRGB:viewColorStr];
            ftvCell.selectType = 1;
        }
        if (ftvCell.selectType) {
            [selectCell addObject:cellIndex];
        }else{
            [selectCell removeObject:cellIndex];
        }
        if ([selectCell count]>1) {
            selectBtn.enabled = YES;
            selectBtn.backgroundColor = [lhColor colorFromHexRGB:mainColorStr];
        }else{
            selectBtn.enabled = YES;
            selectBtn.backgroundColor = [UIColor grayColor];
        }
    }else{
        if (_answer == indexPath.row+1) {
            ((Practice *)self.delegate.sqliteArray[_pageIndex-1]).answerRecord = _answer;
            if (self.delegate.recordJump == SIMULATION_TEST) { //模拟考试
                self.delegate.scoreForTest+=1;
                _textView.hidden = YES;
                delay = 0.4;
            }else{
                _textView.hidden = NO;
            }
            if (_pageIndex != self.delegate.datacount) {
                self.delegate.swipeRight = NO;
                [self.delegate performSelector:@selector(nextPageControl:) withObject:[NSNumber numberWithInteger:_pageIndex +1] afterDelay:delay];
            }
            else{
                UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"题已答完,请交卷!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
                [alertV show];
            }
            //判断是科目一还是科目四
            if (self.subType == 0) {
                [ManageSqlite updateAccordingTestID:_testID withUserAns:1];
                
            }else if (self.subType == 1){
                [ManageSqlite updateAccordingTestID4:_testID withUserAns:1];
            }
            FrankTableViewCell * ftvCell = (FrankTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
            ftvCell.answerForLab.textColor = [UIColor greenColor];
            ftvCell.lableForImage.textColor = [UIColor greenColor];
            ftvCell.lableForImage.layer.borderColor = [UIColor greenColor].CGColor;
            ftvCell.selected = YES;
        }else{
            ((Practice *)self.delegate.sqliteArray[_pageIndex-1]).answerRecord = indexPath.row + 1;
            if (self.delegate.recordJump == SIMULATION_TEST) { //模拟考试
                if (_pageIndex != self.delegate.datacount) {
                    self.delegate.swipeRight = NO;
                    [self.delegate performSelector:@selector(nextPageControl:) withObject:[NSNumber numberWithInteger:_pageIndex +1] afterDelay:0.4];
                }else{
                    UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"题已答完,请交卷!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
                    [alertV show];
                }
                _textView.hidden = YES;
            }else{
                _textView.hidden = NO;
                self.delegate.titileExplain.tLabel.text = @"收起详情";
                self.delegate.titileExplain.selected = YES;
            }
            [self.delegate hideOrShowExplain:NO];
            //判断是科目一还是科目二
            if (self.subType == 0) {
                [ManageSqlite updateAccordingTestID:_testID withUserAns:2];
            }else if (self.subType == 1){
                [ManageSqlite updateAccordingTestID4:_testID withUserAns:2];
            }
            
            FrankTableViewCell * ftvCell = (FrankTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
            ftvCell.answerForLab.textColor = [UIColor redColor];
            ftvCell.lableForImage.textColor = [UIColor redColor];
            ftvCell.lableForImage.layer.borderColor = [UIColor redColor].CGColor;
            
            FrankTableViewCell *trueCell = (FrankTableViewCell *)[tableView viewWithTag:_answer+99];
            trueCell.answerForLab.textColor = [UIColor greenColor];
            trueCell.lableForImage.textColor = [UIColor greenColor];
            trueCell.lableForImage.layer.borderColor = [UIColor greenColor].CGColor;
            ftvCell.selected = YES;
        }
        tableView.delegate = nil;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        
    }else if (buttonIndex == 1){
    
    }
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

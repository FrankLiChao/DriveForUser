//
//  FrankSubjectListView.m
//  Drive
//
//  Created by lichao on 15/8/3.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import "FrankSubjectListView.h"

@interface FrankSubjectListView (){
    UIScrollView *myScrollView;
    CGFloat frank;
    UIButton *provinceBtn;  //表示四川省
    UIButton *nationalBtn;  //表示全国
}

@end

@implementation FrankSubjectListView

- (void)viewDidLoad {
    [super viewDidLoad];
    [[lhColor shareColor]originalInit:self title:@"科目一学霸排名" imageName:nil backButton:YES];
    [self initData];
    [self initFrameView];
    [self createTableView];
    // Do any additional setup after loading the view.
}

-(void)initData{
    frank = DeviceMaxWidth/375;
    indexArray = @[@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"];
    nameArray = @[@"优品学员",@"给你一抹温柔",@"学车",@"eueir",@"sdfhdsk",@"sdufh",@"sdkjfh",@"sdkjk",@"hjsdfg"];
    timeArray = @[@"用时3分13秒",@"用时3分14秒",@"用时3分15秒",@"用时3分16秒",@"用时3分17秒",@"用时3分18秒",@"用时3分19秒",@"用时3分20秒",@"用时3分21秒"];
}

-(void)initFrameView
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 64+1*frank, DeviceMaxWidth, 200*frank)];
    bgView.backgroundColor = [lhColor colorFromHexRGB:mainColorStr];
    [self.view addSubview:bgView];
    
    provinceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    provinceBtn.frame = CGRectMake((DeviceMaxWidth-300*frank)/2, 10*frank, 150*frank, 30*frank);
    [provinceBtn setTitle:@"四川" forState:UIControlStateNormal];
    provinceBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    provinceBtn.selected = YES;
    [provinceBtn setTitleColor:[lhColor colorFromHexRGB:mainColorStr] forState:UIControlStateNormal];
    [provinceBtn setBackgroundImage:imageWithName(@"provinceImage_n") forState:UIControlStateNormal];
    [provinceBtn setBackgroundImage:imageWithName(@"provinceImage_y") forState:UIControlStateSelected];
    [provinceBtn addTarget:self action:@selector(clickProvinceBtn:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:provinceBtn];
    
    nationalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nationalBtn.frame = CGRectMake((DeviceMaxWidth-300*frank)/2+150*frank, 10*frank, 150*frank, 30*frank);
    [nationalBtn setTitle:@"全国" forState:UIControlStateNormal];
    [nationalBtn setTitleColor:[lhColor colorFromHexRGB:mainColorStr] forState:UIControlStateNormal];
    nationalBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [nationalBtn setBackgroundImage:imageWithName(@"nationalImage_n") forState:UIControlStateNormal];
    [nationalBtn setBackgroundImage:imageWithName(@"nationalImage_y") forState:UIControlStateSelected];
    [nationalBtn addTarget:self action:@selector(clickNationalBtn:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:nationalBtn];
    
    UIImageView *imageV1 = [[UIImageView alloc] initWithFrame:CGRectMake(27.5*frank, (200*frank-60*frank)/2, 60*frank, 60*frank)];
    imageV1.layer.cornerRadius = 30*frank;
    imageV1.layer.masksToBounds = YES;
    [imageV1 setImage:imageWithName(@"twoHead")];
    imageV1.backgroundColor = [UIColor grayColor];
    [bgView addSubview:imageV1];
    
    UILabel *lable1 = [[UILabel alloc] initWithFrame:CGRectMake(39.5*frank, (200*frank-60*frank)/2+50*frank, 36*frank, 12*frank)];
    lable1.layer.cornerRadius = 7*frank;
    lable1.layer.masksToBounds = YES;
    lable1.text = @"NO.2";
    lable1.font = [UIFont systemFontOfSize:11];
    lable1.textAlignment = NSTextAlignmentCenter;
    lable1.textColor = [UIColor blackColor];
    lable1.backgroundColor = [UIColor yellowColor];
    lable1.layer.borderWidth = 1*frank;
    lable1.layer.borderColor = [[UIColor whiteColor] CGColor];
    [bgView addSubview:lable1];
    
    UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(0, (200*frank-60*frank)/2+65*frank, 55*frank+60*frank, 30*frank)];
    nameLab.text = @"优品学车";
    nameLab.font = [UIFont systemFontOfSize:13];
    nameLab.textAlignment = NSTextAlignmentCenter;
    nameLab.textColor = [UIColor whiteColor];
    [bgView addSubview:nameLab];
    
    UILabel *timeLab = [[UILabel alloc] initWithFrame:CGRectMake(0, (200*frank-60*frank)/2+85*frank, 55*frank+60*frank, 30*frank)];
    timeLab.text = @"考100分 3分01秒";
    timeLab.font = [UIFont systemFontOfSize:11];
    timeLab.textAlignment = NSTextAlignmentCenter;
    timeLab.textColor = [UIColor whiteColor];
    [bgView addSubview:timeLab];
    
    CGFloat space = (DeviceMaxWidth-120*frank-75*frank-55*frank)/2;
    
    UIImageView *imageV2 = [[UIImageView alloc] initWithFrame:CGRectMake(27.5*frank+60*frank+space, (200*frank-75*frank)/2, 75*frank, 75*frank)];
    imageV2.layer.cornerRadius = 37.5*frank;
    imageV2.backgroundColor = [UIColor grayColor];
    imageV2.layer.masksToBounds = YES;
    [imageV2 setImage:imageWithName(@"oneHead")];
    [bgView addSubview:imageV2];
    
    UILabel *lable2 = [[UILabel alloc] initWithFrame:CGRectMake(27.5*frank+60*frank+space+19.5*frank, (200*frank-75*frank)/2+65*frank, 36*frank, 12*frank)];
    lable2.layer.cornerRadius = 7*frank;
    lable2.layer.masksToBounds = YES;
    lable2.text = @"NO.1";
    lable2.font = [UIFont systemFontOfSize:11];
    lable2.textAlignment = NSTextAlignmentCenter;
    lable2.textColor = [UIColor blackColor];
    lable2.backgroundColor = [UIColor yellowColor];
    lable2.layer.borderWidth = 1*frank;
    lable2.layer.borderColor = [[UIColor whiteColor] CGColor];
    [bgView addSubview:lable2];
    
    UILabel *nameLab2 = [[UILabel alloc] initWithFrame:CGRectMake(100*frank, (200*frank-75*frank)/2+80*frank,(DeviceMaxWidth-200*frank), 30*frank)];
    nameLab2.text = @"优品学车";
    nameLab2.font = [UIFont systemFontOfSize:15];
    nameLab2.textAlignment = NSTextAlignmentCenter;
    nameLab2.textColor = [UIColor whiteColor];
    [bgView addSubview:nameLab2];
    
    UILabel *timeLab2 = [[UILabel alloc] initWithFrame:CGRectMake(100*frank, (200*frank-60*frank)/2+95*frank, (DeviceMaxWidth-200*frank), 30*frank)];
    timeLab2.text = @"考100分 3分00秒";
    timeLab2.font = [UIFont systemFontOfSize:13];
    timeLab2.textAlignment = NSTextAlignmentCenter;
    timeLab2.textColor = [UIColor whiteColor];
    [bgView addSubview:timeLab2];

    
    UIImageView *imageV3 = [[UIImageView alloc] initWithFrame:CGRectMake(DeviceMaxWidth-60*frank-27.5*frank, (200*frank-60*frank)/2, 60*frank, 60*frank)];
    imageV3.layer.cornerRadius = 30*frank;
    imageV3.layer.masksToBounds = YES;
    imageV3.backgroundColor = [UIColor grayColor];
    [imageV3 setImage:imageWithName(@"threeHead")];
    [bgView addSubview:imageV3];
    
    UILabel *lable3 = [[UILabel alloc] initWithFrame:CGRectMake(DeviceMaxWidth-60*frank-27.5*frank+12*frank,(200*frank-60*frank)/2+50*frank, 36*frank, 12*frank)];
    lable3.layer.cornerRadius = 7*frank;
    lable3.layer.masksToBounds = YES;
    lable3.text = @"NO.3";
    lable3.font = [UIFont systemFontOfSize:11];
    lable3.textAlignment = NSTextAlignmentCenter;
    lable3.textColor = [UIColor blackColor];
    lable3.backgroundColor = [UIColor yellowColor];
    lable3.layer.borderWidth = 1*frank;
    lable3.layer.borderColor = [[UIColor whiteColor] CGColor];
    [bgView addSubview:lable3];
    
    UILabel *nameLab3 = [[UILabel alloc] initWithFrame:CGRectMake(DeviceMaxWidth-55*frank-60*frank, (200*frank-60*frank)/2+65*frank, 55*frank+60*frank, 30*frank)];
    nameLab3.text = @"优品学车";
    nameLab3.font = [UIFont systemFontOfSize:13];
    nameLab3.textAlignment = NSTextAlignmentCenter;
    nameLab3.textColor = [UIColor whiteColor];
    [bgView addSubview:nameLab3];
    
    UILabel *timeLab3 = [[UILabel alloc] initWithFrame:CGRectMake(DeviceMaxWidth-55*frank-60*frank, (200*frank-60*frank)/2+85*frank, 55*frank+60*frank, 30*frank)];
    timeLab3.text = @"考100分 3分02秒";
    timeLab3.font = [UIFont systemFontOfSize:11];
    timeLab3.textAlignment = NSTextAlignmentCenter;
    timeLab3.textColor = [UIColor whiteColor];
    [bgView addSubview:timeLab3];
}

-(void)clickNationalBtn:(UIButton *)button_{
    if (button_.selected) {
        if (provinceBtn.selected) {
            button_.selected = NO;
        }
        
    }else{
        button_.selected = YES;
        if (provinceBtn.selected){
            provinceBtn.selected = NO;
        }
    }
    indexArray = @[@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"];
    nameArray = @[@"优品学员",@"给你一抹温柔",@"学车",@"eueir",@"sdfhdsk",@"sdufh",@"sdkjfh",@"sdkjk",@"hjsdfg"];
    timeArray = @[@"用时3分13秒",@"用时3分14秒",@"用时3分15秒",@"用时3分16秒",@"用时3分17秒",@"用时3分18秒",@"用时3分19秒",@"用时3分20秒",@"用时3分21秒"];
    [subjectListView reloadData];
}

-(void)clickProvinceBtn:(UIButton *)button_{
    if (button_.selected) {
        if (nationalBtn.selected) {
            button_.selected = NO;
        }
    }else{
        button_.selected = YES;
        if (nationalBtn.selected) {
            nationalBtn.selected = NO;
        }
    }
    indexArray = @[@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"];
    nameArray = @[@"dsk",@"se",@"dsfgsk",@"eueir",@"sdfhdsk",@"sdufh",@"sdkjfh",@"sdkjk",@"hjsdfg"];
    timeArray = @[@"用时3分13秒",@"用时3分14秒",@"用时3分15秒",@"用时3分16秒",@"用时3分17秒",@"用时3分18秒",@"用时3分19秒",@"用时3分20秒",@"用时3分21秒"];
    [subjectListView reloadData];
}

-(void)createTableView{
    subjectListView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+200*frank, DeviceMaxWidth, DeviceMaxHeight-64-200*frank) style:UITableViewStylePlain];
    subjectListView.delegate = self;
    subjectListView.dataSource = self;
    subjectListView.backgroundColor = [lhColor colorFromHexRGB:viewColorStr];
    subjectListView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:subjectListView];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    FrankSubjectListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[FrankSubjectListViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.lableForIndex.text = [indexArray objectAtIndex:indexPath.row];
    cell.lableForName.text = [nameArray objectAtIndex:indexPath.row];
    cell.lableForTime.text = [timeArray objectAtIndex:indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 9;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60*widthRate;
}

#pragma mark - view
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

@implementation FrankSubjectListViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier

{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _lableForIndex = [[UILabel alloc] initWithFrame:CGRectMake(20*widthRate, 20*widthRate, 20*widthRate, 20*widthRate)];
        _lableForIndex.textAlignment = NSTextAlignmentCenter;
        _lableForIndex.font = [UIFont systemFontOfSize:15];
        _lableForIndex.textColor = [lhColor colorFromHexRGB:blueColorStr];
        [self addSubview:_lableForIndex];
        
        _imageForStudents = [[UIImageView alloc] initWithFrame:CGRectMake(50*widthRate, 10*widthRate, 40*widthRate, 40*widthRate)];
//        _imageForStudents.layer.borderWidth = 0.5;
//        _imageForStudents.layer.cornerRadius = 25*widthRate;
        _imageForStudents.layer.borderColor = [[UIColor clearColor] CGColor];
        [_imageForStudents setImage:[UIImage imageNamed:@"defaultHead"]];
        [self addSubview:_imageForStudents];
        
        _lableForName = [[UILabel alloc] initWithFrame:CGRectMake(110*widthRate, 10*widthRate, DeviceMaxWidth-110*widthRate, 20*widthRate)];
        _lableForName.text = @"婷婷";
        _lableForName.font = [UIFont systemFontOfSize:15];
        _lableForName.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
        [self addSubview:_lableForName];
        
        _lableForTime = [[UILabel alloc] initWithFrame:CGRectMake(110*widthRate, 30*widthRate, DeviceMaxWidth-110, 20*widthRate)];
        _lableForTime.text = @"用时47秒";
        _lableForTime.font = [UIFont systemFontOfSize:12.0f];
        _lableForTime.textColor = [lhColor colorFromHexRGB:contentTitleColorStr1];
        [self addSubview:_lableForTime];
        
        _lableForScore = [[UILabel alloc] initWithFrame:CGRectMake(DeviceMaxWidth-80*widthRate, 20*widthRate, 50*widthRate, 20*widthRate)];
        _lableForScore.text = @"100分";
        _lableForScore.font = [UIFont systemFontOfSize:15];
        _lableForScore.textColor = [UIColor redColor];
        [self addSubview:_lableForScore];
    }
    return self;
}

@end


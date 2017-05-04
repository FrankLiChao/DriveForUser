//
//  lhSelectCityViewController.m
//  Drive
//
//  Created by bosheng on 15/8/5.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import "lhSelectCityViewController.h"
#import "lhCityTableViewCell.h"
#import "lhHotCityTableViewCell.h"

#import "PinYin4Objc.h"

@interface lhSelectCityViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSString * cityStr;
    
    UIScrollView * maxScrollView;
    UITableView * cityTableView;//显示城市
    UITableView * schTableView;//搜索显示城市名字
    
    UITextField * searchTextField;
    UIButton * searchBtn;
    
    NSMutableDictionary * cities;
    NSMutableArray * keys;
    NSMutableArray * arrayHotCity;
    NSMutableArray * arrayCitys;
    
    NSMutableArray * allCityArray;//全部城市名字数组
    NSMutableArray * searchArray;//搜索结果数组
    NSMutableArray * pinYinAllArray;
    NSMutableString * searchStr;
    
    UILabel * cLabel;//定位城市显示
}

@end

@implementation lhSelectCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[lhColor shareColor]originalInit:self title:@"选择城市" imageName:nil backButton:YES];
    
    arrayHotCity = [NSMutableArray arrayWithObjects:@"成都",@"北京",@"天津",@"西安",@"重庆",@"沈阳",@"青岛",@"深圳",@"长沙", nil];
    keys = [NSMutableArray array];
    arrayCitys = [NSMutableArray array];
    searchArray = [NSMutableArray array];
    pinYinAllArray = [NSMutableArray array];
    searchStr = [NSMutableString string];
    
    [self firmInit];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - firmInit
- (void)firmInit
{

    [[lhColor shareColor]locationCity:^(NSString *city) {
        
        cityStr = [[lhColor shareColor] city:city];
        
        cLabel.text = cityStr;
    }];
    
    maxScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, DeviceMaxWidth, DeviceMaxHeight-64)];
    maxScrollView.showsVerticalScrollIndicator = NO;
    maxScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:maxScrollView];
    
    searchTextField = [[UITextField alloc]initWithFrame:CGRectMake(25*widthRate, 10*widthRate, 244*widthRate, 30*widthRate)];
    searchTextField.delegate = self;
    searchTextField.clearButtonMode = UITextFieldViewModeAlways;
    searchTextField.returnKeyType = UIReturnKeySearch;
//    searchTextField.background = imageWithName(@"appSearchText");
    searchTextField.layer.borderColor = [lhColor colorFromHexRGB:lineColorStr].CGColor;
    searchTextField.layer.borderWidth = 0.8;
    searchTextField.textAlignment = NSTextAlignmentCenter;
    searchTextField.placeholder = @"输入城市名称查询";
    searchTextField.font = [UIFont fontWithName:fontName size:14];
    [maxScrollView addSubview:searchTextField];
    
    UIImage * searchImg = imageWithName(@"appSearchIcon");
    searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setBackgroundImage:searchImg forState:UIControlStateNormal];
    searchBtn.frame = CGRectMake(269*widthRate, 10*widthRate, 30*widthRate, 30*widthRate);
    [searchBtn setBackgroundImage:searchImg forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    [maxScrollView addSubview:searchBtn];
    
    CGFloat heih = 45*widthRate;
    
    UILabel * nLabel = [[UILabel alloc]initWithFrame:CGRectMake(25*widthRate, heih, 200, 20*widthRate)];
    nLabel.textColor = [lhColor colorFromHexRGB:@"3598dc"];
    nLabel.font = [UIFont fontWithName:fontName size:14];
    nLabel.text = @"当前定位城市";
    [maxScrollView addSubview:nLabel];
    
    heih += 28*widthRate;
    
    UITapGestureRecognizer * locationTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(locationTapEvent)];
    UIImageView * hImg = [[UIImageView alloc]initWithFrame:CGRectMake(25*widthRate, heih, 67*widthRate, 24*widthRate)];
    hImg.userInteractionEnabled = YES;
    [hImg addGestureRecognizer:locationTap];
    hImg.image = imageWithName(@"hotCityBg");
    [maxScrollView addSubview:hImg];
    
    
    UIImageView * lImg = [[UIImageView alloc]initWithFrame:CGRectMake(5*widthRate, 4*widthRate, 11*widthRate, 16*widthRate)];
    lImg.image = imageWithName(@"nowAddressLocation");
    [hImg addSubview:lImg];
    
    cLabel = [[UILabel alloc]initWithFrame:CGRectMake(17*widthRate, 2*widthRate, 48*widthRate, 20*widthRate)];
    cLabel.textAlignment = NSTextAlignmentCenter;
    cLabel.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
    cLabel.font = [UIFont fontWithName:fontName size:14];
    cLabel.text = cityStr;
    [hImg addSubview:cLabel];
    
    heih += 34*widthRate;
    
    UIView * lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, heih, DeviceMaxWidth, 7*widthRate)];
    lineView1.backgroundColor = [lhColor colorFromHexRGB:viewColorStr];
    [maxScrollView addSubview:lineView1];
    
    NSString *path=[[NSBundle mainBundle] pathForResource:@"citydict"
                                                   ofType:@"plist"];
    cities = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    
    [keys addObjectsFromArray:[[cities allKeys] sortedArrayUsingSelector:@selector(compare:)]];
    
    for (NSString * city in keys) {
        NSArray * temA = [cities objectForKey:city];
        for (NSString * c in temA) {
            [pinYinAllArray addObject:[self nameToPinYinWith:c]];
        }
        [searchArray addObjectsFromArray:temA];
    }

    allCityArray = [NSMutableArray arrayWithArray:searchArray];
    
    //添加热门城市
    NSString * strHot = @"热";
    [keys insertObject:strHot atIndex:0];
    [cities setObject:arrayHotCity forKey:strHot];

    cityTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, heih + 7*widthRate, DeviceMaxWidth, CGRectGetHeight(maxScrollView.frame)-7*widthRate-heih) style:UITableViewStylePlain];
    cityTableView.sectionIndexColor = [lhColor colorFromHexRGB:mainColorStr];
    cityTableView.separatorColor = [UIColor clearColor];
    cityTableView.backgroundColor = [UIColor clearColor];
    cityTableView.delegate = self;
    cityTableView.dataSource = self;
    [maxScrollView addSubview:cityTableView];
    
    schTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, DeviceMaxHeight, DeviceMaxWidth, CGRectGetHeight(maxScrollView.frame)-7*widthRate-heih) style:UITableViewStylePlain];
    schTableView.separatorColor = [UIColor clearColor];
    schTableView.backgroundColor = [UIColor whiteColor ];
    schTableView.delegate = self;
    schTableView.dataSource = self;
    [maxScrollView addSubview:schTableView];
    
}

#pragma mark - UITabelViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == cityTableView && indexPath.section == 0) {
        if (indexPath.section > 0) {
            
            return;
        }
    }

    lhCityTableViewCell * cCell = (lhCityTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [lhColor shareColor].nowCityStr = cCell.cityLabel.text;
    [[NSUserDefaults standardUserDefaults] setObject:[lhColor shareColor].nowCityStr forKey:saveLocalCityName];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self.navigationController popViewControllerAnimated:YES];
   
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == cityTableView) {
        if (indexPath.section == 0) {
            return 120*widthRate;
        }
        else{
            return 40*widthRate;
        }
        
    }
    else if(tableView == schTableView){
        return 40*widthRate;
    }
    
    return 40*widthRate;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == cityTableView) {

        return [keys count];
    }
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == cityTableView) {
        return 20*widthRate;
    }
    
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == cityTableView) {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 20*widthRate)];
        bgView.backgroundColor = [UIColor whiteColor];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(25*widthRate, 0, 250*widthRate, 20*widthRate)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [lhColor colorFromHexRGB:lineColorStr];
        titleLabel.font = [UIFont boldSystemFontOfSize:13];
        
        NSString *key = [keys objectAtIndex:section];
        if ([key rangeOfString:@"热"].location != NSNotFound) {
            titleLabel.text = @"热门城市";
        }
        else{
            titleLabel.text = key;
        }
        [bgView addSubview:titleLabel];
        
        return bgView;
    }
    
    return nil;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView == cityTableView) {
        return keys;
    }
    return @[];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == cityTableView) {
        if (section == 0) {
            return 1;
        }

        NSString *key = [keys objectAtIndex:section];
        NSArray *citySection = [cities objectForKey:key];
        
        return [citySection count];
    }
    else if(tableView == schTableView){
        
        
        
        return searchArray.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == cityTableView) {
        
        NSString * key = [keys objectAtIndex:indexPath.section];
        NSString * cityS = [[cities objectForKey:key] objectAtIndex:indexPath.row];
        if (indexPath.section == 0) {
            lhHotCityTableViewCell * hcCell = [[lhHotCityTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"hh"];
            for (int i = 0; i < 9; i++) {
                UIButton * hotBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                hotBtn.tag = i;
                hotBtn.layer.cornerRadius = 4;
                hotBtn.layer.masksToBounds = YES;
                hotBtn.titleLabel.font = [UIFont fontWithName:fontName size:14];
                [hotBtn setTitleColor:[lhColor colorFromHexRGB:contentTitleColorStr1] forState:UIControlStateNormal];
                [hotBtn setTitle:[[cities objectForKey:key] objectAtIndex:i] forState:UIControlStateNormal];
                hotBtn.frame = CGRectMake(25*widthRate+95*widthRate*(i%3), 9*widthRate+i/3*36*widthRate, 70*widthRate, 25*widthRate);
                hotBtn.backgroundColor = [lhColor colorFromHexRGB:viewColorStr];
                [hotBtn addTarget:self action:@selector(hotBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
                [hcCell addSubview:hotBtn];
            }
            
            return hcCell;
        }
        else{
            static NSString * cityInd = @"cityInd";
            lhCityTableViewCell * ctCell = [tableView dequeueReusableCellWithIdentifier:cityInd];
            
            if (ctCell == nil) {
                ctCell = [[lhCityTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cityInd];
            }
            
            ctCell.cityLabel.text = cityS;
            
            
            return ctCell;
        }
    }
    else if(tableView == schTableView){
        static NSString * cityInd = @"cityIndSearch";
        lhCityTableViewCell * ctCell = [tableView dequeueReusableCellWithIdentifier:cityInd];
        
        if (ctCell == nil) {
            ctCell = [[lhCityTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cityInd];
        }
        
        ctCell.cityLabel.text = [searchArray objectAtIndex:indexPath.row];
        
        
        return ctCell;
    }
    
    return nil;
}

#pragma mark - 热门城市
- (void)hotBtnEvent:(UIButton *)button_
{
    NSLog(@"选择热门城市 %ld",(long)button_.tag);
    
    [lhColor shareColor].nowCityStr = [arrayHotCity objectAtIndex:button_.tag];
    [[NSUserDefaults standardUserDefaults] setObject:[lhColor shareColor].nowCityStr forKey:saveLocalCityName];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - 选择定位城市
- (void)locationTapEvent
{
    NSLog(@"选择城市");
    [lhColor shareColor].nowCityStr = cityStr;
    [[NSUserDefaults standardUserDefaults] setObject:[lhColor shareColor].nowCityStr forKey:saveLocalCityName];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
//    if ([@"" isEqualToString:string]) {
//        if (searchStr.length > 0) {
//            searchStr = [NSMutableString stringWithString:[searchStr substringToIndex:searchStr.length-1]];
//        }
//        else{
//            searchStr = [NSMutableString stringWithString:@""];
//        }
//    }
//    else{
//        [searchStr appendString:string];
//    }
    
    [self performSelector:@selector(textFieldChange1) withObject:nil afterDelay:0.1];
    
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.3 animations:^{
        schTableView.frame = CGRectMake(0, 40*widthRate, DeviceMaxWidth, CGRectGetHeight(maxScrollView.frame)-40*widthRate);
    }];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    searchStr = [NSMutableString stringWithString:[self nameToPinYinWith:searchTextField.text]];
    [self search:searchTextField.text];
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    NSLog(@"clear?");
    
    [self performSelector:@selector(searchDisAppear) withObject:nil afterDelay:0.1];
    
    return YES;
}

- (void)searchDisAppear
{
    searchTextField.text = @"";
    searchStr = [NSMutableString stringWithString:@""];
    [searchTextField resignFirstResponder];
    
    [UIView animateWithDuration:0.3 animations:^{
        schTableView.frame = CGRectMake(0, DeviceMaxHeight, DeviceMaxWidth, CGRectGetHeight(maxScrollView.frame)-40*widthRate);
    }];
    
}

- (NSString *)nameToPinYinWith:(NSString *)name
{
    HanyuPinyinOutputFormat *outputFormat=[[HanyuPinyinOutputFormat alloc] init];
    [outputFormat setToneType:ToneTypeWithoutTone];
    [outputFormat setVCharType:VCharTypeWithV];
    [outputFormat setCaseType:CaseTypeLowercase];
    NSString *outputPinyin=[PinyinHelper toHanyuPinyinStringWithNSString:name withHanyuPinyinOutputFormat:outputFormat withNSString:@""];
    
    return outputPinyin;
}

#pragma mark - 
- (void)textFieldChange1
{
    searchStr = [NSMutableString stringWithString:searchTextField.text];
    
    [self search:searchStr];
}

#pragma mark - 搜索
- (void)searchBtnEvent
{
    NSLog(@"搜索");
    searchStr = [NSMutableString stringWithString:[self nameToPinYinWith:searchTextField.text]];
    [self search:searchTextField.text];
    
}

//点击搜索
- (void)search2
{
    if ([@"" isEqualToString:searchTextField.text]) {
        
        searchArray = allCityArray;
        [lhColor removeNullLabelWithSuperView:schTableView];
        [schTableView reloadData];
        
        return;
    }
    
    NSMutableArray * tempArray = [NSMutableArray array];
    for (int i = 0; i < allCityArray.count; i++) {
        if ([[allCityArray objectAtIndex:i] hasPrefix:searchTextField.text]) {//搜索到结果
            [tempArray addObject:[allCityArray objectAtIndex:i]];
        }
    }
    
    searchArray = tempArray;
    
    if (searchArray && searchArray.count > 0) {
        [lhColor removeNullLabelWithSuperView:schTableView];
    }
    else{
        [lhColor addANullLabelWithSuperView:schTableView withFrame:CGRectMake(0, 70*widthRate, DeviceMaxWidth, 20*widthRate) withText:@"无搜索结果"];
    }
    
    [schTableView reloadData];
}

//自动搜索
- (void)search:(NSString *)str
{
    if ([@"" isEqualToString:str]) {
        
        searchArray = allCityArray;
        [lhColor removeNullLabelWithSuperView:schTableView];
        [schTableView reloadData];
        
        return;
    }
    
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF BEGINSWITH %@",[self nameToPinYinWith:str]];
    
    NSArray * pyNowArray = [pinYinAllArray filteredArrayUsingPredicate:pred];

    NSMutableArray * tempArray = [NSMutableArray array];
    for (int i = 0; i < pinYinAllArray.count; i++) {
        for (NSString * c in pyNowArray){
            if ([c isEqualToString:[pinYinAllArray objectAtIndex:i]]) {//搜索到结果
                [tempArray addObject:[allCityArray objectAtIndex:i]];
            }
        }
    }
    
    searchArray = tempArray;
    
    if (searchArray && searchArray.count > 0) {
        [lhColor removeNullLabelWithSuperView:schTableView];
    }
    else{
        [lhColor addANullLabelWithSuperView:schTableView withFrame:CGRectMake(0, 70*widthRate, DeviceMaxWidth, 20*widthRate) withText:@"无搜索结果"];
    }
    
    [schTableView reloadData];
    
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

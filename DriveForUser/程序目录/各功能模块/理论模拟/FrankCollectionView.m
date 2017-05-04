//
//  CollectionView.m
//  PracticeSimulation
//
//  Created by lichao on 15/7/23.
//  Copyright (c) 2015年 LiFrank. All rights reserved.
//

#import "FrankCollectionView.h"
#import "FrankCollectionViewCell.h"
#import "FrankPracticeView.h"
#import "Practice.h"

@interface FrankCollectionView ()

@end

@implementation FrankCollectionView

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initFrameView];
}

-(void)initFrameView{
    for (int i=0; i<[_cellDataForArry count]; i++) {
        if (((Practice *)_cellDataForArry[i]).answerRecord > 0) {
            if (((Practice *)_cellDataForArry[i]).testAnswer == ((Practice *)_cellDataForArry[i]).answerRecord) {
                countRight++;
            }else{
                countWrong++;
            }
        }
    }
    practice = [[Practice alloc] init];
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, DeviceMaxHeight)];
    bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [self.view addSubview:bgView];
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, DeviceMaxWidth, 50*widthRate)];
    titleView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:titleView];
    
    CGFloat widthX = 10*widthRate;
    
    rAnswer = [[UILabel alloc] initWithFrame:CGRectMake(widthX, 15*widthRate, 70*widthRate, 20*widthRate)];
    rAnswer.text = @"答对 ";
    rAnswer.font = [UIFont systemFontOfSize:13];
    rAnswer.textColor = [UIColor greenColor];
    [titleView addSubview:rAnswer];
    
    widthX += rAnswer.frame.size.width+10*widthRate;
    
    wAnswer = [[UILabel alloc] initWithFrame:CGRectMake(widthX, 15*widthRate, 70*widthRate, 20*widthRate)];
    wAnswer.text = @"答错 ";
    wAnswer.font = [UIFont systemFontOfSize:13];
    wAnswer.textColor = [UIColor redColor];
    [titleView addSubview:wAnswer];
    
    self.returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.returnBtn.frame = CGRectMake(DeviceMaxWidth-60*widthRate, 0, 50*widthRate, 50*widthRate);
//    [self.returnBtn setTitle:@"返回" forState:UIControlStateNormal];
    [self.returnBtn setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [self.returnBtn setTitleColor:[lhColor colorFromHexRGB:mainColorStr] forState:UIControlStateNormal];
    self.returnBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    
    [titleView addSubview:self.returnBtn];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 49.5*widthRate, DeviceMaxWidth, 0.5*widthRate)];
    lineView.backgroundColor = [lhColor colorFromHexRGB:contentTitleColorStr1];
    [titleView addSubview:lineView];
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64+50*widthRate, DeviceMaxWidth, DeviceMaxHeight-64-50*widthRate) collectionViewLayout:flowLayout];
    [_collectionView registerClass:[FrankCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:_collectionView];
}

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.delegate.datacount;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    return 0;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"cell";
    FrankCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    practice = self.cellDataForArry[indexPath.row];
    if (practice.answerRecord>0) {
        if (practice.testAnswer == practice.answerRecord) {
            cell.btnForSelectCell.backgroundColor = [UIColor greenColor];
        }else {
            cell.btnForSelectCell.backgroundColor = [UIColor orangeColor];
        }
    }else{
        cell.btnForSelectCell.backgroundColor = [UIColor whiteColor];
    }
    rAnswer.text = [NSString stringWithFormat:@"答对 %ld",countRight];
    wAnswer.text = [NSString stringWithFormat:@"答错 %ld",countWrong];
    cell.btnForSelectCell.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row+1];
    
    return cell;
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(40*widthRate, 40*widthRate);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5*widthRate, 5*widthRate, 5*widthRate, 5*widthRate);
}

//定义每个UICollectionView 横向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

////定义每个UICollectionView 纵向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate hideCollectionView];
    self.delegate.swipeRight = NO;
    [self.delegate nextPageControl:[NSNumber numberWithInteger:indexPath.row+1]];
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

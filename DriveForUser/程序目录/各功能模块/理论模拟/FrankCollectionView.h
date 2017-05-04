//
//  CollectionView.h
//  PracticeSimulation
//
//  Created by lichao on 15/7/23.
//  Copyright (c) 2015年 LiFrank. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FrankPracticeView;
@class Practice;

@interface FrankCollectionView : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>{
    UICollectionView    *_collectionView;
    Practice            *practice;
    UILabel             *rAnswer;       //回答正确
    UILabel             *wAnswer;       //回答错误
    NSInteger           countRight;     //答对的个数
    NSInteger           countWrong;     //答错得个数
}
@property(strong,nonatomic)FrankPracticeView *delegate;
@property (nonatomic,strong)UIButton *returnBtn;
@property (nonatomic,strong)NSArray  *cellDataForArry;

@end

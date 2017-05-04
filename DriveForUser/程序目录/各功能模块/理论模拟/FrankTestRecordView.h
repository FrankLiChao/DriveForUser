//
//  FrankTestRecordView.h
//  Drive
//
//  Created by lichao on 15/8/3.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FrankTestRecordView : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    NSInteger cellCount;
    NSMutableArray *rootArray;
}

@property (nonatomic,assign)NSInteger subType;          //表示科目（0：表示科目一  1：表示科目二）

@end

@interface FrankTestRecordViewCell : UITableViewCell{
}
@property (nonatomic,strong)UILabel  *recordIndex;      //记录的序号
@property (nonatomic,strong)UILabel  *recordScore;      //考试的分数
@property (nonatomic,strong)UILabel  *recordTime;       //考试的时间
@property (nonatomic,strong)UIButton *checkWrong;       //查看错题按钮


@end


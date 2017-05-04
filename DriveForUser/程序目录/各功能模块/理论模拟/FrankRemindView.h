//
//  FrankRemindView.h
//  Drive
//
//  Created by lichao on 15/8/26.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FrankRemindView : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    UIImageView *headImage;
    UILabel     *nameLable;
    NSArray *nameForTab;
    NSArray *contentForTab;
}

@property (nonatomic,assign)NSInteger subType;      //表示科目（0：表示科目一  1：表示科目四）


@end

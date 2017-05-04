//
//  lhWriteViewController.h
//  Drive
//
//  Created by bosheng on 15/7/31.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface lhWriteViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    UITableView *myTableView;
    UIImageView *zanImage;
    UIImageView *commentImage;
}

@property (nonatomic,strong)UILabel *countZan;
@property (nonatomic,strong)UILabel *countComment;
@property (nonatomic,strong)NSDictionary *topicDic;
@property (nonatomic,assign)NSInteger commentMark;


@end

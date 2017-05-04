//
//  FrankSchoolDetailView.h
//  Drive
//
//  Created by lichao on 15/8/6.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TQStarRatingView.h"

@interface FrankSchoolDetailView : UIViewController<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>{
    UIScrollView *myScrollView;
    UIImageView     *schoolImage; //驾校图片
    UILabel      *schoolName;  //驾校名称
    UILabel      *schoolType;  //驾校等级
    TQStarRatingView    *starImgView; //驾校的星
    UILabel      *stuName;       //学员名称数量
    UILabel      *schoolPhone;  //驾校电话
    UILabel      *schoolAddr;  //驾校地址
    UITableView  *stuComments;
    NSDictionary *schoolDic;
}

//@property(nonatomic,retain)NSDictionary *schDic;
@property(nonatomic,retain)NSString *schoolID;

@end

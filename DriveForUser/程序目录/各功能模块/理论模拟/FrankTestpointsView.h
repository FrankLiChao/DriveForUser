//
//  FrankTestpointsView.h
//  Drive
//
//  Created by lichao on 15/8/3.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FrankTestpointsView : UIViewController<UITableViewDataSource,UITableViewDelegate>

@end

@interface FrankTestpointsViewCell : UITableViewCell{

}
@property(nonatomic,strong)UILabel *lableForIndex;
@property(nonatomic,strong)UILabel *lableForPointsName;
@property(nonatomic,strong)UILabel *lableForPointIntroduce;

@end


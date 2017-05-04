//
//  FrankTestskillView.h
//  Drive
//
//  Created by lichao on 15/7/31.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FrankTestskillView : UIViewController<UITableViewDelegate,UITableViewDataSource>{


}

@end

@interface FrankTestskillViewCell : UITableViewCell{

    
}
@property(nonatomic,strong)UILabel *indexLabel;
@property(nonatomic,strong)UILabel *skillTitle;
@property(nonatomic,strong)UILabel *skillintroduce;

@end
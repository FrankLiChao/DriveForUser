//
//  FrankWriteTopic.h
//  Drive
//
//  Created by lichao on 15/12/28.
//  Copyright © 2015年 bosheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "lhDriTestCirViewController.h"
#import "FrankTopicsView.h"

@interface FrankWriteTopic : UIViewController

@property (nonatomic,strong)NSArray *categoryArray;
@property (nonatomic,strong)lhDriTestCirViewController *delegate;
@property (nonatomic,strong)FrankTopicsView *topicDelegate;
@property (nonatomic,assign)NSInteger vcType;

@end

//
//  lhQuestionListViewController.h
//  GasStation
//
//  Created by bosheng on 16/2/22.
//  Copyright © 2016年 bosheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface lhQuestionListViewController : UIViewController

@property (nonatomic,assign)NSInteger type;//type=5,常见问题，else类别问题
@property (nonatomic,strong)NSString * titleStr;//标题
@property (nonatomic,strong)NSString * typeIdStr;

@end

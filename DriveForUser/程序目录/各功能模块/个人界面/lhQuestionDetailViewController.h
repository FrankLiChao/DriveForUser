//
//  lhQuestionDetailViewController.h
//  GasStation
//
//  Created by bosheng on 16/2/22.
//  Copyright © 2016年 bosheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NJKWebViewProgress.h"

@interface lhQuestionDetailViewController : UIViewController<NJKWebViewProgressDelegate>

@property (nonatomic,strong)NSString * questionIdStr;

@end

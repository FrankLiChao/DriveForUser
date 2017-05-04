//
//  lhUserProtocolViewController.h
//  GasStation
//
//  Created by bosheng on 15/11/9.
//  Copyright © 2015年 bosheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NJKWebViewProgress.h"

@interface lhUserProtocolViewController : UIViewController<UIWebViewDelegate,NJKWebViewProgressDelegate>

@property (nonatomic,assign)NSInteger type;
@property (nonatomic,strong)NSString * urlStr;

@end

//
//  FrankWebView.h
//  Drive
//
//  Created by lichao on 15/11/10.
//  Copyright © 2015年 bosheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NJKWebViewProgress.h"

@interface FrankWebView : UIViewController<NJKWebViewProgressDelegate>

@property (nonatomic,strong)NSString *myWebUrl;
@property (nonatomic,strong)NSString *nameStr;

@end

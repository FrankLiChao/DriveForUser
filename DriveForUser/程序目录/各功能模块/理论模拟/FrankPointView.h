//
//  FrankPointView.h
//  Drive
//
//  Created by lichao on 15/8/5.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FrankPointView : UIViewController<UIScrollViewDelegate>{
    UILabel *textForLable1;
    UIScrollView *scrollView;
}

@property NSInteger pointForIndex;

@end

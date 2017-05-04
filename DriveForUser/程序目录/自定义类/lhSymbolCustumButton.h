//
//  lhSymbolCustumButton.h
//  Drive
//
//  Created by bosheng on 15/7/29.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface lhSymbolCustumButton : UIButton

@property (nonatomic,strong)UILabel * tLabel;
@property (nonatomic,strong)UIImageView  *titView;
@property (nonatomic,strong)UILabel  *titLable;
@property (nonatomic,strong)UIButton * imgBtn;//图片

- (instancetype)initWithFrame1:(CGRect)frame;
- (instancetype)initWithFrame2:(CGRect)frame;
- (instancetype)initWithFrankFrame:(CGRect)frame;
-(instancetype)initWithFrankFrame1:(CGRect)frame;
@end

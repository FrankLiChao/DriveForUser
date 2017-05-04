//
//  TQStarRatingView.h
//  TQStarRatingView
//
//  Created by fuqiang on 13-8-28.
//  Copyright (c) 2013年 TinyQ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TQStarRatingView;

@protocol StarRatingViewDelegate <NSObject>

@optional
-(void)starRatingView:(TQStarRatingView *)view score:(float)score;

@end

@interface TQStarRatingView : UIView

- (id)initWithFrame:(CGRect)frame numberOfStar:(int)number distance:(CGFloat)distance HeiDistance:(CGFloat)hd;
@property (nonatomic, readonly) int numberOfStar;
@property (nonatomic, assign) CGFloat number;
@property (nonatomic, weak) id <StarRatingViewDelegate> delegate;

@end

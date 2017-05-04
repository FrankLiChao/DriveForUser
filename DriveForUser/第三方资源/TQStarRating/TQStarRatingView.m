//
//  TQStarRatingView.m
//  TQStarRatingView
//
//  Created by fuqiang on 13-8-28.
//  Copyright (c) 2013年 TinyQ. All rights reserved.
//

#import "TQStarRatingView.h"

#define maxScoreCount 5.0

@interface TQStarRatingView ()

@property (nonatomic, strong) UIView *starBackgroundView;
@property (nonatomic, strong) UIView *starForegroundView;

@property (nonatomic, assign)CGFloat distance;
@property (nonatomic, assign)CGFloat heiDistance;

@end

@implementation TQStarRatingView

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame numberOfStar:5 distance:0.0 HeiDistance:0.0];
}

- (id)initWithFrame:(CGRect)frame numberOfStar:(int)number distance:(CGFloat)distance HeiDistance:(CGFloat)hd
{
    self = [super initWithFrame:frame];
    if (self) {
        _numberOfStar = number;
        _distance = distance;
        _heiDistance = hd;
        
        self.starBackgroundView = [self buidlStarViewWithImageName:@"bt_star_a"];
        self.starForegroundView = [self buidlStarViewWithImageName:@"bt_star_b"];
        [self addSubview:self.starBackgroundView];
        [self addSubview:self.starForegroundView];
        
    }
    return self;
}

//- (void)swipGestureEvent:(UIGestureRecognizer *)swipG
//{
//    if(swipG.state == UIGestureRecognizerStateChanged){
//        CGPoint point = [swipG locationInView:self];
//        CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
//        point.x += 40*widthRate;
//        if (point.x > self.frame.size.width) {
//            point.x = self.frame.size.width;
//        }
//        if(CGRectContainsPoint(rect,point))
//        {
//            [self changeStarForegroundViewWithPoint:point];
//        }
//    }
//    else if(swipG.state == UIGestureRecognizerStateEnded){
//        CGPoint point = [swipG locationInView:self];
//        __weak TQStarRatingView * weekSelf = self;
//        
//        [UIView transitionWithView:self.starForegroundView
//                          duration:0.2
//                           options:UIViewAnimationOptionCurveEaseInOut
//                        animations:^
//         {
//             [weekSelf changeStarForegroundViewWithPoint:point];
//         }
//                        completion:^(BOOL finished)
//         {
//             
//         }];
//    }
//    
//}
//
//- (void)tapGestureEvent:(UITapGestureRecognizer *)tapG
//{
//    if(tapG.state == UIGestureRecognizerStateChanged){
//        CGPoint point = [tapG locationInView:self];
//        CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
//        point.x += 40*widthRate;
//        if (point.x > self.frame.size.width) {
//            point.x = self.frame.size.width;
//        }
//        if(CGRectContainsPoint(rect,point))
//        {
//            [self changeStarForegroundViewWithPoint:point];
//        }
//    }
//    else if(tapG.state == UIGestureRecognizerStateEnded){
//        CGPoint point = [tapG locationInView:self];
//        __weak TQStarRatingView * weekSelf = self;
//        
//        [UIView transitionWithView:self.starForegroundView
//                          duration:0.2
//                           options:UIViewAnimationOptionCurveEaseInOut
//                        animations:^
//         {
//             [weekSelf changeStarForegroundViewWithPoint:point];
//         }
//                        completion:^(BOOL finished)
//         {
//             
//         }];
//    }
//}

- (UIView *)buidlStarViewWithImageName:(NSString *)imageName
{
    CGRect frame = self.bounds;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.clipsToBounds = YES;

    for (int i = 0; i < self.numberOfStar; i ++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:imageWithName(imageName)];
        CGFloat wid = (frame.size.width-(self.numberOfStar-1)*_distance)/self.numberOfStar;
        imageView.frame = CGRectMake(i * (wid+_distance), _heiDistance, wid, frame.size.height-2*_heiDistance);
        [view addSubview:imageView];
    }
    return view;
}

- (void)changeStarForegroundViewWithPoint:(CGPoint)point
{
    CGPoint p = point;
    
    if (p.x < 0)
    {
        p.x = 0;
    }
    else if (p.x > self.frame.size.width)
    {
        p.x = self.frame.size.width;
    }
    
    NSString * str = [NSString stringWithFormat:@"%0.2f",p.x / self.frame.size.width];
    float score = [str floatValue];
    p.x = score * self.frame.size.width;
    self.starForegroundView.frame = CGRectMake(0, 0, p.x, self.frame.size.height);
    
    _number = score*maxScoreCount;
    if(self.delegate && [self.delegate respondsToSelector:@selector(starRatingView: score:)])
    {
        [self.delegate starRatingView:self score:score*maxScoreCount];
    }
}

- (void)setNumber:(CGFloat)number
{
    _number = number;
    CGFloat wid = (CGRectGetWidth(self.frame)-(self.numberOfStar-1)*_distance)/self.numberOfStar;
    CGPoint p = CGPointMake(wid*number+((int)number)*_distance, 0);
    [self changeStarForegroundViewWithPoint:p];
    
}

@end

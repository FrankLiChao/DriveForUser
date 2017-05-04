//
//  UIScrollView+FrankScrollerView_touch.m
//  Drive
//
//  Created by lichao on 16/1/19.
//  Copyright © 2016年 bosheng. All rights reserved.
//

#import "UIScrollView+FrankScrollerView_touch.h"

@implementation UIScrollView (FrankScrollerView_touch)

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self nextResponder] touchesBegan:touches withEvent:event];
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self nextResponder] touchesEnded:touches withEvent:event];
    [super touchesEnded:touches withEvent:event];
}
@end

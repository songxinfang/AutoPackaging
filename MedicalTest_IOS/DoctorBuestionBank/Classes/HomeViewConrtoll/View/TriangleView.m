//
//  TriangleView.m
//  GradeTabDemo
//
//  Created by A053 on 16/10/10.
//  Copyright © 2016年 Yvan. All rights reserved.
//

#import "TriangleView.h"

@implementation TriangleView
{
    CGFloat w;
    CGFloat h;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextMoveToPoint(context, w/2, 0);
    CGContextAddLineToPoint(context, 0, h);
    CGContextAddLineToPoint(context, w, h);
    CGContextFillPath(context);
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        w = self.frame.size.width;
        h = self.frame.size.height;
    }
    return self;
}

@end

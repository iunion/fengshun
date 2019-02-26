//
//  FSCameraGridView.m
//  fengshun
//
//  Created by Aiwei on 2019/2/26.
//  Copyright © 2019年 FS. All rights reserved.
//

#import "FSCameraGridView.h"


#define kMarginX 10.0f
#define kMarginY 15.0f
#define kLineWidth 1.0f
#define kLineColor [UIColor whiteColor]

@implementation FSCameraGridView
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGFloat width = CGRectGetWidth(rect);
    CGFloat height = CGRectGetHeight(rect);
    
    UIColor *color = kLineColor;
    [color set]; //设置线条颜色
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineWidth = kLineWidth;
    
    
    //竖1
    [path moveToPoint:CGPointMake(width/3, kMarginY)];
    [path addLineToPoint:CGPointMake(width/3, height - kMarginY)];
    
    //竖2
    [path moveToPoint:CGPointMake(width/3 *2, kMarginY)];
    [path addLineToPoint:CGPointMake(width/3 *2, height - kMarginY)];
    
    //横1
    [path moveToPoint:CGPointMake(kMarginX, height/3)];
    [path addLineToPoint:CGPointMake(width - kMarginX, height/3)];
    
    //衡2
    [path moveToPoint:CGPointMake(kMarginX, height/3 *2)];
    [path addLineToPoint:CGPointMake(width - kMarginX, height/3 *2)];
    
    
    [path stroke];
}


@end

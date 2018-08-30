//
//  FSVerticalButton.m
//  Muslog
//
//  Created by Aiwei on 16/8/11.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "FSVerticalButton.h"

@implementation FSVerticalButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGPoint center        = CGPointMake(self.frame.size.width / 2, _imageCenterY ? _imageCenterY : self.imageView.frame.size.height / 2);
    self.imageView.center = center;

    CGRect titleFrame             = self.titleLabel.frame;
    self.titleLabel.frame         = CGRectMake(0, self.frame.size.height - titleFrame.size.height, self.frame.size.width, titleFrame.size.height);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

@end

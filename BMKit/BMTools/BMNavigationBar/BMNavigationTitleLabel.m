//
//  BMNavigationTitleLabel.m
//  BMNavigationBarSample
//
//  Created by DennisDeng on 2018/5/4.
//  Copyright © 2018年 DennisDeng. All rights reserved.
//

#import "BMNavigationTitleLabel.h"

#define BMNAVIGATIONTITLE_WIDTH     180.0f

@implementation BMNavigationTitleLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.font = [UIFont boldSystemFontOfSize:18.0f];
        //self.font = [UIFont systemFontOfSize:16.0f weight:UIFontWeightSemibold];
        self.minimumScaleFactor = 0.5f;
        self.adjustsFontSizeToFitWidth = YES;
        self.backgroundColor = [UIColor clearColor];
        self.contentMode = UIViewContentModeTop;
        self.textAlignment = NSTextAlignmentCenter;
        self.textColor = nil;//[UIColor whiteColor];
        self.tintColor = [UIColor whiteColor];
        self.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
        self.bm_width = BMNAVIGATIONTITLE_WIDTH;
    }
    
    return self;
}

- (void)tintColorDidChange
{
    self.textColor = self.tintColor;
}

@end

//
//  BMImageDetailItem.m
//  BMTableViewManagerSample
//
//  Created by jiang deng on 2018/7/30.
//  Copyright © 2018年 DJ. All rights reserved.
//

#import "BMImageDetailItem.h"

@implementation BMImageDetailItem

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        self.detailImageWidth = 20.0f;
        self.imageDetailGap = 8.0f;
    }
    
    return self;
}

@end

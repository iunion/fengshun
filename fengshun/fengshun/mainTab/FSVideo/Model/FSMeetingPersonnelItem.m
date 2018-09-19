//
//  FSMeetingPersonnelItem.m
//  fengshun
//
//  Created by ILLA on 2018/9/17.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSMeetingPersonnelItem.h"

@implementation FSMeetingPersonnelItem

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        self.enabled = YES;
        self.cellHeight = 70.0f;
        self.underLineDrawType = BMTableViewCell_UnderLineDrawType_None;
        self.isShowHighlightBg = NO;
    }
    
    return self;
}

@end

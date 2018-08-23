//
//  BMTextItem.m
//  BMTableViewManagerSample
//
//  Created by DennisDeng on 2017/8/22.
//  Copyright © 2017年 DennisDeng. All rights reserved.
//

#import "BMTextItem.h"

@implementation BMTextItem

- (instancetype)initWithTitle:(NSString *)title value:(NSString *)value placeholder:(NSString *)placeholder
{
    self = [super initWithTitle:title value:value placeholder:placeholder];
    
    if (self)
    {
        self.textFieldSeparatorInset = UIEdgeInsetsZero;
    }
    
    return self;
}

@end

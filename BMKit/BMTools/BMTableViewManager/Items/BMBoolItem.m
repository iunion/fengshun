//
//  BMBoolItem.m
//  BMTableViewManagerSample
//
//  Created by DennisDeng on 2018/1/11.
//  Copyright © 2018年 DennisDeng. All rights reserved.
//

#import "BMBoolItem.h"

@implementation BMBoolItem

+ (instancetype)itemWithTitle:(NSString *)title value:(BOOL)value
{
    return [[self alloc] initWithTitle:title value:value];
}

+ (instancetype)itemWithTitle:(NSString *)title value:(BOOL)value switchValueChangeHandler:(switchValueChangeHandler) valueChangeHandler
{
    return [[self alloc] initWithTitle:title value:value switchValueChangeHandler:valueChangeHandler];
}

- (instancetype)initWithTitle:(NSString *)title value:(BOOL)value
{
    return [self initWithTitle:title value:value switchValueChangeHandler:nil];
}

- (instancetype)initWithTitle:(NSString *)title value:(BOOL)value switchValueChangeHandler:(switchValueChangeHandler) valueChangeHandler
{
    self = [super init];
    if (!self)
    {
        return nil;
    }
    
    //self.isShowSelectBg = NO;
    self.isShowHighlightBg = NO;
    
    self.title = title;
    self.value = value;
    
    self.switchable = YES;
    self.valueChangeHandler = valueChangeHandler;
    
    return self;
}

@end

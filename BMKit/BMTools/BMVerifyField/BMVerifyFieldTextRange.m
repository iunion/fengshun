//
//  BMVerifyFieldTextRange.m
//  BMBaseKit
//
//  Created by jiang deng on 2019/4/30.
//  Copyright © 2019 BM. All rights reserved.
//

#import "BMVerifyFieldTextRange.h"

@implementation BMVerifyFieldTextRange
{
    BMVerifyFieldTextPosition *_start;
    BMVerifyFieldTextPosition *_end;
}

- (BMVerifyFieldTextPosition *)start
{
    return _start;
}

- (BMVerifyFieldTextPosition *)end
{
    return _end;
}

+ (instancetype)rangeWithRange:(NSRange)range
{
    BMVerifyFieldTextPosition *start = [BMVerifyFieldTextPosition positionWithOffset:range.location];
    BMVerifyFieldTextPosition *end = [BMVerifyFieldTextPosition positionWithOffset:range.location + range.length];
    return [self rangeWithStart:start end:end];
}

+ (instancetype)rangeWithStart:(BMVerifyFieldTextPosition *)start end:(BMVerifyFieldTextPosition *)end
{
    if (!start || !end)
    {
        return nil;
    }
    
    assert(start.offset <= end.offset);
    
    BMVerifyFieldTextRange *range = [[self alloc] init];
    range->_start = start;
    range->_end = end;
    return range;
}

- (instancetype)copyWithZone:(NSZone *)zone
{
    return [self.class rangeWithStart:_start end:_end];
}

- (NSRange)range
{
    return NSMakeRange(_start.offset, _end.offset - _start.offset);
}

@end

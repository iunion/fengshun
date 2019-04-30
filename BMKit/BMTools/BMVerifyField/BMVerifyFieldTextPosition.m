//
//  BMVerifyFieldTextPosition.m
//  BMBaseKit
//
//  Created by jiang deng on 2019/4/30.
//  Copyright © 2019 BM. All rights reserved.
//

#import "BMVerifyFieldTextPosition.h"

@implementation BMVerifyFieldTextPosition

+ (instancetype)positionWithOffset:(NSInteger)offset
{
    BMVerifyFieldTextPosition *position = [[self alloc] init];
    position->_offset = offset;
    return position;
}

- (instancetype)copyWithZone:(NSZone *)zone
{
    return  [self.class positionWithOffset:self.offset];
}

@end

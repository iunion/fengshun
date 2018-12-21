//
//  FSGlobalEnum.m
//  fengshun
//
//  Created by Aiwei on 2018/12/21.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSGlobalEnum.h"

@implementation FSGlobalEnum

+ (FSJumpType)jumpTypeWithString:(NSString *)jumpString
{
    if ([jumpString isEqualToString:@"NATIVE"])
    {
        return FSJumpType_Native;
    }
    else if ([jumpString isEqualToString:@"H5"])
    {
        return FSJumpType_H5;
    }
    else if ([jumpString isEqualToString:@"COURSE_SERIES"])
    {
        return FSJumpType_Course;
    }
    return FSJumpType_None;
}

@end

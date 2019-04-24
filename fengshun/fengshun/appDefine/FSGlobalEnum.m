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
    else if ([jumpString isEqualToString:@"VEDIO"])
    {
        return FSJumpType_VideoMeeting;
    }
    return FSJumpType_None;
}

+ (FSJumpVC_TYPE)getJumpType:(NSString *)type
{
    if ([type isEqualToString:@"statute"])
    {
        
        return FSJumpVC_TYPE_STATUTE;
    }
    else if ([type isEqualToString:@"case"])
    {
        return FSJumpVC_TYPE_CASE;
    }
    else if ([type isEqualToString:@"document"])
    {
        return FSJumpVC_TYPE_DOCUMENT;
    }
    else if ([type isEqualToString:@"video"])
    {
        return FSJumpVC_TYPE_VIDEO;
    }
    else if ([type isEqualToString:@"fileScanning"])
    {
        return FSJumpVC_TYPE_FILESCANNING;
    }
    else if ([type isEqualToString:@"consultation"])
    {
        return FSJumpVC_TYPE_CONSULTATION;
    }
    else if ([type isEqualToString:@"personal"])
    {
        return FSJumpVC_TYPE_PERSONAL;
    }
    else if ([type isEqualToString:@"forum"])
    {
        return FSJumpVC_TYPE_FORUM;
    }
    else
    {
        return FSJumpVC_TYPE_NONE;
    }
}

@end

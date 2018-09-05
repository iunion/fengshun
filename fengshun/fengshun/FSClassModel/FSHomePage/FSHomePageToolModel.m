//
//  FSHomePageToolModel.m
//  fengshun
//
//  Created by Aiwei on 2018/9/5.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSHomePageToolModel.h"

@implementation FSHomePageToolModel

+ (instancetype)modelWithParams:(NSDictionary *)params
{
    FSHomePageToolModel *model = [super modelWithParams:params];
    model.m_toolType           = [self toolTypeWithToolString:[params bm_stringForKey:@"toolType"]];
    return model;
}

+ (FSHomePageTooltype)toolTypeWithToolString:(NSString *)toolString
{
    if ([toolString isEqualToString:@"VIDEO_MEDIATION"])
    {
        return FSHomePageTooltype_VideoMediation;
    }
    else if ([toolString isEqualToString:@"FILE_SCANNING"])
    {
        return FSHomePageTooltype_FileScanning;
    }
    else if ([toolString isEqualToString:@"DOCUMENT"])
    {
        return FSHomePageTooltype_Document;
    }
    else if ([toolString isEqualToString:@"STATUTE_SEARCHING"])
    {
        return FSHomePageTooltype_StatuteSearching;
    }
    else if ([toolString isEqualToString:@"CASE_SEARCHING"])
    {
        return FSHomePageTooltype_CaseSearching;
    }
    else if ([toolString isEqualToString:@"CALCULATOR"])
    {
        return FSHomePageTooltype_Calculator;
    }
    return FSHomePageTooltype_Unknown;
}
@end

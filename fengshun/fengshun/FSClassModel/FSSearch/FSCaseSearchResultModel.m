//
//  FSCaseSearchResultModel.m
//  fengshun
//
//  Created by Aiwei on 2018/9/7.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSCaseSearchResultModel.h"

@implementation FSCaseReultModel

+ (instancetype)modelWithParams:(NSDictionary *)params
{
    FSCaseReultModel *model = [[self alloc] init];
    model.m_caseId          = [params bm_stringForKey:@"id"];
    model.m_title           = [params bm_stringForKey:@"title"];
    model.m_simpleContent   = [params bm_stringForKey:@"simpleContent"];
    model.m_caseNo          = [params bm_stringForKey:@"caseNo"];
    model.m_court           = [params bm_stringForKey:@"court"];
    model.m_caseTag         = [params bm_stringForKey:@"docType"];


    return model;
}

@end

@implementation FSCaseSearchResultModel

+ (instancetype)modelWithParams:(NSDictionary *)params
{
    FSCaseSearchResultModel *model = [[self alloc] init];
    model.m_isMore                 = [params bm_boolForKey:@"isMore"];
    model.m_totalCount             = [params bm_intForKey:@"size"];
    model.m_resultDataArray        = [FSCaseReultModel modelsWithDataArray:[params bm_arrayForKey:@"data"]];
    model.m_filterSegments         = [FSCaseFilterSegment modelsWithDataArray:[params bm_arrayForKey:@"aggs"]];
    return model;
}
@end

@implementation FSCaseFilterSegment
+ (instancetype)modelWithParams:(NSDictionary *)params
{
    FSCaseFilterSegment *model = [[self alloc] init];
    model.m_title              = [params bm_stringForKey:@"value" withDefault:@""];
    model.m_type               = [params bm_stringForKey:@"name" withDefault:@""];
    model.m_filters            = [FSCaseFilter modelsWithDataArray:[params bm_arrayForKey:@"bucket"]];
    return model;
}

@end

@implementation FSCaseFilter

+ (instancetype)modelWithParams:(NSDictionary *)params
{
    FSCaseFilter *model = [[self alloc] init];
    model.m_docCount    = [params bm_intForKey:@"docCount"];
    model.m_name        = [params bm_stringForKey:@"name" withDefault:@""];
    model.m_value       = [params bm_stringForKey:@"value" withDefault:@""];
    return model;
}
@end

//
//  FSCaseModel.m
//  fengshun
//
//  Created by Aiwei on 2018/9/20.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSCaseModel.h"

@implementation FSCaseModel

@end

@implementation FSCaseCollectionModel

+ (instancetype)modelWithParams:(NSDictionary *)params
{
    FSCaseCollectionModel *model = [[self alloc] init];
    model.m_caseId          = [params bm_stringForKey:@"detailId"];
    model.m_title           = [params bm_stringForKey:@"title"];
    model.m_source          = [params bm_stringForKey:@"source"];
    model.m_jumpUrl         = [params bm_stringForKey:@"jumpAddress"];
    model.m_collectionId    = [params bm_stringForKey:@"collectionId"];
    
    return model;
}

@end

@implementation FSCaseResultModel

+ (instancetype)modelWithParams:(NSDictionary *)params
{
    FSCaseResultModel *model = [[self alloc] init];
    model.m_caseId          = [params bm_stringForKey:@"id"];
    model.m_title           = [params bm_stringForKey:@"title"];
    model.m_simpleContent   = [params bm_stringForKey:@"simpleContent"];
    model.m_caseNo          = [params bm_stringForKey:@"caseNo"];
    model.m_court           = [params bm_stringForKey:@"court"];
    model.m_caseTag         = [params bm_stringForKey:@"docType"];
    
    
    return model;
}

@end


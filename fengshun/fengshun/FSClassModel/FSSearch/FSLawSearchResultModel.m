//
//  FSLawSearchResultModel.m
//  fengshun
//
//  Created by Aiwei on 2018/9/11.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSLawSearchResultModel.h"

@implementation FSLawResultModel

+(instancetype)modelWithParams:(NSDictionary *)params
{
    FSLawResultModel *model = [[self alloc]init];
    model.m_lawsId = [params bm_stringForKey:@"id"];
    model.m_lawsNo = [params bm_stringForKey:@"lawsNo"];
    model.m_title  = [params bm_stringForKey:@"title"];
    model.m_simpleContent = [params bm_stringForKey:@"simpleContent"];
    model.m_Organ = [params bm_stringForKey:@"establishmentOrgan"];
    model.m_publishDate = [params bm_stringForKey:@"publishDate"];
    model.m_executeDate = [params bm_stringForKey:@"executeDate"];
    model.m_executeTag = [params bm_stringForKey:@"timeliness"];
    model.m_matchCount = [params bm_intForKey:@"matchCount"];
    
    return model;
}

@end

@implementation FSLawSearchResultModel

+ (instancetype)modelWithParams:(NSDictionary *)params
{
    FSLawSearchResultModel *model = [super modelWithParams:params];
    model.m_resultDataArray       = [FSLawResultModel modelsWithDataArray:[params bm_arrayForKey:@"data"]];
    return model;
}

@end

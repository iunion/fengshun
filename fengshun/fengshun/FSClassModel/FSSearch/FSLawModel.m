//
//  FSLawModel.m
//  fengshun
//
//  Created by Aiwei on 2018/9/20.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSLawModel.h"

@implementation FSLawModel

@end

@implementation FSLawCollectionModel

+ (instancetype)modelWithParams:(NSDictionary *)params
{
    FSLawCollectionModel *model = [[self alloc] init];
    model.m_lawsId              = [params bm_stringForKey:@"detailId"];
    model.m_title               = [params bm_stringForKey:@"title"];
    model.m_source              = [params bm_stringForKey:@"source"];
    model.m_jumpUrl             = [params bm_stringForKey:@"jumpAddress"];
    model.m_collectionId        = [params bm_stringForKey:@"collectionId"];

    return model;
}

@end

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

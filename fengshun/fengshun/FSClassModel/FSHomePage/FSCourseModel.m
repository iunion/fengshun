//
//  FSCourseModel.m
//  fengshun
//
//  Created by Aiwei on 2018/9/5.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSCourseModel.h"

@implementation FSCourseModel


@end

@implementation FSCourseCollectionModel

+ (instancetype)modelWithParams:(NSDictionary *)params
{
    FSCourseCollectionModel *model = [[self alloc]init];
    model.m_id = [params bm_intForKey:@"detailId"];
    model.m_tilte = [params bm_stringForKey:@"title"];
    model.m_sourceInfo = [params bm_stringForKey:@"source"];
    model.m_readCount = [params bm_intForKey:@"readCount"];
    model.m_jumpAddress = [params bm_stringForKey:@"jumpAddress"];
    model.m_coverThumbUrl = [params bm_stringForKey:@"coverThumbUrl"];
    model.m_collectionId = [params bm_stringForKey:@"collectionId"];
    
    return model;
}

@end

@implementation FSCourseRecommendModel


+ (instancetype)modelWithParams:(NSDictionary *)params
{
    FSCourseRecommendModel *model = [[self alloc]init];
    model.m_id = [params bm_intForKey:@"courseId"];
    model.m_tilte = [params bm_stringForKey:@"title"];
    model.m_sourceInfo = [params bm_stringForKey:@"source"];
    model.m_readCount = [params bm_intForKey:@"readCount"];
    model.m_jumpAddress = [params bm_stringForKey:@"jumpAddress"];
    model.m_coverThumbUrl = [params bm_stringForKey:@"coverThumbUrl"];
    model.m_isSeries = [params bm_boolForKey:@"seriesFlag"];

    return model;
}
@end

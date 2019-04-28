//
//  FSColumModel.m
//  fengshun
//
//  Created by 龚旭杰 on 2019/4/24.
//  Copyright © 2019年 FS. All rights reserved.
//

#import "FSColumModel.h"

@implementation FSColumModel

+ (instancetype)fsColumModelWithDic:(NSDictionary *)params
{
    FSColumModel *model = [FSColumModel new];
    [model updateModel:params];
    return model;
}

- (void)updateModel:(NSDictionary *)params
{
    self.m_UserId = [params bm_intForKey:@"userId"];
    self.m_ArticleCount = [params bm_intForKey:@"articleCount"];
    self.m_HeaderUrl = [params bm_stringForKey:@"headUrl"];
    self.m_ItemList = [FSColumCellModel modelWithArr:[params bm_arrayForKey:@"itemList"]];
    self.m_NikeName = [params bm_stringForKey:@"nickName"];
    self.m_Organization = [params bm_stringForKey:@"organization"];
    self.m_Position = [params bm_stringForKey:@"position"];
    self.m_JumpAddress = [params bm_stringForKey:@"jumpAddress"];
}

+ (NSArray *)modelWithArr:(NSArray *)array
{
    NSMutableArray *arr = [NSMutableArray array];
    for (NSDictionary *params in array) {
        FSColumModel *model = [FSColumModel fsColumModelWithDic:params];
        [arr addObject:model];
    }
    return arr;
}

+ (NSArray *)getHomeListArr:(NSArray *)dataList
{
    NSMutableArray *data = [NSMutableArray array];
    NSArray *arr = [self modelWithArr:dataList];
    for (FSColumModel *columModel in arr) {
        [data addObject:columModel];
        [data addObjectsFromArray:columModel.m_ItemList];
        [data addObject:[NSString stringWithFormat:@"文章%@篇",@(columModel.m_ArticleCount)]];
    }
    return data;
}

@end

@implementation FSColumCellModel

+ (instancetype)fsColumCellModelWithDic:(NSDictionary *)params
{
    FSColumCellModel *model = [FSColumCellModel new];
    [model updateModel:params];
    return model;
}

- (void)updateModel:(NSDictionary *)params
{
    self.m_CommentCount = [params bm_intForKey:@"commentCount"];
    self.m_Id = [params bm_intForKey:@"id"];
    self.m_ReadCount = [params bm_intForKey:@"readCount"];
    self.m_ThumbUrl = [params bm_stringForKey:@"thumbUrl"];
    self.m_Title = [params bm_stringForKey:@"title"];
    self.m_JumpAddress = [params bm_stringForKey:@"jumpAddress"];
}

+ (NSArray *)modelWithArr:(NSArray *)array
{
    NSMutableArray *arr = [NSMutableArray array];
    for (NSDictionary *params in array) {
        FSColumCellModel *model = [FSColumCellModel fsColumCellModelWithDic:params];
        model.m_IsLast = NO;
        [arr addObject:model];
    }
    FSColumCellModel *model = [arr lastObject];
    model.m_IsLast = YES;
    return arr;
}



@end

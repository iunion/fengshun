//
//  FSCollectionModel.m
//  fengshun
//
//  Created by jiang deng on 2018/9/26.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSCollectionModel.h"

@implementation FSCollectionModel

+ (instancetype)collectionModelWithDic:(NSDictionary *)dic
{
    if (![dic bm_isNotEmptyDictionary])
    {
        return nil;
    }

    // 收藏id
    NSString *collectionId = [dic bm_stringTrimForKey:@"collectionId"];
    if (![collectionId bm_isNotEmpty])
    {
        return nil;
    }

    FSCollectionModel *model = [[FSCollectionModel alloc] init];
    [model updateWithServerDic:dic];
    
    if ([model.m_CollectionId bm_isNotEmpty] && [model.m_DetailId bm_isNotEmpty])
    {
        return model;
    }
    else
    {
        return nil;
    }
}

- (void)updateWithServerDic:(NSDictionary *)dic
{
    if (![dic bm_isNotEmptyDictionary])
    {
        return;
    }

    // 收藏id
    NSString *collectionId = [dic bm_stringTrimForKey:@"collectionId"];
    if (![collectionId bm_isNotEmpty])
    {
        return;
    }

    // 帖子/法规/案例/文书/课程id
    NSString *detailId = [dic bm_stringTrimForKey:@"detailId"];
    if (![detailId bm_isNotEmpty])
    {
        return;
    }

    self.m_CollectionId = collectionId;
    self.m_DetailId = detailId;

    // 文书的文件id
    self.m_FiledId = [dic bm_stringTrimForKey:@"filedId"];

    // 缩略图url
    self.m_CoverThumbUrl = [dic bm_stringTrimForKey:@"coverThumbUrl"];
    // 指导性案例
    self.m_GuidingCase = [dic bm_stringTrimForKey:@"guidingCase"];
    // 文书预览地址
    self.m_PreviewUrl = [dic bm_stringTrimForKey:@"previewUrl"];
    // 阅读数
    self.m_ReadCount = [dic bm_uintForKey:@"readCount"];
    // 来源
    self.m_Source = [dic bm_stringTrimForKey:@"source"];
    // 发贴时间
    self.m_CreateTime = [dic bm_doubleForKey:@"createTime"]/1000;
    // 帖子评论数
    self.m_CommentCount = [dic bm_uintForKey:@"commentCount"];
    // 帖子标题
    self.m_Title = [dic bm_stringTrimForKey:@"title"];
    // 跳转地址
    self.m_JumpAddress = [dic bm_stringTrimForKey:@"jumpAddress"];
}

@end

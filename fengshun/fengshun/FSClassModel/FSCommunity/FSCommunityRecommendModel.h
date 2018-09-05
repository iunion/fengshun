//
//  FSCommunityModel.h
//  fengshun
//
//  Created by best2wa on 2018/9/4.
//  Copyright © 2018年 FS. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 endRow = 9;
 hasNextPage = 0;
 hasPreviousPage = 0;
 lastPage = 1;
 list =
 
 
 */
@class FSCommunityPlateModel;
@class FSCommunityPlateListModel;
@class FSCommunityRecommendListModel;

@interface FSCommunityRecommendModel : NSObject

@property (nonatomic, assign) NSInteger m_EndRow;

@property (nonatomic, assign) BOOL m_HasNextPage;

@property (nonatomic, assign) BOOL m_HasPreviousPage;

@property (nonatomic, assign) NSInteger m_LastPage;

@property (nonatomic, strong) NSArray<FSCommunityRecommendListModel *> *m_List;

@property (nonatomic, assign) NSInteger m_PageIndex;

@property (nonatomic, assign) NSInteger m_PageSize;

@property (nonatomic, assign) NSInteger m_StartRow;

@property (nonatomic, assign) NSInteger m_TotalPages;

@property (nonatomic, assign) NSInteger m_TotalRows;


+ (FSCommunityRecommendModel *)recommendModelWithDic:(NSDictionary *)dic;

@end

@interface FSCommunityRecommendListModel : NSObject

// 帖子评论数
@property (nonatomic, assign) NSInteger m_CommentCount;
// 版块名称
@property (nonatomic, strong) NSString *m_ForumName;
// 用户昵称
@property (nonatomic, strong) NSString *m_NickName;
// 发贴时间
@property (nonatomic, assign) NSInteger m_PostsCreateTime;
// 帖子标志: 推荐 置顶
@property (nonatomic, strong) NSString *m_PostsFlag;
// 最后回贴时间
@property (nonatomic, assign) NSInteger m_PostsLastReplyTime;
// 帖子标题
@property (nonatomic, strong) NSString *m_PostsTitle;

@end


@interface FSCommunityPlateBaseModel : NSObject

@property (nonatomic, assign) NSInteger m_PageIndex;

@property (nonatomic, assign) NSInteger m_PageSize;

@property (nonatomic, assign) NSInteger m_TotalPages;

@property (nonatomic, strong) NSArray<FSCommunityPlateModel *> *m_List;

+ (FSCommunityPlateBaseModel *)plateBaseModelWithDic:(NSDictionary *)dic;

@end

@interface FSCommunityPlateModel : NSObject
//section名称
@property (nonatomic, strong) NSString *m_name;
//modelList
@property (nonatomic, strong) NSArray<FSCommunityPlateListModel *> *m_List;

+ (NSArray *)plateModelWithArr:(NSArray *)dataArray;

@end

@interface FSCommunityPlateListModel : NSObject
// 版块关注数量
@property (nonatomic, assign) NSInteger m_AttentionCount;
// 版块介绍
@property (nonatomic, strong) NSString *m_Description;
// 一级版块名称
@property (nonatomic, strong) NSString *m_ForumNameFirst;
// 二级版块名称
@property (nonatomic, strong) NSString *m_ForumNameSecond;
// 封面图片
@property (nonatomic, strong) NSString *m_IconUrl;
// 二级版块id
@property(nonatomic ,assign) NSInteger m_Id;
// 版块发贴数量
@property(nonatomic ,assign) NSInteger m_PostsCount;

@end



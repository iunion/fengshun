//
//  FSCommunityModel.h
//  fengshun
//
//  Created by best2wa on 2018/9/4.
//  Copyright © 2018年 FS. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FSCommunityForumListModel;

#pragma mark - 推荐帖子model

@interface FSCommunityTopicListModel : NSObject
// 帖子id
@property (nonatomic, strong) NSString *m_Id;
// 版块icon
@property (nonatomic, strong) NSString *m_IconUrl;
// 版块名称
@property (nonatomic, strong) NSString *m_ForumName;
// 帖子标志: 推荐 置顶
@property (nonatomic, strong) NSString *m_PostsFlag;
// 帖子标题
@property (nonatomic, strong) NSString *m_PostsTitle;
// 最后回贴时间
@property (nonatomic, assign) NSInteger m_PostsLastReplyTime;
// 用户昵称
@property (nonatomic, strong) NSString *m_NickName;
// 帖子评论数
@property (nonatomic, assign) NSInteger m_CommentCount;
// 发贴时间
@property (nonatomic, assign) NSInteger m_PostsCreateTime;

+ (NSArray *)communityRecommendListModelArr:(NSArray *)list;

// 刷新model
- (void)updateTopicModel:(NSDictionary *)data;

@end

#pragma mark - 板块列表

@interface FSCommunityForumModel : NSObject
// section名称
@property (nonatomic, strong) NSString *m_Name;
// 板块图片
@property (nonatomic, strong) NSString *m_IconUrl;
// modelList
@property (nonatomic, strong) NSArray<FSCommunityForumListModel *> *m_List;

+ (NSArray *)plateModelWithArr:(NSArray *)dataArray;

@end

@interface FSCommunityForumListModel : NSObject
// 二级版块id
@property (nonatomic, assign) NSInteger m_Id;
// 封面图片
@property (nonatomic, strong) NSString *m_IconUrl;
// 一级版块名称
@property (nonatomic, strong) NSString *m_ForumNameFirst;
// 版块介绍
@property (nonatomic, strong) NSString *m_Description;
// 版块关注数量
@property (nonatomic, assign) NSInteger m_AttentionCount;
// 版块发贴数量
@property (nonatomic, assign) NSInteger m_PostsCount;
// 是否关注
@property (nonatomic, assign) BOOL m_AttentionFlag;
// 二级版块名称
@property (nonatomic, strong) NSString *m_ForumNameSecond;
// 刷新model
- (void)updateForumModel:(NSDictionary *)data;

@end



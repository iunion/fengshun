//
//  FSCommunityModel.h
//  fengshun
//
//  Created by best2wa on 2018/9/4.
//  Copyright © 2018年 FS. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 帖子推荐model
 */
@interface FSCommunityRecommendModel : NSObject

// 帖子评论数
@property(nonatomic ,assign)NSInteger m_CommentCount;
// 版块名称
@property(nonatomic, strong)NSString *m_ForumName;
// 用户昵称
@property(nonatomic, strong)NSString *m_NickName;
// 发贴时间
@property(nonatomic, assign)NSInteger m_PostsCreateTime;
// 帖子标志: 推荐 置顶
@property(nonatomic, strong)NSString *m_PostsFlag;
// 最后回贴时间
@property(nonatomic, assign)NSInteger m_PostsLastReplyTime;
// 帖子标题
@property(nonatomic, strong)NSString *m_PostsTitle;

+ (NSArray *)recommendModelWithArr:(NSArray *)dataArray;

@end

/**
 帖子板块列表model
 */
@interface FSCommunityPlateModel : NSObject

// 版块关注数量
@property(nonatomic ,assign)NSInteger m_AttentionCount;
// 版块介绍
@property(nonatomic, strong)NSString *m_Description;
// 一级版块名称
@property(nonatomic, strong)NSString *m_ForumNameFirst;
// 二级版块名称
@property(nonatomic, strong)NSString *m_ForumNameSecond;
// 封面图片
@property(nonatomic, strong)NSString *m_IconUrl;
// 二级版块id
@property(nonatomic ,assign)NSInteger m_Id;
// 版块发贴数量
@property(nonatomic ,assign)NSInteger m_PostsCount;

+ (NSArray *)plateModelWithArr:(NSArray *)dataArray;

@end



//
//  FSCommunityModel.h
//  fengshun
//
//  Created by best2wa on 2018/9/4.
//  Copyright © 2018年 FS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMTableViewManagerDefine.h"

@class FSForumModel;

#pragma mark - 帖子模型
@interface FSTopicModel : NSObject
/*
 commentCount = 0;
 createName = "<null>";
 createTime = 1536741785000;
 description = 14445522;
 forumIconUrl = "http://mat1.gtimg.com/www/qq2018/imgs/qq_logo_2018x2.png";
 forumId = 5;
 forumName = "版块51";
 jumpAddress = "https://devftlsh5.odrcloud.net/note/3";
 postsId = 3;
 thumbUrl = "<null>";
 title = "特殊test";
 */

@property (nonatomic, assign) BMTableViewCell_PositionType m_PositionType;

// 帖子id
@property (nonatomic, strong) NSString *m_Id;
// 版块Id
@property (nonatomic, strong) NSString *m_ForumId;
// 版块icon
@property (nonatomic, strong) NSString *m_IconUrl;
// 版块名称
@property (nonatomic, strong) NSString *m_ForumName;
// 帖子标题
@property (nonatomic, strong) NSString *m_Title;
// 发贴时间
@property (nonatomic, assign) NSTimeInterval m_CreateTime;
// 最后回贴时间
@property (nonatomic, assign) NSTimeInterval m_LastReplyTime;
// 帖子评论数
@property (nonatomic, assign) NSUInteger m_CommentCount;
// 跳转地址
@property (nonatomic, strong) NSString *m_JumpAddress;

// 用户Id
@property (nonatomic, strong) NSString *m_UserId;
// 用户昵称
@property (nonatomic, strong) NSString *m_NickName;

// 是否置顶
@property (nonatomic, assign) BOOL m_TopFlag;

+ (instancetype)topicWithServerDic:(NSDictionary *)dic;

+ (NSArray *)communityRecommendListModelArr:(NSArray *)arr;

- (void)updateWithServerDic:(NSDictionary *)dic;

@end

#pragma mark - 板块列表

@interface FSCommunityForumModel : NSObject
// section名称
@property (nonatomic, strong) NSString *m_Name;
// 板块图片
@property (nonatomic, strong) NSString *m_IconUrl;
// modelList
@property (nonatomic, strong) NSMutableArray<FSForumModel *> *m_List;

+ (NSArray *)plateModelWithArr:(NSArray *)dataArray;

@end

@interface FSForumModel : NSObject
// 二级版块id
@property (nonatomic, assign) NSInteger m_Id;
// 一级图片
@property (nonatomic, strong) NSString *m_IconUrlFirst;
// 二级图片
@property (nonatomic, strong) NSString *m_IconUrlSecond;
// iconUrl
@property (nonatomic, strong) NSString *m_IconUrl;
// 背景图
@property (nonatomic, strong) NSString *m_BackUrl;
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

+ (instancetype)forumModelWithServerDic:(NSDictionary *)dic;
// 刷新model
- (void)updateForumModel:(NSDictionary *)data;

@end


@interface FSTopicTypeModel : NSObject
// 是否活跃
@property (nonatomic , assign) BOOL m_IsActive;
// 帖子类型名称 （最新发布、最新回复）
@property (nonatomic , strong) NSString *m_PostListName;
// 帖子类型 请求type
@property (nonatomic , strong) NSString *m_PostListType;

+ (instancetype)topicTypeModelWithDic:(NSDictionary *)dic;

@end


#pragma mark - 帖子详情

@interface FSTopicDetailModel:NSObject
/*
     collection = 1;
     content = "14445522<br><img src=\"https://devftls.odrcloud.net/storm/file/download/b22fae972f6a4ac19403a270bb1183f3.jpeg\" alt=\"图片\" style=\"max-width:100%\"><br><br><img src=\"https://devftls.odrcloud.net/storm/file/download/737fa25085fd4bbaae8d53374598a0ba.jpg\" alt=\"图片\" style=\"max-width:100%\"><br>";
     createTime = 1536821218000;
     headPortraitUrl = "https://devres.odrcloud.net/169/5/4036b96e736d4ecb95268ac0c0a41b32.jpeg";
     nickName = gloggs;
     readCount = 367;
     report = 0;
     title = test;
     userId = 1000002;
 */

@property (nonatomic, assign) BOOL m_IsCollection;

@property (nonatomic, strong) NSString *m_Content;

@property (nonatomic, assign) NSTimeInterval m_CreateTime;

@property (nonatomic, strong) NSString *m_HeadPortraitUrl;

@property (nonatomic, strong) NSString *m_NickName;

@property (nonatomic, assign) BOOL m_IsReport;

@property (nonatomic, assign) NSInteger m_ReadCount;

@property (nonatomic, strong) NSString *m_Title;

@property (nonatomic, strong) NSString *m_UserId;

+ (instancetype)topicDetailModelWithDic:(NSDictionary *)dic;

@end

@interface FSTopicCollectModel : NSObject

/*
 collectionId = 190;
 commentCount = 9;
 coverThumbUrl = "<null>";
 createTime = 1536819513000;
 detailId = 4;
 filedId = "<null>";
 guidingCase = "<null>";
 jumpAddress = "<null>";
 previewUrl = "<null>";
 readCount = "<null>";
 source = "版块51";
 title = "发我";
 */

// 收藏id
@property (nonatomic, strong) NSString * m_CollectionId;
// 缩略图url
@property (nonatomic, strong) NSString *m_CoverThumbUrl;
// 帖子/法规/案例/文书/课程id
@property (nonatomic, strong) NSString *m_DetailId;
// 文书的文件id
@property (nonatomic, strong) NSString *m_FiledId;
//指导性案例
@property (nonatomic, strong) NSString *m_GuidingCase;
// 文书预览地址
@property (nonatomic, strong) NSString *m_PreviewUrl;
// 阅读数
@property (nonatomic, assign) NSInteger m_ReadCount;
// 来源
@property (nonatomic, strong) NSString *m_Source;
// 发贴时间
@property (nonatomic, assign) NSTimeInterval m_CreateTime;
// 帖子评论数
@property (nonatomic, assign) NSUInteger m_CommentCount;
// 帖子标题
@property (nonatomic, strong) NSString *m_Title;
// 跳转地址
@property (nonatomic, strong) NSString *m_JumpAddress;

+ (FSTopicCollectModel *)collectTopicModelWithDic:(NSDictionary *)dic;


@end



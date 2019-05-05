//
//  FSColumModel.h
//  fengshun
//
//  Created by 龚旭杰 on 2019/4/24.
//  Copyright © 2019年 FS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FSColumModel : NSObject

// 文章数目
@property (nonatomic , assign) NSInteger m_ArticleCount;
// 头像
@property (nonatomic , strong) NSString *m_HeaderUrl;
// 专栏详细列表
@property (nonatomic , strong) NSArray *m_ItemList;
// 用户昵称
@property (nonatomic , strong) NSString *m_NikeName;
// 机构
@property (nonatomic , strong) NSString *m_Organization;
// 职位
@property (nonatomic , strong) NSString *m_Position;
// 用户id
@property (nonatomic , assign) NSInteger m_UserId;
// 跳转链接
@property (nonatomic , strong) NSString *m_JumpAddress;
// 身份认证
@property (nonatomic , assign) BOOL m_IsIdAyth;

+ (instancetype)fsColumModelWithDic:(NSDictionary *)params;

+ (NSArray *)modelWithArr:(NSArray *)array;

// 获取主页的model列表
+ (NSArray *)getHomeListArr:(NSArray *)dataList;

@end

@interface FSColumCellModel : NSObject

@property (nonatomic , assign) BOOL m_IsLast;
// r内容图片
@property (nonatomic , strong) NSString *m_ThumbUrl;
// 标题
@property (nonatomic , strong) NSString *m_Title;
// 评论数
@property (nonatomic , assign) NSInteger m_CommentCount;
// 专栏id
@property (nonatomic , assign) NSInteger m_Id;
// 阅读数
@property (nonatomic , assign) NSInteger m_ReadCount;
// 跳转链接
@property (nonatomic , strong) NSString *m_JumpAddress;

+ (instancetype)fsColumCellModelWithDic:(NSDictionary *)params;

+ (NSArray *)modelWithArr:(NSArray *)array;

@end

NS_ASSUME_NONNULL_END

//
//  FSGlobalEnum.h
//  fengshun
//
//  Created by Aiwei on 2018/12/21.
//  Copyright © 2018年 FS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSGlobalEnum : NSObject

typedef NS_ENUM(NSUInteger, FSJumpType) {
    FSJumpType_None,
    FSJumpType_Native,
    FSJumpType_H5,      // webview
    FSJumpType_Course,  //课堂
    FSJumpType_VideoMeeting,
};
+ (FSJumpType)jumpTypeWithString:(NSString *)jumpString;

typedef NS_ENUM(NSUInteger, FSPushToVCType)
{
    FSPushToVCType_None = 0,
    FSPushToVCType_NotificationCenter, // 通知中心
    FSPushToVCType_VideoMeeting,    // 视频会议
    FSPushToVCType_TopicVC,     // 帖子
    FSPushToVCType_CourseVC,    // 图文课程
};

typedef NS_ENUM(NSUInteger, FSReceivePushInfoState)
{
    FSReceivePushInfoState_Active, // APP在前台收到APNs
    FSReceivePushInfoState_PushInfoEnter, // APP在后台,通过外部跳转进入
    FSReceivePushInfoState_PushInfoLaunching, // APP未启动,通过部跳转启动
};

/**
 外部跳转 && banner跳转原生
 */
typedef NS_ENUM(NSUInteger, FSJumpVC_TYPE) {
    FSJumpVC_TYPE_NONE,
    FSJumpVC_TYPE_STATUTE, // 法规检索首页
    FSJumpVC_TYPE_CASE, //  案例检索首页
    FSJumpVC_TYPE_DOCUMENT,// 文书范本首页
    FSJumpVC_TYPE_VIDEO,// 视频调解首页
    FSJumpVC_TYPE_FILESCANNING,//  文件扫描首页
    FSJumpVC_TYPE_CONSULTATION, // 智能咨询首页
    FSJumpVC_TYPE_PERSONAL,// 个人信息
    FSJumpVC_TYPE_FORUM,// 板块
};

+ (FSJumpVC_TYPE)getJumpType:(NSString *)type;

@end

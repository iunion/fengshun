//
//  FSJumpVCManager.h
//  fengshun
//
//  Created by 龚旭杰 on 2019/4/23.
//  Copyright © 2019年 FS. All rights reserved.
//

#import <Foundation/Foundation.h>


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

NS_ASSUME_NONNULL_BEGIN

@interface FSJumpVCManager : NSObject


+ (BOOL)canOpenUrl:(NSURL *)url;

+ (BOOL)jumpVcWithUrl:(NSURL *)url pushVC:(UIViewController *)pushVC;

@end

NS_ASSUME_NONNULL_END

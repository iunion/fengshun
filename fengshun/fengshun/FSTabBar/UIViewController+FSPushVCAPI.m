//
//  UIViewController+FSPushVCAPI.m
//  fengshun
//
//  Created by Aiwei on 2018/12/21.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "UIViewController+FSPushVCAPI.h"
#import "FSLoginVC.h"
#import "FSCustomInfoVC.h"


@implementation UIViewController (FSPushVCAPI)



- (void)fspush_withModel:(FSPushVCModel *)pushModel
{
    switch (pushModel.m_pushType) {
        case FSPushToVCType_None:
            return;
            break;
            
        case FSPushToVCType_NotificationCenter:
        {
            if ([pushModel.m_url bm_isNotEmpty])
            {
                [FSPushVCManager fsPresentWebVC:self url:pushModel.m_url title:nil];
            }
            else
            {
                [FSPushVCManager showMessageVC:self andShowNotificationTab:YES];
            }
        }
            
            break;
        case FSPushToVCType_VideoMeeting:
#ifdef FSVIDEO_ON
            [FSPushVCManager meetingDetailVCShowInVC:self withMeetingId:pushModel.m_requestId];
#endif
            break;
        case FSPushToVCType_TopicVC:
            [FSPushVCManager showTopicDetail:self topicId:pushModel.m_requestId];
            break;
        case FSPushToVCType_CourseVC:
            [FSPushVCManager viewController:self pushToCourseDetailWithId:pushModel.m_requestId andIsSerial:NO];
            break;
    }
}

- (BOOL)canOpenUrl:(NSURL *)url
{
    return  [url.scheme isEqualToString:FS_URL_Schemes_X]||[url.scheme isEqualToString:FS_URL_SCHEMES];
}

- (BOOL)fspush_withUrl:(NSURL *)url
{
    if (![self canOpenUrl:url])
    {
        return NO;
    }
    FSJumpVC_TYPE jumpType = [FSGlobalEnum getJumpType:url.host];
    if (jumpType == FSJumpVC_TYPE_NONE)
    {
        return NO;
    }
    switch (jumpType) {
        case FSJumpVC_TYPE_STATUTE://
            [FSPushVCManager pushToLawSearch:self];
            break;
        case FSJumpVC_TYPE_CASE://
        {
            [FSPushVCManager homePage:self pushToCaseSearchWithHotKeys:nil];
        }
            break;
        case FSJumpVC_TYPE_DOCUMENT://
            [FSPushVCManager homePagePushToTextSplitVC:self];
            break;
        case FSJumpVC_TYPE_VIDEO://
        {
#ifdef FSVIDEO_ON
            if ([FSUserInfoModel isLogin])
            {
                [FSPushVCManager pushVideoMediateList:self.navigationController];
            }
            else
            {
                [self showLoginWithVC:self];
            }
#endif
        }
            break;
        case FSJumpVC_TYPE_FILESCANNING://
            if ([FSUserInfoModel isLogin])
            {
                [FSPushVCManager homePagePushToFileScanVC:self];
            }
            else
            {
                [self showLoginWithVC:self];
            }
            break;
        case FSJumpVC_TYPE_CONSULTATION://
            [FSPushVCManager pushToAIConsultVC:self];
            break;
        case FSJumpVC_TYPE_PERSONAL://
        {
            if ([FSUserInfoModel isLogin])
            {
                FSCustomInfoVC *vc = [[FSCustomInfoVC alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                [self showLoginWithVC:self];
            }
        }
            break;
        case FSJumpVC_TYPE_FORUM://
        {
            // 获取帖子的id
            NSDictionary *params = [url bm_queryDictionary];
            [FSPushVCManager showCommunitySecVCPushVC:self fourmId:[params bm_intForKey:@"id"] fourmName:@""];
        }
            break;
            case FSJumpVC_TYPE_CALCULATOR:
        {
            [FSPushVCManager showWebView:self url:[NSString stringWithFormat:@"%@/tooIndex",FS_H5_SERVER] title:@""];
        }
            case FSJumpVC_TYPE_COLUMN:
        {
            NSDictionary *params = [url bm_queryDictionary];
            if ([[params bm_stringForKey:@"url"] bm_isNotEmpty])
            {
                [FSPushVCManager showWebView:self url:[params bm_stringForKey:@"url"] title:nil];
            }
        }
            break;
        default:
            break;
    }
    return YES;
}

// 弹出登录
- (BOOL)showLoginWithVC:(UIViewController *)pushVC
{
    if ([FSUserInfoModel isLogin])
    {
        return NO;
    }
    FSLoginVC *loginVC = [[FSLoginVC alloc] init];
    BMNavigationController *nav = [[BMNavigationController alloc] initWithRootViewController:loginVC];
    [pushVC presentViewController:nav animated:YES completion:^{
    }];
    return YES;
}

@end

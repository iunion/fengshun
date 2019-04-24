//
//  FSJumpVCManager.m
//  fengshun
//
//  Created by 龚旭杰 on 2019/4/23.
//  Copyright © 2019年 FS. All rights reserved.
//

#import "FSJumpVCManager.h"
#import "NSURL+BMParameters.h"
#import "FSCustomInfoVC.h"
#import "FSLoginVC.h"

#define FS_URL_Schemes @"ftls"

@implementation FSJumpVCManager

+ (BOOL)canOpenUrl:(NSURL *)url
{
    return  [url.scheme isEqualToString:FS_URL_Schemes];
}

+ (NSDictionary *)getParamsWithUrl:(NSURL *)url
{
    return [url bm_queryDictionary];
}

+ (BOOL)jumpVcWithUrl:(NSURL *)url pushVC:(UIViewController *)pushVC
{
    if (![self canOpenUrl:url])
    {
        return NO;
    }
    FSJumpVC_TYPE jumpType = [self getJumpType:url.host];
    if (jumpType == FSJumpVC_TYPE_NONE)
    {
        return NO;
    }
    switch (jumpType) {
        case FSJumpVC_TYPE_STATUTE://
            [FSPushVCManager pushToLawSearch:pushVC];
            break;
        case FSJumpVC_TYPE_CASE://
        {
            [FSApiRequest getCaseSearchHotkeysSuccess:^(id  _Nullable responseObject) {
                NSDictionary *data = responseObject;
                [FSPushVCManager homePage:pushVC pushToCaseSearchWithHotKeys:[data bm_arrayForKey:@"hotKeywords"]];
            } failure:^(NSError * _Nullable error) {
                
            }];
        }
            break;
        case FSJumpVC_TYPE_DOCUMENT://
            [FSPushVCManager homePagePushToTextSplitVC:pushVC];
            break;
        case FSJumpVC_TYPE_VIDEO://
        {
#ifdef FSVIDEO_ON
            if ([FSUserInfoModel isLogin])
            {
                [FSPushVCManager pushVideoMediateList:pushVC.navigationController];
            }
            else
            {
                [self showLoginWithVC:pushVC];
            }
#endif
        }
            break;
        case FSJumpVC_TYPE_FILESCANNING://
            if ([FSUserInfoModel isLogin])
            {
                [FSPushVCManager homePagePushToFileScanVC:pushVC];
            }
            else
            {
                [self showLoginWithVC:pushVC];
            }
            break;
        case FSJumpVC_TYPE_CONSULTATION://
            [FSPushVCManager pushToAIConsultVC:pushVC];
            break;
        case FSJumpVC_TYPE_PERSONAL://
        {
            FSCustomInfoVC *vc = [[FSCustomInfoVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [pushVC.navigationController pushViewController:vc animated:YES];
        }
            break;
        case FSJumpVC_TYPE_FORUM://
        {
            // 获取帖子的id
            NSDictionary *params = [self getParamsWithUrl:url];
            [FSPushVCManager showCommunitySecVCPushVC:pushVC fourmId:[params bm_intForKey:@"id"] fourmName:@""];
        }
            break;
            
        default:
            break;
    }
    return YES;
}

+ (FSJumpVC_TYPE)getJumpType:(NSString *)type
{
    if ([type isEqualToString:@"statute"])
    {
        
        return FSJumpVC_TYPE_STATUTE;
    }
    else if ([type isEqualToString:@"case"])
    {
        return FSJumpVC_TYPE_CASE;
    }
    else if ([type isEqualToString:@"document"])
    {
        return FSJumpVC_TYPE_DOCUMENT;
    }
    else if ([type isEqualToString:@"video"])
    {
        return FSJumpVC_TYPE_VIDEO;
    }
    else if ([type isEqualToString:@"fileScanning"])
    {
        return FSJumpVC_TYPE_FILESCANNING;
    }
    else if ([type isEqualToString:@"consultation"])
    {
        return FSJumpVC_TYPE_CONSULTATION;
    }
    else if ([type isEqualToString:@"personal"])
    {
        return FSJumpVC_TYPE_PERSONAL;
    }
    else if ([type isEqualToString:@"forum"])
    {
        return FSJumpVC_TYPE_FORUM;
    }
    else
    {
        return FSJumpVC_TYPE_NONE;
    }
}

// 弹出登录
+ (BOOL)showLoginWithVC:(UIViewController *)pushVC
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

//
//  FSAPNsNotificationModel.m
//  fengshun
//
//  Created by Aiwei on 2018/12/21.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSPushVCModel.h"

@implementation FSPushVCModel

@end

@implementation FSAPNsNotificationModel

+ (instancetype)modelWithParams:(NSDictionary *)params
{
    FSAPNsNotificationModel *model = [self new];
    model.m_pushType = [params bm_intForKey:@"pushType"];
    model.m_requestId = [params bm_stringForKey:@"identifier"];
    model.m_url = [params bm_stringForKey:@"url"];
    model.m_pushInfo = [params bm_dictionaryForKey:@"info"];
    NSDictionary *aps = [params bm_dictionaryForKey:@"aps"];
    model.m_content = [aps bm_stringForKey:@"alert"]; //推送显示的内容
    model.m_badge = [aps bm_intForKey:@"badge"]; //badge 数量
    return model;
}

@end

//
//  FSAPNsNotificationModel.h
//  fengshun
//
//  Created by Aiwei on 2018/12/21.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSSuperModel.h"

@interface FSPushVCModel : FSSuperModel

@property (nonatomic, assign) FSPushToVCType m_pushType;
@property (nonatomic, copy) NSString *m_requestId;  // 页面的请求id
@property (nonatomic, copy) NSString *m_url;  // web类跳转专用
@property (nonatomic, strong) NSDictionary *m_pushInfo; // 额外的跳转信息

@end


// V1.1添加的远程推送主要是传递页面跳转信息,所以继承FSPushVCModel即可
@interface FSAPNsNotificationModel : FSPushVCModel
@property (nonatomic, copy)NSString *m_content;
@property (nonatomic, assign)NSInteger m_badge;
@end


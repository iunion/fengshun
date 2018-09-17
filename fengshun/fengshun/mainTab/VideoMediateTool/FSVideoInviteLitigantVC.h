//
//  FSInviteLitigantVC.h
//  fengshun
//
//  Created by ILLA on 2018/9/12.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSSuperVC.h"
#import "FSSetTableViewVC.h"

typedef void(^inviteLitigantCompleteBlock)(NSArray *litigantList);

@interface FSVideoInviteLitigantVC : FSSetTableViewVC

// 已存在会议的会议邀请人员需要请求API
@property (nonatomic, assign) NSInteger meetingId;

@property (nonatomic, copy) inviteLitigantCompleteBlock inviteComplete;

@end

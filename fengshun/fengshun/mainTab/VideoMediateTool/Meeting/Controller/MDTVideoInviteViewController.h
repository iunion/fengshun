//
//  MDTVideoInviteViewController.h
//  ODR
//
//  Created by DH on 2018/7/16.
//  Copyright © 2018年 DH. All rights reserved.
//  调解员功能-邀请协助调解员或者观摩者

#import "FSSuperVC.h"

@interface MDTVideoInviteViewController : FSSuperVC
+ (instancetype)vcWithMeetingID:(NSInteger )meetingID caseId:(NSInteger)caseID;
@end

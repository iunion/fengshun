//
//  MDTChatTextViewController.h
//  ODR
//
//  Created by DH on 2018/6/1.
//  Copyright © 2018年 DH. All rights reserved.
//

#import "FSTableViewVC.h"
#import "ChatTextViewModel.h"
#import "VideoCallModel.h"

@interface PublicTextChatViewController : FSTableViewVC
+ (instancetype)vcWithMeetingModel:(RTCRoomInfoModel *)model;
// 显示群聊页面内容
- (void)showChat;
@end

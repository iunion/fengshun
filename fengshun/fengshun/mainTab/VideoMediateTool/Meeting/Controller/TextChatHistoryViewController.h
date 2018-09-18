//
//  SingleTextChaHistoryVC.h
//  ODR
//
//  Created by ILLA on 2018/9/10.
//  Copyright © 2018年 DH. All rights reserved.
//

#import "FSTableViewVC.h"
#import "ChatTextViewModel.h"

@interface TextChatHistoryViewController : FSTableViewVC

@property (nonatomic, strong) VideoCallMemberModel *memberModel;

+ (instancetype)ChatTextVCWithMeetingModel:(VideoCallMemberModel *)memberModel;

@end


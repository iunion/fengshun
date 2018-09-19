//
//  SingleChatTextViewController.h
//  ODR
//
//  Created by DH on 2017/11/9.
//  Copyright © 2017年 DH. All rights reserved.
//

#import "FSTableViewVC.h"
#import "ChatTextViewModel.h"


@protocol SingleTextChatViewControllerDelegate <NSObject>
- (void)finishPriviteSessionModel:(VideoCallMemberModel *)member;
@end

@interface SingleTextChatViewController : FSTableViewVC
@property (nonatomic, weak) id <SingleTextChatViewControllerDelegate> delegate;
+ (instancetype)singleChatTextVCWithMeetingModel:(VideoCallMemberModel *)memberModel;
@end

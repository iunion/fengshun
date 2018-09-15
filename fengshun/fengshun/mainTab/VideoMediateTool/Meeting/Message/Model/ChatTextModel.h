//
//  ChatTextModel.h
//  ODR
//
//  Created by DH on 2017/9/12.
//  Copyright © 2017年 DH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSSuperModel.h"

@class ChatTextMemberModel;
@interface ChatTextModel : FSSuperModel

@property (nonatomic, assign) BOOL isOnlyTime; ///< 是否只显示时间

@property (nonatomic, assign) NSInteger messageId;
@property (nonatomic, copy) NSString *messageContent;
@property (nonatomic, copy) NSString *messageType;
@property (nonatomic, copy) NSString *messageResourceEnums;
@property (nonatomic, assign) NSTimeInterval createTime;
@property (nonatomic, assign) BOOL isMe;
@property (nonatomic, strong) ChatTextMemberModel *sender;
@property (nonatomic, strong) ChatTextMemberModel *receiver;

@property (nonatomic, assign) BOOL isVoice; ///< 文本来源于语音识别
@property (nonatomic, assign) BOOL showMessageType; ///< 私聊和历史记录不显示文本来源于手动输入还是语音识别

@end

@interface ChatTextMemberModel : FSSuperModel
@property (nonatomic, copy) NSString *memberId;
@property (nonatomic, copy) NSString *memberName;
@property (nonatomic, copy) NSString *memberType;
@property (nonatomic, assign) BOOL master;
@end

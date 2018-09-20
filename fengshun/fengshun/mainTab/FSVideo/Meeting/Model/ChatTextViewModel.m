//
//  ChatTextViewModel.m
//  ODR
//
//  Created by ILLA on 2018/8/16.
//  Copyright © 2018年 DH. All rights reserved.
//

#import "ChatTextViewModel.h"
#import "FSUserInfoModle.h"

@implementation ChatTextViewModel


#pragma mark - getter

- (instancetype)init {
    if (self = [super init]) {
        self.chatList = [NSMutableArray array];
    }
    return self;
}

#pragma mark - Deal Data

+ (NSArray *)modelListWithData:(NSArray *)data
{
    if ([data bm_isNotEmpty]) {
        NSMutableArray *temp = [NSMutableArray array];
        for (NSDictionary *dic in data) {
            [temp addObject:[self chatTextModelWithDict:dic]];
        }
        return temp;
    }
    
    return nil;
}

+ (ChatTextModel *)chatTextModelWithDict:(NSDictionary *)dic
{
    ChatTextModel *model = [ChatTextModel modelWithParams:dic];
    model.createTime = model.createTime*0.001;
    model.isMe = [model.sender.memberId isEqualToString:[[[FSUserInfoModle userInfo] m_UserBaseInfo] m_PhoneNum]];
    return model;
}

- (void)formatChatList
{
    if (self.chatList.count < 2) {
        return;
    }
    // 首先根据时间戳排序
    [self.chatList sortUsingComparator:^NSComparisonResult(ChatTextModel * obj1, ChatTextModel * obj2) {
        if (obj1.createTime > obj2.createTime)
        {
            return NSOrderedDescending;
        }
        else if (obj1.createTime < obj2.createTime)
        {
            return NSOrderedAscending;
        }
        else
        {
            if ([obj1.messageId integerValue] > [obj2.messageId integerValue])
            {
                return NSOrderedDescending;
            }
            else
            {
                return NSOrderedAscending;
            }
        }
    }];
}

- (NSArray *)formatMessagesFromChatList
{
    NSMutableArray *mutArray = [NSMutableArray new];
    NSDate *lastDate;
    
    for (ChatTextModel *model in self.chatList)
    {
        NSDate *createDate = [NSDate dateWithTimeIntervalSince1970:model.createTime];
        if ((lastDate == nil) || (![createDate bm_isSameDayTimeAsDate:lastDate]))
        {
            [mutArray addObject:[self timeItemFromModel:model]];
            lastDate = createDate;
        }
        [mutArray addObject:[self textItemFromModel:model]];
    }
    
    return mutArray;
}

- (void)convertToItemsFromChatList
{
    NSArray *formated = [self formatMessagesFromChatList];
    self.showList = formated;
}

// 将服务器返回的模型字典转化为界面可用的item
- (ChatTextModel *)textItemFromModel:(ChatTextModel *)model {
    model.showMessageType = model.receiver ? NO:YES;
    model.isVoice = [model.messageResource isEqualToString:@"VOICE_DISCERN"];
    return model;
}

- (ChatTextModel *)timeItemFromModel:(ChatTextModel *)model {
    ChatTextModel *time = [ChatTextModel new];
    time.createTime = model.createTime;
    time.isOnlyTime = YES;
    return time;
}

@end

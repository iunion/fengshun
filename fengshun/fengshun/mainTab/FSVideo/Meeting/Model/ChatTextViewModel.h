//
//  ChatTextViewModel.h
//  ODR
//
//  Created by ILLA on 2018/8/16.
//  Copyright © 2018年 DH. All rights reserved.
//

#import "ChatTextModel.h"
#import "VideoCallModel.h"

@interface ChatTextViewModel : NSObject

@property (nonatomic, strong) NSMutableArray<ChatTextModel *> *chatList; // 纯消息列表

@property (nonatomic, strong) NSArray *showList; // 添加了时间条的数据

+ (NSArray *)modelListWithData:(NSArray *)data;
+ (ChatTextModel *)chatTextModelWithDict:(NSDictionary *)dic;

- (void)formatChatList;
- (void)convertToItemsFromChatList;

@end

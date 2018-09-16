
//
//  ChatTextModel.m
//  ODR
//
//  Created by DH on 2017/9/12.
//  Copyright © 2017年 DH. All rights reserved.
//

#import "ChatTextModel.h"


@implementation ChatTextModel

+ (instancetype)modelWithParams:(NSDictionary *)params
{
    ChatTextModel *model = [[self alloc] init];
    model.messageId                 = [params bm_intForKey:@"id"];
    model.messageContent            = [params bm_stringForKey:@"messageContent"];
    model.messageType               = [params bm_stringForKey:@"messageType"];
    model.messageResourceEnums      = [params bm_stringForKey:@"messageResourceEnums"];
    model.createTime                = [params bm_doubleForKey:@"createTime"];
    model.sender                    = [ChatTextMemberModel modelWithParams:params[@"sender"]];
    if (params[@"receiver"]) {
        model.receiver                  = [ChatTextMemberModel modelWithParams:params[@"receiver"]];
    }
    return model;
}
@end


@implementation ChatTextMemberModel
+ (instancetype)modelWithParams:(NSDictionary *)params
{
    ChatTextMemberModel *model = [[self alloc] init];
    model.memberId              = [params bm_stringForKey:@"memberId"];
    model.memberName            = [params bm_stringForKey:@"memberName"];
    model.memberType            = [params bm_stringForKey:@"memberType"];
    model.master                = [params bm_boolForKey:@"master"];
    return model;
}
@end

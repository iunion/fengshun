//
//  FSImageJump.m
//  fengshun
//
//  Created by Aiwei on 2018/9/5.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSImageJump.h"

@implementation FSImageJump

+ (instancetype)modelWithParams:(NSDictionary *)params
{
    FSImageJump *model  = [[self alloc] init];
    model.m_tilte       = [params bm_stringForKey:@"description"];
    model.m_id          = [params bm_intForKey:@"id"];
    model.m_imageUrl    = [params bm_stringForKey:@"imageUrl"];
    model.m_jumpAddress = [params bm_stringForKey:@"jumpAddress"];
    model.m_jumpType    = [FSGlobalEnum jumpTypeWithString:[params bm_stringForKey:@"jumpType"]];
    return model;
}

@end

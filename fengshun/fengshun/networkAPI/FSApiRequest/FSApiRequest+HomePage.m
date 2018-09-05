//
//  FSApiRequest+HomePage.m
//  fengshun
//
//  Created by Aiwei on 2018/9/5.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSApiRequest+HomePage.h"

@implementation FSApiRequest (HomePage)

+(XMRequest *)getHomeDataSuccess:(XMSuccessBlock)successBlock failure:(XMFailureBlock)failureBlock
{
    return [XMRequestManager rm_requestWithApi:@"/storm/home/getAppHomeData" parameters:nil success:successBlock failure:failureBlock];
}

@end

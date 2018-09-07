//
//  FSApiRequest+HomePage.m
//  fengshun
//
//  Created by Aiwei on 2018/9/5.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSApiRequest.h"

@implementation FSApiRequest (HomePage)

+(NSMutableURLRequest *)loadHomePageData
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/storm/home/getAppHomeData", FS_URL_SERVER];

    return [FSApiRequest makeRequestWithURL:urlStr parameters:@{}];
}

+(XMRequest *)getMessageUnReadFlagSuccess:(XMSuccessBlock)successBlock failure:(XMFailureBlock)failureBlock
{
    return [XMRequestManager rm_requestWithApi:@"/storm/home/getMessageUnReadFlag" parameters:nil success:successBlock failure:failureBlock];
}
+ (XMRequest *)getCaseSearchHotkeysSuccess:(XMSuccessBlock)successBlock failure:(XMFailureBlock)failureBlock
{
    return [XMRequestManager rm_getRequestWithApi:@"/search/ftls/cases/hotKeywords" parameters:nil success:successBlock failure:failureBlock];
}
@end

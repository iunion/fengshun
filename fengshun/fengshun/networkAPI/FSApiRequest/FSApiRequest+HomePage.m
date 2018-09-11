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
// 案例检索
+ (XMRequest *)getCaseSearchHotkeysSuccess:(XMSuccessBlock)successBlock failure:(XMFailureBlock)failureBlock
{
    return [XMRequestManager rm_getRequestWithApi:@"/search/ftls/cases/hotKeywords" parameters:nil success:successBlock failure:failureBlock];
}
+(NSMutableURLRequest *)searchCaseWithKeywords:(NSArray *)keywords start:(NSUInteger)startLocation size:(NSUInteger)size filters:(NSArray *)filters
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/search/ftls/searchCases", FS_URL_SERVER];
    
    NSMutableDictionary *parames = [@{@"keywords":keywords,@"size":@(size),@"start":@(startLocation)} mutableCopy];
    if ([filters bm_isNotEmpty]) {
        [parames setObject:filters forKey:@"aggs"];
    }
    return [FSApiRequest makeRequestWithURL:urlStr parameters:parames];
}

// 法规检索
+ (XMRequest *)getLawTopicSuccess:(XMSuccessBlock)successBlock failure:(XMFailureBlock)failureBlock
{
    return [XMRequestManager rm_getRequestWithApi:@"/search/ftls/laws/thematic" parameters:nil success:successBlock failure:failureBlock];
}
+(NSMutableURLRequest *)searchLawsWithKeywords:(NSArray *)keywords start:(NSUInteger)startLocation size:(NSUInteger)size filters:(NSArray *)filters
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/search/ftls/searchLaws", FS_URL_SERVER];
    
    NSMutableDictionary *parames = [@{@"keywords":keywords,@"size":@(size),@"start":@(startLocation)} mutableCopy];
    if ([filters bm_isNotEmpty]) {
        [parames setObject:filters forKey:@"aggs"];
    }
    return [FSApiRequest makeRequestWithURL:urlStr parameters:parames];
}

@end

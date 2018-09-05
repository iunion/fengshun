//
//  FSApiRequest+HomePage.h
//  fengshun
//
//  Created by Aiwei on 2018/9/5.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSApiRequest.h"
#import "XMRequestManager.h"

@interface FSApiRequest (HomePage)

// 获取首页数据
+ (XMRequest *)getHomeDataSuccess:(nullable XMSuccessBlock)successBlock
                          failure:(nullable XMFailureBlock)failureBlock;

@end

//
//  FSApiRequest+HomePage.m
//  fengshun
//
//  Created by Aiwei on 2018/9/5.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSApiRequest+HomePage.h"

@implementation FSApiRequest (HomePage)

+(NSMutableURLRequest *)loadHomePageData
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/storm/home/getAppHomeData", FS_URL_SERVER];

    return [FSApiRequest makeRequestWithURL:urlStr parameters:@{}];
}

@end

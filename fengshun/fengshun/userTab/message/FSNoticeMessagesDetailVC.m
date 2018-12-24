//
//  FSNoticeMessagesDetailVC.m
//  fengshun
//
//  Created by Aiwei on 2018/12/24.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSNoticeMessagesDetailVC.h"

@interface FSNoticeMessagesDetailVC ()

@end

@implementation FSNoticeMessagesDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadApiData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableURLRequest *)setLoadDataRequestWithFresh:(BOOL)isLoadNew
{
    if (![_m_NoticeMessagesId bm_isNotEmpty]) {
        return nil;
    }
    return [FSApiRequest getUserNoticeMessageDetailWithId:_m_NoticeMessagesId];
}
- (BOOL) succeedLoadedRequestWithDic:(NSDictionary *)requestDic
{
    return YES;
}
@end

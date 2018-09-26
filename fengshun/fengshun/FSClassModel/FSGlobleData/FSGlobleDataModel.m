//
//  FSGlobleDataModel.m
//  fengshun
//
//  Created by jiang deng on 2018/9/12.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSGlobleDataModel.h"

@implementation FSGlobleDataModel

+ (instancetype)globleDataModelWithServerDic:(NSDictionary *)dic
{
    if (![dic bm_isNotEmptyDictionary])
    {
        return nil;
    }
    
    NSString *code = [dic bm_stringTrimForKey:@"code"];
    if (![code bm_isNotEmpty])
    {
        return nil;
    }
    
    FSGlobleDataModel *globleData = [[FSGlobleDataModel alloc] init];
    [globleData updateWithServerDic:dic];
    
    if ([globleData.m_Code bm_isNotEmpty])
    {
        return globleData;
    }
    else
    {
        return nil;
    }
}

- (void)updateWithServerDic:(NSDictionary *)dic
{
    if (![dic bm_isNotEmptyDictionary])
    {
        return;
    }
    
    // code
    NSString *code = [dic bm_stringTrimForKey:@"code"];
    if (![code bm_isNotEmpty])
    {
        return;
    }

    // parentCode
    self.m_ParentCode = [dic bm_stringTrimForKey:@"parentCode"];

    // name
    self.m_Name = [dic bm_stringTrimForKey:@"name"];
    
    // value
    NSString *value = [dic bm_stringTrimForKey:@"value"];
    if (![value bm_isNotEmpty])
    {
        return;
    }
    self.m_Value = value;
    
    self.m_Code = code;
    
    // children
    NSArray *childrenArray = [dic bm_arrayForKey:@"children"];
    if ([childrenArray bm_isNotEmpty])
    {
        self.m_Children = [[NSMutableArray alloc] init];
        for (NSDictionary *childDic in childrenArray)
        {
            FSGlobleDataModel *globleData = [FSGlobleDataModel globleDataModelWithServerDic:childDic];
            if (globleData)
            {
                [self.m_Children addObject:globleData];
            }
        }
        
        if (![self.m_Children bm_isNotEmpty])
        {
            self.m_Children = nil;
        }
    }
}

@end

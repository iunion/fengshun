//
//  FSSuperModel.m
//  fengshun
//
//  Created by Aiwei on 2018/9/5.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSSuperModel.h"

@implementation FSSuperModel

+ (NSArray *)modelsWithDataArray:(NSArray *)dataArray
{
    NSMutableArray *data = [NSMutableArray array];
    if ([dataArray bm_isNotEmpty])
    {
        for (id object in dataArray)
        {
            if ([object isKindOfClass:[NSDictionary class]])
            {
                FSSuperModel *model = [self modelWithParams:object];
                if(model)[data addObject:model];
            }
        }
    }
    return [data copy];
}
+ (instancetype)modelWithParams:(NSDictionary *)params
{
    BMLog(@"请在具体的类中完成model的转换");
    return nil;
}
@end

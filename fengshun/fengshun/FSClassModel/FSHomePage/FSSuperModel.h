//
//  FSSuperModel.h
//  fengshun
//
//  Created by Aiwei on 2018/9/5.
//  Copyright © 2018 FS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSSuperModel : NSObject
+ (NSArray *)modelsWithDataArray:(NSArray *)dataArray;
+ (instancetype)modelWithParams:(NSDictionary *)params;
@end

//
//  FSGlobleDataModel.h
//  fengshun
//
//  Created by jiang deng on 2018/9/12.
//  Copyright © 2018年 FS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSGlobleDataModel : NSObject

// code
@property (nonatomic, strong) NSString *m_Code;
// parentCode
@property (nonatomic, strong) NSString *m_ParentCode;
// name
@property (nonatomic, strong) NSString *m_Name;

// value
@property (nonatomic, strong) NSString *m_Value;

// children
@property (nonatomic, strong) NSMutableArray <FSGlobleDataModel *> *m_Children;


+ (instancetype)globleDataModelWithServerDic:(NSDictionary *)dic;
- (void)updateWithServerDic:(NSDictionary *)dic;

@end

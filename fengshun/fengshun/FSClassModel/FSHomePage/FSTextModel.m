//
//  FSListTextModel.m
//  fengshun
//
//  Created by Aiwei on 2018/9/12.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSTextModel.h"


@implementation FSTextModel


@end

@implementation FSListTextModel

+ (instancetype)modelWithParams:(NSDictionary *)params
{
    FSListTextModel *model = [[self alloc] init];
    model.m_title          = [params bm_stringForKey:@"documentName"];
    model.m_typeCode       = [params bm_stringForKey:@"documentTypeCode"];
    model.m_fileId         = [params bm_stringForKey:@"fileId"];
    model.m_previewUrl     = [params bm_stringForKey:@"previewUrl"];
    return model;
}
@end
@implementation FSTextTypeModel

+ (instancetype)modelWithParams:(NSDictionary *)params
{
    FSTextTypeModel *model = [[self alloc] init];
    model.m_typeCode       = [params bm_stringForKey:@"documentTypeCode" withDefault:@""];
    model.m_typeName       = [params bm_stringForKey:@"documentTypeName" withDefault:@""];
    return model;
}
@end

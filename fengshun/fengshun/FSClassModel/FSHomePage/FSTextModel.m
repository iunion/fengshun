//
//  FSListTextModel.m
//  fengshun
//
//  Created by Aiwei on 2018/9/12.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSTextModel.h"


@implementation FSTextModel

- (NSString *)m_title
{
    if ([self p_canSeparatedString]) {
        
        return [[self p_separatedStrings] bm_safeObjectAtIndex:0];
    }
    else
    {
        return _m_fullTitle;
    }
}

- (NSString *)m_subTitle
{
    if ([self p_canSeparatedString]) {
        return [[self p_separatedStrings] bm_safeObjectAtIndex:1];
    }
    else
    {
        
        return nil;
    }
}
- (BOOL)p_canSeparatedString
{
    return [_m_fullTitle containsString:@"（"]||[_m_fullTitle containsString:@"("];
}
- (NSArray *)p_separatedStrings
{
    NSString *boundary = @"--boundary--";
    NSString *content = [_m_fullTitle stringByReplacingOccurrencesOfString:@"（" withString:boundary];
    content = [content stringByReplacingOccurrencesOfString:@"）" withString:boundary];
    content = [content stringByReplacingOccurrencesOfString:@"(" withString:boundary];
    content = [content stringByReplacingOccurrencesOfString:@")" withString:boundary];
    return [content componentsSeparatedByString:boundary];
}

@end

@implementation FSListTextModel

+ (instancetype)modelWithParams:(NSDictionary *)params
{
    FSListTextModel *model = [[self alloc] init];
    model.m_fullTitle      = [params bm_stringForKey:@"documentName"];
    model.m_typeCode       = [params bm_stringForKey:@"documentTypeCode"];
    model.m_fileId         = [params bm_stringForKey:@"fileId"];
    model.m_documentId     = [params bm_stringForKey:@"documentId"];
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

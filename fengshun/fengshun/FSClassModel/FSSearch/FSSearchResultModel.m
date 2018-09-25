//
//  FSCaseSearchResultModel.m
//  fengshun
//
//  Created by Aiwei on 2018/9/7.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSSearchResultModel.h"


@implementation FSSearchResultModel
+ (instancetype)modelWithParams:(NSDictionary *)params
{
    FSSearchResultModel *model = [[self alloc] init];
    model.m_isMore             = [params bm_boolForKey:@"isMore"];
    model.m_totalCount         = [params bm_intForKey:@"size"];
    model.m_keywordsStr        = [params bm_stringForKey:@"keywords"];
    model.m_filterSegments     = [FSSearchFilterSegment modelsWithDataArray:[params bm_arrayForKey:@"aggs"]];
    return model;
}
+ (void)setTextLabel:(UILabel *)label withText:(NSString *)text fontSize:(CGFloat)fontSize textColor:(UIColor *)textColor attributed:(BOOL)attributed
{
    if (![text bm_isNotEmpty]) {
        label.attributedText = nil;
        label.text           = nil;
        return;
    }
    if (attributed) {
        NSMutableAttributedString *aString = [NSMutableAttributedString bm_attributedStringReplaceHTMLString:text fontSize:fontSize contentColor:textColor.hexStringFromColor tagColor:UI_COLOR_R1.hexStringFromColor starTag:@"<em>" endTag:@"</em>"];
        label.attributedText = aString;
        
    }
    else
    {
        label.textColor = textColor;
        label.font = [UIFont systemFontOfSize:fontSize];
        label.text  = text;
    }
}
@end

@implementation FSCaseSearchResultModel

+ (instancetype)modelWithParams:(NSDictionary *)params
{
    FSCaseSearchResultModel *model = [super modelWithParams:params];
    model.m_resultDataArray        = [FSCaseResultModel modelsWithDataArray:[params bm_arrayForKey:@"data"]];
    return model;
}
@end

@implementation FSLawSearchResultModel

+ (instancetype)modelWithParams:(NSDictionary *)params
{
    FSLawSearchResultModel *model = [super modelWithParams:params];
    model.m_resultDataArray       = [FSLawResultModel modelsWithDataArray:[params bm_arrayForKey:@"data"]];
    return model;
}

@end

@implementation FSSearchFilterSegment
+ (instancetype)modelWithParams:(NSDictionary *)params
{
    FSSearchFilterSegment *model = [[self alloc] init];
    model.m_title              = [params bm_stringForKey:@"value" withDefault:@""];
    model.m_type               = [params bm_stringForKey:@"name" withDefault:@""];
    model.m_filters            = [FSSearchFilter modelsWithDataArray:[params bm_arrayForKey:@"bucket"]];
    return model;
}

@end

@implementation FSSearchFilter

+ (instancetype)modelWithParams:(NSDictionary *)params
{
    FSSearchFilter *model = [[self alloc] init];
    model.m_docCount    = [params bm_intForKey:@"docCount"];
    model.m_name        = [params bm_stringForKey:@"name" withDefault:@""];
    model.m_value       = [params bm_stringForKey:@"value" withDefault:@""];
    return model;
}
@end

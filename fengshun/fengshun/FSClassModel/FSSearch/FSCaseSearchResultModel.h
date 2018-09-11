//
//  FSCaseSearchResultModel.h
//  fengshun
//
//  Created by Aiwei on 2018/9/7.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSSuperModel.h"

@class FSSearchFilterSegment, FSSearchFilter;

@interface FSCaseReultModel : FSSuperModel

@property (nonatomic, copy) NSString *m_caseId;
@property (nonatomic, copy) NSString *m_title;
@property (nonatomic, copy) NSString *m_simpleContent;
@property (nonatomic, copy) NSString *m_caseNo;
@property (nonatomic, copy) NSString *m_court;

// 欠缺
@property (nonatomic, copy) NSString *m_caseTag;
@property (nonatomic, copy) NSString *m_jumpUrl;
@property (nonatomic, copy) NSString *m_date;

@end


@interface FSCaseSearchResultModel : FSSuperModel

@property (nonatomic, assign) BOOL      m_isMore;
@property (nonatomic, assign) NSInteger m_totalCount;

// 用于跳转到详情页
@property (nonatomic, copy) NSString *m_keywordsStr;

@property (nonatomic, strong) NSArray<FSSearchFilterSegment *> *m_filterSegments;
@property (nonatomic, strong) NSArray<FSCaseReultModel *> *     m_resultDataArray;


@end

@interface FSSearchFilterSegment : FSSuperModel

@property (nonatomic, copy) NSString *                   m_title;
@property (nonatomic, copy) NSString *                   m_type;
@property (nonatomic, strong) NSArray<FSSearchFilter *> *m_filters;

@end

@interface FSSearchFilter : FSSuperModel

@property (nonatomic, copy) NSString *  m_name;
@property (nonatomic, copy) NSString *  m_value;
@property (nonatomic, assign) NSInteger m_docCount;

@end

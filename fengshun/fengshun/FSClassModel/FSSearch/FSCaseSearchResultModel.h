//
//  FSCaseSearchResultModel.h
//  fengshun
//
//  Created by Aiwei on 2018/9/7.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSSuperModel.h"

@class FSCaseFilterSegment, FSCaseFilter;

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

@property (nonatomic, strong) NSArray<FSCaseReultModel *> *m_resultDataArray;

@property (nonatomic, strong) NSArray<FSCaseFilterSegment *> *m_filterSegments;

@end

@interface FSCaseFilterSegment :FSSuperModel

@property(nonatomic, copy)NSString *m_title;
@property(nonatomic, copy)NSString *m_type;
@property(nonatomic, strong)NSArray <FSCaseFilter *> *m_filters;

@end

@interface FSCaseFilter :FSSuperModel

@property(nonatomic, copy)NSString *m_name;
@property(nonatomic, copy)NSString *m_value;
@property(nonatomic, assign)NSInteger m_docCount;

@end

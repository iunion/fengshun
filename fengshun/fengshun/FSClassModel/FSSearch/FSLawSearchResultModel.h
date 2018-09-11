//
//  FSLawSearchResultModel.h
//  fengshun
//
//  Created by Aiwei on 2018/9/11.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSSuperModel.h"
#import "FSCaseSearchResultModel.h"


@interface FSLawResultModel : FSSuperModel

@property (nonatomic, copy) NSString *m_lawsId;
@property (nonatomic, copy) NSString *m_lawsNo;
@property (nonatomic, copy) NSString *m_title;
@property (nonatomic, copy) NSString *m_simpleContent;

@property (nonatomic, copy) NSString *m_Organ;

@property (nonatomic, copy) NSString *m_publishDate;
@property (nonatomic, copy) NSString *m_executeDate;
// 生效标识
@property (nonatomic, copy) NSString *m_executeTag;

// 命中数
@property (nonatomic, assign) NSInteger m_matchCount;


@end

@interface FSLawSearchResultModel : FSSuperModel

@property (nonatomic, assign) BOOL      m_isMore;
@property (nonatomic, assign) NSInteger m_totalCount;
// 用于跳转到详情页
@property (nonatomic, copy) NSString *m_keywordsStr;

@property (nonatomic, strong) NSArray<FSSearchFilterSegment *> *m_filterSegments;
@property (nonatomic, strong) NSArray<FSLawResultModel *> *     m_resultDataArray;

@end

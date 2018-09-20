//
//  FSCaseModel.h
//  fengshun
//
//  Created by Aiwei on 2018/9/20.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSSuperModel.h"

@interface FSCaseModel : FSSuperModel
@property (nonatomic, copy) NSString *m_caseId;
@property (nonatomic, copy) NSString *m_title;

@end

@interface FSCaseCollectionModel : FSCaseModel

@property (nonatomic, copy) NSString *m_collectionId;
@property (nonatomic, copy) NSString *m_source;
@property (nonatomic, copy) NSString *m_jumpUrl;
@end

@interface FSCaseResultModel : FSCaseModel

@property (nonatomic, copy) NSString *m_simpleContent;
@property (nonatomic, copy) NSString *m_caseNo;
@property (nonatomic, copy) NSString *m_court;
@property (nonatomic, copy) NSString *m_caseTag;

// UI有,但数据欠缺
@property (nonatomic, copy) NSString *m_date;

@end

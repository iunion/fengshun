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

@interface FSCaseResultModel : FSCaseModel

@property (nonatomic, copy) NSString *m_simpleContent;
@property (nonatomic, copy) NSString *m_caseNo;
@property (nonatomic, copy) NSString *m_court;
@property (nonatomic, copy) NSString *m_basicInfo;
@property (nonatomic, assign) BOOL    m_isGuidingCase;
@property (nonatomic, copy) NSString *m_caseTag;

@end

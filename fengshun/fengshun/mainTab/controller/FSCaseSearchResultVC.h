//
//  FSCaseSearchResultVC.h
//  fengshun
//
//  Created by Aiwei on 2018/9/10.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSSearchResultVC.h"

@class FSSearchFilter, FSCaseSearchResultModel;

@interface FSCaseSearchResultVC : FSSearchResultVC

@property(nonatomic, strong)FSSearchFilter *m_leftFilter;
@property(nonatomic, strong)FSSearchFilter *m_rightFilter;
@property(nonatomic, strong)FSCaseSearchResultModel *m_searchResultModel;
@end

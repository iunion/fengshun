//
//  FSCaseSearchResultVC.h
//  fengshun
//
//  Created by Aiwei on 2018/9/10.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSSearchResultVC.h"

@class FSCaseFilter, FSCaseSearchResultModel;

@interface FSCaseSearchResultVC : FSSearchResultVC

@property(nonatomic, strong)FSCaseFilter *m_leftFilter;
@property(nonatomic, strong)FSCaseFilter *m_rightFilter;
@property(nonatomic, strong)FSCaseSearchResultModel *m_searchResultModel;
@end

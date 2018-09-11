//
//  FSLawSearchResultVC.h
//  fengshun
//
//  Created by Aiwei on 2018/9/10.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSSearchResultVC.h"

@class FSSearchFilter, FSLawSearchResultModel;

@interface FSLawSearchResultVC : FSSearchResultVC
@property(nonatomic, strong)FSSearchFilter *m_leftFilter;
@property(nonatomic, strong)FSSearchFilter *m_rightFilter;
@property(nonatomic, strong)FSLawSearchResultModel *m_searchResultModel;
@end

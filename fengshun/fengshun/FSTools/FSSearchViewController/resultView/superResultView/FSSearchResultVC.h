//
//  FSSearchResultVC.h
//  fengshun
//
//  Created by Aiwei on 2018/9/10.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSTableViewVC.h"

@class FSSearchResultView;

typedef void(^SearchSucceed)(id resultModel);

@interface FSSearchResultVC : FSTableViewVC

@property(nonatomic, weak)FSSearchResultView *m_resultView;
@property(nonatomic, copy)SearchSucceed m_searchsucceed;

@property(nonatomic, assign)NSUInteger loadPage;

@property (nonatomic, weak)     UIViewController *m_masterVC;

@end

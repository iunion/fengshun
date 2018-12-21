//
//  FSBaseComTopicListVC.h
//  fengshun
//
//  Created by jiang deng on 2018/12/21.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSTableViewVC.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FSBaseComTopicScrollTopDelegate;

@interface FSBaseComTopicListVC : FSTableViewVC

@property (nonatomic, weak) id <FSBaseComTopicScrollTopDelegate> scrollTopDelegate;

@property (nonatomic, assign) BOOL m_CanScroll;

@end

@protocol FSBaseComTopicScrollTopDelegate <NSObject>

- (void)comTopicScrollToTop:(nullable UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END

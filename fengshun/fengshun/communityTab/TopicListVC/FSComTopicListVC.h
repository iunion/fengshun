//
//  FSComTopicListVC.h
//  fengshun
//
//  Created by jiang deng on 2018/12/21.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSTableViewVC.h"
#import "FSBaseComTopicListVC.h"

NS_ASSUME_NONNULL_BEGIN

#define ComTopicHeaderImageHeight   200.0f
#define ComTopicHeaderImageGap      8.0f
#define ComTopicSegmentBarHeight    44.0f

@interface FSComTopicListVC : FSBaseComTopicListVC

- (instancetype)initWithTopicSortType:(NSString *)sortType
                               formId:(NSInteger )formId;

- (void)refreshVC;

@end

NS_ASSUME_NONNULL_END
